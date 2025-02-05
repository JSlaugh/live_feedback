defmodule LiveFeedback.Repo.Migrations.CreateQueuesTable do
  use Ecto.Migration

  def change do
    create table(:queues) do
      add :course_page_id, references(:course_pages, on_delete: :delete_all)
      add :name, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:queues, [:course_page_id, :name])
  end
end
