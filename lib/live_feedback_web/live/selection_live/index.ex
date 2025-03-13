defmodule LiveFeedbackWeb.SelectionLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Selection

  @impl true
  def mount(%{"coursepage" => course_page_id, "queue" => queue_id}, session, socket) do
    user_id = get_user_id(session)
    profile_id = Selection.get_profile_id(user_id, course_page_id).id
    first_question = Selection.get_question_from_queue(queue_id, 1)
    question_responses = Selection.get_question_responses(first_question.id)
    {:ok,
     socket
     |> assign(:profile_id, profile_id)
     |> assign(:course_name, Selection.get_course_name(course_page_id))
     |> assign(:current_question_num, 1)
     |> assign(:current_question, first_question)
     |> assign(:responses, question_responses)
    }
  end

  def get_user_id(session) do
    Map.get(session, "user_id")
  end

  #when an answer is pushed
  @impl true
  def handle_event("select-answer", %{"id" => option_id}, socket) do
    #gets the question type and gets a list of all responses for a profile for the question out of the socket
    question_type = socket.assigns.current_question.question_type
    profile_responses =
      socket.assigns.responses
      |> Enum.filter(fn %LiveFeedback.Questions.QuestionOptionsResponse{user_profile_id: id} ->
        id == socket.assigns.profile_id
      end)

    #if the response selected is already in the database for that question & profile, delete it
    if Enum.any?(profile_responses, fn %LiveFeedback.Questions.QuestionOptionsResponse{question_options_occurrence_id: id} -> id == String.to_integer(option_id) end) do
      Selection.delete_response_for_profile_for_question(socket.assigns.profile_id, option_id)
      {:noreply, socket}
    else
      #if it is a new response (not in the DB), determine what question type it is
      #if multiple choice || T/F
      if question_type != "multi-select" do
        #if there are no previous responses, simply add a new one
        if profile_responses != [] do
          attrs = %{
            "question_options_occurrence_id" => option_id
          }
          Selection.update_response_for_profile_for_question(socket.assigns.profile_id, socket.assigns.current_question.id, attrs)
          {:noreply, socket}
        #if there is a previous response, update it
        else
          attrs = %{
            "user_profile_id" => socket.assigns.profile_id,
            "question_options_occurrence_id" => option_id
          }
          case Selection.add_response(attrs) do
            {:ok, _response} ->
              {:noreply,
              socket
              |> put_flash(:success, "successfully recorded response")
              }
          end
        end
      #if it is multiselect then add it
      else
        attrs = %{
          "user_profile_id" => socket.assigns.profile_id,
          "question_options_occurrence_id" => option_id
        }
        case Selection.add_response(attrs) do
          {:ok, _response} ->
            {:noreply,
            socket
            |> put_flash(:success, "successfully recorded response")
            }
        end
      end
    end
    #update the question responses list
    question_responses = Selection.get_question_responses(socket.assigns.current_question.id)
    {:noreply, assign(socket, :responses, question_responses)}
  end

end
