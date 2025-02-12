defmodule LiveFeedback.Courses.CoursePage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "course_pages" do
    field :description, :string
    field :title, :string
    field :slug, :string
    belongs_to :user, LiveFeedback.Accounts.User

    has_many :queue, LiveFeedback.Questions.Queue
    has_many :question_set, LiveFeedback.Questions.QuestionSet
    has_many :participation_request, LiveFeedback.Participation.ParticipationRequest
    has_many :user_profile, LiveFeedback.Accounts.UserProfile

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(course_page, attrs) do
    course_page
    |> cast(attrs, [:title, :description, :slug, :user_id])
    |> validate_required([:title, :description, :slug])
    |> unique_constraint(:slug)
  end
end
