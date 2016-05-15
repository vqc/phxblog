defmodule Phxblog.UserTest do
  use Phxblog.ModelCase

  alias Phxblog.User

  @valid_attrs %{email: "test@test.com",  username: "testuser",
                  password: "password", password_confirmation: "password" }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password_digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password,
              Ecto.Changeset.get_change(changeset, :password_digest))
  end

  test "password_digest value is not set if password is nil" do
    changeset = User.changeset(%User{}, %{email: "test@test.com",
                                          password: nil,
                                          password_confirmation: nil,
                                          username: "testuser",
                                          })
    refute Ecto.Changeset.get_change(changeset, :password_digest)
  end
end
