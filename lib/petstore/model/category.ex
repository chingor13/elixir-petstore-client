# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule Petstore.Model.Category do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :"id",
    :"name"
  ]
end

defimpl Poison.Decoder, for: Petstore.Model.Category do
  import Petstore.Deserializer
  def decode(value, options) do
    value
  end
end

