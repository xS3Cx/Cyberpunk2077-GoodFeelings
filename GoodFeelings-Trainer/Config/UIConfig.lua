-- Config/UIConfig.lua
local UI = require("UI/Core/Style")
local JsonHelper = require("Core/JsonHelper")
local Logger = require("Core/Logger")
local UIConfig = {}
UIConfig.filePath = "config/JSON/ui.json"

local function collectData()
    local dropdownData = {}
    for k, v in pairs(UI.Dropdown) do
        if k ~= "ArrowRight" and k ~= "ArrowDown" then -- These are special characters json no like 
            dropdownData[k] = v
        end
    end

    return {
        Layout = UI.Layout,
        Colors = UI.Colors,
        OptionRow = UI.OptionRow,
        Header = UI.Header,
        Footer = UI.Footer,
        Notification = UI.Notification,
        InfoBox = UI.InfoBox,
        BreakRow = UI.BreakRow,
        Dropdown = dropdownData, 
        Toggle = UI.Toggle,
        Numeric = UI.Numeric,
        Radio = UI.Radio,
        StringCycler = UI.StringCycler,
        ColorPicker = UI.ColorPicker,
        TextInput = UI.TextInput,
        Background = UI.Background
    }
end


local function applyData(data)
    if not data or type(data) ~= "table" then return end
    for k, v in pairs(data) do
        if UI[k] and type(v) == "table" then
            for subk, subv in pairs(v) do
                UI[k][subk] = subv
            end
        end
    end
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
