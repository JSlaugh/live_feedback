defmodule LiveFeedback.Repo.Migrations.AddQuestionSetIdToQuestionsTable do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :question_set_id, references(:question_sets, on_delete: :nothing)
    end
  end
end
