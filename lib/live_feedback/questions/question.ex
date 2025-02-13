defmodule LiveFeedback.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :url, :string
    field :question_type, :string
    field :question_content, :string
    field :display_order, :integer
    field :is_archived, :boolean, default: false
    field :is_required, :boolean, default: false
    belongs_to :question_set, LiveFeedback.Questions.QuestionSet

    has_many :question_option, LiveFeedback.Questions.QuestionOption
    has_many :question_options_response, LiveFeedback.Questions.QuestionOptionsResponse

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:url, :question_type, :question_content, :display_order, :is_archived])
    |> validate_required([:question_type, :question_content, :display_order])
    |> validate_length(:question_type, max: 50)
    |> validate_length(:question_content, max: 500)
  end
end
