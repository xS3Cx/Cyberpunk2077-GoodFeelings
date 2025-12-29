-- View/Settings/SettingsView.lua
local Buttons = require("UI").Buttons

local ResetUI = require("UI/Core/ResetUI")

local UIConfig = require("Config/UIConfig")
local NavigationConfig = require("Config/NavigationConfig")
local Bindings = require("Controls/Bindings")

local function SettingsViewFunction()
    -- Main Categories
    Buttons.Submenu("Navigation & Input", require("View/Settings/NavigationInputSettingsView"), "Configure navigation, hotkeys, and language settings")
    Buttons.Submenu("Visual & Interface", require("View/Settings/VisualInterfaceSettingsView"), "Customize menu appearance and layout")
    Buttons.Submenu("UI Elements", require("View/Settings/UIElementsSettingsView"), "Configure overlay, notifications, and UI components")
    Buttons.Submenu("Controls Styling", require("View/Settings/ControlsStylingSettingsView"), "Customize button, selector, and input styles")

    -- System Actions
    Buttons.Break("System")
    if Buttons.Option(L("settingsmenu.resetall.label"), tip("settingsmenu.resetall.tip")) then
        ResetUI.ResetAll()
        NavigationConfig.Reset()
        Bindings.ResetAll()
    end

    if Buttons.Option(L("settingsmenu.saveall.label"), tip("settingsmenu.saveall.tip")) then
        UIConfig.Save()
        NavigationConfig.Save()
    end
end

local SettingsView = { title = "settingsmenu.title", view = SettingsViewFunction }

return SettingsView

