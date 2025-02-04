defmodule LiveFeedback.Questions.Queue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "queues" do
    belongs_to :course_page, LiveFeedback.Courses.CoursePage
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [:course_page_id, :name, :description])
    |> validate_required([:course_page_id, :name])
    |> foreign_key_constraint(:course_page_id)
  end
end
