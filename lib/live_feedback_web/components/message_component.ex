defmodule LiveFeedbackWeb.MessageComponent do
  use Phoenix.LiveComponent

  import LiveFeedbackWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <%!-- Message Box --%>
    <div id={"message-#{@message.id}"} class="">
      <div class="bg-gray-200 p-4 rounded-lg flex flex-row justify-between">
        <div>
          <p class="break-all">
            <%= @message.content %>
          </p>
        </div>
        
        <div class="space-y-1 ml-1">
          <!-- Button to Focus Message -->
          <%= if @page_admin do %>
            <button
              phx-click="focus_message"
              phx-value-id={@message.id}
              phx-target={@myself}
              class="text-brand_navy underline"
            >
              <.icon name="hero-arrows-pointing-out" />
            </button>
          <% end %>
          
          <div>
            <%= if @anonymous_id == @message.anonymous_id do %>
              <button
                phx-click="edit_message"
                phx-value-id={@message.id}
                phx-target={@myself}
                class="text-brand_navy"
              >
                <.icon name="hero-pencil-square" />
              </button>
            <% end %>
          </div>
          
          <div>
            <%= if @page_admin || @anonymous_id == @message.anonymous_id do %>
              <button
                phx-click="delete_message"
                phx-value-id={@message.id}
                phx-target={@myself}
                class="text-red-500"
              >
                <.icon name="hero-trash" />
              </button>
            <% end %>
          </div>
        </div>
      </div>
       <%!-- Display Like Count and Like Button --%>
      <div class="flex bg-brand_blue -mt-4 ml-4 w-14 p-1 mb-2 rounded-lg space-x-2  items-center">
        <button
          phx-click="like_message"
          phx-value-id={@message.id}
          phx-value-value="like"
          phx-target={@myself}
          class="text-brand_navy"
        >
          <.icon name={
            if LiveFeedback.Messages.has_liked_message?(@message, @anonymous_id),
              do: "hero-hand-thumb-up-solid",
              else: "hero-hand-thumb-up"
          } />
        </button>
         <span class="text-white"><%= @message.like_count %></span>
      </div>
    </div>
    """
  end

  def handle_event("focus_message", %{"id" => id}, socket) do
    message = LiveFeedback.Messages.get_message!(id)

    send(socket.assigns.parent_pid, {:selected_message_focus, message})

    {:noreply, socket}
  end

  def handle_event("edit_message", %{"id" => id}, socket) do
    message = LiveFeedback.Messages.get_message!(id)

    send(socket.assigns.parent_pid, {:selected_message_edit, message})

    {:noreply, socket}
  end

  def handle_event("delete_message", %{"id" => id}, socket) do
    message = LiveFeedback.Messages.get_message!(id)
    page_admin = Map.get(socket.assigns, :page_admin)
    anonymous_id = Map.get(socket.assigns, :anonymous_id)

    if page_admin || message.anonymous_id == anonymous_id do
      LiveFeedback.Messages.delete_message(message)
      send(socket.assigns.parent_pid, {:selected_message_delete, message})
      {:noreply, socket}
    else
      {:noreply, put_flash(socket, :error, "You are not authorized to delete this message.")}
    end
  end

  def handle_event("like_message", %{"id" => id}, socket) do
    message = LiveFeedback.Messages.get_message!(id)
    anonymous_id = Map.get(socket.assigns, :anonymous_id)

    case LiveFeedback.Messages.toggle_like_message(message, anonymous_id) do
      {:ok, update_message} ->
        # Update only the changed message in the stream
        send(socket.assigns.parent_pid, {:selected_message_liked, update_message})
        {:noreply, socket}

      {:error, changeset} ->
        # Log errors for debugging
        IO.inspect(changeset.errors, label: "Changeset Errors")
        {:noreply, socket}
    end
  end
end
