defmodule ExScraping.Application do
  @moduledoc false

  use Application

  @name __MODULE__

  @doc false
  def start(_type, _args) do
    [
      Supervisor.child_spec({ExScraping.Backend.Worker, [:motorrad]}, id: Worker)
    ]
    |> Supervisor.start_link(strategy: :one_for_one, name: @name)
  end
end
