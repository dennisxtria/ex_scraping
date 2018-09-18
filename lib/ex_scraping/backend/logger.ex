defmodule ExScraping.Backend.Logger do
  @moduledoc """
  Provides function for logging API requests and responses.
  """

  defmacro __using__(_opts) do
    quote do
      require Logger

      @typep result :: :ok | {:error, reason :: term}

      @typep oxr_reason :: {pos_integer, String.t()}

      @doc """
      Logs a `:get_latest` result.
      """
      @spec log_get_latest(oxr_reason :: oxr_reason, update_frequency :: pos_integer) :: result
      def log_get_latest(oxr_reason, update_frequency) do
        Logger.warn(fn ->
          "Failed to fetch the OXR update frequency because error=#{inspect(oxr_reason)}." <>
            "Returning default update_frequency=#{update_frequency}"
        end)
      end
    end
  end
end
