defmodule AppWeb.Auth.ContactController do
  use AppWeb, :controller

  alias App.Auth.ContactForm

  def new(conn, params \\ %{}) do
    changeset = ContactForm.new_contact_form(params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"contact_form" => params}) do
    case ContactForm.do_contact(params) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "You will be contacted shortly.")
        |> redirect(to: page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
