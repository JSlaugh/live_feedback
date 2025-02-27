defmodule LiveFeedback.Queue do

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Questions.Queue

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
end
