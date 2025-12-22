local Logger = require("Core/Logger")
local JsonHelper = require("Core/JsonHelper")

local Language = {}

Language.currentLang = "en"
Language.translations = {}

function Language.Load(langCode)
    Language.currentLang = langCode or "en"
    local path = string.format("lang/%s.json", Language.currentLang)

    local data, err = JsonHelper.Read(path)
    if not data then
        Logger.Log("Localization: Failed to load language file: " .. tostring(err))
        return false
    end

    if type(data) == "table" then
        Language.translations = data
        return true
    else
        Logger.Log("Localization: Unexpected format in: " .. path)
        return false
    end
end

function Language.Get(key)
    local val = Language.translations
    local lastStr = nil
    local lastPart = nil

    for part in string.gmatch(key, "[^%.]+") do
        lastPart = part

        if type(val) == "table" then
            val = val[part]
            if type(val) == "string" then
                lastStr = val
            end
        else
            break
        end
    end

    return lastStr or lastPart or key
end

function Language.tip(key, placeholders)
    local tipText = Language.Get(key)

    if type(placeholders) == "table" then
        for placeholder, value in pairs(placeholders) do
            local resolved = Language.Get(value) or value
            tipText = tipText:gsub("{" .. placeholder .. "}", resolved)
        end
    end

    return tipText
end

-- Only really used in the binding button so don't really need it to be a global
function Language.GetInputKey(code)
    return Language.translations.inputkeys and Language.translations.inputkeys[tostring(code)] or tostring(code)
end

function Language.GetInputButton(code)
    return Language.translations.inputbuttons and Language.translations.inputbuttons[tostring(code)] or "Btn"..tostring(code)
end

L = function(key) return Language.Get(key) end
tip = function(key, placeholders) return Language.tip(key, placeholders) end

return Language
