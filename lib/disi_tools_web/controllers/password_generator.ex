defmodule DisiTools.PasswordGenerator do
  use DisiToolsWeb, :controller

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

  def index(conn, params) do
    case params do
      %{"count" => count, "length" => length} ->
        try do
          cnt = String.to_integer(count)

          clepwd = fn l ->
            {:ok, pwd} = genpassword(l)
            pwd
          end

          data = for _ <- 1..cnt, do: clepwd.(length)

          json(conn, %{passwords: data})
        rescue
          ArgumentError ->
            {:error, "Wrong type."}
        end

      %{"count" => count} ->
        try do
          cnt = String.to_integer(count)

          clepwd = fn ->
            {:ok, pwd} = genpassword()
            pwd
          end

          data = for _ <- 1..cnt, do: clepwd.()

          json(conn, %{passwords: data})
        rescue
          ArgumentError ->
            {:error, "Wrong type."}
        end

      %{"length" => length} ->
        text =
          case genpassword(length) do
            {:ok, password} -> password
            {:error, text} -> text
          end

        json(conn, %{password: text})

      _ ->
        {:ok, password} = genpassword()
        json(conn, %{password: password})
    end
  end
end
