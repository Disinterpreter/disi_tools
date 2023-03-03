defmodule DisiToolsWeb.Router do
  alias DisiTools.PasswordGeneratorController
  alias DisiTools.PasswordGeneratorController
  use DisiToolsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/password", PasswordGeneratorController, :index

  scope "/api", DisiToolsWeb do
    pipe_through :api
  end
end
