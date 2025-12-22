local UI = require("UI")
local Buttons = UI.Buttons

local WorldWeather = require("Features/World").WorldWeather

local weatherRadio = { index = 1 }

local weatherOptions = {
    L("worldweather.options.sunny"),
    L("worldweather.options.lightclouds"),
    L("worldweather.options.cloudy"),
    L("worldweather.options.heavyclouds"),
    L("worldweather.options.fog"),
    L("worldweather.options.rain"),
    L("worldweather.options.toxicrain"),
    L("worldweather.options.pollution"),
    L("worldweather.options.sandstorm"),
    L("worldweather.options.deebblue"),
    L("worldweather.options.lightRain"),
    L("worldweather.options.squatmorning"),
    L("worldweather.options.cloudymorning"),
    L("worldweather.options.rainnight"),
    L("worldweather.options.cloudscourier")
}

local weatherMap = {
    "24h_weather_sunny",
    "24h_weather_light_clouds",
    "24h_weather_cloudy",
    "24h_weather_heavy_clouds",
    "24h_weather_fog",
    "24h_weather_rain",
    "24h_weather_toxic_rain",
    "24h_weather_pollution",
    "24h_weather_sandstorm",
    "q302_deeb_blue",
    "q302_light_rain",
    "q302_squat_morning",
    "q306_epilogue_cloudy_morning",
    "q306_rainy_night",
    "sa_courier_clouds"
}

local function GetCurrentWeatherIndex()
    local current = WorldWeather.GetCurrentWeather()
    for i, id in ipairs(weatherMap) do
        if id == current then
            return i
        end
    end
    return 1
end

local transitionSeconds = { value = 1, min = 1, max = 60, step = 1 }

local function ViewWorldWeather()
    weatherRadio.index = GetCurrentWeatherIndex()

    Buttons.OptionExtended(L("worldweather.current.label"), "", WorldWeather.GetCurrentWeather(), L("worldweather.current.tip"))
    Buttons.Toggle(L("worldweather.freeze.label"), WorldWeather.freezeWeather, L("worldweather.freeze.tip"))
    Buttons.Option(L("worldweather.random.label"), L("worldweather.random.tip"), WorldWeather.SetRandomWeather)
    Buttons.Option(L("worldweather.reset.label"), L("worldweather.reset.tip"), WorldWeather.ResetWeather)
    Buttons.Int(L("worldweather.transitionduration.label"), transitionSeconds, L("worldweather.transitionduration.tip"))

    Buttons.Break("", L("worldweather.weathertypebreak.label"))

    Buttons.Radio(L("worldweather.weathertype.label"), weatherRadio, weatherOptions, L("worldweather.weathertype.tip"), function()
        local selectedWeather = weatherMap[weatherRadio.index]
        WorldWeather.SetWeather(selectedWeather, transitionSeconds.value)
    end)
end

local WorldWeatherView = {
    title = "worldweather.title",
    view = ViewWorldWeather
}

return WorldWeatherView
