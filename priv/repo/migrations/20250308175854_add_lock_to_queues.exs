defmodule LiveFeedback.Repo.Migrations.AddLockToQueues do
  use Ecto.Migration

  def change do
    alter table(:queues) do
      add :is_locked, :boolean, default: false, null: false
    end
  end
end
