defmodule LiveFeedback.Questions.QuestionToSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions_to_sets" do
    belongs_to :question_set, LiveFeedback.Questions.QuestionSet
    belongs_to :question, LiveFeedback.Questions.Question

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_to_set, attrs) do
    question_to_set
    |> cast(attrs, [:question_set_id, :question_id])
    |> validate_required([:question_set_id, :question_id])
    |> foreign_key_constraint(:question_set_id)
    |> foreign_key_constraint(:question_id)
    |> unique_constraint([:question_set_id, :question_id], message: "This question is already assigned to this set.")
  end
end
