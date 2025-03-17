defmodule LiveFeedback.Questions.QuestionOccurrence do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_occurrences" do
    belongs_to :question, LiveFeedback.Questions.Question
    belongs_to :queue, LiveFeedback.Queues.Queue
    field :is_required, :boolean, default: false
    field :url, :string
    field :question_type, :string
    field :question_content, :string
    field :display_order, :integer
    field :set_display_order, :integer
    field :is_archived, :boolean

    has_many :question_options_occurrences, LiveFeedback.Questions.QuestionOptionsOccurrence,
      on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_occurrence, attrs) do
    question_occurrence
    |> cast(attrs, [
      :question_id,
      :queue_id,
      :is_required,
      :url,
      :question_type,
      :question_content,
      :display_order,
      :set_display_order,
      :is_archived
    ])
    |> validate_required([
      :queue_id,
      :is_required,
      :question_type,
      :question_content
    ])
    |> validate_length(:question_type, max: 50)
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:queue_id)
  end
end
