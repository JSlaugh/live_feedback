defmodule LiveFeedback.Repo.Migrations.ReplaceMessagesUserIdWithUserProfileId do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove :user_id
      add :user_profile_id, references(:user_profiles, on_delete: :nothing)
    end
  end
end
