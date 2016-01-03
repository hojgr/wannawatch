defmodule Wannawatch.Session do
  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user_id)
    if id, do: Wannawatch.Repo.get(Wannawatch.User, id)
  end

  def logged_in?(conn), do: !!current_user(conn)
end
