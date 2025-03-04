defmodule LiveFeedbackWeb.ActivityLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Messages
  alias LiveFeedback.Courses
  alias LiveFeedback.Questions
  alias LiveFeedback.Queues
  alias LiveFeedback.Messages.Message
  alias LiveFeedback.Selection
  alias LiveFeedback.Activity
  alias QRCode

  @impl true
  def mount(%{"coursepage" => slug}, session, socket) do
    # Initial Setup
    # Get Course Page Object -- We need CoursePageID, CourseTitle,
    course_page = Courses.get_course_page_by_slug!(slug)

    # Get the anonymous ID
    anonymous_id = Map.get(session, "anonymous_id")

    # Get the UserID
    user_id = Map.get(session, "user_id", nil)
    # Get ProfileID
    profile =
      if is_nil(user_id) do
        nil
      else
        case Selection.get_profile_id(user_id, course_page.id) do
          nil -> nil
          # auto join functionality
          # attrs = %{
          # "user_id" => user_id,
          # "course_page_id" => course_page.id,
          # "role" => "user"
          # }

          # case Courses.join_class(attrs) do
          # {:ok, profile} -> profile
          # {:error, _reason} -> nil
          # end

          profile -> profile
        end
      end

    # Determine if they are the Presenter or not

    presenter = if profile && profile.role == "owner", do: true, else: false

    # Get the queue if it exists
    {queue, queue_id, first_question, messages, question_responses, max_question_num} =
      case Queues.get_presenting_queue_for_course(course_page.id) do
        nil ->
          {nil, nil, nil, [], nil, nil}

        queue ->
          queue_id = queue.id
          first_question = Selection.get_question_from_queue(queue.id, 1)
          max_question_num = Questions.get_max_display_order(queue.id)

          messages =
            if first_question && first_question.question_type == "QA",
              do: Messages.get_messages_for_question(first_question.id),
              else: nil

          question_responses =
            if first_question,
              do:
                if(presenter,
                  do: Selection.get_question_responses(first_question.id),
                  else: Selection.get_profile_responses(anonymous_id, first_question.id)
                ),
              else: nil

          {queue, queue_id, first_question, messages, question_responses, max_question_num}
      end

    # Set the Visibility of the QR Code to be based on if they are a presenter or not
    qr_code_visible = presenter

    # Not sure if I need this but will leave it for now
    # Subscribe to the Pubsub for this Course ID
    if connected?(socket), do: Messages.subscribe(course_page.id)
    if connected?(socket), do: Messages.subscribe(queue_id)

    {:ok,
     socket
     |> assign(:anonymous_id, anonymous_id)
     |> assign(:user_id, user_id)
     |> assign(:profile_id, if(profile, do: profile.id, else: nil))
     |> assign(:page_admin, presenter)
     |> assign(:qr_code_visible, qr_code_visible)
     |> assign(:course_page, course_page)
     # This needs to have a default value
     |> assign(:live_action, :index)
     # This needs to have a default value
     |> assign(:message, nil)
     # Use existing sort_by or default to :oldest
     |> assign_new(:sort_by, fn -> :oldest end)
     |> assign(:current_question_num, 1)
     |> assign(:max_question_num, max_question_num)
     |> assign(:current_question, first_question)
     |> assign(:queue_id, queue_id)
     |> assign(:responses, question_responses)
     |> stream(
       :messages,
       messages || []
     )}
  end

  # This is always ran after the mount function
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
     |> apply_action(socket.assigns.live_action)}
  end

  defp apply_action(socket, :index) do
    page_title =
      if socket.assigns.current_question == nil do
        "#{socket.assigns.course_page.title} is Not Currently Presenting"
      else
        "#{socket.assigns.course_page.title}: Question #{socket.assigns.current_question_num}"
      end

    socket
    |> assign(:page_title, page_title)
  end

  # We do not have a apply_action for :new (This may or may not be something we need to add based on how we do new messages)

  # Handle Event for changing question
  @impl true
  def handle_event("change_question", %{"direction" => direction}, socket) do
    current_question_num = socket.assigns.current_question_num

    next_question_num =
      if(direction == "next", do: current_question_num + 1, else: current_question_num - 1)

    next_question = Selection.get_question_from_queue(socket.assigns.queue_id, next_question_num)

    question_responses =
      if(next_question.question_type != "QA",
        do: Selection.get_question_responses(next_question.id),
        else: nil
      )

    messages =
      if(next_question.question_type == "QA",
        do: Messages.get_messages_for_question(next_question.id),
        else: []
      )

    topic = "#{socket.assigns.queue_id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub,topic,{:change_question, next_question_num, next_question, question_responses, messages})

    {:noreply, socket}
  end

  # Create Message Function called by the Form in the QA component
  def handle_event("create_message", %{"message" => message_params}, socket) do
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

  def handle_event("join-class", %{}, socket) do
    if socket.assigns.user_id do
      # make a join modal
      Process.send_after(self(), :clear_flash, 3250)

      {:noreply,
       socket
       |> put_flash(:error, "Please add from course page")}
    else
      {:noreply,
       socket
       |> redirect(to: ~p"/users/log_in")
       |> put_flash(:error, "You will need to login to save a class")}
    end
  end

  # Event called by the new message pubsub
  def handle_info({:new_message, message}, socket) do
    # Update the messages stream with the new message
    {:noreply, stream_insert(socket, :messages, message)}
  end

  # Event called by the delete message pubsub
  def handle_info({:delete_message, message}, socket) do
    # Update the messages stream with the new message
    {:noreply, stream_delete(socket, :messages, message)}
  end

  # Event called by the delete all messages pubsub
  def handle_info({:delete_all_messages}, socket) do
    {:noreply, stream(socket, :messages, [], reset: true)}
  end

  # Event called by the Update message & like message pubsub
  def handle_info({:update_message, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end

  def handle_info({:change_question, next_question_num, next_question, question_responses, messages},socket) do
    {:noreply,
     socket
     |> assign(:current_question_num, next_question_num)
     |> assign(:current_question, next_question)
     |> assign(:responses, question_responses)
     |> stream(:messages, messages, reset: true)}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  # Handle Info for PubSub Update --------------------------------------------------
  def handle_info({:toggle_update, _value}, socket) do
    slug = socket.assigns.course_page.slug
    # Force remount by returning :noreply with new assigns
    {:noreply, redirect(socket, to: ~p"/page/#{slug}")}
  end

  # Handle Info for Sorting Messages -----------------------------------------------
  @impl true
  def handle_info({:sorted_messages, sort_by_atom, sorted_messages}, socket) do
    {:noreply,
     socket
     # Update the sort_by atom in the socket
     |> assign(:sort_by, sort_by_atom)
     # Stream the sorted messages
     |> stream(:messages, sorted_messages, reset: true)}
  end

  # Handle Info for Deleting all Messages ------------------------------------------

  def handle_info({:deleted_all_messages, _question_occurrence_id}, socket) do
    topic = "#{socket.assigns.queue_id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:delete_all_messages})
    {:noreply, socket}
  end

  # Handle Info for Deleting a Message From Focus Mode ------------------------------
  def handle_info({:deleted_message_modal, message}, socket) do
    topic = "#{socket.assigns.queue_id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:delete_message, message})

    {:noreply,
     socket
     |> assign(:live_action, :index)}
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
    topic = "#{socket.assigns.queue_id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:update_message, update_message})
    {:noreply, socket}
  end

  # Handle Info for Editing a Message From the Message Component -------------------
  def handle_info({:selected_message_edit, message}, socket) do
    {:noreply, assign(socket, live_action: :edit, message: message)}
  end

  def handle_info({LiveFeedbackWeb.FeedbackLive.FormComponent, {:saved, message}}, socket) do
    topic = "#{socket.assigns.queue_id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:update_message, message})
    {:noreply, socket}
  end

  # Handle Info for Deleting a Message From the Message Component ------------------
  def handle_info({:selected_message_delete, message}, socket) do
    topic = "#{socket.assigns.queue_id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:delete_message, message})
    {:noreply, socket}
  end

  # Handle Info for Refreshing Responses to Quiz Questions
  def handle_info({:refresh_responses}, socket) do
    question_responses =
      Selection.get_profile_responses(
        socket.assigns.anonymous_id,
        socket.assigns.current_question.id
      )

    {:noreply, assign(socket, :responses, question_responses)}
  end

  # Handle Info for testing/troubleshooting purposes only ------------------------------------------
  def handle_info(msg, socket) do
    IO.inspect(msg, label: "Unhandled message")
    {:noreply, socket}
  end
end
