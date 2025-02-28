defmodule LiveFeedback.Repo.Migrations.AddIsActiveToUserProfile do
  use Ecto.Migration

  def change do
    alter table(:user_profiles) do
      add :is_active, :boolean, default: true
    end
  end
end
