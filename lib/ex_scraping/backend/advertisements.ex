defmodule ExScraping.Backend.Advertisements do
  @moduledoc false

  alias ExScraping.Config

  @url Config.url()

  @spec get_new(class :: atom) :: [String.t()]
  def get_new(class) do
    base_url = Config.base_url(class)
    params = Config.params(class)

    params
    |> Enum.map(fn {_, v} -> do_get_new(base_url, v) end)
    |> List.flatten()
  end

  defp do_get_new(base_url, params) do
    response = HTTPoison.get(base_url, [], params: params)

    with {:ok, body} <- get_body(response),
         links = get_href(body),
         false <- Enum.empty?(links) do
      Enum.map(links, fn link -> @url <> link end)
    else
      {:error, _} = error -> error
      true -> {:error, :floki_empty_list}
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

  defp get_href(body) do
    body
    |> Floki.find("[class~=list-group-item]")
    |> Floki.attribute("href")
  end
end
