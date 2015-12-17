defmodule Wannawatch.MovieController do
  use Wannawatch.Web, :controller

  def search(conn, %{"s" => query}) do
    %{body: html} = HTTPoison.get!("http://www.csfd.cz/hledat/?" <> URI.encode_query(%{q: query}) )
    # REGEX EXPLAIN
    #<li>\s* - start matching at <li>
    # <a href="(/film/[^"]*)"> - extract CSFD movie URL
    # <img src="(.*)" - extract movie's main poster
    # .*film c.">(.*)</a> - extract movie name (`c.`` can be c1 or c2 as far as I know)
    # .*([0-9]+)</p> - extract year of release
    # modifiers `rs` mean
    #   r - ungreedy (swap greedyness) -> no need for questionmarks
    #   s - dotall (dot includes all whitespaces incl. newlines)
    # TODO: Make this regexp more human-readable and less error-prone
    regex = ~R{<li>\s*<a href="(/film/[^"]*)"><img src="(.*)".*film c.">(.*)</a>.*([0-9]+)</p>}rs

    other_records_regex = ~R{<a href="(/film/.*)" class="film c.">(.*)</a>.*\(([0-9]+)\)}r

    result = Regex.scan(regex, html, capture: :all_but_first)
    |> Enum.map(fn [url, img, name, year] -> %{url: url, img: img, name: name, year: year} end)

    other_result = Regex.scan(other_records_regex, html, capture: :all_but_first)
    |> Enum.map(fn [url, name, year] -> %{url: url, name: name, year: year} end)

    conn |> json(%{primary: result, secondary: other_result})
  end
end
