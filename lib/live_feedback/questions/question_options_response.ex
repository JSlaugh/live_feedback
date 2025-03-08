defmodule LiveFeedback.Questions.QuestionOptionsResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_options_responses" do
    belongs_to :user_profile, LiveFeedback.Accounts.UserProfile
    belongs_to :question_options_occurrence, LiveFeedback.Questions.QuestionOptionsOccurrence
    field :anonymous_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_options_response, attrs) do
    question_options_response
    |> cast(attrs, [:user_profile_id, :question_options_occurrence_id, :anonymous_id])
    |> validate_required([:question_options_occurrence_id])
    |> foreign_key_constraint(:user_profile_id)
    |> foreign_key_constraint(:question_options_occurrence_id)
  end
end
