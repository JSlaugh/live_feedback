defmodule LiveFeedback.Repo.Migrations.AddCustomIdRequiredToCoursePages do
  use Ecto.Migration

  def change do
    alter table(:course_pages) do
      add :is_custom_registration_id_required, :boolean
      add :registration_id_label, :string
    end
  end
end
