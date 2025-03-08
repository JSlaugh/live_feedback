defmodule LiveFeedback.ActivityResults do

  alias LiveFeedback.Repo
  alias LiveFeedback.Questions.QuestionOptionsOccurrence

  def process_responses(responses, current_question) do

    # Group responses by their question_options_occurrence_id
    grouped_responses = Enum.group_by(responses, & &1.question_options_occurrence_id)

    # Get all option IDs for the current question
    all_option_ids = Enum.map(current_question.question_options_occurrences, & &1.id)

    # Calculate the number of responses for each option
    response_counts = all_option_ids
    |> Enum.map(fn option_id ->
      %{
        option_id: option_id,
        count: length(Map.get(grouped_responses, option_id, []))
      }
    end)

    # Calculate the total number of responses across all options
    total_responses = Enum.sum(Enum.map(response_counts, & &1.count))

    # Process the response counts
    processed_responses = response_counts
    |> Enum.with_index()
    |> Enum.map(fn {response_count, index} ->
      # Calculate the percentage of responses for this option
      percentage = if total_responses > 0, do: Float.round(response_count.count / total_responses * 100, 1), else: 0

      # Fetch the text for this option
      option_text = fetch_option_text(response_count.option_id)

      # Fetch correctness for the option
      correctness = fetch_correctness(response_count.option_id)

      # Return a tuple
      {option_text, correctness, percentage, response_count.count, index}
    end)

    # Sort the processed responses by count in descending order
    Enum.sort_by(processed_responses, fn {_, _, _, count, _} -> count end, &>=/2)
  end

  # You'll need to implement this based on your schema
  defp fetch_option_text(option_occurrence_id) do
    # Fetch the option text from QuestionOptionsOccurrence table
    QuestionOptionsOccurrence
    |> Repo.get(option_occurrence_id)
    |> Map.get(:option_content)
  end

  # You'll need to implement this based on your schema
  defp fetch_correctness(option_occurrence_id) do
    # Fetch is_correct from QuestionOptionsOccurrence table
    QuestionOptionsOccurrence
    |> Repo.get(option_occurrence_id)
    |> Map.get(:is_correct)
  end
end
