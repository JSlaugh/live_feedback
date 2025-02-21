defmodule LiveFeedback.Repo.Migrations.FixSpellingError do
  use Ecto.Migration

    def change do
      alter table(:question_occurrences) do
        remove :dipslay_order
        add :display_order, :integer
      end
    end
end
