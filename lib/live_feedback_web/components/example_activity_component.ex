defmodule LiveFeedbackWeb.ExampleActivityComponent do
  use Phoenix.LiveComponent

  import LiveFeedbackWeb.CoreComponents

  def render (assigns) do
    ~H"""
      <div>
        <h1>Example Activity Component</h1>
      </div>
    """
  end
end
