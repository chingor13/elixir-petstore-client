defmodule Petstore.Api.UserTest do
  use ExUnit.Case
  doctest Petstore.Api.User

  @moduletag :external

  test "login" do
    {:ok, "logged in user session:" <> session_id} = Petstore.Connection.new
    |> Petstore.Api.User.login_user("test", "abc123")

    assert session_id =~ ~r/\d+/
  end

  test "creating users" do
    conn = Petstore.Connection.new

    user = %Petstore.Model.User{
      username: "mytestuser",
      firstName: "foo",
      lastName: "bar",
      email: "mytestuser@foo.com",
      password: "somesecretpassword"
    }

    {:ok, ""} = conn
    |> Petstore.Api.User.create_user(user)

    # find the user
    {:ok, user} = conn
    |> Petstore.Api.User.get_user_by_name("mytestuser")

    # update the user
    updated_user = Map.put(user, :email, "newemail@foo.com")
    {:ok, ""} = conn
    |> Petstore.Api.User.update_user(user.username, updated_user)

    # find the user
    {:ok, user} = conn
    |> Petstore.Api.User.get_user_by_name("mytestuser")

    assert %{email: "newemail@foo.com"} = user

    delete_user(conn, user)
  end

  test "create users with array input" do
    conn = Petstore.Connection.new

    user = %Petstore.Model.User{
      username: "mytestuser",
      firstName: "foo",
      lastName: "bar",
      email: "mytestuser@foo.com",
      password: "somesecretpassword"
    }
    user2 = %Petstore.Model.User{
      username: "mytestuser2",
      firstName: "foo",
      lastName: "bar",
      email: "mytestuser@foo.com",
      password: "somesecretpassword"
    }

    {:ok, ""} = conn
    |> Petstore.Api.User.create_users_with_array_input([user, user2])

    # find the user
    {:ok, _user} = conn
    |> Petstore.Api.User.get_user_by_name("mytestuser")
    # find the user
    {:ok, _user} = conn
    |> Petstore.Api.User.get_user_by_name("mytestuser2")

    delete_user(conn, user)
    delete_user(conn, user2)
  end

  test "create users with list input" do
    conn = Petstore.Connection.new

    user = %Petstore.Model.User{
      username: "mytestuser",
      firstName: "foo",
      lastName: "bar",
      email: "mytestuser@foo.com",
      password: "somesecretpassword"
    }
    user2 = %Petstore.Model.User{
      username: "mytestuser2",
      firstName: "foo",
      lastName: "bar",
      email: "mytestuser@foo.com",
      password: "somesecretpassword"
    }

    {:ok, ""} = conn
    |> Petstore.Api.User.create_users_with_list_input([user, user2])

    # find the user
    {:ok, _user} = conn
    |> Petstore.Api.User.get_user_by_name("mytestuser")
    # find the user
    {:ok, _user} = conn
    |> Petstore.Api.User.get_user_by_name("mytestuser2")

    delete_user(conn, user)
    delete_user(conn, user2)
  end

  defp delete_user(conn, user) do
    # delete the user
    {:ok, ""} = conn
    |> Petstore.Api.User.delete_user(user.username)

    {:error, env} = conn
    |> Petstore.Api.User.get_user_by_name("mytestuser")

    assert %{status: 404} = env
  end

end
