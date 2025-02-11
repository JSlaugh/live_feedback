defmodule LiveFeedbackWeb.QaComponent do
  use Phoenix.LiveComponent

  import LiveFeedbackWeb.CoreComponents

  def render(assigns) do
    # Variables that need to passed into the activity
    page_admin_check = Map.get(assigns, :page_admin)
    course_page_check = Map.get(assigns, :coures_page) # These may need to be checked but they did break. Possibly because currently using default vales
    sort_by_check = Map.get(assigns, :sort_by)
    streams_check = Map.get(assigns, :streams)
    anonymous_id_check = Map.get(assigns, :anonymous_id)
    live_action_check = Map.get(assigns, :live_action)
    message_check = Map.get(assigns, :message) # These may need to be checked but they did break. Possibly because currently using default vales
    page_title_check = Map.get(assigns, :page_title)

    if is_nil(page_admin_check) do
      raise ArgumentError, "page_admin attribute is required"
    end

    if is_nil(sort_by_check) do
      raise ArgumentError, "sort_by attribute is required"
    end

    if is_nil(streams_check) do
      raise ArgumentError, "streams attribute is required"
    end

    if is_nil(anonymous_id_check) do
      raise ArgumentError, "anonymous_id attribute is required"
    end

    if is_nil(live_action_check) do
      raise ArgumentError, "live_action attribute is required"
    end

    if is_nil(page_title_check) do
      raise ArgumentError, "page_title attribute is required"
    end

    ~H"""
      <div>
        <%!-- If it is an admin or owner of the page it should show these items --%>
        <%= if @page_admin do %>
        <.button phx-click="delete_all_messages" phx-target={@myself} class="bg-red-600 hover:bg-red-600">
          Clear the Page
        </.button>
        <% end %>

        <%!-- Items for anyone --%>
        <.link patch={"/page/#{@course_page.slug}/new"}>
          <.button>New Message</.button>
        </.link>

        <div>
          <div class="my-2 lg:my-4">
            <form phx-change="sort_messages" phx-target={@myself}>
              <select id="sort" name="sort" class="p-2 border rounded-lg">
                <option value="oldest" selected={@sort_by == :oldest}>Oldest</option>

                <option value="newest" selected={@sort_by == :newest}>Newest</option>

                <option value="like_count" selected={@sort_by == :like_count}>Most Liked</option>
              </select>
            </form>
          </div>
        </div>

        <div id="messages" phx-update="stream" class="block">
          <%= for {id, message} <- @streams.messages do %>
            <div id={id} class="">
              <!-- Message Box LiveView Component -->
              <.live_component
                module={LiveFeedbackWeb.MessageComponent}
                id={"message-#{id}"}
                message={message}
                anonymous_id={@anonymous_id}
                page_admin={@page_admin}
                parent_pid={self()}
              />
            </div>
          <% end %>
        </div>

        <%!-- Focus Modal --%>
        <.modal
          :if={@live_action == :focus}
          id="message-modal"
          show
          on_cancel={Phoenix.LiveView.JS.patch("/page/testtemplate")}
        >
        <%!-- on_cancel={Phoenix.LiveView.JS.patch("/page/#{@course_page.slug}")}  This is what it should be there when not on a test page --%>
          <div class="flex justify-between p-4 bg-brand_grey rounded-lg">
            <div class="">
              <p class="text-lg break-all"><%= @message.content %></p>
            </div>

            <div>
              <%= if @page_admin || @anonymous_id == @message.anonymous_id do %>
                <button phx-click="delete_message" phx-target={@myself} phx-value-id={@message.id} class="ml-2 text-red-500">
                  <.icon name="hero-trash" />
                </button>
              <% end %>
            </div>
          </div>
        </.modal>

        <%!-- New / Edit Message Modal --%>
        <.modal
          :if={@live_action in [:new, :edit]}
          id="message-modal"
          show
          on_cancel={Phoenix.LiveView.JS.patch("/page/testtemplate")}
        >
        <%!-- on_cancel={Phoenix.LiveView.JS.patch("/page/#{@course_page.slug}")} This is what should be there when not a test page --%>
          <.live_component
            module={LiveFeedbackWeb.FeedbackLive.FormComponent}
            id={@message.id || :new}
            course_page={@course_page}
            title={@page_title}
            action={@live_action}
            message={@message}
            anonymous_id={@anonymous_id}
            patch={"/page/#{@course_page.slug}"}
          />
        </.modal>
      </div>
    """
  end

  # Sort Messages Handle Event
  @impl true
  def handle_event("sort_messages", %{"sort" => sort_by}, socket) do
    # Ensure that sort_by is an atom
    sort_by_atom = String.to_existing_atom(sort_by)

    course_page_id = socket.assigns.course_page.id

    # Fetch and update the sorted messages
    sorted_messages = LiveFeedback.Messages.get_messages_for_course_page_id(course_page_id, sort_by_atom)

    send(socket.assigns.parent_pid, {:sorted_messages, sort_by_atom, sorted_messages})
    {:noreply, socket}
  end

  # Delete All Messages Handle Event
  @impl true
  def handle_event("delete_all_messages", _params, socket) do
    if socket.assigns.page_admin do
      LiveFeedback.Messages.delete_all_messages_for_course_page(socket.assigns.course_page)
      send(socket.assigns.parent_pid, {:deleted_all_messages, socket.assigns.course_page.id})
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  # Delete Message Handle Event for Focus Modal
  @impl true
  def handle_event("delete_message", %{"id" => id}, socket) do
    message = LiveFeedback.Messages.get_message!(id)

    if socket.assigns.page_admin ||
          message.anonymous_id == socket.assigns.anonymous_id do
      LiveFeedback.Messages.delete_message(message)
      send(socket.assigns.parent_pid, {:deleted_message_modal, message})
      {:noreply, socket}
    else
      {:noreply, put_flash(socket, :error, "You are not authorized to delete this message.")}
    end
  end

  # Focus Message Handle Event ---Inside the MessageComponent---
  def handle_info({:selected_message_focus, message}, socket) do
    send(socket.assigns.parent_pid, {:selected_message_focus, message})
    {:noreply, socket}
  end

  # Like Message Handle Event ---Inside the MessageComponent---
  def handle_info({:selected_message_liked, update_message}, socket) do
    send(socket.assigns.parent_pid, {:selected_message_liked, update_message})
    {:noreply, socket}
  end

  # Edit Message Handle Event ---Inside the MessageComponent---
  def handle_info({:selected_message_edit, message}, socket) do
    send(socket.assigns.parent_pid, {:selected_message_edit, message})
    {:noreply, socket}
  end

  # Delete Message Handle Info ---Inside the MessageComponent---
  def handle_info({:selected_message_delete, message}, socket) do
    send(socket.assigns.parent_pid, {:selected_message_delete, message})
    {:noreply, socket}
  end

end
