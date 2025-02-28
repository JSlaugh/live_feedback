defmodule LiveFeedbackWeb.QueueLive.FormComponent do
  use LiveFeedbackWeb, :live_component

  alias LiveFeedback.Queues
  import LiveFeedbackWeb.CoreComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %> <%!-- NEEDS WORK Subtitle Updated Potentially to match Add or Edit --%>
        <:subtitle>Use this form to manage queue records in your database.</:subtitle>
      </.header>
      
      <.simple_form
        for={@form}
        id="queue-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Queue Name:" />
        <.input field={@form[:description]} type="text" label="Description:" />
        <.input field={@form[:presented_date]} type="date" label="Presentation Date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Queue</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true

  def update(%{queue: queue} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Queues.change_queue(queue, %{}))
     end)}
  end

  @impl true
  def handle_event("validate", %{"queue" => queue_params}, socket) do
    changeset = Queues.change_queue(socket.assigns.queue, queue_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"queue" => queue_params}, socket) do
    queue_params = Map.put(queue_params, "course_page_id", socket.assigns.course_page_id)
    save_queue(socket, socket.assigns.action, queue_params)
  end

  defp save_queue(socket, :edit, queue_params) do
    case Queues.update_queue(socket.assigns.queue, queue_params) do
      {:ok, queue} ->
        notify_parent({:saved, queue})

        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_queue(socket, :new, queue_params) do
    case Queues.create_queue(queue_params) do
      {:ok, queue} ->
        notify_parent({:saved, queue})

        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
