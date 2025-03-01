defmodule LiveFeedback.Repo.Migrations.AddDeleteFromQooToQor do
  use Ecto.Migration

  def change do
    # Drop the existing foreign key constraint
    drop constraint(:question_options_responses, "question_options_responses_question_options_occurrence_id_fkey")

    # Modify the column by re-adding the foreign key with `on_delete`
    alter table(:question_options_responses) do
      modify :question_options_occurrence_id, references(:question_options_occurrences, on_delete: :delete_all)
    end
  end
end
