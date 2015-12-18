defmodule Wannawatch.Router do
  use Wannawatch.Web, :router

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

  scope "/api", Wannawatch do
    pipe_through :api

    get "/movie/search", MovieController, :search
  end

  scope "/", Wannawatch do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
		get "/login", AccountController, :login
		post "/login", AccountController, :login_post
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wannawatch do
  #   pipe_through :api
  # end
end
