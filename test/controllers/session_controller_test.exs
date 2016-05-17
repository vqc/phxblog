defmodule Phxblog.SessionControllerTest do
  use Phxblog.ConnCase
  alias Phxblog.User

  setup do
    User.changeset(%User{}, %{username: "test",
                              password: "test",
                              password_confirmation: "test",
                              email: "test@test.com"})
    |>Repo.insert
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows the login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates a new session for a valid user", %{conn: conn} do
    conn = post conn, session_path(conn, :create),
            user: %{ username: "test", password: "test"}
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Sign in successful!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create a new session for an incorrect password", %{conn: conn} do
    conn = post conn, session_path(conn, :create),
            user: %{ username: "test", password: "wrong"}
    refute get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Invalid username/password combo!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create a session if the user does not exist", %{conn: conn} do
    conn = post conn, session_path(conn, :create),
            user: %{ username: "foo", password: "test"}
    assert get_flash(conn, :error) == "Invalid username/password combo!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "deletes the user session", %{conn: conn} do
    user = Repo.get_by(User, %{username: "test"})
    conn = delete conn, session_path(conn, :delete, user)
    refute get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Signed out successfully!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

end
