defmodule LiveFeedback.Questions.QuestionOptionsOccurance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_options_occurances" do
    belongs_to :question_occurance, LiveFeedback.Questions.QuestionOccurance
    field :option_content, :string
    field :option_order, :string
    field :url, :string
    field :is_correct, :boolean

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_options_occurance, attrs) do
    question_options_occurance
    |> cast(attrs, [:question_occurance_id, :option_content, :option_order, :url, :is_correct])
    |> validate_required([:question_occurance_id, :option_content, :option_order])
    |> validate_length(:option_content, max: 500)
    |> validate_length(:option_order, max: 1)
    |> validate_length(:url, max: 255)
    |> validate_inclusion(:is_correct, [true, false])
    |> foreign_key_constraint(:question_occurance_id)
    |> unique_constraint(:option_order, name: :question_options_occurances_question_occurance_id_option_order_index)
  end
end
