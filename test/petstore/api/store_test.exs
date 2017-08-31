defmodule Petstore.Api.StoreTest do
  use ExUnit.Case
  doctest Petstore.Api.Store

  @moduletag external: true, store: true

  test "get_inventory" do
    {:ok, inventory} = Petstore.Connection.new
    |> Petstore.Api.Store.get_inventory()

    assert %{} = inventory
    Enum.each(inventory, fn ({k, v}) ->
      assert_string(k)
      assert_integer(v)
    end)
  end

  defp assert_string(s) when is_binary(s), do: true
  defp assert_string(s) do
    assert false, "expected #{s} to be a string"
  end

  defp assert_integer(i) when is_integer(i), do: true
  defp assert_integer(i) do
    assert false, "expected #{i} to be an integer"
  end

  test "place_order" do
    conn = Petstore.Connection.new

    order_id = :rand.uniform(10000000) + 10000

    {:ok, pets} = conn
    |> Petstore.Api.Pet.find_pets_by_status("available")

    pet = Enum.random(pets)

    order = %Petstore.Model.Order{
      id: order_id,
      petId: pet.id,
      quantity: 10,
      shipDate: "2017-08-31T17:37:11.398Z",
      status: "placed",
      complete: false
    }

    # place an order
    {:ok, placed_order} = conn
    |> Petstore.Api.Store.place_order(order)

    assert pet.id == placed_order.petId

    # find the order
    {:ok, found_order} = conn
    |> Petstore.Api.Store.get_order_by_id(order_id)

    assert pet.id == found_order.petId

    # delete the order
    {:ok, ""} = conn
    |> Petstore.Api.Store.delete_order(order_id)

    {:error, env} = conn
    |> Petstore.Api.Store.get_order_by_id(order_id)

    assert %{status: 404} = env
  end
end
