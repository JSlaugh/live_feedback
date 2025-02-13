defmodule LiveFeedback.Repo.Migrations.TakeOutColumnsInQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      remove :user_id
      remove :course_page_id
    end
  end
end
