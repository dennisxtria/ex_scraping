defmodule ExScraping.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_scraping,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison, :nadia],
      mod: {ExScraping.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.10.1"},
      {:dialyxir, "~> 0.5.1"},
      {:floki, "~> 0.20.3"},
      {:httpoison, "~> 1.1.1"},
      {:nadia, "~> 0.4.4"}
    ]
  end
end
