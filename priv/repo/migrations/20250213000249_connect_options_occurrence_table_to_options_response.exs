defmodule LiveFeedback.Repo.Migrations.ConnectOptionsOccurrenceTableToOptionsResponse do
  use Ecto.Migration

  def change do
    alter table(:question_options_responses) do
      remove :question_occurrence_id
      remove :option_response
      add :question_options_occurrence_id, references(:question_options_occurrences, on_delete: :nothing)
    end
  end
end
