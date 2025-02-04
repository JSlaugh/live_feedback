defmodule LiveFeedback.Repo.Migrations.CreateOptionResponseTable do
  use Ecto.Migration

  def change do
      create table(:question_options_responses) do
        add :user_id, references(:users, on_delete: :nothing)
        add :question_id, references(:questions, on_delete: :nothing)
        add :option_response, :string, size: 1

        timestamps(type: :utc_datetime)
      end

      create unique_index(:question_options_responses, [:user_id, :question_id])
  end
end
