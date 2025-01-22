defmodule LiveFeedback.Messages.LikedBy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "liked_by" do
    belongs_to :message, LiveFeedback.Messages.Message
    field :anonymous_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:anonymous_id, :message_id])
    |> validate_required([:message_id])
    |> unique_constraint([:message_id, :anonymous_id])
  end
end
