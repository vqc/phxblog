defmodule Phxblog.PageController do
  use Phxblog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
