defmodule LiveFeedback.Repo.Migrations.AddBackInDisplayOrderQuestionOccurrence do
  use Ecto.Migration

  def change do
    alter table(:question_occurrences) do
      add :dipslay_order, :integer
    end
  end
end
