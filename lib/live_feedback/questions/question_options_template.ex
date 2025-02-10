defmodule LiveFeedback.Questions.QuestionOptionsTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_options_templates" do
    belongs_to :question_template, LiveFeedback.Questions.QuestionTemplate
    field :option_content, :string
    field :option_order, :string
    field :url, :string
    field :is_correct, :boolean

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_options_template, attrs) do
    question_options_template
    |> cast(attrs, [:question_template_id, :option_content, :option_order, :url, :is_correct])
    |> validate_required([:question_template_id, :option_content, :option_order])
    |> validate_length(:option_content, max: 500)
    |> validate_length(:option_order, max: 1)
    |> validate_length(:url, max: 255)
    |> validate_inclusion(:is_correct, [true, false])
    |> foreign_key_constraint(:question_template_id)
    |> unique_constraint(:option_order, name: :question_options_template_question_templates_id_option_order_index)
  end
end
