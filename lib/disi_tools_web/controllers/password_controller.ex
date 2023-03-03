defmodule DisiTools.PasswordGeneratorController do
  use DisiToolsWeb, :controller

  def index(conn, params) do
    config = DisiTools.FilterConfig.password_filter()
    case Filtrex.parse_params(config, params) do
      {:ok, _} ->
        count_p = params["count"] || "1"
        length_p = params["length"] || "16"
        #table = params["table"] || false

        count = String.to_integer(count_p)
        length = String.to_integer(length_p)
        if length >= 4 and length <= 32  do
          clepwd = fn ->
            {:ok, pwd} = DisiTools.PasswordGenerator.genpassword(length_p)
            pwd
          end
          data = if count <= 32 do
            for _ <- 1..count, do: [clepwd.()]
          else
            [["Invalid"]]
          end
          header = ["Passwords"]

          conn
          |> put_status(200)
          |> text(TableRex.quick_render!(data, header))
        else
          conn
          |> put_status(502)
          |> text("too high length")
        end
      {:error, error} ->
        # render filter error
        conn
        |> put_status(502)
        |> text(error)
    end

  end
end
