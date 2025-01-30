defmodule LiveFeedback.Repo.Migrations.CreateParticipationSummaryTable do
  use Ecto.Migration

  def change do
    create table(:participation_summaries) do
      add :participation_request_id, references(:participation_requests, on_delete: :nothing)
      add :profile_id, references(:user_profiles, on_delete: :nothing)
      add :percentage, :float

      timestamps(type: :utc_datetime)
    end

    create index(:participation_summaries, [:participation_request_id])
    create index(:participation_summaries, [:profile_id])
  end
end
