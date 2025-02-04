defmodule LiveFeedback.Repo.Migrations.CreateQuestionsTable do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :course_page_id, references(:course_pages, on_delete: :nothing)
      add :url, :string
      add :question_type, :string, size: 50
      add :question_content, :string, size: 500
      add :display_order, :integer
      add :is_archived, :boolean

      timestamps(type: :utc_datetime)
    end

    create unique_index(:questions, [:course_page_id, :question_content])
  end
end
