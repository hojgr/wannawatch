defmodule Wannawatch.AccountController do
	use Wannawatch.Web, :controller

	def login(conn, _params) do
		render conn, "login.html"
	end

	def login_post(conn, params) do
		json conn, params
	end

	def register(conn, _params) do
		render conn, "register.html"
	end
	
	def register_post(conn, params) do
		json conn, params
	end
end
