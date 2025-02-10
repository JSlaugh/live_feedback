defmodule LiveFeedback.Repo.Migrations.CreateQuestionOptionsOccurances do
  use Ecto.Migration

  def change do
    create table(:question_options_occurances) do
      add :question_occurance_id, references(:question_occurances, on_delete: :delete_all)
      add :option_content, :string, size: 500
      add :option_order, :string, size: 1
      add :url, :string
      add :is_correct, :boolean

      timestamps(type: :utc_datetime)
    end

    create index(:question_options_occurances, [:question_occurance_id])
    create unique_index(:question_options_occurances, [:question_occurance_id, :option_order])
  end
end
