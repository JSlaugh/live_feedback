defmodule LiveFeedback.Questions.QuestionTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_templates" do
    belongs_to :course_page, LiveFeedback.Courses.CoursePage
    belongs_to :user, LiveFeedback.Accounts.User
    field :url, :string
    field :question_type, :string
    field :question_content, :string
    field :display_order, :integer
    field :is_archived, :boolean, default: false
    field :is_required, :boolean, default: false
    belongs_to :question_set, LiveFeedback.Questions.QuestionSet

    has_many :question_options_template, LiveFeedback.Questions.QuestionOptionsTemplate
    has_many :question_options_response, LiveFeedback.Questions.QuestionOptionsResponse

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question_template, attrs) do
    question_template
    |> cast(attrs, [:course_page_id, :user_id, :url, :question_type, :question_content, :display_order, :is_archived])
    |> validate_required([:course_page_id, :user_id, :question_type, :question_content, :display_order])
    |> validate_length(:question_type, max: 50)
    |> validate_length(:question_content, max: 500)
    |> foreign_key_constraint(:course_page_id)
    |> foreign_key_constraint(:user_id)
  end
end
