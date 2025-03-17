defmodule LiveFeedback.Questions.QuestionOptionsOccurrence do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_options_occurrences" do
    belongs_to :question_occurrence, LiveFeedback.Questions.QuestionOccurrence
    field :option_content, :string
    field :option_order, :string
    field :url, :string
    field :is_correct, :boolean

    has_many :question_options_responses, LiveFeedback.Questions.QuestionOptionsResponse

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_options_occurrence, attrs) do
    question_options_occurrence
    |> cast(attrs, [:question_occurrence_id, :option_content, :option_order, :url, :is_correct])
    |> validate_required([:question_occurrence_id, :option_content, :option_order])
    |> validate_length(:option_content, max: 500)
    |> validate_length(:option_order, max: 1)
    |> validate_length(:url, max: 255)
    |> validate_inclusion(:is_correct, [true, false])
    |> foreign_key_constraint(:question_occurrence_id)
    |> unique_constraint(:option_order, name: :question_options_occurrences_question_occurrence_id_option_order_index)
  end
end
