defmodule LiveFeedback.Repo.Migrations.AdditionalSpellingFixesForOccurrences do
  use Ecto.Migration

  def change do
    alter table(:question_options_occurrences) do
      remove :question_occurance_id
      add :question_occurrence_id, references(:question_occurrences, on_delete: :nothing)
    end

    alter table(:question_options_responses) do
      remove :question_occurance_id
      add :question_occurrence_id, references(:question_occurrences, on_delete: :nothing)
    end

    alter table(:messages) do
      remove :question_occurance_id
      add :question_occurrence_id, references(:question_occurrences, on_delete: :nothing)
    end
  end
end
