defmodule LiveFeedbackWeb.Components.Accordion do
  @moduledoc """
  Provides accordion-related components and helper functions.
  """
  use Phoenix.Component
  import LiveFeedbackWeb.CoreComponents
  alias Phoenix.LiveView.JS

  @doc """
  Accordion components allows users to show and hide sections of related panel on a page.

  ## Examples

  ```heex

  ```
  """
  slot :content do
    attr :title, :string
    attr :id, :string
    attr :start_closed, :boolean
  end

  def accordion(assigns) do
    ~H"""
    <div class="">
      <div class="overflow-hidden flex flex-col gap-4">
        <%= for content <- @content do %>
          <div class="border border-gray-500 rounded-lg">
            <button
              phx-click={hide_panel("##{content.id}")}
              class="w-full text-left py-2 px-4 font-semibold rounded-lg bg-gray-200 hover:bg-gray-300 focus:outline-none flex justify-between"
            >
              <%= content.title %>
              <.icon
                id={"#{content.id}-chevron"}
                name="hero-chevron-down"
                class={
                  [
                    if content[:start_closed] do
                      "rotate-180"
                    end,
                    "w-5 h-5"
                  ]
                  |> Enum.join(" ")
                }
              />
            </button>
            
            <div id={content.id} class="p-4" style={if content[:start_closed], do: "display: none;"}>
              <%= render_slot(content) %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def hide_panel(js \\ %JS{}, selector) do
    js
    |> JS.toggle(to: selector)
    |> JS.toggle_class("rotate-180", to: "#{selector}-chevron")
  end
end
