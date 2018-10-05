defmodule ExScraping.Utils do
  @moduledoc false

  def ad_pages(hits) when rem(hits, 15) == 0, do: div(hits, 15)

  def ad_pages(hits), do: div(hits, 15) + 1
end
