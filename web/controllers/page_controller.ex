defmodule Wannawatch.PageController do
  use Wannawatch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
