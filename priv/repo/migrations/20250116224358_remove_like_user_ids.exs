defmodule LiveFeedback.Repo.Migrations.AddLikedByUserIdsToMessages do
  use Ecto.Migration

  def change do
    # Create the new `liked_by` table for the likes association
    create table(:liked_by) do
      add :message_id, references(:messages, on_delete: :delete_all), null: false
      add :anonymous_id, :string, null: false

      timestamps(type: :utc_datetime)
    end

    # Add a unique constraint to prevent duplicate (message_id, anonymous_id) pairs
    create unique_index(:liked_by, [:message_id, :anonymous_id])

    # Add a new index on `message_id` for the `liked_by` table for faster queries
    create index(:liked_by, [:message_id])
  end
end
