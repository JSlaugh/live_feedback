defmodule LiveFeedback.Repo.Migrations.DropUniqueIndexOnQueueNames do
  use Ecto.Migration

  def change do
    drop index(:queues, [:course_page_id, :name])
  end
end
