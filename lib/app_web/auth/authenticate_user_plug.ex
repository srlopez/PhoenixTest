defmodule AppWeb.Auth.AuthenticateUserPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias AppWeb.Router.Helpers

  def init(_params) do
  end

  @requested_path :requested_path

  def call(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
      |> delete_session(@requested_path)
    else
      conn
      |> put_session(@requested_path, conn.request_path)
      |> put_flash(:error, "You need to sign in or sign up before continuing.")
      |> redirect(to: Helpers.session_path(conn, :new))
      |> halt()
    end
  end
end
