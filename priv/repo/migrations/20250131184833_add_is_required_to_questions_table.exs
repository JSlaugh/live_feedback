defmodule LiveFeedback.Repo.Migrations.AddIsRequiredToQuestionsTable do
  use Ecto.Migration

  def change do
    alter table(:question_templates) do
      add :is_required, :boolean, default: false, null: false
    end
  end
end
