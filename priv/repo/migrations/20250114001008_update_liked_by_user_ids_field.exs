defmodule LiveFeedback.Repo.Migrations.UpdateLikedByUserIdsField do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      modify :liked_by_user_ids, {:array, :string}
    end
  end
end
