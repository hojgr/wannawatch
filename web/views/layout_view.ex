defmodule Wannawatch.LayoutView do
  use Wannawatch.Web, :view

	def flashes(conn) do
		out = [:success, :error, :info] |> Enum.map(fn type ->
			if get_flash(conn, type) do
				encoded = get_flash(conn, type)
				"<div class='" <> to_string(type) <> " message'>" <> encoded <> "</div>"
			else
				""
			end
		end) |> Enum.join("\n")

		{:safe, out}
	end
end
