defmodule LiveFeedback.Questions.QuestionSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_sets" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
