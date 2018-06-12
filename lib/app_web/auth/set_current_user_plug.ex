defmodule AppWeb.Auth.SetCurrentUserPlug do
  import Plug.Conn

  alias App.Repo
  alias App.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    cond do
      current_user = user_id && Repo.get(User, user_id) ->
        token = Phoenix.Token.sign(conn, "user token", user_id)

        conn
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)
        |> assign(:user_token, token)

      true ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)
    end
  end
end
