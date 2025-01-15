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

    {:ok,
     socket
     |> assign(:anonymous_id, anonymous_id)
     |> assign(:page_admin, page_admin)
     |> assign(:course_page, course_page)
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
  def handle_event("edit_message", %{"id" => id, "content" => content}, socket) do
    message = Messages.get_message!(id)

    if (socket.assigns.current_user && socket.assigns.current_user.is_admin) ||
         message.anonymous_id == socket.assigns.anonymous_id do
      Messages.update_message(id, %{"content" => content})
      {:noreply, stream(socket, :messages, Messages.get_messages_for_course_page_id(socket.assigns.course_page.id))}
    else
      {:noreply, put_flash(socket, :error, "You cannot edit this message.")}
    end
  end

  @impl true
  @impl true
def handle_event("like_message", %{"id" => id, "value" => value}, socket) do
  message = Messages.get_message!(id)
  user_id_or_anonymous_id = socket.assigns.anonymous_id

  case Messages.toggle_like_message(message, user_id_or_anonymous_id, value) do
    {:ok, updated_message} ->
      # Update the message in the LiveView stream
      {:noreply, stream_insert(socket, :messages, updated_message)}

    {:error, changeset} ->
      # Handle errors, e.g., log or display an error message
      IO.inspect(changeset.errors, label: "Changeset Errors")
      {:noreply, socket}
  end
end







end
