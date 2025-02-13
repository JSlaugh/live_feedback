defmodule LiveFeedback.Repo.Migrations.AlterDisplayOrderQuestionOccurrences do
  use Ecto.Migration

  def change do
    alter table(:question_occurrences) do
      remove :queue_display_order
      remove :date_used
    end

    rename table(:question_occurrences), :display_order, to: :set_display_order
  end
end
