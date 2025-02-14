defmodule LiveFeedback.Repo.Migrations.CreateQueueOccurrenceTable do
  use Ecto.Migration

  def change do
    create table(:queue_occurrences) do
      add :queue_id, references(:queues, on_delete: :nothing)
      add :presented_date, :date

      timestamps(type: :utc_datetime)
    end

    create unique_index(:queue_occurrences, [:queue_id, :presented_date])
  end
end
