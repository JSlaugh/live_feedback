defmodule LiveFeedback.Messages do
  @moduledoc """
  The Messages context.
  """

  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Messages.Message
  alias LiveFeedback.Messages.LikedBy
  alias LiveFeedback.Courses.CoursePage

  # Admins can update any message
  def authorize(:update_message, %{role: :admin} = _user, _message), do: :ok
  # Can change your own messages
  def authorize(:update_message, %{id: user_id} = _user, %{user_id: user_id} = _message), do: :ok
  def authorize(:update_message, _user, _message), do: :error

  # Delete messages permissions
  def authorize(:delete_message, %{role: :admin} = _user, _message), do: :ok
  def authorize(:delete_message, %{id: user_id} = _user, %{user_id: user_id} = _message), do: :ok
  # Can delete messages if you are the user that created the message's course_page
  def authorize(
        :delete_message,
        %{id: user_id} = _user,
        %{course_page: %{user_id: user_id}} = _message
      ),
      do: :ok

  def authorize(:delete_message, _user, _message), do: :error

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, message} ->
        topic = "messages:#{message.course_page_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:new_message, message})
        {:ok, message}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, message} ->
        topic = "messages:#{message.course_page_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:updated_message, message})
        {:ok, message}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
    |> case do
      {:ok, message} ->
        topic = "messages:#{message.course_page_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:deleted_message, message})
        {:ok, message}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  @doc """
  Returns the list of messages for a course page.

  ## Examples

      iex> get_messages_for_course_page(%CoursePage{id: course_page_id})
      [%Message{}, ...]

  """
  def get_messages_for_course_page_id(course_page_id, sort_by \\ :oldest) do
    sort_order =
      case sort_by do
        :newest -> [desc: :inserted_at]
        :oldest -> [asc: :inserted_at]
        :like_count -> [desc: :like_count]
        _ -> [asc: :inserted_at] # Default to oldest
      end

    from(m in Message,
      where: m.course_page_id == ^course_page_id,
      order_by: ^sort_order
    )
    |> Repo.all(preload: [:course_page])
  end

  def delete_all_messages_for_course_page(%CoursePage{id: course_page_id}) do
    from(message in Message, where: message.course_page_id == ^course_page_id)
    |> Repo.delete_all()
    |> case do
      {_, nil} ->
        topic = "messages:#{course_page_id}"

        Phoenix.PubSub.broadcast(
          LiveFeedback.PubSub,
          topic,
          {:deleted_all_messages, course_page_id}
        )

        {:ok}

      {:error, changeset} ->
        {:error, changeset}
    end
  end



@doc """
Toggles the like on a message for a given user (authenticated or anonymous).
"""
@doc """
Toggles the like on a message for a given user (authenticated or anonymous).
"""
def toggle_like_message(%Message{} = message, anonymous_id) do
  like_query =
    from(like in LikedBy,
      where: like.message_id == ^message.id and like.anonymous_id == ^anonymous_id
    )

  case Repo.one(like_query) do
    # If a like exists, remove it
    %LikedBy{} = like ->
      Repo.delete(like)
      |> case do
        {:ok, _} ->
          update_like_count(message, -1)

        {:error, changeset} ->
          {:error, changeset}
      end

    # If no like exists, create one
    nil ->
      %LikedBy{}
      |> LikedBy.changeset(%{message_id: message.id, anonymous_id: anonymous_id})
      |> Repo.insert()
      |> case do
        {:ok, _} ->
          update_like_count(message, 1)

        {:error, changeset} ->
          {:error, changeset}
      end
  end
end

# Helper function to update the like count on a message
defp update_like_count(%Message{} = message, delta) do
  new_count = message.like_count + delta

  message
  |> Message.changeset(%{like_count: new_count})
  |> Repo.update()
  |> case do
    {:ok, updated_message} ->
      # Broadcast the updated message
      topic = "messages:#{updated_message.course_page_id}"
      Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:updated_message, updated_message})

      {:ok, updated_message}

    {:error, changeset} ->
      {:error, changeset}
  end
end

def has_liked_message?(%Message{} = message, anonymous_id) do
  like_query =
    from(like in LikedBy,
      where: like.message_id == ^message.id and like.anonymous_id == ^anonymous_id
    )

  case Repo.one(like_query) do
    nil -> false
    %LikedBy{} -> true
  end
end

  def subscribe(course_page_id) do
    topic = "messages:#{course_page_id}"
    Phoenix.PubSub.subscribe(LiveFeedback.PubSub, topic)
  end
end
