defmodule Wannawatch.AccountController do
  use Wannawatch.Web, :controller

  def login(conn, _params) do
    alias Wannawatch.User
    changeset = case get_flash(conn, :login_changeset) do
                  nil -> User.changeset(%User{})
                  changeset -> changeset
                end
    
    render conn, "login.html", changeset: changeset
  end

  def login_post(conn, params) do
    json conn, params
  end

  def register(conn, _params) do
    alias Wannawatch.User

    changeset = case get_flash(conn, :original_changeset) do
                  changeset when changeset != nil ->
                    changeset
                  _ ->
                    User.changeset(%User{})
                end

    render conn, "register.html", changeset: changeset
  end
  
  def register_post(conn, %{"user" => user}) do
    alias Wannawatch.User
    changeset = User.changeset(%User{}, user)

    censored_changeset = %{changeset.params | "password" => ""}

    IO.inspect censored_changeset
    
    conn = case changeset.valid? do
             true ->
               conn
               |> put_flash(:success, "Uspesne zaregistrovan!")
               |> redirect(to: page_path(conn, :index))
             false ->
               conn
               |> put_flash(:form_errors, changeset.errors)
               |> put_flash(:error, "Registrace nebyla uspesna")
               |> put_flash(:original_changeset, changeset)
               |> redirect(to: account_path(conn, :register))
           end

  end
end
