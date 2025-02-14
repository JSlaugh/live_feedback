defmodule LiveFeedbackWeb.SelectionLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Selection

  @impl true
  def mount(%{"coursepage" => course_page_id, "queue" => queue_id}, session, socket) do
    user_id = get_user_id(session)
    profile_id = Selection.get_profile_id(user_id, course_page_id).id
    first_question = Selection.get_question_from_queue(queue_id, 1)
    {:ok,
     socket
     |> assign(:profile_id, profile_id)
     #|> assign(:current_response, Selection.get_profile_responses(profile_id, first_question.id))
     |> assign(:course_name, Selection.get_course_name(course_page_id))
     |> assign(:current_question_num, 1)
     |> assign(:current_question, first_question)
    }
  end

  def get_user_id(session) do
    Map.get(session, "user_id")
  end

  def handle_event("select-answer", %{"id" => option_id}, socket) do
    question_type = socket.assigns.current_question.question_type
    #if Enum.any?(socket.assigns.current_question.question_options_occurances, fn option -> option.id == String.to_integer(option_id))
      #|| (question_type != "multi-select" && ) do
    #end

    attrs = %{
      "user_profile_id" => socket.assigns.profile_id,
      "question_option_id" => option_id
    }
    case Selection.add_response(attrs) do
      {:ok, _response} ->
        {:noreply,
        socket
        |> put_flash(:info, "successfully recorded response")
        }
    end
  end

  #determine if their is a response
    #if it is the same as selected, delete it
    #else
      #if multiple choice || t/f, delete all other responses
      #add new response

end
