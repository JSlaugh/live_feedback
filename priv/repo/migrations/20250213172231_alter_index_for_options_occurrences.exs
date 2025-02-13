defmodule LiveFeedback.Repo.Migrations.AlterIndexForOptionsOccurrences do
  use Ecto.Migration

  def change do
    create unique_index(:question_options_occurrences, [:question_occurrence_id, :option_order])
    create unique_index(:question_options_responses, [:user_profile_id, :question_options_occurrence_id])
  end
end
