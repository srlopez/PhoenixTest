defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug AppWeb.Auth.SetCurrentUserPlug  # and token for socket
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", AppWeb do
    # Use the default browser stack
    pipe_through(:browser)

    resources "/users", UserController
    resources "/rooms", RoomController

    get "/register", Auth.RegistrationController, :new
    post "/register", Auth.RegistrationController, :create

    get "/signin", Auth.SessionController, :new
    post "/signin", Auth.SessionController, :create
    delete "/signout", Auth.SessionController, :delete

    get "/contact", Auth.ContactController, :new
    post "/contact", Auth.ContactController, :create

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end
end
