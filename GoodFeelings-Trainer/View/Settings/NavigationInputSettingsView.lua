-- View/Settings/NavigationInputSettingsView.lua
local Buttons = require("UI").Buttons

local NavigationView = require("View/Settings/NavigationView")
local TranslationsView = require("View/Settings/TranslationsView")

local function NavigationInputSettingsViewFunction()
    Buttons.Submenu(L("settingsmenu.navigation.label"), NavigationView, tip("settingsmenu.navigation.tip"))
    Buttons.Submenu("Hotkey Menu", require("View/Settings/HotkeyManagerView"), "View and manage all your hotkey bindings")
    Buttons.Submenu(L("settingsmenu.translations.label"), TranslationsView, tip("settingsmenu.translations.tip"))
end

local NavigationInputSettingsView = { 
    title = "Navigation & Input", 
    view = NavigationInputSettingsViewFunction 
}

return NavigationInputSettingsView
