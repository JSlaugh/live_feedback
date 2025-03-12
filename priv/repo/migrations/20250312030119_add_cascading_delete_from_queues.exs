defmodule LiveFeedback.Repo.Migrations.AddCascadingDeleteFromQueues do
  use Ecto.Migration

  def change do
    # Add cascade delete from queues to question_occurrences
    alter table(:question_occurrences) do
      modify :queue_id, references(:queues, on_delete: :delete_all),
        from: references(:queues, on_delete: :nothing)
    end

    # Add cascade delete from question_occurrences to question_options_occurrences
    alter table(:question_options_occurrences) do
      modify :question_occurrence_id, references(:question_occurrences, on_delete: :delete_all),
        from: references(:question_occurrences, on_delete: :nothing)
    end

    # Add cascade delete from question_occurrences to messages
      alter table(:messages) do
      modify :question_occurrence_id, references(:question_occurrences, on_delete: :delete_all),
        from: references(:question_occurrences, on_delete: :nothing)
    end

    # Add cascade delete from user_profile_id to question_options_responses
    alter table(:question_options_responses) do
      modify :user_profile_id, references(:user_profiles, on_delete: :delete_all),
        from: references(:user_profiles, on_delete: :nothing)
    end

  end
end
