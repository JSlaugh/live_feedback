defmodule LiveFeedback.Repo.Migrations.RemoveQueueOccurrencesTable do
  use Ecto.Migration

  def change do
    drop table("queue_occurrences")

    alter table(:queues) do
      add :presented_date, :date
    end
  end
end
