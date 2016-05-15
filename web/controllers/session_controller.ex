defmodule Phxblog.SessionController do
  use Phxblog.Web, :controller

  alias Phxblog.User

  def new(conn, _params) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end
end
