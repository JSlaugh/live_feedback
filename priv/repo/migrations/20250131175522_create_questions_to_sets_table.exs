defmodule LiveFeedback.Repo.Migrations.CreateQuestionsToSetsTable do
  use Ecto.Migration

  def change do
    create table(:questions_to_sets) do
      add :question_set_id, references(:question_sets, on_delete: :delete_all)
      add :question_id, references(:questions, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:questions_to_sets, [:question_set_id, :question_id])
  end
end
