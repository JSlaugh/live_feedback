defmodule LiveFeedbackWeb.CoursePageLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Courses
  alias LiveFeedback.Courses.CoursePage

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:present_mode, "user")
     |> stream(
       :course_pages,
       []
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    course_page = Courses.get_course_page!(id)

    with :ok <-
           Bodyguard.permit(
             Courses,
             :change_course_page,
             socket.assigns.current_user,
             course_page
           ) do
      socket
      |> assign(:page_title, "Edit Class")
      |> assign(:course_page, course_page)
    else
      {:error, _reason} ->
        socket
        |> put_flash(:error, "You are not authorized to manage this feedback page")
        |> redirect(to: ~p"/course_pages")
    end
  end

  defp apply_action(socket, :new, _params) do
    IO.inspect(Map.get(socket.assigns.streams, :course_pages), label: "My Stream Data")

    socket
    |> assign(:page_title, "Create Class")
    |> assign(:course_page, %CoursePage{})
  end

  defp apply_action(socket, :join, _params) do
    socket
    |> assign(:page_title, "Join page")
    |> assign(:course_page, %CoursePage{})
  end

  defp apply_action(socket, :share, %{"id" => id}) do
    course_page = Courses.get_course_page!(id)

    with :ok <-
           Bodyguard.permit(
             Courses,
             :change_course_page,
             socket.assigns.current_user,
             course_page
           ) do
      socket
      |> assign(:page_title, "Share Access")
      |> assign(:course_page, course_page)
      |> assign(:profiles, Courses.get_profiles_for_course(socket.assigns.current_user.id, id))
    else
      {:error, _reason} ->
        socket
        |> put_flash(:error, "You are not authorized to manage this feedback page")
        |> redirect(to: ~p"/course_pages")
    end
  end

  defp apply_action(socket, :host, _params) do
    course_list = Courses.list_course_pages_by_user(socket.assigns.current_user.id, "owner")

    socket
    |> assign(:present_mode, "owner")
    |> stream(:course_pages, course_list, reset: true)
  end

  defp apply_action(socket, :index, _params) do
    course_list = Courses.list_course_pages_by_user(socket.assigns.current_user.id, "user")

    socket
    |> assign(:page_title, "Listing Feedback pages")
    |> stream(:course_pages, course_list, reset: true)
  end

  @impl true
  def handle_info(
        {LiveFeedbackWeb.CoursePageLive.NewCourseFormComponent, {:saved, course_page}},
        socket
      ) do
    {:noreply, stream_insert(socket, :course_pages, course_page)}
  end

  @impl true
  def handle_info(
        {LiveFeedbackWeb.CoursePageLive.JoinCourseFormComponent, {:saved, course_page}},
        socket
      ) do
    {:noreply, stream_insert(socket, :course_pages, course_page)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    course_page = Courses.get_course_page!(id)

    with :ok <-
           Bodyguard.permit(
             Courses,
             :delete_course_page,
             socket.assigns.current_user,
             course_page
           ) do
      {:ok, _} = Courses.delete_course_page(course_page)

      {:noreply, stream_delete(socket, :course_pages, course_page)}
    else
      {:error, _reason} ->
        socket
        |> put_flash(:error, "You are not authorized to delete this page")
    end
  end

  @impl true
  def handle_event("leave", %{"id" => id}, socket) do
    course_page = Courses.get_course_page!(id)

    case Courses.leave_course_page(course_page.id, socket.assigns.current_user.id) do
      {:ok, _reason} ->
        {:noreply, stream_delete(socket, :course_pages, course_page)}

      {:error, _reason} ->
        socket
        |> put_flash(:error, "Could not leave this page")
    end
  end

  def handle_event("toggle-favorite", %{"id" => id}, socket) do
    case Courses.toggle_favorite(socket.assigns.current_user.id, id) do
      {:ok, _updated_profile} ->
        # Re-fetch all course pages to get the updated data
        course_list =
          Courses.list_course_pages_by_user(
            socket.assigns.current_user.id,
            socket.assigns.present_mode
          )

        # Reset the stream with updated data
        {:noreply, stream(socket, :course_pages, course_list, reset: true)}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to update favorite status")}
    end
  end

  # def handle_event("toggle_course_list", %{"role" => role}, socket) do
  # course_list = Courses.list_course_pages_by_user(socket.assigns.current_user.id, role)
  # {:noreply,
  # socket
  # |> assign(:present_mode, role)
  # |> stream(:course_pages, course_list, reset: true)}
  # end
end
