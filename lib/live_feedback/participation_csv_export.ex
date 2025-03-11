defmodule LiveFeedback.ParticipationCsvExport do
  alias LiveFeedback.Repo
  alias LiveFeedback.Participation.ParticipationRequest
  require NimbleCSV
  import Ecto.Query

  NimbleCSV.define(MyCSV, separator: ",", escape: "\"")

  def export_participation_requests(course_page_id, date_param) do

    # Cast course_page_id to an integer for use in SQL query
    course_page_id = String.to_integer(course_page_id)

    # Convert date to iso so postgres recognizes it
    parsed_date = Date.from_iso8601!(date_param)

    # Headers for CSV data
    headers = ["presented_date", "display_name", "custom_registration_id", "question_id", "question_content", "option_content", "option_order", "correct_yn"]

    # Query your data in the format for participation summaries
      query =
        from qor in "question_options_responses",
        left_join: qoo in "question_options_occurrences", on: qor.question_options_occurrence_id == qoo.id,
        left_join: qo in "question_occurrences", on: qoo.question_occurrence_id == qo.id,
        left_join: q in "queues", on: qo.queue_id == q.id,
        left_join: up in "user_profiles", on: qor.user_profile_id == up.id,
        where: q.course_page_id == ^course_page_id,
        where: q.presented_date == ^parsed_date,
        group_by: [q.presented_date, up.display_name, up.custom_registration_id, qo.id, qo.question_content],
        order_by: [asc: q.presented_date, asc: up.custom_registration_id],
        select: %{
          presented_date: q.presented_date,
          display_name: up.display_name,
          custom_registration_id: up.custom_registration_id,
          question_occurrence_id: qo.id,
          question_content: qo.question_content,
          option_content: fragment("STRING_AGG(?, ', ')", qoo.option_content),
          option_order: fragment("STRING_AGG(?, ', ')", qoo.option_order),
          is_correct: fragment("STRING_AGG(CAST(CASE WHEN ? IS TRUE THEN 1 ELSE 0 END AS text), ', ')", qoo.is_correct)
        }

    participation_summary =
      Repo.all(query)


    # Format the results to match nimble_csv format
    formatted_results =
      participation_summary
      |> Enum.map(fn row ->
        [
          row.presented_date,
          row.display_name,
          row.custom_registration_id,
          row.question_occurrence_id,
          row.question_content,
          row.option_content,
          row.option_order,
          row.is_correct
        ]
      end)

    # Try to pull a record. If it doesn't exist, throw an error
      # Assign participation_date to a var to use in name of file
      try do
        presented_date =
          formatted_results
          |> List.first() # Get first row
          |> List.first() # Get first column. It will always be presented_date

          # Create filename
          filename = "course_#{course_page_id}_attendance_export_#{presented_date}"

          # Convert rows to CSV format
          csv_data =
            [headers | formatted_results]
            |> MyCSV.dump_to_iodata()


          # Logic to determine what directory to write to based on your environment
          file_path = if Mix.env() == :prod do
            # Code that should run on the server (production)
            # Use var for version num
            "/app/lib/live_feedback-0.1.0/priv/static/participation_summaries/#{filename}.csv"
          else
            # Code that should run on your local machine (dev or test)
            "priv/static/participation_summaries/#{filename}.csv"
          end

          # Write to file
          File.write!(file_path, csv_data)

        {:ok, formatted_results}
      rescue
        _hold in FunctionClauseError -> {:error, "No participation data found for the given date"}
      end

  end

end
