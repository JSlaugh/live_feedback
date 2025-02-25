defmodule LiveFeedback.Repo.Migrations.AddDefaultFalseToCustomRegistrationId do
  use Ecto.Migration

  def change do
    alter table("course_pages") do
      modify :is_custom_registration_id_required, :boolean, default: false
    end
  end
end
