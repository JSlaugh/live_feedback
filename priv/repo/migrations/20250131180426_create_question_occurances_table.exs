defmodule LiveFeedback.Repo.Migrations.CreateQuestionOccurancesTable do
  use Ecto.Migration

  def change do
    create table(:question_occurances) do
      add :question_id, references(:questions, on_delete: :nothing)
      add :queue_id, references(:queues, on_delete: :nothing)
      add :queue_display_order, :integer
      add :date_used, :date
      add :is_required, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:question_occurances, [:question_id, :queue_id])
  end
end
