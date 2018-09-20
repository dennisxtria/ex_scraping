defmodule ExScraping.API.Telegram do
  @moduledoc false

  alias ExScraping.Config

  @user_id Config.user_id()

  @doc false
  def send({{:error, reason}, _}) do
    error_message =
      "Error while checking for new ads.\nWill try again in an hour.\n#{inspect(reason)}"

    send_message([error_message])
  end

  def send({:ok, []}) do
    send_message(["There are no new ads."])
  end

  def send({:ok, new_filtered_ads}) do
    send_message(["There are new ads published:\n"] ++ new_filtered_ads)
  end

  defp send_message(message) do
    Enum.each(message, fn ad ->
      Nadia.send_message(@user_id, ad)
    end)
  end
end
