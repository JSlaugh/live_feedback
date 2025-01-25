defmodule LiveFeedback.Repo.Migrations.CreateOptionResponseTable do
  use Ecto.Migration

  def change do
      create table(:question_options_responses) do
        add :user_id, references(:users, on_delete: :nothing)
        add :question_id, references(:questions, on_delete: :nothing)
        add :option_response, :integer
        timestamps()
      end

      create index(:question_options_responses, [:user_id])
      create index(:question_options_responses, [:question_id])
  end
end
