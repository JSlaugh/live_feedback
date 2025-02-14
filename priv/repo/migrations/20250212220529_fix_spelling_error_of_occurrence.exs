defmodule LiveFeedback.Repo.Migrations.FixSpellingErrorOfOccurrence do
  use Ecto.Migration

    def change do
      rename table(:question_occurances), to: table(:question_occurrences)
      rename table(:question_options_occurances), to: table(:question_options_occurrences)

    end
end
