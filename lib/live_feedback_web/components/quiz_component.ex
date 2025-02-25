defmodule LiveFeedbackWeb.QuizComponent do
  use Phoenix.LiveComponent

  alias LiveFeedback.Selection

  @impl true
  def render(assigns) do
    # Variables that we need
    # Profile_id, current_question, responses
    if not Map.has_key?(assigns, :profile_id) do
      raise ArgumentError, "profile_id attribute is required"
    end

    if not Map.has_key?(assigns, :current_question) do
      raise ArgumentError, "current_question attribute is required"
    end

    if not Map.has_key?(assigns, :responses) do
      raise ArgumentError, "responses attribute is required"
    end

    ~H"""
      <div class="h-screen p-8 flex flex-col">
        <div class="grid grid-cols-2 gap-6 max-w-4xl mx-auto h-[65vh] w-[65vw]">
          <!-- #Check if this option matches a response for this profile -->
          <%= for {option, index} <- Enum.with_index(@current_question.question_options_occurrences) do %>
            <div class={[
              "flex items-center justify-center p-6 rounded-xl shadow-lg cursor-pointer transition-transform hover:scale-105",
              case index do
                0 -> "bg-blue-500 hover:bg-blue-600"
                1 -> "bg-green-500 hover:bg-green-600"
                2 -> "bg-purple-500 hover:bg-purple-600"
                3 -> "bg-orange-500 hover:bg-orange-600"
              end,
              if Enum.any?(@responses, fn %{user_profile_id: pid, question_options_occurrence_id: oid} -> pid == @profile_id and oid == option.id end) do
                "opacity-50"
              else
                ""
              end
            ]}
            phx-click="select-answer" phx-target={@myself} phx-value-id={option.id}>
              <p class="text-xl text-white font-semibold text-center"><%= option.option_content %></p>
            </div>
          <% end %>
        </div>
      </div>
    """
  end

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
              |> put_flash(:info, "successfully recorded response")
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
            |> put_flash(:info, "successfully recorded response")
            }
        end
      end
    end
    # update the question responses list
    send(socket.assigns.parent_pid, {:refresh_responses})
    {:noreply, socket}
  end
end
