defmodule ExScraping.API.Telegram do
  @moduledoc false

  @spec send(message :: [] | [String.t()]) ::
          {:ok, Nadia.Model.Message.t()} | {:error, Nadia.Model.Error.t()}
  def send(message), do: do_send(message)

  defp do_send([]) do
    get_user_id()
    |> send_message(["There were no new ads published."])
  end

  defp do_send(message) do
    get_user_id()
    |> send_message(["The newest ads published are:\n"] ++ message)
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
