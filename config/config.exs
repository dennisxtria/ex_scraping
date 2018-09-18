use Mix.Config

app = Mix.Project.config()[:app]

config app, :car_gr,
  url: "https://www.car.gr",
  motorrad_filters: %{
    "fs" => "1",
    "condition" => "used",
    "offer_type" => "sale",
    "price-with" => ">50",
    "price-to" => "<6000",
    "registration-from" => ">2009",
    "mileage-from" => ">500",
    "mileage-to" => "<40000",
    "significant_damage" => "f",
    "rg" => "3",
    "hi" => "1"
  },
  car_filters: %{
    "fs" => "1",
    "condition" => "used",
    "offer_type" => "sale",
    "price-with" => ">50",
    "price-from" => ">3000",
    "price-to" => "<5000",
    "registration-from" => ">2005",
    "mileage-to" => "<125000",
    "engine_size-from" => ">1000",
    "engine_size-to" => "<1300",
    "significant_damage" => "f",
    "rg" => "3",
    "modified" => "3",
    "hi" => "1",
    "st" => "private"
  }

config app, :vendors,
  motorrad: %{
    suzuki_vstrom: %{"make" => "242", "model" => "4462"}
  },
  car: %{
    ford_fiesta: %{"make" => "126", "model" => "177"},
    honda_jazz: %{"make" => "22", "model" => "714"},
    mitsubishi_colt: %{"make" => "198", "model" => "542"},
    toyota_yaris: %{"make" => "248", "model" => "820"}
  }

import_config "#{Mix.env()}.exs"

if File.exists?("#{__DIR__}/#{Mix.env()}.secrets.exs") do
  import_config "#{Mix.env()}.secrets.exs"
end
