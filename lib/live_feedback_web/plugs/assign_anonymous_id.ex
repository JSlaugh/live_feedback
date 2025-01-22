defmodule LiveFeedbackWeb.Plugs.AssignAnonymousId do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    case get_session(conn, :anonymous_id) do
      nil ->
        anonymous_id = generate_anonymous_id(conn)
        conn
        |> put_session(:anonymous_id, anonymous_id)
      _anonymous_id ->
        conn
    end
  end

  defp generate_anonymous_id(conn) do
    case get_user_id(conn) do
      nil ->
        UUID.uuid4() # Generate a random UUID if no user is logged in
      user_id ->
        hash_user_id(user_id) # Generate a hash of the user_id
    end
  end

  defp get_user_id(conn) do
    case conn.assigns[:current_user] do
      %{} = current_user -> current_user.id
      _ -> nil
    end
  end

  defp hash_user_id(user_id) do
    :crypto.hash(:sha256, to_string(user_id))
    |> Base.encode16(case: :lower) # Encode as a lowercase hex string
  end
end
