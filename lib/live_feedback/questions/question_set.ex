defmodule LiveFeedback.Questions.QuestionSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question_sets" do
    belongs_to :user, LiveFeedback.Accounts.User
    belongs_to :course_page, LiveFeedback.Courses.CoursePage
    field :name, :string
    field :description, :string

    has_many :question_template, LiveFeedback.Questions.QuestionTemplate

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
