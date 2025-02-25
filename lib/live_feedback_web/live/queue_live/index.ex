defmodule LiveFeedbackWeb.QueueLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Queues.Queue
  alias LiveFeedback.Queues

  @impl true
  def mount(%{"course_page_id" => course_page_id}, _session, socket) do
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

  defp apply_action(socket, :index, %{"course_page_id" => course_page_id}) do
    socket
    |> assign(:page_title, "List Queues")
    |> assign(:course_page_id, course_page_id)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Queue")
    |> assign(:queue, %Queue{})
  end

  @impl true
  def handle_info({LiveFeedbackWeb.MessageLive.FormComponent, {:saved, message}}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end
end
