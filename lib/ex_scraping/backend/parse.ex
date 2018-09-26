defmodule ExScraping.Backend.Parse do
  @moduledoc false

  def ad_links(body) do
    body
    |> Floki.find("[class~=list-group-item]")
    |> Floki.attribute("href")
    |> check_findings()
  end

  def ad_hits(body) do
    [{_, _, [hits | _]} | _] = body |> Floki.find("[class=hits-number]")

    hits
    |> String.to_integer()
    |> IO.inspect(label: :hits)
    |> check_findings
  end

  def check_findings([]), do: {:error, :floki_empty_list}

  def check_findings(result), do: {:ok, result}
end
