
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
