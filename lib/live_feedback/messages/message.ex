defmodule LiveFeedback.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :is_anonymous, :boolean, default: false
    field :anonymous_id, :string
    field :is_answered, :boolean, default: false
    field :like_count, :integer, default: 0

    belongs_to :question_occurrence, LiveFeedback.Questions.QuestionOccurrence
    belongs_to :user_profile, LiveFeedback.Accounts.UserProfile
    has_many :likes, LiveFeedback.Messages.LikedBy, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [
      :content,
      :is_anonymous,
      :anonymous_id,
      :is_answered,
      :like_count,
      :question_occurrence_id,
      :user_profile_id,
      :anonymous_id
    ])
    |> validate_required([:content])
  end
end
