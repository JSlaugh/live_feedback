defmodule LiveFeedback.Repo.Migrations.AddCascadingDeleteFromQueues do
  use Ecto.Migration

  def change do
    # Add cascade delete from queues to question_occurrences
    alter table(:question_occurrences) do
      remove :queue_id
    end

    alter table(:question_occurrences) do
      add :queue_id, references(:queues, on_delete: :delete_all)
    end

    # Add cascade delete from question_occurrences to question_options_occurrences
    alter table(:question_options_occurrences) do
      remove :question_occurrence_id
    end

    alter table(:question_options_occurrences) do
      add :question_occurrence_id, references(:question_occurrences, on_delete: :delete_all)
    end

    # Add cascade delete from question_occurrences to messages
    alter table(:messages) do
      remove :question_occurrence_id
    end

    alter table(:messages) do
      add :question_occurrence_id, references(:question_occurrences, on_delete: :delete_all)
    end

    # Add cascade delete from user_profiles to question_options_responses
    alter table(:question_options_responses) do
      remove :user_profile_id
    end

    alter table(:question_options_responses) do
      add :user_profile_id, references(:user_profiles, on_delete: :delete_all)
    end
  end
end
