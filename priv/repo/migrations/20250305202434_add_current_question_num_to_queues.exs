defmodule LiveFeedback.Repo.Migrations.AddCurrentQuestionNumToQueues do
  use Ecto.Migration

  def change do
    alter table(:queues) do
      add :current_question_num, :integer, default: 1, null: false
    end
  end
end
