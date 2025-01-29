defmodule LiveFeedback.Repo.Migrations.CreateUserProfilesTable do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :course_page_id, references(:course_pages, on_delete: :delete_all)
      add :role, :string
      add :display_name, :string
      add :custom_registration_id, :string

      timestamps()
    end

    create index(:user_profiles, [:user_id])
    create index(:user_profiles, [:course_page_id])
  end
end
