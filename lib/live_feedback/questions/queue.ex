defmodule LiveFeedback.Questions.Queue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "queues" do
    belongs_to :course_page, LiveFeedback.Courses.CoursePage
    field :name, :string
    field :description, :string
    field :presented_date, :date
    field :is_presenting, :boolean, default: false

    has_many :question_occurrence, LiveFeedback.Questions.QuestionOccurrence

    timestamps(type: :utc_datetime)


  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [:course_page_id, :name, :description, :presented_date, :is_presenting])
    |> validate_required([:course_page_id, :name, :is_presenting])
    |> foreign_key_constraint(:course_page_id)
  end
end
