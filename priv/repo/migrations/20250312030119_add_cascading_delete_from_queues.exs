defmodule LiveFeedback.Repo.Migrations.AddCascadingDeleteFromQueues do
  use Ecto.Migration

  def up do
    execute("""
    DO $$
    BEGIN
      -- Check if the constraint exists before adding it
      IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'question_occurrences'
        AND constraint_name = 'question_occurrences_queue_id_fkey'
      ) THEN
        -- Add the missing foreign key constraint
        ALTER TABLE question_occurrences
        ADD CONSTRAINT question_occurrences_queue_id_fkey
        FOREIGN KEY (queue_id) REFERENCES queues(id) ON DELETE SET NULL;
      END IF;
    END $$;
    """)

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

  def down do
    # Reverse the changes if needed
    alter table(:question_occurrences) do
      modify :queue_id, references(:queues, on_delete: :nothing),
        from: references(:queues, on_delete: :delete_all)
    end

    alter table(:question_options_occurrences) do
      modify :question_occurrence_id, references(:question_occurrences, on_delete: :nothing),
        from: references(:question_occurrences, on_delete: :delete_all)
    end

    alter table(:messages) do
      modify :question_occurrence_id, references(:question_occurrences, on_delete: :nothing),
        from: references(:question_occurrences, on_delete: :delete_all)
    end

    alter table(:question_options_responses) do
      modify :user_profile_id, references(:user_profiles, on_delete: :nothing),
        from: references(:user_profiles, on_delete: :delete_all)
    end

  end
end
