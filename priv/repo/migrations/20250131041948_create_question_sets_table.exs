defmodule LiveFeedback.Repo.Migrations.CreateQuestionSetsTable do
  use Ecto.Migration

  def change do
    create table(:question_sets) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :course_page_id, references(:course_pages, on_delete: :delete_all)
      add :name, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:question_sets, [:course_page_id, :name, :description])
  end
end
