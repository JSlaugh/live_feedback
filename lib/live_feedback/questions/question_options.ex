defmodule LiveFeedback.Questions.QuestionOptions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    belongs_to :question_id, LiveFeedback.Questions.Question
    field :option_content, :string
    field :option_order, :integer
    field :url, :string
    field :is_correct, :boolean

    timestamps()
  end

  @doc false
  def changeset(question_option, attrs) do
    question_option
    |> cast(attrs, [:question_id, :option_content, :option_order, :url, :is_correct])
    |> validate_required([:question_id, :option_content, :option_order])
    |> validate_length(:option_content, max: 500)
    |> validate_length(:url, max: 255)
    |> validate_inclusion(:is_correct, [true, false])
    |> foreign_key_constraint(:question_id)
    |> unique_constraint(:option_order, name: :question_options_question_id_option_order_index)
  end
end
