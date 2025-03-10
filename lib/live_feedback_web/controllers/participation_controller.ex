defmodule LiveFeedbackWeb.ParticipationController do
  use LiveFeedbackWeb, :controller
  alias LiveFeedback.ParticipationCsvExport

  def download_csv(conn, params) do

    # Pull the parameters from the URL
    course_page_id = params["id"]
    date = params["date"]

    {:ok, file_path} = ParticipationCsvExport.export_participation_requests(course_page_id, date)


    # Create filename - This is the same code found in the LiveFeedback.ParticipationCsvExport.export_participation_requests function
    filename = "course_#{course_page_id}_attendance_export_#{date}"

    # Define file path
    file_path = "priv/static/participation_summaries/#{filename}.csv"

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}.csv\"")
    |> send_file(200, file_path)
  end
end
