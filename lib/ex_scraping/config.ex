defmodule ExScraping.Config do
  @moduledoc false

  import Application, only: [get_env: 3]

  @app Mix.Project.config()[:app]

  @type filters :: %{String.t() => String.t()}

  @spec url :: String.t()
  def url, do: get_env(@app, :car_gr, nil)[:url]

  @spec base_url(class :: atom) :: String.t()
  def base_url(:motorrad), do: url() <> "/classifieds/bikes/"

  def base_url(:car), do: url() <> "/classifieds/cars/"

  @spec filters(class :: atom) :: filters
  def filters(:motorrad), do: get_env(@app, :car_gr, nil)[:motorrad_filters]

  def filters(:car), do: get_env(@app, :car_gr, nil)[:car_filters]

  @spec vendors(class :: atom) :: filters
  def vendors(:motorrad), do: get_env(@app, :vendors, nil)[:motorrad]

  def vendors(:car), do: get_env(@app, :vendors, nil)[:car]

  @spec params(class :: atom) :: filters
  def params(class) do
    Enum.reduce(vendors(class), %{}, fn {k, v}, acc ->
      Map.put(acc, k, Map.merge(filters(class), v))
    end)
  end

  @spec frequency :: pos_integer
  def frequency, do: get_env(@app, :frequency, nil)

  @spec user_id :: pos_integer
  def user_id, do: get_env(@app, :user_id, nil)
end
