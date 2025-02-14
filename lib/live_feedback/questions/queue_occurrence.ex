defmodule LiveFeedback.Questions.QueueOccurrence do
  use Ecto.Schema
  import Ecto.Changeset

  schema "queue_occurrences" do
    belongs_to :queue, LiveFeedback.Questions.Queue
    field :presented_date, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(queue_occurrence, attrs) do
    queue_occurrence
    |> cast(attrs, [:queue_id, :presented_date])
    |> validate_required([:queue_id, :presented_date])
    |> foreign_key_constraint(:queue_id)
  end
end
