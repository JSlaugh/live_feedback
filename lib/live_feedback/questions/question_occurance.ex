defmodule LiveFeedback.Questions.QuestionOccurance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_occurances" do
    belongs_to :question, LiveFeedback.Questions.Question
    belongs_to :queue, LiveFeedback.Questions.Queue
    field :queue_display_order, :integer
    field :date_used, :date
    field :is_required, :boolean, default: false

    has_many :question_options_responses, LiveFeedback.Questions.QuestionOptionsResponse
    #has_many :messages, LiveFeedback.Messages.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_occurance, attrs) do
    question_occurance
    |> cast(attrs, [:question_id, :queue_id, :queue_display_order, :date_used])
    |> validate_required([:question_id, :queue_id, :queue_display_order])
    |> validate_number(:queue_display_order, greater_than: 0)
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:queue_id)
  end
end
