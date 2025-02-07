defmodule LiveFeedbackWeb.QaComponent do
  use Phoenix.LiveComponent

  import LiveFeedbackWeb.CoreComponents

  def render(assigns) do
    # Variables that need to passed into the activity
    # page_admin, course_page, sort_by, streams, anonymous_id

    ~H"""
      <div>
        <%!-- If it is an admin or owner of the page it should show these items --%>
        <%= if @page_admin do %>
        <.button phx-click="delete_all_messages" class="bg-red-600 hover:bg-red-600">
          Clear the Page
        </.button>
        <% end %>

        <%!-- Items for anyone --%>
        <.link patch={"/page/#{@course_page.slug}/new"}>
          <.button>New Message</.button>
        </.link>

        <div>
          <div class="my-2 lg:my-4">
            <form phx-change="sort_messages">
              <select id="sort" name="sort" class="p-2 border rounded-lg">
                <option value="oldest" selected={@sort_by == :oldest}>Oldest</option>

                <option value="newest" selected={@sort_by == :newest}>Newest</option>

                <option value="like_count" selected={@sort_by == :like_count}>Most Liked</option>
              </select>
            </form>
          </div>
        </div>

        <div id="messages" phx-update="stream" class="block">
          <%= for {id, message} <- @streams.messages do %>
            <div id={id} class="">
              <!-- Message Box LiveView Component -->
              <.live_component
                module={LiveFeedbackWeb.MessageComponent}
                id={"message-#{id}"}
                message={message}
                anonymous_id={@anonymous_id}
                page_admin={@page_admin}
                parent_pid={self()}
              />
            </div>
          <% end %>
        </div>
      </div>
    """
  end
end
