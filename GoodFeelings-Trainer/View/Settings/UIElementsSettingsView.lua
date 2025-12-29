-- View/Settings/UIElementsSettingsView.lua
local Buttons = require("UI").Buttons

local NotificationView = require("View/Settings/NotificationView")
local InfoBoxView = require("View/Settings/InfoBoxView")
local TextInputView = require("View/Settings/TextInputView")

local function UIElementsSettingsViewFunction()
    Buttons.Submenu("Overlay Settings", require("View/Settings/OverlaySettingsView"), "Configure on-screen overlay elements")
    Buttons.Submenu(L("settingsmenu.notifications.label"), NotificationView, tip("settingsmenu.notifications.tip"))
    Buttons.Submenu(L("settingsmenu.infobox.label"), InfoBoxView, tip("settingsmenu.infobox.tip"))
    Buttons.Submenu(L("settingsmenu.textinput.label"), TextInputView, tip("settingsmenu.textinput.tip"))
end

local UIElementsSettingsView = { 
    title = "UI Elements", 
    view = UIElementsSettingsViewFunction 
}

return UIElementsSettingsView
