defmodule LiveFeedbackWeb.ToggleableImage do
  use Phoenix.LiveComponent

  import LiveFeedbackWeb.CoreComponents

  def render(assigns) do
    icon = Map.get(assigns, :icon)
    visible_bool = Map.get(assigns, :visible_bool)

    if is_nil(icon) do
      raise ArgumentError, "icon attribute is required"
    end

    if is_nil(visible_bool) do
      raise ArgumentError, "visible_bool attribute is required"
    end

    ~H"""
      <div class="hidden lg:block">
        <div class="">
          <button phx-click="toggle_block" phx-target={@myself} class="p-2 mb-4 bg-brand_blue text-white rounded-lg">
            <.icon name={@icon} />
          </button>
          <%= if @visible_bool do %>
            <%= render_slot(@innerblock) %>
          <% end %>
        </div>
      </div>
    """
  end

  def handle_event("toggle_block", _, socket) do
    toggle_bool = !socket.assigns.visible_bool

    send(socket.assigns.parent_pid, {:update_toggle, toggle_bool})

    {:noreply, assign(socket, :visible_bool, toggle_bool)}
  end
end
