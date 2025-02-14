defmodule LiveFeedback.Repo.Migrations.AddIndexForQuestions do
  use Ecto.Migration

  def change do
    create unique_index(:questions, [:question_type, :question_content])
  end
end
