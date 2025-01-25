defmodule LiveFeedback.Questions.QuestionOptionsResponses do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    belongs_to :user_id, LiveFeedback.Accounts.User
    belongs_to :question__id, LiveFeedback.Questions.Question
    field :option_response, :integer

    timestamps()
  end

  @doc false
  def changeset(question_options_responses, attrs) do
    question_options_responses
    |> cast(attrs, [:user_id, :question_id, :option_response])
    |> validate_required([:user_id, :question_id, :option_response])
    |> validate_number(:option_response, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
  end
end
