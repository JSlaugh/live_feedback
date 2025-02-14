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
          max_question_num={@max_question_num}
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
      class="flex justify-between items-center p-4 bg-white rounded-lg border border-gray-300 hover:border-blue-500 transition-all shadow-sm mb-4">
      <p class="text-gray-800"><%= @question.question_content %></p>
      <div class="flex items-center gap-2">
        <div class="flex flex-col" id={"navigation_buttons_#{@question.id}"} phx-update="replace">
          <button
            id={"up_button_#{@question.id}"}
            phx-click="move_question"
            phx-value-id={@question.id}
            phx-value-direction="up"
            class={"text-gray-500 hover:text-blue-600 focus:outline-none #{if @question.display_order == 1, do: 'invisible', else: 'visible'}"}>
            <.icon name="hero-chevron-up" />
          </button>
          <button
            id={"down_button_#{@question.id}"}
            phx-click="move_question"
            phx-value-id={@question.id}
            phx-value-direction="down"
            class={"text-gray-500 hover:text-blue-600 focus:outline-none #{if @question.display_order == @max_question_num, do: 'invisible', else: 'visible'}"}>
            <.icon name="hero-chevron-down" />
          </button>
        </div>
        <div class="border-l border-gray-300 h-8 mx-2"></div>
        <button
          id={"delete_button_#{@question.id}"}
          phx-click="confirm_delete"
          phx-value-id={@question.id}
          class="text-red-500 hover:text-red-600 focus:outline-none">
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
      class="relative bg-white rounded-lg border border-gray-300 p-6 mb-4 shadow-sm"
    >
      <input type="hidden" name="question_id" value={@question.id} phx-key={@question.id} />
      <div class="space-y-4">
        <div class="flex gap-4 mb-4">
          <!-- Question Content -->
          <div class="flex-grow">
            <.live_component module={LiveFeedbackWeb.QuestionLive.QuestionContent} question={@question} id={"question_content_component_#{@question.id}"} phx-key={"question_content_component_#{@question.id}"} />
          </div>

          <!-- Question Type Selection -->
          <div class="w-48">
            <select
              id={"question_type_#{@question.id}"}
              phx-key={"question_type_#{@question.id}"}
              name="question_type"
              phx-change="typeChange"
              class="w-full px-3 py-2 h-[46px] bg-white border border-gray-300 rounded-md text-gray-700 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="QA" selected={@question_type == "QA"}>Q&A</option>
              <option value="free_response" selected={@question_type == "free_response"}>Free Response</option>
              <option value="multiple_choice" selected={@question_type == "multiple_choice"}>Multiple Choice</option>
              <option value="multi-select" selected={@question_type == "multi-select"}>Multi-Select</option>
              <option value="true_false" selected={@question_type == "true_false"}>True/False</option>
            </select>
          </div>
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
        <div class="pb-8"></div>
      </div>

      <!-- Required Toggle -->
      <div class="absolute bottom-0 right-0 left-0 p-2 bg-white border-t border-gray-200">
        <div class="flex justify-end items-center gap-4">
          <.live_component
            module={LiveFeedbackWeb.QuestionLive.RequiredToggle}
            question={@question}
            id={"required_toggle_component_#{@question.id}"}
          />

          <button type="submit" class="py-2 px-4 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">Save</button>
        </div>
      </div>
    </form>
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.QuestionContent do
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div id={"content_input_#{@question.id}"} phx-key={"content_input_#{@question.id}"}>
      <input
        type="text"
        id={"content_inputBox_#{@question.id}"}
        name="question_content"
        placeholder="Question"
        class="w-full px-3 py-2 text-lg border-b-2 border-gray-300 focus:border-blue-500 focus:outline-none"
        value={@question.question_content}
        required
      />
    </div>
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.MultipleChoice do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id={"MC_options_#{@question.id}"} phx-key={"MC_Options_#{@question.id}"} class="space-y-3 mt-4">
      <%= for {letter, _index} <- Enum.with_index(["A", "B", "C", "D"]) do %>
        <% option = Enum.find(@question.question_options_occurrences, fn o -> o.option_order == letter end) ||
                    %LiveFeedback.Questions.QuestionOptions{id: "#{letter}", option_content: "", is_correct: false, option_order: letter} %>
        <div class="flex items-center gap-3 pl-2">
          <.live_component
            module={LiveFeedbackWeb.QuestionLive.RadioOrCheckbox}
            question={@question}
            question_type={@question_type}
            option={option}
            letter={letter}
            id={"radio_checkbox_#{option.id}_#{@question.id}"}
            phx_key={"radio_checkbox_#{option.id}_#{@question.id}"}
          />
          <.live_component
            module={LiveFeedbackWeb.QuestionLive.OptionContent}
            option={option}
            question={@question}
            letter={letter}
            id={"option_content_#{option.id}_#{@question.id}"}
            phx-key={"option_content_#{option.id}_#{@question.id}"}
          />
        </div>
      <% end %>
    </div>
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.TrueFalse do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id={"TF_options_#{@question.id}"} phx-key={"TF_Options_#{@question.id}"} class="space-y-3 mt-4">
      <%= for {letter, index} <- Enum.with_index(["A", "B"], 1) do %>
        <% option = Enum.find(@question.question_options_occurrences, fn o -> o.option_order == index end) ||
                    %LiveFeedback.Questions.QuestionOptions{id: "#{letter}", option_content: "", is_correct: false, option_order: index} %>
        <div class="flex items-center gap-3 pl-2">
          <input type="radio"
                 id={"correct_#{letter}"}
                 name="answer"
                 value={letter}
                 class="h-4 w-4 text-blue-600 border-gray-300 focus:ring-blue-500"
                 checked={option.is_correct} />
          <label class="text-gray-700"><%= if letter == "A", do: "True", else: "False" %></label>
        </div>
      <% end %>
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
     class="h-4 w-4 text-blue-600 border-gray-300 focus:ring-blue-500"
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
     placeholder="Option text"
     class="w-full px-3 py-2 text-gray-700 border-b border-gray-300 focus:border-blue-500 focus:outline-none"
     value={@option.option_content} />
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.RequiredToggle do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex items-center space-x-2" id={"required_toggle_#{@question.id}"}>
      <label for={"required_toggle_input_#{@question.id}"} class="text-sm text-gray-700">Required</label>
      <label class="relative inline-flex items-center cursor-pointer">
        <input
          type="checkbox"
          id={"required_toggle_input_#{@question.id}"}
          name="is_required"
          checked={@question.is_required}
          class="sr-only peer"
        />
        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600">
        </div>
      </label>
    </div>
    """
  end
end
