defmodule AppWeb.Auth.RegistrationController do
  use AppWeb, :controller

  alias App.Auth.Registration

  def new(conn, _params) do
    changeset = Registration.new_registration()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => params}) do
    case Registration.register_user(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully registered.")
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
