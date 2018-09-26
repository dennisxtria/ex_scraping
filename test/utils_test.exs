defmodule UtilsTest do
  use ExUnit.Case, async: true

  alias ExScraping.Utils

  setup_all do
    hits = :rand.uniform(100)

    [hits: hits]
  end

  test "counts the number of ads pages", context do
    # hits = context.hits
    assert 1 === Utils.ad_pages(2)
    assert 1 === Utils.ad_pages(5)
    assert 1 === Utils.ad_pages(10)
    assert 1 === Utils.ad_pages(14)
    assert 1 === Utils.ad_pages(15)
    assert 2 === Utils.ad_pages(17)
    assert 2 === Utils.ad_pages(20)
    assert 2 === Utils.ad_pages(25)
    assert 2 === Utils.ad_pages(29)
    assert 2 === Utils.ad_pages(30)
    assert 3 === Utils.ad_pages(35)
    assert 3 === Utils.ad_pages(41)
    assert 3 === Utils.ad_pages(45)
    assert 4 === Utils.ad_pages(47)
    assert 4 === Utils.ad_pages(50)
    assert 4 === Utils.ad_pages(56)
    assert 4 === Utils.ad_pages(60)
  end
end
