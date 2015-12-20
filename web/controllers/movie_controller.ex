defmodule Wannawatch.MovieController do
  use Wannawatch.Web, :controller

  def search(conn, %{"s" => query}) do
    json conn, Wannawatch.CSFD.search(query)
  end
end
