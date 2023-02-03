defmodule DisiToolsWeb.Router do
  alias DisiTools.PasswordGenerator
  use DisiToolsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/password", PasswordGenerator, :index

  scope "/api", DisiToolsWeb do
    pipe_through :api
  end
end
