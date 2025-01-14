defmodule LiveFeedback.MixProject.MessageUpVotes do
  alias LiveFeedback.Messages.Message
  alias LiveFeedback.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "message_up_vote" do
    belongs_to(:user,  User, primary_key: true)
    belongs_to(:message, Message, primary_key: true)

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w(user_id message_id)a
  def changeset(message_up_vote, params \\ %{}) do
    message_up_vote
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:message_id)
    |> unique_constraint([:user,:message],
    name: :user_id,
    message: @already_exists
    )
  end
end
