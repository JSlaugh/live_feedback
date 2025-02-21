defmodule LiveFeedbackWeb.FeedbackLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Messages
  alias LiveFeedback.Courses
  alias LiveFeedback.Messages.Message
  alias QRCode

  @impl true
  def mount(%{"coursepage" => coursepageid}, session, socket) do
    course_page = Courses.get_course_page_by_slug!(coursepageid)
    if connected?(socket), do: Messages.subscribe(course_page.id)
    anonymous_id = get_anonymous_id(session)

    page_admin =
      if socket.assigns.current_user do
        course_page.user_id == socket.assigns.current_user.id ||
          socket.assigns.current_user.is_admin
      else
        false
      end

      qr_code_visible = page_admin

    {:ok,
     socket
     |> assign(:anonymous_id, anonymous_id)
     |> assign(:page_admin, page_admin)
     |> assign(:qr_code_visible, qr_code_visible)
     |> assign(:course_page, course_page)
     |> assign_new(:sort_by, fn -> :oldest end) # Use existing sort_by or default to :oldest
     |> stream(
       :messages,
       Messages.get_messages_for_course_page_id(course_page.id)
     )}
  end


  def get_anonymous_id(session) do
    Map.get(session, "anonymous_id")
  end

  @impl true
  def handle_params(params, url, socket) do
    url =
      URI.parse(url)
    {:ok, qr_code_svg} =
      QRCode.create("#{url.scheme}://#{url.authority}/page/#{socket.assigns.course_page.slug}")
      |> QRCode.render()

    {:noreply,
     socket
     |> assign(:qr_code_svg, qr_code_svg)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"coursepage" => coursepage}) do
    course_page = Courses.get_course_page_by_slug!(coursepage)

    socket
    |> assign(:page_title, "Live Feedback")
    |> assign(:course_page, course_page)
    |> assign(:messages, Messages.get_messages_for_course_page_id(course_page.id))
  end

  # defp apply_action(socket, :index, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Course page")
  #   |> assign(:course_page, Courses.get_course_page!(id))
  # end

  defp apply_action(socket, :new, %{"coursepage" => coursepage}) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:course_page, Courses.get_course_page_by_slug!(coursepage))
    |> assign(:message, %Message{})
  end

  @impl true
  def handle_event("delete_all_messages", _params, socket) do
    if socket.assigns.page_admin do
      Messages.delete_all_messages_for_course_page(socket.assigns.course_page)
      {:noreply, stream(socket, :messages, [], reset: true)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("sort_messages", %{"sort" => sort_by}, socket) do
    # Ensure that sort_by is an atom
    sort_by_atom = String.to_existing_atom(sort_by)

    course_page_id = socket.assigns.course_page.id

    # Fetch and update the sorted messages
    sorted_messages = Messages.get_messages_for_course_page_id(course_page_id, sort_by_atom)

    {:noreply,
    socket
    |> assign(:sort_by, sort_by_atom)  # Update the sort_by atom in the socket
    |> stream(:messages, sorted_messages, reset: true)}  # Stream the sorted messages
  end

  # ------------ This is the action for the delete in the modal------------
  @impl true
  def handle_event("delete_message", %{"id" => id}, socket) do
    message = Messages.get_message!(id)

    if socket.assigns.page_admin ||
         message.anonymous_id == socket.assigns.anonymous_id do
      Messages.delete_message(message)
      {:noreply, stream_delete(socket, :messages, message)}
    else
      {:noreply, put_flash(socket, :error, "You are not authorized to delete this message.")}
    end
  end

  @impl true
  def handle_info({:deleted_message, message}, socket) do
    if message.course_page_id == socket.assigns.course_page.id do
      socket =
        socket
        |> stream_delete(:messages, message)
        |> push_patch(to: ~p"/page/#{socket.assigns.course_page.slug}")

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    if message.course_page_id == socket.assigns.course_page.id do
      sorted_messages =
        Messages.get_messages_for_course_page_id(
          socket.assigns.course_page.id,
          socket.assigns.sort_by
        )

      {:noreply, stream(socket, :messages, sorted_messages, reset: true)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:updated_message, updated_message}, socket) do
    # Only update the message if it belongs to the current course page
    if updated_message.course_page_id == socket.assigns.course_page.id do
      {:noreply, stream_insert(socket, :messages, updated_message)}
    else
      {:noreply, socket}
    end
  end


  @impl true
  def handle_info({:deleted_all_messages, _course_page}, socket) do
    {:noreply, stream(socket, :messages, [], reset: true)}
  end

  # Focus Message Handle Event
  def handle_info({:selected_message_focus, message}, socket) do
    {:noreply,
    socket
    |> assign(:live_action, :focus)
    |> assign(:message, message)}
  end

  # Edit Message Handle Event
  def handle_info({:selected_message_edit, message}, socket) do
    {:noreply, assign(socket, live_action: :edit, message: message)}
  end

  # Delete Message Handle Event
  def handle_info({:selected_message_delete, message}, socket) do
    {:noreply, stream_delete(socket, :messages, message)}
  end

  # Like Message Handle Event
  def handle_info({:selected_message_liked, update_message}, socket) do
    {:noreply, stream_insert(socket, :messages, update_message)}
  end

  #Toggle QR Code Handle Event
  def handle_info({:update_toggle, toggle_bool}, socket) do
    {:noreply, assign(socket, :qr_code_visible, toggle_bool)}
  end

  @impl true
  def handle_info({LiveFeedbackWeb.FeedbackLive.FormComponent, {:saved, _message}}, socket) do
    # if message.course_page_id == socket.assigns.course_page.id do
    #   updated_messages = [message | socket.assigns.messages]
    #   {:noreply, stream(socket, :messages, updated_messages)}
    # else
    {:noreply, socket}
    # end
  end
end
