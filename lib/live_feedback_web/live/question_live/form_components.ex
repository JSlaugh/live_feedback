defmodule LiveFeedback.QuestionLive.QuestionComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id={"question_wrapper_#{@question.id}"} class="w-full">
      <div class={if "#{@show_form}" == "#{@question.id}", do: "block", else: "hidden"} id={"question_form_#{@question.id}"}>
        <.live_component
          module={LiveFeedbackWeb.QuestionLive.FormComponent}
          question={@question}
          question_type={@question_type}
          id={"form_#{@question.id}"}
        />
      </div>

      <div class={if "#{@show_form}" != "#{@question.id}", do: "block", else: "hidden"} id={"question_view_#{@question.id}"} phx-target={@myself} phx-click="toggle_form">
        <.live_component
          module={LiveFeedbackWeb.QuestionLive.ViewQuestion}
          question={@question}
          id={"questionView_#{@question.id}"}
        />
      </div>
    </div>
    """
  end
  @impl true
  def handle_event("toggle_form", _params, socket) do
    IO.inspect(socket, label: "My Stream Data")
    send(self(), {:toggle_form, socket.assigns.question.id})
    {:noreply, socket}
  end
end


defmodule LiveFeedbackWeb.QuestionLive.ViewQuestion do
  use Phoenix.LiveComponent
  import LiveFeedbackWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div
      id={"question_#{@question.id}"}
      class="flex justify-between items-center p-4 bg-gray-200 rounded-lg shadow-md hover:bg-gray-300 transition-all">
      <p class="text-gray-800"><%= @question.question_content %></p>
      <div>
        <div>
          <button phx-click="move_question" phx-value-id={@question.id} phx-value-direction="up" class="hover:text-red-700 focus:outline-none">
            <.icon name="hero-chevron-up" />
          </button>
          <button phx-click="move_question" phx-value-id={@question.id} phx-value-direction="down" class=" hover:text-red-700 focus:outline-none">
            <.icon name="hero-chevron-down" />
          </button>
        </div>
        <button phx-click="delete_question" phx-value-id={@question.id} class="text-red-500 hover:text-red-700 focus:outline-none">
          <.icon name="hero-trash" />
        </button>
      </div>
    </div>
    """
  end

end

defmodule LiveFeedbackWeb.QuestionLive.FormComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <form
      id={"question_form_#{@question.id}"}
      phx-key={"question_form_#{@question.id}"}
      phx-submit={if @question.id == "new", do: "add_question", else: "edit_question"}
      class="mt-4 space-y-4"
      >
      <input type="hidden" name="question_id" value={@question.id} phx-key={@question.id} />
        <!-- Question Content -->
        <.live_component module={LiveFeedbackWeb.QuestionLive.QuestionContent} question={@question} id={"question_content_component_#{@question.id}"} phx-key={"question_content_component_#{@question.id}"} />

        <!-- Question Type Selection -->
        <div>
          <label for="question_type" class="block text-lg font-medium text-gray-700">Question Type:</label>
          <select id={"question_type_#{@question.id}"} phx-key={"question_type_#{@question.id}"} name="question_type" phx-change="typeChange" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500" >
            <option value="QA" selected={@question_type == "QA"}>Q&A</option>
            <option value="free_response" selected={@question_type == "free_response"}>Free Response</option>
            <option value="multiple_choice" selected={@question_type == "multiple_choice"}>Multiple Choice</option>
            <option value="multi-select" selected={@question_type == "multi-select"}>Multi-Select</option>
            <option value="true_false" selected={@question_type == "true_false"}>True/False</option>
          </select>
        </div>

        <!-- Render Options -->
        <div id={"question_options_#{@question.id}"} phx-key={"question_options_#{@question.id}"} phx-update="replace">
          <%= if @question_type == "multiple_choice" or @question_type == "multi-select" do %>
            <.live_component module={LiveFeedbackWeb.QuestionLive.MultipleChoice} question_type={@question_type} question={@question} id={"MC_options_#{@question.id}"} phx-key={"MC_Options_#{@question.id}"} />
          <% end %>

          <%= if @question_type == "true_false" do %>
            <.live_component  module={LiveFeedbackWeb.QuestionLive.TrueFalse} question={@question} id={"TF_options_#{@question.id}"} phx-key={"TF_Options_#{@question.id}"} />
          <% end %>
        </div>

        <button type="submit" class="w-full py-2 px-4 bg-green-500 text-white font-semibold rounded-lg shadow-md hover:bg-green-600">Save</button>
      </form>
    """
  end
end


defmodule LiveFeedbackWeb.QuestionLive.QuestionContent do
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div id={"content_input_#{@question.id}"} phx-key={"content_input_#{@question.id}"}>
      <label for="question_content" class="block text-lg font-medium text-gray-700">Question:</label>
      <input type="text" id={"content_inputbox_#{@question.id}"} phx-key={"content_inputbox_#{@question.id}"} name="question_content" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500" value={@question.question_content}required />
    </div>
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.MultipleChoice do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id={"MC_options_#{@question.id}"} phx-key={"MC_Options_#{@question.id}"} class="space-y-4">
      <table class="w-full table-auto border-collapse border border-gray-300">
        <thead>
          <tr class="bg-gray-200">
            <th class="px-4 py-2 text-left">Option</th>
            <th class="px-4 py-2 text-left">Answer Text</th>
            <th class="px-4 py-2 text-left">Correct</th>
          </tr>
        </thead>
        <tbody>
          <%= for {letter, _index} <- Enum.with_index(["A", "B", "C", "D"]) do %>
            <% option = Enum.find(@question.question_options_occurances, fn o -> o.option_order == letter end) ||
                        %LiveFeedback.Questions.QuestionOptions{id: "#{letter}", option_content: "", is_correct: false, option_order: letter} %>
            <tr>
              <td class="px-4 py-2"><%= letter %></td>
              <td class="px-4 py-2">
                <.live_component
                  module={LiveFeedbackWeb.QuestionLive.OptionContent}
                  option={option}
                  question={@question}
                  letter={letter}
                  id={"option_content_#{option.id}_#{@question.id}"}
                  phx-key={"option_content_#{option.id}_#{@question.id}"}
                />
              </td>
              <td class="px-4 py-2 text-center">
                <.live_component
                  module={LiveFeedbackWeb.QuestionLive.RadioOrCheckbox}
                  question={@question}
                  question_type={@question_type}
                  option={option}
                  letter={letter}
                  id={"radio_checkbox_#{option.id}_#{@question.id}"}
                  phx_key={"radio_checkbox_#{option.id}_#{@question.id}"}
                />
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.TrueFalse do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id={"TF_options_#{@question.id}"} phx-key={"TF_Options_#{@question.id}"} class="space-y-4">
      <table class="w-full table-auto border-collapse border border-gray-300">
        <thead>
          <tr class="bg-gray-200">
            <th class="px-4 py-2 text-left">Option</th>
            <th class="px-4 py-2 text-left">Correct</th>
          </tr>
        </thead>
        <tbody>
          <%= for {letter, index} <- Enum.with_index(["A", "B"], 1) do %>
            <% option = Enum.find(@question.question_options_occurances, fn o -> o.option_order == index end) ||
                        %LiveFeedback.Questions.QuestionOptions{id: "#{letter}", option_content: "", is_correct: false, option_order: index} %>
            <tr>
              <td class="px-4 py-2"><%= if letter == "A", do: "True", else: "False" %></td>
              <td class="px-4 py-2 text-center">
                <input type="radio"
                       id={"correct_#{letter}"}
                       name="answer"
                       value={letter}
                       class="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500"
                       checked={option.is_correct} />
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.RadioOrCheckbox do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <input type={if @question_type == "multiple_choice", do: "radio", else: "checkbox"}
       id={"correct_#{@option.id}"}
       name={if @question_type == "multiple_choice", do: "answer", else: "correct_#{@letter}"}
       value={@letter}
       class="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500"
       checked={@option.is_correct} />

    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.OptionContent do
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <input type="text"
       id={"option_#{@option.id}"}
       name={"option_#{@letter}"}
       class="block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
       value={@option.option_content} />

    """
  end
end
