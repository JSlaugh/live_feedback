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
      <div class="grid grid-cols-2 gap-6 max-w-4xl mx-auto h-[40vh] w-[80%]">
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
    option_id_int = String.to_integer(option_id)

    # Check if response already exists
    existing_response = Enum.find(profile_responses, fn %LiveFeedback.Questions.QuestionOptionsResponse{
                                       question_options_occurrence_id: id
                                     } ->
       id == option_id_int
     end)

    updated_responses = if existing_response do
      # Delete case - remove from responses in socket
      updated_responses = Enum.reject(profile_responses, fn r ->
        r.question_options_occurrence_id == option_id_int
      end)

      # Delete from DB
      Selection.delete_response_for_profile_for_question(socket.assigns.anonymous_id, option_id)

      updated_responses
    else
      # Handle new response based on question type
      if question_type != "multi-select" do
        # For single-select questions (multiple choice or T/F)
        attrs = %{
          "question_options_occurrence_id" => option_id
        }

        attrs = if socket.assigns.profile_id != nil && socket.assigns.current_question.is_required == true,
               do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
               else: attrs

        if profile_responses != [] do
          # Update existing response - replace in socket
          Selection.update_response_for_profile_for_question(
            socket.assigns.anonymous_id,
            socket.assigns.current_question.id,
            attrs
          )

          # Create updated response struct for the socket
          old_response = List.first(profile_responses)
          updated_response = %{old_response | question_options_occurrence_id: option_id_int}

          [updated_response]
        else
          # Add new response
          attrs = Map.put(attrs, "anonymous_id", socket.assigns.anonymous_id)

          case Selection.add_response(attrs) do
            {:ok, new_response} ->
              {[new_response], :added}
          end
        end
      else
        # For multi-select questions - add to collection
        attrs = %{
          "anonymous_id" => socket.assigns.anonymous_id,
          "question_options_occurrence_id" => option_id
        }

        attrs = if socket.assigns.profile_id != nil && socket.assigns.current_question.is_required == true,
               do: Map.put(attrs, "user_profile_id", socket.assigns.profile_id),
               else: attrs

        case Selection.add_response(attrs) do
          {:ok, new_response} -> profile_responses ++ [new_response]
        end
      end
    end

    # Send the updated responses to the parent process
    send(socket.assigns.parent_pid, {:refresh_responses, updated_responses})

    # Broadcast changes to the presenter
    topic = "Host:#{socket.assigns.course_page.id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:refresh_presenter_responses})

    # Update this socket with the new responses
    updated_socket = assign(socket, :responses, updated_responses)

    {:noreply, updated_socket}
  end

  # Modified handler for the parent component to directly accept the updated responses
  def handle_info({:update_responses, updated_responses}, socket) do
    {:noreply, assign(socket, :responses, updated_responses)}
  end

  # Keep the original handler as a fallback, if needed
  def handle_info({:refresh_responses}, socket) do
    question_responses =
      Selection.get_profile_responses(
        socket.assigns.anonymous_id,
        socket.assigns.current_question.id
      )

    {:noreply, assign(socket, :responses, question_responses)}
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
