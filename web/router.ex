defmodule GalenaServer.Router do
  use GalenaServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GalenaServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", GalenaServer do
    pipe_through :api

    resources "/servers", ServerController

    post "/servers/:id/start", ServerController, :start
    post "/servers/:id/stop", ServerController, :stop

  end
end
