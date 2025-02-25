defmodule LiveFeedback.Queues do
  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Queues.Queue

  @doc """
  Returns the list of queues for a course.
  """
  def get_queues_for_course(course_id) do
    from(queue in Queue,
      where: queue.course_page_id == ^course_id
    )
    |> Repo.all()
  end

  @doc """
  Returns the name of a course.
  """
  def get_course_name(course_page_id) do
    from(course in CoursePage,
      where: course.id == ^course_page_id,
      select: course.title
    )
    |> Repo.one()
  end

  @doc """
  Updates a queue.
  """
  def update_queue(%Queue{} = queue, attrs) do
    queue
    |> Queue.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, queue} ->
        topic = "queues:#{queue.id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:updated_queue, queue})
        {:ok, queue}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Creates a queue.
  """
  def create_queue(attrs \\ %{}) do
    %Queue{}
    |> Queue.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, queue} ->
        topic = "queues:#{queue.course_page_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:new_queue, queue})
        {:ok, queue}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a queue.
  """
  def delete_queue(%Queue{} = queue) do
    Repo.delete(queue)
    |> case do
      {:ok, _} ->
        topic = "queues:#{queue.course_page_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:deleted_queue, queue})
        {:ok, queue}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Change Queue
  """
  def change_queue(%Queue{} = queue, attrs) do
    queue
    |> Queue.changeset(attrs)
  end
end
