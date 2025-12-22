local Handler = require("Controls/Handler")
local JsonHelper = require("Core/JsonHelper")
local Logger = require("Core/Logger")

local NavigationConfig = {}
NavigationConfig.filePath = "config/JSON/navigation.json"

local function collectData()
    return {
        scrollDelayBase = Handler.scrollDelayBase,
        scrollMinDelay = Handler.scrollMinDelay,
        accelThreshold = Handler.accelThreshold,
        accelStep = Handler.accelStep,
    }
end

local function applyData(data)
    if type(data) ~= "table" then return end
    if data.scrollDelayBase then Handler.scrollDelayBase = data.scrollDelayBase end
    if data.scrollMinDelay then Handler.scrollMinDelay = data.scrollMinDelay end
    if data.accelThreshold then Handler.accelThreshold = data.accelThreshold end
    if data.accelStep then Handler.accelStep = data.accelStep end
end

function NavigationConfig.Save()
    local ok, err = JsonHelper.Write(NavigationConfig.filePath, collectData())
    if ok then
        Logger.Log("NavigationConfig: Navigation settings saved successfully.")
        return true
    else
        Logger.Log("NavigationConfig: Failed to save navigation (" .. tostring(err) .. ")")
        return false
    end
end

function NavigationConfig.Load()
    local data, err = JsonHelper.Read(NavigationConfig.filePath)
    if data then
        applyData(data)
        Logger.Log("NavigationConfig: Navigation settings loaded successfully.")
        return true
    else
        Logger.Log("NavigationConfig: Failed to load navigation (" .. tostring(err) .. ")")
        return false
    end
end

function NavigationConfig.Reset()
    Handler.scrollDelayBase = 200
    Handler.scrollMinDelay = 30
    Handler.accelThreshold = 1250
    Handler.accelStep = 20
    Logger.Log("NavigationConfig: Navigation settings reset to defaults.")
end

return NavigationConfig
