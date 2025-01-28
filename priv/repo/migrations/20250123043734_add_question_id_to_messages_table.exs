defmodule LiveFeedback.Repo.Migrations.AddQuestionIdToMessagesTable do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :question_id, references(:questions, on_delete: :delete_all)
    end
  end
end
