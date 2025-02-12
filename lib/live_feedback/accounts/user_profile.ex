defmodule LiveFeedback.Accounts.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_profiles" do
    belongs_to :user, LiveFeedback.Accounts.User
    belongs_to :course_page, LiveFeedback.Courses.CoursePage
    field :role, :string
    field :display_name, :string
    field :custom_registration_id, :string

    has_many :message, LiveFeedback.Messages.Message
    has_many :question_options_response, LiveFeedback.Questions.QuestionOptionsResponse
    has_many :participation_summary, LiveFeedback.Participation.ParticipationSummary

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_profile, attrs) do
    user_profile
    |> cast(attrs, [:user_id, :course_page_id, :role, :display_name, :custom_registration_id])
    |> validate_required([:user_id, :course_page_id])
    |> unique_constraint(:custom_registration_id) # Optional if needed to be unique
  end
end
