defmodule LiveFeedback.Questions.QuestionOptionsResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_options_responses" do
    belongs_to :user, LiveFeedback.Accounts.User
    belongs_to :question, LiveFeedback.Questions.Question
    field :option_response, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_options_response, attrs) do
    question_options_response
    |> cast(attrs, [:user_id, :question_id, :option_response])
    |> validate_required([:user_id, :question_id, :option_response])
    |> validate_length(:option_response, max: 1)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
  end
end
