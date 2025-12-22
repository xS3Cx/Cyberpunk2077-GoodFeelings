local JsonHelper = require("Core/JsonHelper")
local Logger = require("Core/Logger")

local OptionRegistration = {
    filePath = "config/JSON/options.json",
    registry = {},
    _cachedData = nil
}

function OptionRegistration.Register(key, ref, default)
    if not ref or type(ref) ~= "table" or ref.value == nil then
        Logger.Log("OptionRegistration: Tried to register invalid ref: " .. tostring(key))
        return
    end

    if OptionRegistration.registry[key] then return end

    OptionRegistration.registry[key] = { ref = ref, default = default }

    if OptionRegistration._cachedData and OptionRegistration._cachedData[key] ~= nil then
        ref.value = OptionRegistration._cachedData[key]
    elseif ref.value == nil and default ~= nil then
        ref.value = default
    end
end

function OptionRegistration.Load()
    local data, err = JsonHelper.Read(OptionRegistration.filePath)
    if not data then
        Logger.Log("OptionRegistration: No file loaded: " .. tostring(err))
        return
    end

    OptionRegistration._cachedData = data

    for key, entry in pairs(OptionRegistration.registry) do
        local fileVal = data[key]
        if fileVal ~= nil then
            entry.ref.value = fileVal
        elseif entry.default ~= nil then
            entry.ref.value = entry.default
        end
    end
end

function OptionRegistration.Save()
    local existing, _ = JsonHelper.Read(OptionRegistration.filePath)
    if type(existing) ~= "table" then existing = {} end

    local changed = false
    for key, entry in pairs(OptionRegistration.registry) do
        local oldVal = existing[key]
        local newVal = entry.ref.value
        if oldVal ~= newVal then
            existing[key] = newVal
            changed = true
        end
    end

    if changed then
        local ok, err = JsonHelper.Write(OptionRegistration.filePath, existing)
        if not ok then
            Logger.Log("OptionRegistration: Failed to save: " .. tostring(err))
        end
    end
end

return OptionRegistration
