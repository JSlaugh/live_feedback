defmodule LiveFeedback.Repo.Migrations.TakeOutColumnsInQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      remove_if_exists :user_id
      remove_if_exists :course_page_id
    end
  end
end
