defmodule LiveFeedback.Repo.Migrations.MessageUpVotes do
  use Ecto.Migration

  def change do
    create table(:messages_up_vote, primary_key: false) do
      add(:users_id, references(:users, on_delete: :delete_all), primary_key: true)
      add(:messages_id, references(:messages, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create(index(:messages_up_vote, [:users_id]))
    create(index(:messages_up_vote, [:messages_id]))
  end
end
