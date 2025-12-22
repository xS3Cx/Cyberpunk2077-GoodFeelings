-- Config/UIConfig.lua
local UI = require("UI/Core/Style")
local JsonHelper = require("Core/JsonHelper")
local Logger = require("Core/Logger")
local UIConfig = {}
UIConfig.filePath = "config/JSON/ui.json"

local function collectData()
    local dropdownData = {}
    for k, v in pairs(UI.Base.Dropdown or {}) do
        if k ~= "ArrowRight" and k ~= "ArrowDown" then
            dropdownData[k] = v
        end
    end

    return {
        Layout = UI.Base.Layout,
        Colors = UI.Colors, -- Colors are not in Base because they don't scale
        OptionRow = UI.Base.OptionRow,
        Header = UI.Base.Header,
        SecondHeader = UI.Base.SecondHeader,
        Footer = UI.Base.Footer,
        Notification = UI.Base.Notification,
        InfoBox = UI.Base.InfoBox,
        BreakRow = UI.BreakRow, -- Logic key, not scaled
        Dropdown = dropdownData, 
        Toggle = UI.Base.Toggle,
        Numeric = UI.Base.Numeric,
        Radio = UI.Base.Radio,
        StringCycler = UI.Base.StringCycler,
        ColorPicker = UI.Base.ColorPicker,
        TextInput = UI.Base.TextInput,
        Background = UI.Base.Background
    }
end


local function applyData(data)
    if not data or type(data) ~= "table" then return end
    for k, v in pairs(data) do
        if k == "Colors" or k == "BreakRow" then
            if UI[k] and type(v) == "table" then
                for subk, subv in pairs(v) do
                    UI[k][subk] = subv
                end
            end
        elseif UI.Base[k] and type(v) == "table" then
            for subk, subv in pairs(v) do
                UI.Base[k][subk] = subv
            end
        end
    end
    -- Trigger scaling update after load
    UI.ApplyScale()
end

function UIConfig.Save()
    local ok, err = JsonHelper.Write(UIConfig.filePath, collectData())
    if ok then
        Logger.Log("UIConfig: UI settings saved successfully.")
        return true
    else
        Logger.Log("UIConfig: Failed to save UI settings (" .. tostring(err) .. ")")
        return false
    end
end

function UIConfig.Load()
    local data, err = JsonHelper.Read(UIConfig.filePath)
    if data then
        applyData(data)
        Logger.Log("UIConfig: UI settings loaded successfully.")
        return true
    else
        Logger.Log("UIConfig: Failed to load UI settings (" .. tostring(err) .. ")")
        return false
    end
end

return UIConfig
