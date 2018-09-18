defmodule ExScraping.Backend.Worker do
  @moduledoc false

  use GenServer

  alias __MODULE__
  alias ExScraping.API.Telegram
  alias ExScraping.Backend.Advertisements
  alias ExScraping.Config

  use ExScraping.Backend.Logger

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
    result =
      with {:ok, latest_ads} <- Advertisements.get_latest(class),
           filtered_latest_ads = :lists.subtract(latest_ads, older_ads) do
        {:noreply, %{state | latest_ads: :lists.append(older_ads, filtered_latest_ads)}}
      else
        [{:error, reason}] ->
          inspect(reason)
          {:noreply, state}
      end

    IO.inspect(result, label: :result)
    Telegram.send(result)
    Process.send_after(self(), :update, @frequency)
  end
end
