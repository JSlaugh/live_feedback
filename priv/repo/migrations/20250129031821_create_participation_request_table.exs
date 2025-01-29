defmodule LiveFeedback.Repo.Migrations.CreateParticipationRequestTable do
  use Ecto.Migration

  def change do
    create table(:participation_requests) do
      add :course_page_id, references(:course_pages, on_delete: :delete_all)
      add :participation_date, :date
      add :date_requested, :date

      timestamps()
    end

    create index(:participation_requests, [:course_page_id])
  end
end
