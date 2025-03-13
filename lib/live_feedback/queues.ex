defmodule LiveFeedback.Queues do
  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Queues.Queue
  alias LiveFeedback.Accounts.User

  @doc """
   Authorization for deleting a queue
  """

  def authorize(:delete_queue, %User{id: user_id}, %Queue{} = queue) do
    queue = Repo.preload(queue, :course_page)
    if queue.course_page.user_id == user_id, do: :ok, else: :error
  end

  def authorize(:delete_queue, _user, _queue), do: :error

  @doc """
   get a single queue
  """

  def get_queue!(id) do
    Repo.get!(Queue, id)
  end

  @doc """
  Returns the list of queues for a course.
  """
  def get_queues_for_course(course_id) do
    from(queue in Queue,
      where: queue.course_page_id == ^course_id,
      order_by: [asc: queue.presented_date, desc: queue.inserted_at]
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

  def next_question(queue_id, next_question_num) do
    queue = get_queue!(queue_id)

    queue
    |> Ecto.Changeset.change(current_question_num: next_question_num)
    |> Repo.update!()
  end

  def toggle_queue_lock(queue_id, is_locked) do
    from(q in Queue,
      where: q.id == ^queue_id,
      update: [set: [is_locked: ^is_locked]]
    )
    |> Repo.update_all([])
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
        {:ok, queue}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec delete_queue(%{
          :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
          optional(any()) => any()
        }) :: {:error, <<_::208>>} | {:ok, any()}
  @doc """
  Deletes a queue.
  """
  def delete_queue(queue) do
    Repo.delete(queue)
    |> case do
      {:ok, queue} ->
        {:ok, queue}

      {:error, _} ->
        {:error, "Queue could not be deleted"}
    end
  end

  @doc """
  Change Queue
  """
  def change_queue(%Queue{} = queue, attrs) do
    queue
    |> Queue.changeset(attrs)
  end

  def get_presenting_queue_for_course(course_id) do
    from(queue in Queue,
      where: queue.course_page_id == ^course_id and queue.is_presenting == true
    )
    |> Repo.one()
  end

  def toggle_present_queue(course_page_id, queue_id) do
    Repo.transaction(fn ->
      # Find the queue
      queue = Repo.get!(Queue, queue_id)

      if queue.is_presenting do
        # If currently presenting, turn it off
        queue
        |> Ecto.Changeset.change(is_presenting: false)
        |> Repo.update!()

        "Ending Presentation"
      else
        # If not presenting, first turn off all other queues for this course
        from(q in Queue,
          where: q.course_page_id == ^course_page_id,
          update: [set: [is_presenting: false]]
        )
        |> Repo.update_all([])

        # Now turn on the selected queue
        queue
        |> Ecto.Changeset.change(is_presenting: true)
        |> Repo.update!()

        "Presentation is starting"
      end
    end)
  end
end
