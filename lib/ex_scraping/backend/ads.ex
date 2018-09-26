defmodule ExScraping.Backend.Ads do
  @moduledoc false

  alias ExScraping.Backend.HTTP
  alias ExScraping.Config

  @spec get_new(class :: atom) :: [String.t()]
  def get_new(class) do
    base_url = Config.base_url(class)
    params = Config.params(class)

    params
    |> Enum.map(fn {_, v} -> HTTP.get_html(base_url, v) end)
    |> List.flatten()
  end

end
