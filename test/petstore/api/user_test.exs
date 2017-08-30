defmodule Petstore.Api.UserTest do
  use ExUnit.Case
  doctest Petstore.Api.User

  @moduletag :external

  test "login" do
    Petstore.Connection.new
    |> Petstore.Api.User.login_user("test", "abc123")
    |> IO.inspect
  end

end
