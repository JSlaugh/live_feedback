defmodule LiveFeedback.Participation.ParticipationRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participation_requests" do
    belongs_to :course_page, LiveFeedback.Courses.CoursePage
    field :participation_date, :date
    field :date_requested, :date

    has_many :participation_summary, LiveFeedback.Participation.ParticipationSummary

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(participation_request, attrs) do
    participation_request
    |> cast(attrs, [:course_page_id, :participation_date, :date_requested])
    |> validate_required([:course_page_id, :participation_date, :date_requested])
  end
end
