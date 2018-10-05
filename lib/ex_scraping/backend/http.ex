defmodule ExScraping.Backend.HTTP do
  @moduledoc false

  alias ExScraping.Config

  import ExScraping.Backend.Parse
  import ExScraping.Utils

  @url Config.url()

  def get_html(base_url, params) do
    response = HTTPoison.get(base_url, [], params: params)

    with {:ok, body} <- get_body(response),
         {:ok, links} <- ad_links(body),
         {:ok, hits} <- ad_hits(body) do
      first_page_ads = create_links(links)

      pages = ad_pages(hits)
      pages_range = 2..pages

      case pages === 1 do
        true ->
          first_page_ads

        false ->
          Enum.map(pages_range, fn page ->
            response = HTTPoison.get(base_url, [], params: Map.put(params, "pg", page))

            with {:ok, body} <- get_body(response),
                 {:ok, links} <- ad_links(body) do
              next_page_ads = create_links(links)
              Map.merge(first_page_ads, next_page_ads)
            end
          end)
      end
    else
      error -> error
    end
  end

  defp get_body({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    {:ok, body}
  end

  defp get_body({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, status_code}
  end

  defp get_body({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  defp create_links(links) do
    links
    |> Enum.reduce(%{}, fn link, acc -> Map.put(acc, create_link_ids(link), @url <> link) end)
  end

  defp create_link_ids(link) do
    link
    |> String.trim_leading("/")
    |> String.split("-")
    |> List.first()
  end
end
