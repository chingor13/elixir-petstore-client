defmodule Petstore.Api.PetTest do
  use ExUnit.Case
  doctest Petstore.Api.Pet

  @moduletag external: true, pets: true

  test "add pet" do
    conn = Petstore.Connection.new()
    pet = %Petstore.Model.Pet{name: "Jeff test", status: "available"}

    {:ok, new_pet} = conn
    |> Petstore.Api.Pet.add_pet(pet)

    id = Map.get(new_pet, "id")
    assert id

    # TODO: when the swagger spec is fixed, this return type should be a Petstore.ModelPet struct
    # assert_valid_pet(new_pet)

    {:ok, found_pet} = conn
    |> Petstore.Api.Pet.get_pet_by_id(id)
    assert_valid_pet(found_pet)

    # test update pet
    {:ok, updated_pet} = conn
    |> Petstore.Api.Pet.update_pet(Map.put(found_pet, :status, "pending"))

    assert id == Map.get(updated_pet, "id")
    assert "pending" == Map.get(updated_pet, "status")

    # test delete pet
    {:ok, ""} = conn
    |> Petstore.Api.Pet.delete_pet(id)
  end

  test "find_pets_by_status" do
    {:ok, pets} = Petstore.Connection.new()
    # |> Petstore.Api.Pet.find_pets_by_status(["pending", "sold"])
    |> Petstore.Api.Pet.find_pets_by_status("pending")

    assert Enum.count(pets) > 0

    pets
    |> Enum.each(&assert_valid_pet/1)
  end

  defp assert_valid_pet(pet) do
    assert %Petstore.Model.Pet{} = pet
    assert_valid_category(pet.category)
    assert_valid_tags(pet.tags)
    assert pet.id
  end

  defp assert_valid_category(nil), do: true
  defp assert_valid_category(category) do
    assert %Petstore.Model.Category{} = category
  end

  defp assert_valid_tags(nil), do: true
  defp assert_valid_tags([]), do: true
  defp assert_valid_tags([tag | rest]) do
    assert_valid_tag(tag)
    assert_valid_tags(rest)
  end
  defp assert_valid_tag(tag) do
    assert %Petstore.Model.Tag{} = tag
  end

  test "find_pets_by_tags" do

  end

  test "update_pet_with_form" do

  end
end
