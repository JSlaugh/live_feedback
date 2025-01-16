defmodule LiveFeedback.Messages do
  @moduledoc """
  The Messages context.
  """

  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Messages.Message
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
  def get_messages_for_course_page_id(course_page_id) do
    from(m in Message, where: m.course_page_id == ^course_page_id, order_by: [asc: m.inserted_at])
    |> Repo.all(preload: [:course_page])
  end

  def delete_all_messages_for_course_page(%CoursePage{id: course_page_id}) do
    from(m in Message, where: m.course_page_id == ^course_page_id)
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
def toggle_like_message(%Message{} = message, user_id_or_anonymous_id, _value) do
  # Get the current list of user IDs who have liked this message or default to an empty list
  liked_by_user_ids = message.liked_by_user_ids || []

  # Determine if the user has already liked the message
  user_has_liked = Enum.member?(liked_by_user_ids, user_id_or_anonymous_id)

  # Update the like count and list
  updated_likes =
    if user_has_liked do
      List.delete(liked_by_user_ids, user_id_or_anonymous_id)
    else
      [user_id_or_anonymous_id | liked_by_user_ids]
    end

  updated_like_count =
    if user_has_liked do
      message.like_count - 1
    else
      message.like_count + 1
    end

  changeset = Message.changeset(message, %{like_count: updated_like_count, liked_by_user_ids: updated_likes})

  case Repo.update(changeset) do
    {:ok, updated_message} ->
      # Broadcast the updated message to the course page topic
      topic = "messages:#{updated_message.course_page_id}"
      Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:updated_message, updated_message})

      {:ok, updated_message}

    {:error, changeset} ->
      {:error, changeset}
  end
end


  def subscribe(course_page_id) do
    topic = "messages:#{course_page_id}"
    Phoenix.PubSub.subscribe(LiveFeedback.PubSub, topic)
  end
end
