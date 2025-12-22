local WorldWeather = {}
local Logger = require("Core/Logger")

local function weatherSystem()
    return Game.GetWeatherSystem()
end  

WorldWeather.freezeWeather = { value = false }
WorldWeather.lockedWeather = nil

WorldWeather.weatherStates = {
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
    "sa_courier_clouds",
}

function WorldWeather.GetCurrentWeather()
    if not weatherSystem() then return "Unknown" end
    local state = weatherSystem():GetWeatherState()
    return state and tostring(state.name.value) or "Unknown"
end


function WorldWeather.SetWeather(state, transitionSeconds)
    if not weatherSystem() then return end
    transitionSeconds = transitionSeconds or 1
    Logger.Log(string.format("[EasyTrainerWorldWeather] Setting weather: %s (%ds)", state, transitionSeconds))
    weatherSystem():SetWeather(state, transitionSeconds, 1)
end

function WorldWeather.SetRandomWeather()
    local state = WorldWeather.weatherStates[math.random(1, #WorldWeather.weatherStates)]
    WorldWeather.SetWeather(state)
end

function WorldWeather.FreezeWeatherToggle(enabled)
    WorldWeather.freezeWeather.value = enabled
    if enabled then
        WorldWeather.lockedWeather = WorldWeather.GetCurrentWeather()
    else
        WorldWeather.lockedWeather = nil
    end
end

function WorldWeather.ResetWeather()
    if not weatherSystem() then return end
    Logger.Log("[EasyTrainerWorldWeather] Resetting weather")
    weatherSystem():ResetWeather(true)
end

function WorldWeather.Update()
    if WorldWeather.freezeWeather.value and WorldWeather.lockedWeather then
        local current = WorldWeather.GetCurrentWeather()
        if current ~= WorldWeather.lockedWeather then
            WorldWeather.SetWeather(WorldWeather.lockedWeather, 5)
        end
    end
end

return WorldWeather
