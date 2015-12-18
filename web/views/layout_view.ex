defmodule Wannawatch.LayoutView do
  use Wannawatch.Web, :view

	def flashes(conn) do
		out = [:success, :error, :info] |> Enum.map(fn type ->
			if get_flash(conn, type) do
				"<div class='" <> to_string(type) <> " message'>" <> get_flash(conn, type) <> "</div>"
			else
				""
			end
		end) |> Enum.join("\n")

		{:safe, out}
	end
end
