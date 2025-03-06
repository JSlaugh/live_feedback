defmodule LiveFeedbackWeb.QuizComponent do
  use Phoenix.LiveComponent

  alias LiveFeedback.Selection
  alias LiveFeedback.ActivityResults

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

    if not Map.has_key?(assigns, :course_page) do
      raise ArgumentError, "course_page attribute is required"
    end

    ~H"""
      <div class=" p-8 flex flex-col">
        <div class="grid grid-cols-2 gap-6 max-w-4xl mx-auto h-[65vh] w-[65vw]">
          <!-- #Check if this option matches a response for this profile -->
          <%= for {option, index} <- Enum.with_index(@current_question.question_options_occurrences) do %>
            <div class={[
              "flex items-center justify-center p-6 rounded-xl shadow-lg",
              if !@page_admin do
                "cursor-pointer transition-transform hover:scale-105"
              end,
              case index do
                0 -> if @page_admin, do: "bg-blue-500", else: ["bg-blue-500", "hover:bg-blue-600"]
                1 -> if @page_admin, do: "bg-green-500", else: ["bg-green-500", "hover:bg-green-600"]
                2 -> if @page_admin, do: "bg-purple-500", else: ["bg-purple-500", "hover:bg-purple-600"]
                3 -> if @page_admin, do: "bg-orange-500", else: ["bg-orange-500", "hover:bg-orange-600"]
              end,
              if Enum.any?(@responses, fn %{anonymous_id: aid, question_options_occurrence_id: oid} -> aid == @anonymous_id and oid == option.id end) do
                "opacity-50"
              else
                ""
              end
            ]}
            phx-click={if !@page_admin, do: "select-answer"} phx-target={@myself} phx-value-id={option.id}>
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
    profile_responses = socket.assigns.responses

    #if the response selected is already in the database for that question & profile, delete it
    if Enum.any?(profile_responses, fn %LiveFeedback.Questions.QuestionOptionsResponse{question_options_occurrence_id: id} -> id == String.to_integer(option_id) end) do
      Selection.delete_response_for_profile_for_question(socket.assigns.anonymous_id, option_id)
      {:noreply, socket}
    else
      #if it is a new response (not in the DB), determine what question type it is
      #if multiple choice || T/F
      if question_type != "multi-select" do
        #if there is a previous response, update it
        if profile_responses != [] do
          attrs = %{
            "question_options_occurrence_id" => option_id
          }
          attrs = if socket.assigns.profile_id != nil && socket.assigns.current_question.is_required == true,
            do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
            else: attrs
          Selection.update_response_for_profile_for_question(socket.assigns.anonymous_id, socket.assigns.current_question.id, attrs)
          {:noreply, socket}
        #if there are no previous responses, simply add a new one
        else
          attrs = %{
            "anonymous_id" => socket.assigns.anonymous_id,
            "question_options_occurrence_id" => option_id
          }
          attrs = if socket.assigns.profile_id != nil && socket.assigns.current_question.is_required == true,
            do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
            else: attrs
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
          "anonymous_id" => socket.assigns.anonymous_id,
          "question_options_occurrence_id" => option_id
        }
        attrs = if socket.assigns.profile_id != nil && socket.assigns.current_question.is_required == true,
          do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
          else: attrs
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

    #broadcast changes to the presenter
    topic = "Host:#{socket.assigns.course_page.id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:refresh_presenter_responses})

    {:noreply, socket}
  end
end

# QUIZ RESULTS COMPONENT - PROFESSOR VIEW -----------------------------------------------
defmodule LiveFeedbackWeb.QuizResultsComponent do
  use Phoenix.LiveComponent

  alias LiveFeedback.ActivityResults
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

    if not Map.has_key?(assigns, :course_page) do
      raise ArgumentError, "course_page attribute is required"
    end

    ~H"""
      <div class="w-full max-w-xl mx-auto p-4 bg-white shadow-md rounded-lg">
        <h2 class="text-xl font-semibold mb-4 text-gray-800">Question Responses</h2>

        <div class="space-y-3">
          <%= for {option, percentage, responses, index} <- @processed_responses do %>
            <div class="flex items-center">
              <div class="w-1/4 text-gray-700 pr-2">
                <%= option %>
              </div>
              <div class="flex-grow bg-gray-200 rounded-full h-4 mr-2 relative">
                <div
                  class={[
                    "h-4 rounded-full transition-all duration-500 ease-in-out",
                    case index do
                      0 -> "bg-blue-500"
                      1 -> "bg-green-500"
                      2 -> "bg-purple-500"
                      3 -> "bg-orange-500"
                      _ -> "bg-blue-500"  # Fallback color
                    end
                  ]}
                  style={"width: #{percentage}%"}
                >
                <span class="absolute right-0 top-0 text-xs text-gray-700 mr-2">
                  <%= responses %> <%= if responses == 1, do: "response", else: "responses" %>
                </span>
                </div>
              </div>
              <div class="w-12 text-right text-gray-600">
                <%= percentage %>%
              </div>
            </div>
          <% end %>
        </div>
      </div>
    """
  end

end
