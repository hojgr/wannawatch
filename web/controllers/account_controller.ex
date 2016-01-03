defmodule Wannawatch.AccountController do
  alias Wannawatch.User
  use Wannawatch.Web, :controller

  def logout(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:success, "Odhlaseni bylo uspesne")
    |> redirect(to: page_path(conn, :index))
  end
  
  def login(conn, _params) do
    changeset = User.changeset(%User{})
    
    render conn, "login.html", changeset: changeset
  end

  def login_post(conn, %{"user" => params}) do
    user = Repo.get_by(User, username: params["username"]) # nil

    login = case user do
              nil -> false
              _ -> Comeonin.Bcrypt.checkpw(params["password"], user.password)
            end

    case login do
      true ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:success, "Uspesne prihlasen")
        |> redirect(to: page_path(conn, :index))
      false ->
        conn
        |> put_flash(:error, "Nespravne jmeno nebo heslo")
        |> render("login.html", changeset: User.changeset(%User{}))
    end
  end

  def register(conn, _params) do
    changeset = case get_flash(conn, :original_changeset) do
                  changeset when changeset != nil ->
                    changeset
                  _ ->
                    User.changeset(%User{})
                end

    render conn, "register.html", changeset: changeset
  end
  
  def register_post(conn, %{"user" => user}) do
    changeset = User.registration_changeset(%User{}, user)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:success, "Uspesne zaregistrovan!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        censored_changeset = Map.put(changeset, :params, %{changeset.params | "password" => ""})
        
        conn
        |> put_flash(:form_errors, changeset.errors)
        |> put_flash(:error, "Registrace nebyla uspesna")
        |> put_flash(:original_changeset, censored_changeset)
        |> redirect(to: account_path(conn, :register))
    end
  end
end
