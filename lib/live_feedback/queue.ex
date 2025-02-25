defmodule LiveFeedback.Queues do
  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Queues.Queue

  def get_queues_for_course(course_id) do
    from(queue in Queue,
      where: queue.course_page_id == ^course_id
    )
    |> Repo.all()
  end

  def get_course_name(course_page_id) do
    from(course in CoursePage,
      where: course.id == ^course_page_id,
      select: course.title
    )
    |> Repo.one()
  end
end
