defmodule AppWeb.RegisterControllerTest do
  use AppWeb.ConnCase

  alias App.Auth.Registration

  # Añadidos email y hashed_password en attrs de creacion
  @valid_attrs %{
    name: "some name",
    email: "some@email.com",
    password: "some",
    password_confirmation: "some"
  }
  @invalid_attrs %{name: "", email: "some email.com", password: "12", password_confirmation: "34"}

  def fixture() do
    {:ok, user} = Registration.register_user(@valid_attrs)
    user
  end

  describe "registration form" do
    test "renders form", %{conn: conn} do
      conn = get(conn, registration_path(conn, :new))
      assert html_response(conn, 200) =~ "Register"
    end
  end

  describe "create registration" do
    test "redirects to main when data is valid", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create), registration: @valid_attrs)
      conn = get(conn, redirected_to(conn))
      assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create), registration: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops"
      # "can&#39;t be blank" 
      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape("can't be blank"))

      assert html_response(conn, 200) =~ "should be at least 3 character(s)"
      assert html_response(conn, 200) =~ "must match password"
    end

    test "render errors when email duplicates", %{conn: conn} do
      fixture()
      conn = post(conn, registration_path(conn, :create), registration: @valid_attrs)
      assert html_response(conn, 200) =~ "has already been taken"
    end
  end
end
