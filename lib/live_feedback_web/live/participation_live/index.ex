defmodule LiveFeedbackWeb.ParticipationLive.Index do

  # CALL THE FUNCTIONS ON THIS PAGE

  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Participation
  alias LiveFeedback.Participation.ParticipationRequest

  @impl true
  def mount(%{"id" => course_page_id}, _session, socket) do

    participation_dates = Participation.list_all_available_participation_dates(course_page_id)

    # Pass in an empty changeset for the form to use
    changeset = ParticipationRequest.changeset(%ParticipationRequest{})

    {:ok,
     socket
     |> assign(:course_page_id, course_page_id)
     |> assign(:csv_gathered, false)
     |> assign(:participation_dates, participation_dates)
     |> assign(
        :form,
        to_form(changeset)
     )
    }
  end

  @impl true
  def handle_event("add_pr", params, socket) do

   presented_date = case params do
      # When coming from table row click
      %{"date" => date} when is_binary(date) -> date
      # When coming from form submission
      %{"date" => date} -> date
      # When clicking on a row without a presented date
      %{"date" => nil} -> nil
      # When form is submitted
      %{"_target" => ["date"], "date" => date} -> date
      # When params is empty or doesn't match any pattern above
      _ -> nil
    end

    attrs = %{
          "course_page_id" => socket.assigns.course_page_id,
          "participation_date" => presented_date,
          "date_requested" => Date.utc_today() |> Date.to_string()
        }

    if presented_date do
      case Participation.add_participation_request(attrs) do
        {:ok, _participation_request} ->

          case LiveFeedback.ParticipationCsvExport.export_participation_requests(socket.assigns.course_page_id, presented_date) do
            {:ok, formatted_results} ->

              # Pull the first value of the first list (will always be presented_date unless expressly changed)
              date_presented = List.first(formatted_results) |> List.first()

              {:noreply,
                socket
                |> put_flash(:success, "CSV export compiled successfully. Click 'Download CSV' to download your data.")
                |> assign(:participation_data, formatted_results)
                |> assign(:date_presented, date_presented)
                |> assign(:csv_gathered, true)}
                #IO.inspect(socket.assigns.participation_data, label: "DATA CAME THROUGH:")
            {:error, reason} ->
              {:noreply,
              socket
              |> put_flash(:error, reason)
              |> push_navigate(to: "/course_pages/#{socket.assigns.course_page_id}/participation")}
          end
      end
    else
      # Handle the case when there's no valid date
      {:noreply, socket |> put_flash(:error, "Cannot request participation summary for a queue that hasn't been presented yet")}
    end
  end
end
