defmodule LiveFeedbackWeb.SelectionLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Selection

  @impl true
  def mount(%{"coursepage" => course_page_id, "queue" => queue_id}, session, socket) do
    user_id = get_user_id(session)
    profile_id = Selection.get_profile_id(user_id, course_page_id).id
    first_question = Selection.get_question_from_queue(queue_id, 1)
    #messages = (if first_question.question_type == "QA", do: Activity.get_messages_for_question(first_question.id), else: nil)
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

  @impl true
  def handle_event("select-answer", %{"id" => option_id}, socket) do
    question_type = socket.assigns.current_question.question_type
    profile_responses = Selection.get_profile_responses(socket.assigns.profile_id, socket.assigns.current_question.id)
    if Enum.any?(profile_responses, fn response -> response.question_options_occurrence_id == String.to_integer(option_id) end) do
      Selection.delete_response_for_profile_for_question(socket.assigns.profile_id, option_id)
      {:noreply, socket}
    else
      if question_type != "multi-select" do
        if profile_responses != [] do
          attrs = %{
            "question_options_occurrence_id" => option_id
          }
          Selection.update_response_for_profile_for_question(socket.assigns.profile_id, socket.assigns.current_question.id, attrs)
          {:noreply, socket}
        else
          attrs = %{
            "user_profile_id" => socket.assigns.profile_id,
            "question_options_occurrence_id" => option_id
          }
          case Selection.add_response(attrs) do
            {:ok, _response} ->
              {:noreply,
              socket
              |> put_flash(:info, "successfully recorded response")
              }
          end
        end
      else
        attrs = %{
          "user_profile_id" => socket.assigns.profile_id,
          "question_options_occurrence_id" => option_id
        }
        case Selection.add_response(attrs) do
          {:ok, _response} ->
            {:noreply,
            socket
            |> put_flash(:info, "successfully recorded response")
            }
        end
      end
    end
  end

  #case
  #no response || (multi-select && response not in DB) -> add response
  #same response in DB -> delete response
  #different response -> update response

end
