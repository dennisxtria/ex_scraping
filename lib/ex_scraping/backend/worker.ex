defmodule ExScraping.Backend.Worker do
  @moduledoc false

  use GenServer

  alias __MODULE__
  alias ExScraping.API.Telegram
  alias ExScraping.Backend.Advertisements
  alias ExScraping.Config

  @frequency Config.frequency()

  @spec start_link(args :: term) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(Worker, args, name: Worker)
  end

  @impl true
  def init([class]) do
    state = %{class: class, latest_ads: []}
    update()
    {:ok, state}
  end

  @doc false
  def update, do: Process.send(Worker, :update, [])

  @impl true
  def handle_info(:update, %{class: class, latest_ads: older_ads} = state) do
    latest_ads =
      class
      |> Advertisements.get_latest()
      |> filter(older_ads)

    Telegram.send(latest_ads)

    Process.send_after(self(), :update, @frequency)

    {:noreply, %{state | latest_ads: older_ads ++ latest_ads}}
  end

  defp filter(latest_ads, older_ads), do: :lists.subtract(latest_ads, older_ads)
end
