defmodule Phxblog.SessionController do
  use Phxblog.Web, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Phxblog.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    #pass to the render function
    #pass it the connection (conn)
    #the template to be rendered (without the eex)
    #and the changeset
    render conn, "new.html", changeset: User.changeset(%User{})
  end

  def create(conn, %{"user" => user_params}) do
    if is_nil(user_params["username"]) do
      conn
      |> put_flash(:error, "Invalid username/password combo!")
      |> redirect(to: page_path(conn, :index))
    else
      #this part pulls the first applicable user from Ecto.Repo that
      #has a matching username
      Repo.get_by(User, username: user_params["username"])
      |> sign_in(user_params["password"], conn)
    end
  end

  #the functions get run in order. so this one will run when the user is nil
  #note that there is an error in the create function when the
  #user is nil. so it doesn't seem like this function ever gets called.
  #put an if into the create function to check for nil?
  defp sign_in(user, password, conn) when is_nil(user) do
    conn
    |> put_flash(:error, "Invalid username/password combo!")
    |> redirect(to: page_path(conn, :index))
  end

  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      conn
      |> put_session(:current_user, %{id: user.id, username: user.username})
      |> put_flash(:info, "Sign in successful!")
      |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_session(:current_user, nil)
      |> put_flash(:info, "Invalid username/password combo!")
      |> redirect(to: page_path(conn, :index))
    end
  end
end
