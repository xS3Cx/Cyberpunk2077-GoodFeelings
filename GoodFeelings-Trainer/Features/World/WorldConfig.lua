local ConfigManager = require("Config/OptionConfig")

local WorldTime = require("Features/World").WorldTime
local WorldWeather = require("Features/World").WorldWeather

local function RegisterAllWorldOptions()
    ConfigManager.Register("toggle.world.freezeTime", WorldTime.toggleFreezeTime)
    ConfigManager.Register("toggle.world.timeLapse", WorldTime.toggleTimeLapse)
    ConfigManager.Register("toggle.world.syncSystemClock", WorldTime.toggleSyncToSystemClock)
    ConfigManager.Register("toggle.world.freezeWeather", WorldWeather.freezeWeather)
end


return RegisterAllWorldOptions
