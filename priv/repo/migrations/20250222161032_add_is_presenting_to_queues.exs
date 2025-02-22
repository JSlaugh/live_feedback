defmodule LiveFeedback.Repo.Migrations.AddIsPresentingToQueues do
  use Ecto.Migration

  def change do
    alter table(:queues) do
      add :is_presenting, :boolean, default: false
    end
  end
end
