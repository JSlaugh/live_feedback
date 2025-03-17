defmodule LiveFeedback.Participation.ParticipationSummary do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participation_summaries" do
    belongs_to :participation_request, LiveFeedback.Participation.ParticipationRequest
    belongs_to :user_profile, LiveFeedback.Accounts.UserProfile
    field :completion_percentage, :float
    field :correctness_percentage, :float

    #has_many :participation_request, LiveFeedback.Participation.ParticipationRequest

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(participation_summary, attrs) do
    participation_summary
    |> cast(attrs, [:participation_request_id, :profile_id, :percentage])
    |> validate_required([:participation_request_id, :profile_id, :percentage])
    |> validate_number(:percentage, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
  end
end
