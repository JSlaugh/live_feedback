defmodule LiveFeedbackWeb.JoinCourseFormComponent do
  use LiveFeedbackWeb, :live_component

  alias LiveFeedback.Courses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Join current class</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="join-class-form"
        phx-target={@myself}
        phx-submit="join"
      >
        <.input field={@form[:display_name]} type="text" label="Display Name" />
        <.input field={@form[:custom_registration_name]} type="text" label="Organization ID" placeholder="Optional"/>
        <:actions>
          <.button phx-disable-with="Joining...">Join Class</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{course_page: course_page} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Courses.change_course_page(course_page))
     end)}
  end

  @impl true
  def handle_event("join", %{"course_page" => %{"custom_registration_name" => custom_registration_name, "display_name" => display_name}}, socket) do
        attrs = %{
          "user_id" => socket.assigns.current_user.id,
          "course_page_id" => socket.assigns.course_page.id,
          "role" => "user",
          "display_name" => display_name,
          "custom_registration_id" => custom_registration_name,
          "is_active" => true
        }
        case Courses.join_class(attrs) do
          {:ok, profile} ->
            socket =
              socket
              |> put_flash(:info, "Joined class successfully")

              course_page = Courses.get_course_page!(profile.course_page_id)
              notify_parent({:saved, course_page})

              {:noreply,
               socket
               |> put_flash(:info, "Feedback page created successfully")
               |> redirect(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}

          {:error, message} when is_binary(message) ->
            {:noreply, socket
            |> put_flash(:error, message)
            |> push_patch(to: socket.assigns.patch)}

          _ ->
            {:noreply, socket
            |> put_flash(:error, "Something went wrong. Please try again.")
            |> push_patch(to: socket.assigns.patch)}
        end
  end
  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
