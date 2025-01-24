defmodule LiveFeedbackWeb.QuestionLive.Index do
  use LiveFeedbackWeb, :live_view
  alias LiveFeedback.Questions.Question
  alias LiveFeedback.Repo
  import Ecto.Query

  @impl true
  def mount(%{"course_page_id" => course_page_id}, _session, socket) do
    questions =
      from(q in Question,
        where: q.course_page_id == ^course_page_id,
        order_by: [asc: q.display_order]
      )
      |> Repo.all()

    {:ok,
     socket
     # Provide an empty list if questions is not defined
     |> assign(questions: questions || [])
     |> assign(course_page_id: course_page_id)
    }
  end
end
