defmodule DisiTools.PasswordGenerator do

  def genpassword() do
    string = :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)
    {:ok, string}
  end

  def genpassword(length) do
    try do
      len = String.to_integer(length)

      if len >= 4 and len <= 32 do
        string = :crypto.strong_rand_bytes(len) |> Base.url_encode64() |> binary_part(0, len)
        {:ok, string}
      else
        {:error,
         "Incorrect request, password must be a number and length must be less than 32 and more than 4."}
      end
    rescue
      ArgumentError ->
        {:error, "Wrong type."}
    end
  end

end
