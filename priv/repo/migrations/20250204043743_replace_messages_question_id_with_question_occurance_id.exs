defmodule LiveFeedback.Repo.Migrations.ReplaceMessagesQuestionIdWithQuestionOccuranceId do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove :question_id
      add :question_occurance_id, references(:question_occurances, on_delete: :delete_all)
    end
  end
end
