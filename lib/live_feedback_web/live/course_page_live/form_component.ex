defmodule LiveFeedbackWeb.CoursePageLive.JoinCourseFormComponent do
  use LiveFeedbackWeb, :live_component

  alias LiveFeedback.Courses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Join a class with a code</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="join-class-form"
        phx-target={@myself}
        phx-submit="join"
      >
        <.input field={@form[:class_code]} type="text" label="Class Code" />
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
  def handle_event("join", %{"course_page" => %{"class_code" => class_code, "custom_registration_name" => custom_registration_name, "display_name" => display_name}}, socket) do
    case Courses.get_course_page_by_slug(class_code) do
      {:ok, course} ->
        attrs = %{
          "user_id" => socket.assigns.current_user.id,
          "course_page_id" => course.id,
          "role" => "user",
          "display_name" => display_name,
          "custom_registration_id" => custom_registration_name,
          "is_active" => true
        }
        IO.inspect(attrs)
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
               |> push_patch(to: socket.assigns.patch)}

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

      {:error, _reason} ->
        {:noreply, socket
        |> push_patch(to: ~p"/course_pages/join")
        |> put_flash(:error, "Invalid Class Code")}
    end
  end
  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end



defmodule LiveFeedbackWeb.CoursePageLive.NewCourseFormComponent do
  use LiveFeedbackWeb, :live_component

  alias LiveFeedback.Courses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Manage your feedback pages</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="course_page-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:slug]} type="text" label="Slug (this goes into the URL)" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Feedback page</.button>
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
  def handle_event("validate", %{"course_page" => course_page_params}, socket) do
    changeset = Courses.change_course_page(socket.assigns.course_page, course_page_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"course_page" => course_page_params}, socket) do
    save_course_page(socket, socket.assigns.action, course_page_params)
  end

  defp save_course_page(socket, :edit, course_page_params) do
    case Courses.update_course_page(socket.assigns.course_page, course_page_params) do
      {:ok, course_page} ->
        notify_parent({:saved, course_page})

        {:noreply,
         socket
         |> put_flash(:info, "Feedback page updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_course_page(socket, :new, course_page_params) do
    user = socket.assigns.current_user

    course_page_params = Map.put_new(course_page_params, "user_id", user.id)

    case Courses.create_course_page(course_page_params) do
      {:ok, course_page} ->
        attrs = %{
          "user_id" => socket.assigns.current_user.id,
          "course_page_id" => course_page.id,
          "role" => "owner"
        }
        Courses.join_class(attrs)
        IO.inspect(course_page)
        notify_parent({:saved, course_page})

        {:noreply,
         socket
         |> put_flash(:info, "Feedback page created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
