defmodule LiveFeedbackWeb.ParticipationController do
  use LiveFeedbackWeb, :controller
  alias LiveFeedback.ParticipationCsvExport

  def download_csv(conn, %{"course_page_id" => course_page_id}) do
    {:ok, file_path} = ParticipationCsvExport.export_participation_requests(course_page_id)


    #I NEED THE FILENAME AND FILEPATH HERE SOMEHOW
    filename = "temp"

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}.csv\"")
    |> send_file(200, file_path)
  end
end
