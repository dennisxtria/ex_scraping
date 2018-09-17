defmodule ExScraping.Backend.Advertisements do
  @moduledoc false

  alias ExScraping.Config

  @url Config.url()

  @spec get_latest(class :: atom) :: [String.t()]
  def get_latest(class) do
    base_url = Config.base_url(class)
    params = Config.params(class)

    params
    |> Enum.map(fn {_, v} -> do_get_latest(base_url, v) end)
    |> List.flatten()
  end

  defp do_get_latest(base_url, vendor) do
    base_url
    |> get_body(vendor)
    |> parse()
    |> create_links()
  end

  defp get_body(base_url, params) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(base_url, [], params: params)

    body
  end

  defp parse(body) do
    body
    |> Floki.find("[class~=list-group-item]")
    |> Floki.attribute("href")
  end

  defp create_links(links) do
    Enum.map(links, fn link -> @url <> link end)
  end
end
