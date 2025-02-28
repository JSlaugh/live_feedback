defmodule LiveFeedbackWeb.ParticipationLive.Index do

  # CALL THE FUNCTIONS ON THIS PAGE

  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Participation
  alias LiveFeedback.Participation.ParticipationRequest

  @impl true
  def mount(%{"course_page_id" => course_page_id}, _session, socket) do

    participation_dates = Participation.list_all_available_participation_dates(course_page_id)

    # Pass in an empty changeset for the form to use
    changeset = ParticipationRequest.changeset(%ParticipationRequest{})

    {:ok,
     socket
     |> assign(:course_page_id, course_page_id)
     |> assign(:csv_gathered, false)
     |> stream(:participation_dates, participation_dates)
     |> assign(
        :form,
        to_form(changeset)
     )
    }
  end

  @impl true
  def handle_event("add_pr", %{"date" => presented_date}, socket) do

    attrs = %{
          "course_page_id" => socket.assigns.course_page_id,
          "participation_date" => presented_date,
          "date_requested" => Date.utc_today() |> Date.to_string()
        }

    case Participation.add_participation_request(attrs) do
      {:ok, _participation_request} ->

        case LiveFeedback.ParticipationCsvExport.export_participation_requests(socket.assigns.course_page_id, presented_date) do
          {:ok, formatted_results} ->
            {:noreply,
              socket
              |> put_flash(:info, "CSV export compiled successfully. Click 'Download CSV' to download your data.")
              |> assign(:participation_data, formatted_results)
              |> assign(:csv_gathered, true)}
              #IO.inspect(socket.assigns.participation_data, label: "DATA CAME THROUGH:")
          {:error, reason} ->
            {:noreply,
            socket
            |> put_flash(:error, reason)
            |> push_navigate(to: "/course_pages/#{socket.assigns.course_page_id}/participation")}
        end
    end
  end

end
