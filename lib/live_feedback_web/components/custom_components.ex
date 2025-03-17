defmodule LiveFeedbackWeb.CustomComponents do
  use Phoenix.Component

  #Main Activity Template Component
  def activity_template(assigns) do
    ~H"""
      <!-- Main Block -->
      <div class="max-w-full lg:grid lg:grid-cols-[1fr,3fr,1fr] lg:gap-4">
        <!-- Left Sidebar -->
        <div id="leftSidebar" class="">
          <%= render_slot(@leftSidebar) %>
        </div>
        <!-- Body -->
        <div id="body" class="">
          <%= render_slot(@activity) %>
        </div>
        <!-- Right Sidebar -->
        <div id="rightSidebar" class="">
          <%= render_slot(@rightSidebar) %>
        </div>
      </div>
    """
  end

end
