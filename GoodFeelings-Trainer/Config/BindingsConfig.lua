local JsonHelper = require("Core/JsonHelper")
local Bindings = require("Controls/Bindings")
local Logger = require("Core/Logger")

local BindingsConfig = {}
local filePath = "config/JSON/bindings.json"

function BindingsConfig.Load()
    local data, err = JsonHelper.Read(filePath)
    if type(data) ~= "table" then
        Logger.Log("BindingsConfig: Failed to load bindings (" .. tostring(err) .. ")")
        return false
    end

    for action, binding in pairs(data) do
        Bindings.Rebind(action, binding)
    end

    Logger.Log("BindingsConfig: Bindings loaded successfully.")
    return true
end

function BindingsConfig.Save()
    local ok, err = JsonHelper.Write(filePath, Bindings.Actions)
    if ok then
        Logger.Log("BindingsConfig: Bindings saved successfully.")
        return true
    else
        Logger.Log("BindingsConfig: Failed to save bindings (" .. tostring(err) .. ")")
        return false
    end
end

return BindingsConfig
