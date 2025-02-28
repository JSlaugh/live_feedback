defmodule LiveFeedback.Repo.Migrations.AddIsFavoriteToUserProfiles do
  use Ecto.Migration

  def change do
    alter table(:user_profiles) do
      add :is_course_page_favorite, :boolean, default: false
    end
  end
end
