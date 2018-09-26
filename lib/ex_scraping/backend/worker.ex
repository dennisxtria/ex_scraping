defmodule ExScraping.Backend.Worker do
  @moduledoc false

  alias __MODULE__
  alias ExScraping.API.Telegram
  alias ExScraping.Backend.Ads
  alias ExScraping.Config

  use GenServer

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
    {_result, new_filtered_ads} =
      message =
      class
      |> Ads.get_new()
      |> IO.inspect(label: :all_ads_mofo)
    #   |> filter(older_ads)

    # Telegram.send(message)
    Process.send_after(self(), :update, @frequency)
    {:noreply, %{state | latest_ads: :lists.append(older_ads, new_filtered_ads)}}
  end

  defp filter([{:error, _} = h | _], _older_ads), do: {h, []}

  defp filter(latest_ads, older_ads), do: {:ok, :lists.subtract(latest_ads, older_ads)}
end
