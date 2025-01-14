defmodule LiveFeedback.Repo.Migrations.AddLikedByUserIdsToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :liked_by_user_ids, {:array, :integer}, default: []
    end
  end
end
