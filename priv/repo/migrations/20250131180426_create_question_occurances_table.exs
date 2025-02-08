defmodule LiveFeedback.Repo.Migrations.CreateQuestionOccurancesTable do
  use Ecto.Migration

  def change do
    create table(:question_occurances) do
      add :question_template_id, references(:question_templates, on_delete: :nothing)
      add :queue_id, references(:queues, on_delete: :nothing)
      add :queue_display_order, :integer
      add :date_used, :date
      add :is_required, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:question_occurances, [:question_template_id, :queue_id])
  end
end
