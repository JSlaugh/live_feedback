defmodule LiveFeedback.QuestionLive.QuestionComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id={"question_wrapper_#{@question.id}"} class="w-full">
      <%= if @show_form == "#{@question.id}"  do %>
        <.live_component module={LiveFeedbackWeb.QuestionLive.FormComponent} question_type={@question_type} id={"form_#{@question.id}"}/>
      <% else %>
        <.live_component module={LiveFeedbackWeb.QuestionLive.ViewQuestion} question={@question} id={"questionView_#{@question.id}"}/>
      <% end %>
    </div>
    """
  end

end

defmodule LiveFeedbackWeb.QuestionLive.ViewQuestion do
  use Phoenix.LiveComponent
  import LiveFeedbackWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div phx-click="toggle_form" phx-value-form={Integer.to_string(@question.id)} id={"question_#{@question.id}"} class="flex justify-between items-center p-4 bg-gray-200 rounded-lg shadow-md hover:bg-gray-300 transition-all">
      <p class="text-gray-800"><%= @question.question_content %></p>
      <button phx-click="delete_question" phx-value-id={@question.id} class="text-red-500 hover:text-red-700 focus:outline-none">
        <.icon name="hero-trash" />
      </button>
    </div>
    """
  end
end


defmodule LiveFeedbackWeb.QuestionLive.FormComponent do
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
      <form id="question_form" phx-submit="add_question" class="mt-4 space-y-4" phx-update="replace">
        <!-- Question Content -->
        <.live_component module={LiveFeedbackWeb.QuestionLive.QuestionContent}  id="content" />

        <!-- Question Type Selection -->
        <div>
          <label for="question_type" class="block text-lg font-medium text-gray-700">Question Type:</label>
          <select id="question_type" name="question_type" phx-change="typeChange" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option value="QA">Q&A</option>
            <option value="free_response">Free Response</option>
            <option value="multiple_choice">Multiple Choice</option>
            <option value="multi-select">Multi-Select</option>
            <option value="true_false">True/False</option>
          </select>
        </div>

        <!-- Render Options -->
        <div id="options" phx-update="replace">
          <%= if @question_type == "multiple_choice" or @question_type == "multi-select" do %>
            <.live_component module={LiveFeedbackWeb.QuestionLive.MultipleChoice} question_type={@question_type} id="multiple_choice" />
          <% end %>

          <%= if @question_type == "true_false" do %>
            <.live_component  module={LiveFeedbackWeb.QuestionLive.TrueFalse} id="true_false" />
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
    <div id="content">
      <label for="question_content" class="block text-lg font-medium text-gray-700">Question:</label>
      <input type="text" id="question_content" name="question_content" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500" required />
    </div>
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.MultipleChoice do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id="multiple-choice-options" class="space-y-4">
      <table class="w-full table-auto border-collapse border border-gray-300">
        <thead>
          <tr class="bg-gray-200">
            <th class="px-4 py-2 text-left">Option</th>
            <th class="px-4 py-2 text-left">Answer Text</th>
            <th class="px-4 py-2 text-left">Correct</th>
          </tr>
        </thead>
        <tbody>
          <%= for option <- ["A", "B", "C", "D"] do %>
            <tr>
              <td class="px-4 py-2"><%= option %></td>
              <td class="px-4 py-2">
                <.live_component
                  module={LiveFeedbackWeb.QuestionLive.OptionContent}
                  option={option}
                  id={"option_content_#{option}"}
                />
              </td>
              <td class="px-4 py-2 text-center">
              <.live_component
                module={LiveFeedbackWeb.QuestionLive.RadioOrCheckbox}
                question_type={@question_type}
                option={option}
                id={"radio_checkbox_#{option}"}
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
    <div id="true_false" class="space-y-4">
      <table class="w-full table-auto border-collapse border border-gray-300">
        <thead>
          <tr class="bg-gray-200">
            <th class="px-4 py-2 text-left">Option</th>
            <th class="px-4 py-2 text-left">Correct</th>
          </tr>
        </thead>
        <tbody>
          <%= for option <- ["A", "B"] do%>
            <tr>
              <td class="px-4 py-2"><%= if option == "A", do: "True", else: "False" %></td>
              <td class="px-4 py-2 text-center">
                <input type="radio" id={"correct_#{option}"} name="answer" value={option} class="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500" />
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
             id={"correct_#{@option}"}
             name={if @question_type == "multiple_choice", do: "answer", else: "correct_#{@option}"}
             value={@option}
             class="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500" />
    """
  end
end

defmodule LiveFeedbackWeb.QuestionLive.OptionContent do
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <input type="text"
           id={"option_#{@option}"}
           name={"option_#{@option}"}
           class="block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
    """
  end
end
