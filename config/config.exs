use Mix.Config

app = Mix.Project.config()[:app]

config app, :car_gr,
  url: "https://www.car.gr",
  intermediate_url_motorrad: "/classifieds/bikes/",
  intermediate_url_car: "/classifieds/cars/",
  motorrad_filters: %{
    "fs" => "1",
    "condition" => "used",
    "offer_type" => "sale",
    "onlyprice" => "1",
    "price" => ">50",
    "price-to" => "<6000",
    "registration-from" => ">2008",
    "mileage-from" => ">500",
    "mileage-to" => "<40000",
    "significant_damage" => "f",
    "rg" => "3",
    "hi" => "1",
    "st" => "private",
    "pg" => "1"
  },
  car_filters: %{
    "fs" => "1",
    "condition" => "used",
    "offer_type" => "sale",
    "onlyprice" => "1",
    "price" => ">50",
    "price-to" => "<13000",
    "registration-from" => ">2008",
    "mileage-from" => ">500",
    "mileage-to" => "<100000",
    "engine_size-to" => "<1600",
    "engine_power-from" => ">150",
    "significant_damage" => "f",
    "rg" => "3",
    "hi" => "1",
    "st" => "private",
    "pg" => "1"
  }

config app, :vendors,
  motorrad: %{
    suzuki_vstrom: %{"make" => "242", "model" => "4462"}
  },
  car: %{
    vw_scirocco: %{"make" => "251", "model" => "840"}
  }

import_config "#{Mix.env()}.exs"

if File.exists?("#{__DIR__}/#{Mix.env()}.secrets.exs") do
  import_config "#{Mix.env()}.secrets.exs"
end
