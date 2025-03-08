defmodule LiveFeedbackWeb.QaComponent do
  alias LiveFeedback.Messages
  alias LiveFeedback.Messages.Message
  use Phoenix.LiveComponent

  import LiveFeedbackWeb.CoreComponents
  @impl true
  def render(assigns) do
    # Variables that need to passed into the activity
    if not Map.has_key?(assigns, :page_admin) do
      raise ArgumentError, "page_admin attribute is required"
    end

    if not Map.has_key?(assigns, :course_page) do
      raise ArgumentError, "course_page attribute is required"
    end

    if not Map.has_key?(assigns, :sort_by) do
      raise ArgumentError, "sort_by attribute is required"
    end

    if not Map.has_key?(assigns, :streams) do
      raise ArgumentError, "streams attribute is required"
    end

    if not Map.has_key?(assigns, :anonymous_id) do
      raise ArgumentError, "anonymous_id attribute is required"
    end

    if not Map.has_key?(assigns, :live_action) do
      raise ArgumentError, "live_action attribute is required"
    end

    if not Map.has_key?(assigns, :message) do
      raise ArgumentError, "message attribute is required"
    end

    if not Map.has_key?(assigns, :page_title) do
      raise ArgumentError, "page_title attribute is required"
    end

    if not Map.has_key?(assigns, :current_question) do
      raise ArgumentError, "current_question attribute is required"
    end

    if not Map.has_key?(assigns, :queue_id) do
      raise ArgumentError, "queue_id attribute is required"
    end

    ~H"""
    <div>
      <div class="flex justify-between mx-2 mb-4 xl:mb-6">
        <div>
          <form phx-change="sort_messages" phx-target={@myself}>
            <select id="sort" name="sort" class="p-2 pr-8  border rounded-lg">
              <option value="oldest" selected={@sort_by == :oldest}>Oldest</option>
              
              <option value="newest" selected={@sort_by == :newest}>Newest</option>
              
              <option value="like_count" selected={@sort_by == :like_count}>Most Liked</option>
            </select>
          </form>
        </div>
         <%!-- If it is an admin or owner of the page it should show these items --%>
        <%= if @page_admin do %>
          <.buttonCustomColor
            phx-click="delete_all_messages"
            phx-target={@myself}
            class="bg-logo_red hover:bg-brand_dark_red text-white"
          >
            Clear the Page
          </.buttonCustomColor>
        <% end %>
      </div>
      <div
        id="messages"
        phx-update="stream"
        class="block max-h-[400px] lg:max-h-[40vh] overflow-y-scroll mx-2"
      >
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
      <%= if !@page_admin do %>
        <.simple_form for={@form} phx-submit="create_message">
          <.textareaWithSave field={@form[:content]} type="textarea" label="New Message" />
        </.simple_form>
      <% end %>
       <%!-- Focus Modal --%>
      <.modal
        :if={@live_action == :focus}
        id="message-modal"
        show
        on_cancel={Phoenix.LiveView.JS.patch("/page/#{@course_page.slug}")}
      >
        <div class="flex justify-between p-4 bg-brand_grey rounded-lg">
          <div class="">
            <p class="text-lg break-normal"><%= @message.content %></p>
          </div>

          <div>
            <%= if @page_admin || @anonymous_id == @message.anonymous_id do %>
              <button
                phx-click="delete_message"
                phx-target={@myself}
                phx-value-id={@message.id}
                class="ml-2 text-red-500"
              >
                <.icon name="hero-trash" />
              </button>
            <% end %>
          </div>
        </div>
      </.modal>
       <%!-- New / Edit Message Modal --%>
      <.modal
        :if={@live_action in [:edit]}
        id="message-modal"
        show
        on_cancel={Phoenix.LiveView.JS.patch("/page/#{@course_page.slug}")}
      >
        <.live_component
          module={LiveFeedbackWeb.FeedbackLive.FormComponent}
          id={@message.id || :new}
          course_page={@course_page}
          title={@page_title}
          action={@live_action}
          message={@message}
          anonymous_id={@anonymous_id}
          patch={"/page/#{@course_page.id}/#{@queue_id}"}
        />
      </.modal>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    changeset = Messages.change_message(%Message{})
    {:ok, assign(socket, form: to_form(changeset, action: :validate))}
  end

  # Sort Messages Handle Event -- Updated for Question Occurrences
  @impl true
  def handle_event("sort_messages", %{"sort" => sort_by}, socket) do
    # Ensure that sort_by is an atom
    sort_by_atom = String.to_existing_atom(sort_by)

    current_question_id = socket.assigns.current_question.id

    # Fetch and update the sorted messages
    sorted_messages =
      LiveFeedback.Messages.get_messages_for_question(current_question_id, sort_by_atom)

    send(socket.assigns.parent_pid, {:sorted_messages, sort_by_atom, sorted_messages})
    {:noreply, socket}
  end

  # Delete All Messages Handle Event -- Updated for Question Occurrences
  @impl true
  def handle_event("delete_all_messages", _params, socket) do
    if socket.assigns.page_admin do
      LiveFeedback.Messages.delete_all_messages_for_question_occurrence(
        socket.assigns.current_question.id
      )

      send(socket.assigns.parent_pid, {:deleted_all_messages, socket.assigns.current_question.id})
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  # Delete Message Handle Event for Focus Modal -- Updated for Question Occurrences
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

  # Focus Message Handle Event ---Inside the MessageComponent--- Updated for Question Occurrences
  def handle_info({:selected_message_focus, message}, socket) do
    send(socket.assigns.parent_pid, {:selected_message_focus, message})
    {:noreply, socket}
  end

  # Like Message Handle Event ---Inside the MessageComponent--- Updated for Question Occurrences
  def handle_info({:selected_message_liked, update_message}, socket) do
    send(socket.assigns.parent_pid, {:selected_message_liked, update_message})
    {:noreply, socket}
  end

  # Edit Message Handle Event ---Inside the MessageComponent--- Updated for Question Occurrences
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
