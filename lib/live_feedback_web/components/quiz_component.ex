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
    <div class="mt-4 flex flex-col">
      <div class="grid grid-cols-2 gap-6 max-w-4xl mx-auto h-[50vh] w-[80vw]">
        <!-- #Check if this option matches a response for this profile -->
        <%= for {option, index} <- Enum.with_index(@current_question.question_options_occurrences) do %>
          <div
            class={[
              "flex items-center justify-center  rounded-xl shadow-lg",
              if !@page_admin && !@locked do
                "cursor-pointer transition-transform hover:scale-105"
              end,
              case index do
                0 ->
                  if @page_admin || @locked, do: "bg-blue-500", else: ["bg-blue-500", "hover:bg-blue-600"]

                1 ->
                  if @page_admin || @locked, do: "bg-green-500", else: ["bg-green-500", "hover:bg-green-600"]

                2 ->
                  if @page_admin || @locked, do: "bg-purple-500", else: ["bg-purple-500", "hover:bg-purple-600"]

                3 ->
                  if @page_admin || @locked, do: "bg-orange-500", else: ["bg-orange-500", "hover:bg-orange-600"]
              end,
              if Enum.any?(@responses, fn %{anonymous_id: aid, question_options_occurrence_id: oid} ->
                   aid == @anonymous_id and oid == option.id
                 end) || (@locked && !@page_admin) do
                "opacity-50"
              else
                ""
              end
            ]}
            phx-click={if !@page_admin && !@locked, do: "select-answer"}
            phx-throttle="500"
            phx-target={@myself}
            phx-value-id={option.id}
          >
            <p class="w-full break-normal px-2 text-sm md:text-xl text-white font-semibold text-center">
              <%= option.option_content %>
            </p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("select-answer", %{"id" => option_id}, socket) do
    # gets the question type and gets a list of all responses for a profile for the question out of the socket
    question_type = socket.assigns.current_question.question_type
    profile_responses = socket.assigns.responses

    # if the response selected is already in the database for that question & profile, delete it
    if Enum.any?(profile_responses, fn %LiveFeedback.Questions.QuestionOptionsResponse{
                                         question_options_occurrence_id: id
                                       } ->
         id == String.to_integer(option_id)
       end) do
      Selection.delete_response_for_profile_for_question(socket.assigns.anonymous_id, option_id)
      {:noreply, socket}
    else
      # if it is a new response (not in the DB), determine what question type it is
      # if multiple choice || T/F
      if question_type != "multi-select" do
        # if there is a previous response, update it
        if profile_responses != [] do
          attrs = %{
            "question_options_occurrence_id" => option_id
          }

          attrs =
            if socket.assigns.profile_id != nil &&
                 socket.assigns.current_question.is_required == true,
               do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
               else: attrs

          Selection.update_response_for_profile_for_question(
            socket.assigns.anonymous_id,
            socket.assigns.current_question.id,
            attrs
          )

          {:noreply, socket}
          # if there are no previous responses, simply add a new one
        else
          attrs = %{
            "anonymous_id" => socket.assigns.anonymous_id,
            "question_options_occurrence_id" => option_id
          }

          attrs =
            if socket.assigns.profile_id != nil &&
                 socket.assigns.current_question.is_required == true,
               do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
               else: attrs

          case Selection.add_response(attrs) do
            {:ok, _response} ->
              {:noreply,
               socket
               |> put_flash(:info, "successfully recorded response")}
          end
        end

        # if it is multiselect then add it
      else
        attrs = %{
          "anonymous_id" => socket.assigns.anonymous_id,
          "question_options_occurrence_id" => option_id
        }

        attrs =
          if socket.assigns.profile_id != nil &&
               socket.assigns.current_question.is_required == true,
             do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
             else: attrs

        case Selection.add_response(attrs) do
          {:ok, _response} ->
            {:noreply,
             socket
             |> put_flash(:info, "successfully recorded response")}
        end
      end
    end

    # update the question responses list
    send(socket.assigns.parent_pid, {:refresh_responses})

    # broadcast changes to the presenter
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

  import LiveFeedbackWeb.CoreComponents

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
    <div class="w-full mt-2 mx-auto border-t  p-4 bg-white shadow-md rounded-lg">
      <h2 class="text-xl font-semibold mb-4 text-gray-800">Question Responses</h2>

      <div class="space-y-3">
        <%= for {option, correctness, percentage, responses, index} <- @processed_responses do %>
          <div class="flex items-center">
            <div class={["w-1/4 text-gray-700 pr-2", if correctness do "font-bold" end]} >
              <%= option %>
              <%= if correctness do %>
                <span class="font-bold italic text-brand_navy mb-4">(correct)</span>
              <% else %>
              <% end %>
            </div>

            <div class="flex-grow bg-gray-200 rounded-lg h-10 mr-2 relative">
              <div
                class={
                  [
                    "h-10 rounded-lg transition-all duration-500 ease-in-out ",
                    case index do
                      0 -> "bg-blue-500"
                      1 -> "bg-green-500"
                      2 -> "bg-purple-500"
                      3 -> "bg-orange-500"
                      # Fallback color
                      _ -> "bg-blue-500"
                    end,
                    if !correctness do "opacity-40" end
                  ]
                }
                style={"width: #{percentage}%"}
              >
                <span class="absolute right-0 top-1 text-xs font-bold text-gray-700 mr-2"></span>
              </div>
            </div>

            <div class="w-12 text-right text-black">
              <span class="font-bold">
                <%= percentage %>%
              </span>
               <%= responses %> <.icon name="hero-chat-bubble-left-right" class="w-6 h-6" />
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
