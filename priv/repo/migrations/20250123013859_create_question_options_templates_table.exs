defmodule LiveFeedback.Repo.Migrations.CreateQuestionOptionsTemplatesTable do
  use Ecto.Migration

  def change do
    create table(:question_options_templates) do
      add :question_template_id, references(:question_templates, on_delete: :delete_all)
      add :option_content, :string, size: 500
      add :option_order, :string, size: 1
      add :url, :string
      add :is_correct, :boolean

      timestamps(type: :utc_datetime)
    end

    create index(:question_options_templates, [:question_template_id])
    create unique_index(:question_options_templates, [:question_template_id, :option_order])
  end
end
