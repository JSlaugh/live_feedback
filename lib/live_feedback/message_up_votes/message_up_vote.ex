defmodule LiveFeedback.MixProject.MessageUpVotes do
  alias LiveFeedback.Messages.Message
  alias LiveFeedback.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "message_up_votes" do
    belongs_to(:users,  User, primary_key: true)
    belongs_to(:messages, Message, primary_key: true)

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w(users_id messages_id)a
  def changeset(message_up_vote, params \\ %{}) do
    message_up_vote
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:users_id)
    |> foreign_key_constraint(:messages_id)
    |> unique_constraint([:users,:messages],
    name: :users_id,
    message: @already_exists
    )
  end
end
