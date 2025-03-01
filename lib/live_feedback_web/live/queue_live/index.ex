defmodule LiveFeedbackWeb.QueueLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Queues.Queue
  alias LiveFeedback.Queues

  @impl true
  def mount(%{"id" => course_page_id}, _session, socket) do
    Phoenix.PubSub.subscribe(LiveFeedback.PubSub, "queues:#{course_page_id}")

    {:ok,
     socket
     |> stream(:queues, Queues.get_queues_for_course(course_page_id))
     |> assign(:course_name, Queues.get_course_name(course_page_id))
     |> assign(:course_page_id, course_page_id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"id" => course_page_id}) do
    socket
    |> assign(:page_title, "List Queues")
    |> assign(:course_page_id, course_page_id)
  end

  defp apply_action(socket, :new, %{"id" => course_page_id}) do
    socket
    |> assign(:page_title, "New Queue")
    |> assign(:queue, %Queue{})
    |> assign(:course_page_id, course_page_id)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Queue")
    |> assign(:queue, Queues.get_queue!(id))
  end

  @impl true
  def handle_info({LiveFeedbackWeb.QueueLive.FormComponent, {:saved, queue}}, socket) do
    {:noreply, stream_insert(socket, :queues, queue)}
  end

  @impl true
  def handle_event("delete_queue", %{"id" => id}, socket) do
    delete_queue(socket, id)
  end

  defp delete_queue(socket, id) do
    queue = Queues.get_queue(id)

    with :ok <- Bodyguard.permit(Queues, :delete_queue, socket.assigns.current_user, queue) do
      Queues.delete_queue(queue)
      {:noreply, stream_delete(socket, :queues, queue)}
    else
      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "You are not authorized to delete this queue")}
    end
  end
end
