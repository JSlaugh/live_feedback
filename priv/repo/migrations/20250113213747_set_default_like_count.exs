defmodule LiveFeedback.Repo.Migrations.SetDefaultLikeCount do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :like_count, :integer, default: 0, null: false
    end
  end
end
