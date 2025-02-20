defmodule LiveFeedbackWeb.ActivityLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Messages
  alias LiveFeedback.Courses
  alias LiveFeedback.Messages.Message
  alias LiveFeedback.Selection
  alias QRCode

  @impl true
  def mount(%{"coursepage" => course_page_id, "queue" => queue_id}, session, socket) do
    # Initial Setup
    # Get Course Page Object -- We need CoursePageID, CourseTitle,
    course_page = Courses.get_course_page!(course_page_id)

    # Get the UserID
    user_id = get_user_id(session)

    # Get ProfileID
    profile_id = Selection.get_profile_id(user_id, course_page_id).id

    # Get the First Question
    first_question = Selection.get_question_from_queue(queue_id, 1)

    # Determine if they are the Presenter or not
    presenter =
      if socket.assigns.current_user do
        course_page.user_id == socket.assigns.current_user.id ||
          socket.assigns.current_uers.is_admin
      else
        false
      end

    # Set the Visibility of the QR Code to be based on if they are a presenter or not
    qr_code_visible = presenter

    # Get the anonymous ID
    anonymous_id = get_anonymous_id(session)

    # Not sure if I need this but will leave it for now
    # Subscribe to the Pubsub for this Course ID
    if connected?(socket), do: Messages.subscribe(course_page.id)

    messages = (if first_question.question_type == "QA", do: Messages.get_messages_for_question(first_question.id), else: nil)

    {:ok,
     socket
     |> assign(:anonymous_id, anonymous_id)
     |> assign(:page_admin, presenter)
     |> assign(:qr_code_visible, qr_code_visible)
     |> assign(:course_page, course_page)
     |> assign(:live_action, :index) # This needs to have a default value
     |> assign(:message, nil) # This needs to have a default value
     |> assign_new(:sort_by, fn -> :oldest end) # Use existing sort_by or default to :oldest
     |> assign(:profile_id, profile_id)
     |> assign(:current_question_num, 1)
     |> assign(:current_question, first_question)
     |> assign(:queue_id, queue_id)
     |> stream(
       :messages,
       messages
     )}
  end

  def get_user_id(session) do
    Map.get(session, "user_id")
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

  defp apply_action(socket, :index, %{"coursepage" => course_page_id}) do
    course_page = Courses.get_course_page!(course_page_id)

    socket
    |> assign(:page_title, "Live Feedback")
    |> assign(:course_page, course_page)
    |> assign(:messages, Messages.get_messages_for_question(socket.assigns.current_question.id))
  end

  # Handle Info for Sorting Messages -----------------------------------------------
  @impl true
  def handle_info({:sorted_messages, sort_by_atom, sorted_messages}, socket) do
    {:noreply,
    socket
    |> assign(:sort_by, sort_by_atom)  # Update the sort_by atom in the socket
    |> stream(:messages, sorted_messages, reset: true)}  # Stream the sorted messages
  end

  # Handle Info for Deleteing all Messages ------------------------------------------
  def handle_info({:deleted_all_messages, question_occurrence_id}, socket) do
    {:noreply, stream(socket, :messages, [], reset: true)}
  end

  # Handle Info for Deleting a Message From Focus Mode ------------------------------
  def handle_info({:deleted_message_modal, message}, socket) do
    {:noreply, socket
    |> assign(:live_action, :index)
    |> stream_delete(:messages, message)}
  end

  def handle_info({:deleted_message, message}, socket) do # This is needed for the pubsub in messages.ex
   {:noreply, socket}
  end

  # Handle Info for Focusing on a Message -------------------------------------------
  def handle_info({:selected_message_focus, message}, socket) do
    {:noreply,
    socket
    |> assign(:live_action, :focus)
    |> assign(:message, message)}
  end

  # Handle Info for Liking a message -----------------------------------------------
  def handle_info({:selected_message_liked, update_message}, socket) do
    {:noreply, stream_insert(socket, :messages, update_message)}
  end

  def handle_info({:updated_message, updated_message}, socket) do # This is needed for the pubsub in messages.ex
    {:noreply, socket}
  end

  # Handle Info for Editing a Message From the Message Component -------------------
  def handle_info({:selected_message_edit, message}, socket) do
    {:noreply, assign(socket, live_action: :edit, message: message)}
  end

  def handle_info({LiveFeedbackWeb.FeedbackLive.FormComponent, {:saved, _message}}, socket) do
    messages = LiveFeedback.Repo.all(LiveFeedback.Messages.Message) # I think this should be moved but it does fix the issue.
    {:noreply, stream(socket, :messages, messages)}
  end

  # Handle Info for Deleting a Message From the Message Component ------------------
  def handle_info({:selected_message_delete, message}, socket) do
    {:noreply, stream_delete(socket, :messages, message)}
  end

  # Handle Info for testing purposes only ------------------------------------------
  def handle_info(msg, socket) do
    IO.inspect(msg, label: "Unhandled message")
    {:noreply, socket}
  end
end
