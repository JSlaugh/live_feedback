defmodule LiveFeedback.Participation.ParticipationSummary do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participation_summaries" do
    belongs_to :participation_request, LiveFeedback.Participation.ParticipationRequest
    belongs_to :profile, LiveFeedback.Accounts.UserProfile
    field :percentage, :float

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
