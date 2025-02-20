defmodule LiveFeedbackWeb.QueueLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Queue

  @impl true
  def mount(%{"course_page_id" => course_page_id}, _session, socket) do
    {:ok,
     socket
     |> stream(:queues, Queue.get_queues_for_course(course_page_id))
    }
  end

end
