defmodule LiveFeedback.Repo.Migrations.CreateQuestionOptionsTable do
  use Ecto.Migration

  def change do
    create table(:question_options) do
      add :question_id, references(:questions, on_delete: :nothing)
      add :option_content, :string, size: 500
      add :option_order, :integer
      add :url, :string
      add :is_correct, :boolean
    end

    create index(:question_options, [:question_id])
    create unique_index(:question_options, [:question_id, :option_order])
  end
end
