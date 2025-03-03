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
      join: qoo in "question_options_occurrences", on: qor.question_options_occurrence_id == qoo.id,
      join: qo in "question_occurrences", on: qoo.question_occurrence_id == qo.id,
      join: q in "queues", on: qo.queue_id == q.id,
      join: up in "user_profiles", on: qor.user_profile_id == up.id,
      select: [
        presented_date: q.presented_date,
        display_name: up.display_name,
        custom_registration_id: up.custom_registration_id,
        question_id: qo.question_id,
        question_content: qo.question_content,
        option_content: qoo.option_content,
        option_order: qoo.option_order,
        correct_yn: fragment("CASE WHEN ? IS TRUE THEN 1 ELSE 0 END", qoo.is_correct)
      ],
      where: up.course_page_id == ^course_page_id,
      where: q.presented_date == ^parsed_date,
      order_by: [asc: q.presented_date, asc: up.custom_registration_id]

    participation_summary =
      Repo.all(query)

    # Format the results to match nimble_csv format
    formatted_results =
      participation_summary
      |> Enum.map(fn row ->
        Enum.map(row, fn
          # If the value is a tuple, extract the second element
          {_, value} -> value
          # If it's a Date, convert it to a string
          %Date{} = date -> Date.to_string(date)
          # If it's a NaiveDateTime, convert it to a string
          %NaiveDateTime{} = ndt -> NaiveDateTime.to_string(ndt)
          # If it's a DateTime, convert it to a string
          %DateTime{} = dt -> DateTime.to_string(dt)
          # Otherwise, return the value as is
          value -> value
        end)
      end)

    # Try to pull a record. If it doesn't exist, throw an error
      # Assign participation_date to a var to use in name of file
      try do
        date_presented =
          formatted_results
          |> List.first() # Get first row
          |> List.first() # Get first column. It will always be presented_date

          # Create filename
          filename = "course_#{course_page_id}_attendance_export_#{date_presented}"

          # Convert rows to CSV format
          csv_data =
            [headers | formatted_results]
            |> MyCSV.dump_to_iodata()

          # Define file path
          file_path = "priv/static/participation_summaries/#{filename}.csv"

          # Write to file
          File.write!(file_path, csv_data)

        {:ok, formatted_results}
      rescue
        _hold in FunctionClauseError -> {:error, "No participation data found for the given date"}
      end

  end

end
