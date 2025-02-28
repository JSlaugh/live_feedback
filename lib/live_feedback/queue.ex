defmodule LiveFeedback.Queue do

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Queues.Queue

  def get_queue!(id), do: Repo.get!(Queue, id)
  def get_queues_for_course(course_id) do
    from(queue in Queue,
      where: queue.course_page_id == ^course_id)
    |> Repo.all()
  end

  def get_presenting_queue_for_course(course_id) do
    from(queue in Queue,
    where: queue.course_page_id == ^course_id and queue.is_presenting == true)
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
