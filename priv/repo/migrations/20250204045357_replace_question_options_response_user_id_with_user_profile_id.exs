defmodule LiveFeedback.Repo.Migrations.ReplaceQuestionOptionsResponseUserIdWithUserProfileId do
  use Ecto.Migration

  def change do
    alter table(:question_options_responses) do
      remove :user_id
      add :user_profile_id, references(:user_profiles, on_delete: :nothing)

      remove :question_id
      add :question_occurance_id, references(:question_occurances, on_delete: :nothing)

    end

    create unique_index(:question_options_responses, [:user_profile_id, :question_occurance_id])
  end
end
