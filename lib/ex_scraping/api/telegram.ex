defmodule ExScraping.API.Telegram do
  @moduledoc false

  @spec send(message :: [] | [String.t()]) ::
          {:ok, Nadia.Model.Message.t()} | {:error, Nadia.Model.Error.t()}
  def send(message) do
    do_send(message)
  end

  defp do_send({{:error, reason}, _}) do
    error_message =
      "Error while checking for new ads.\nWill try again in an hour.\n#{inspect(reason)}"

    get_user_id()
    |> send_message([error_message])
  end

  defp do_send({:ok, []}) do
    get_user_id()
    |> send_message(["There are no new ads."])
  end

  defp do_send({:ok, new_filtered_ads}) do
    get_user_id()
    |> send_message(["There are new ads published:\n"] ++ new_filtered_ads)
  end

  defp get_user_id do
    {:ok,
     [%Nadia.Model.Update{message: %Nadia.Model.Message{from: %Nadia.Model.User{id: id}}} | _]} =
      Nadia.get_updates()

    id
  end

  defp send_message(id, message) do
    Enum.each(message, fn ad ->
      Nadia.send_message(id, ad)
    end)
  end
end
