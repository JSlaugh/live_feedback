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
          <form phx-target={@myself}>
            <select phx-change="sort_messages_parent" id="sort" name="sort" class="p-2 pr-8  border rounded-lg">
              <option value="oldest" selected={@sort_by == :oldest}>Oldest</option>

              <option value="newest" selected={@sort_by == :newest}>Newest</option>

              <option value="like_count" selected={@sort_by == :like_count}>Most Liked</option>
            </select>
            <button
              type="button"
              phx-click="sort_messages"
              phx-value-sort={@sort_by}
              phx-target={@myself}
              class="ml-2 p-2 border rounded-lg bg-gray-200 hover:bg-gray-300"
            >
              <.icon name="hero-arrow-path"/>
            </button>

            <%!-- If it is an admin or owner of the page it should show this item --%>
            <%= if @page_admin do %>
              <label
                phx-click="toggle_live_refresh"
                phx-value-sort={@sort_by}
                phx-target={@myself}
                class="relative inline-flex items-center cursor-pointer"
                title={"#{if @live_refresh, do: "Stop", else: "Start"} Live Sort"}
              >
                <input
                  type="checkbox"
                  name="is_required"
                  checked={@live_refresh}
                  class="sr-only peer"
                />
                <div class="w-20 h-8 flex items-center justify-between px-2 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-12 peer-checked:after:border-white after:content-[''] after:absolute after:top-[4px] after:left-[4px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-blue-600">
                  <%= if @live_refresh do %>
                    <span class="text-xs text-white font-bold pl-0.5 z-10">Stop</span>
                    <span class="text-xs text-gray-800 font-bold pr-0.5 z-10 opacity-0">Start</span>
                  <% else %>
                    <span class="text-xs text-white font-bold pl-0.5 z-10 opacity-0">Stop</span>
                    <span class="text-xs text-gray-800 font-bold pr-0.5 z-10">Start</span>
                  <% end %>
                </div>
              </label>
            <% end %>
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
          <.textareaWithSave
          field={@form[:content]}
          type="textarea"
          label="New Message"
          phx-hook="SubmitOnEnter"
          phx-target={@myself}
          phx-throttle="500"
          />
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
                phx-click="answer_message"
                phx-target={@myself}
                phx-value-id={@message.id}
                class="ml-2 text-red-500"
              >
                <.icon name="hero-archive-box" />
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

  # Sort Messages Parent Handle Event
  @impl true
  def handle_event("sort_messages_parent", %{"sort" => sort_by}, socket) do
    # Run Sort
    send(socket.assigns.parent_pid, {:sort_messages, sort_by})

    # If live_refresh is on, turn it off
    if socket.assigns.live_refresh do
      live_refresh = false
      send(socket.assigns.parent_pid, {:toggle_live_refresh, live_refresh})
    end

    {:noreply, socket}
  end

  # Sort Messages Handle Event -- Updated for Question Occurrences
  @impl true
  def handle_event("sort_messages", %{"sort" => sort_by}, socket) do
    send(socket.assigns.parent_pid, {:sort_messages, sort_by})
    {:noreply, socket}
  end

  # Live Refresh/Sort
  def handle_event("toggle_live_refresh", %{"sort" => sort_by}, socket) do
    # toggle boolean
    live_refresh = !socket.assigns.live_refresh
    send(socket.assigns.parent_pid, {:toggle_live_refresh, live_refresh})

    # Run Sort
    if live_refresh do
      Process.send_after(self(), {:run_sort, sort_by}, 2000)
    end

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

  def handle_event("answer_message", %{"id" => id}, socket) do
    message = Messages.get_message!(id)
    page_admin = Map.get(socket.assigns, :page_admin)
    anonymous_id = Map.get(socket.assigns, :anonymous_id)

    if page_admin || message.anonymous_id == anonymous_id do
      attrs = %{"is_answered" => true}
      Messages.answer_message(message, attrs)
      # deletes message from stream

      send(socket.assigns.parent_pid, {:selected_message_delete, message})
      {:noreply, socket |> push_patch(to: "/page/#{socket.assigns.course_page.slug}")}
    else
      {:noreply,
       put_flash(socket, :error, "You are not authorized to mark this question as answered.")}
    end
  end

  # Create Message Function called by the Form in the QA component
  def handle_event("create_message", %{"message" => message}, socket) do
    message_params = %{"content" => message}

    message_params =
      Map.merge(message_params, %{
        "anonymous_id" => socket.assigns.anonymous_id || nil,
        "question_occurrence_id" => socket.assigns.current_question.id || nil,
        "user_profile_id" => socket.assigns.profile_id || nil
      })

    case Messages.create_message(message_params) do
      {:ok, message} ->
        topic = "#{socket.assigns.queue_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:new_message, message})
        # Reset the form.
        socket =
          assign(socket, :form, to_form(Messages.change_message(%Message{}), action: :validate))

        {:noreply, socket}

      {:error, changeset} ->
        form = to_form(changeset)
        socket = assign(socket, :form, form)
        {:noreply, socket}
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
