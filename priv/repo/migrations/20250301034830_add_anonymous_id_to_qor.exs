defmodule LiveFeedback.Repo.Migrations.AddAnonymousIdToQor do
  use Ecto.Migration

  def change do
    alter table(:question_options_responses) do
      add :anonymous_id, :string
    end
  end
end
