defmodule LiveFeedbackWeb.ActivityLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Messages
  alias LiveFeedback.Courses
  alias LiveFeedback.Messages.Message
  alias QRCode

  @impl true
  def mount(_params, session, socket) do
    #For testing purposes only
    coursepageid = "test"  #This would normally be found in the params

    # Normal Stuff
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

  # def mount(_params, _session, socket) do
  #  {:ok, socket}
  # end


end
