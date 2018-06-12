defmodule AppWeb.Auth.SessionController do
  use AppWeb, :controller

  alias App.Auth.SessionManager

  def new(conn, params) do
    if get_session(conn, :current_user_id) do
      conn
      |> put_flash(:info, "You're already signed in")
      |> redirect(to: page_path(conn, :index))
    else
      changeset = SessionManager.new_session(params)
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"session" => params}) do
    case SessionManager.create_session(params) do
      {:ok, user} ->
        redirect_to = get_session(conn, :requested_path) || page_path(conn, :index)

        conn
        |> put_flash(:info, "Successfully signed in.")
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: redirect_to)

      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end
end
