defmodule LiveFeedbackWeb.PageControllerTest do
  use LiveFeedbackWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, :index)
    assert html_response(conn, 200) =~ "Welcome to Chattr Live"
  end
end
