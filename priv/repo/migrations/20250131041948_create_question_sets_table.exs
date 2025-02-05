defmodule LiveFeedback.Repo.Migrations.CreateQuestionSetsTable do
  use Ecto.Migration

  def change do
    create table(:question_sets) do
      add :name, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:question_sets, [:name, :description])
  end
end
