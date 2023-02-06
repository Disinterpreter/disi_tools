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
      %{"count" => count, "table" => table} ->
        if table == "true" do
          try do
            cnt = String.to_integer(count)
              if cnt <= 16 do
                clepwd = fn ->
                  {:ok, pwd} = genpassword()
                  [pwd]
                end

                data = for _ <- 1..cnt, do: clepwd.()

                header = ["Passwords"]
                IO.inspect(data)
                text(conn,TableRex.quick_render!(data, header))
              else
                conn
                |> put_status(503)
                |> text("Wrong count of passwords")
              end
            rescue
              ArgumentError ->
                conn
                |> put_status(503)
                |> text("Wrong count of passwords")
          end
        end

      %{"count" => count, "length" => length} ->
        try do
          cnt = String.to_integer(count)
          if cnt <= 16 do
            clepwd = fn l ->
              pwd = genpassword(l)
              case pwd do
                {:ok, pass} -> pass
                {:error, _} -> "WRONG"
              end
            end
            data = for _ <- 1..cnt, do: clepwd.(length)
            if data |> Enum.at(0) != "WRONG" do
              json(conn, %{passwords: data})
            else
              conn
              |> put_status(503)
              |> json(%{text: "Wrong password length."})
            end
          else
            conn
            |> put_status(503)
            |> json(%{text: "Maximum count is 8"})
          end
        rescue
          ArgumentError ->
            conn
            |> put_status(503)
            |> json(%{text: "Wrong type."})
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
            conn
            |> put_status(503)
            |> json(%{text: "Wrong type."})
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
