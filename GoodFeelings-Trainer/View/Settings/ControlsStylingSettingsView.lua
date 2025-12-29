-- View/Settings/ControlsStylingSettingsView.lua
local Buttons = require("UI").Buttons

local SimpleControlsView = require("View/Settings/SimpleControlsView")
local SelectionControlsView = require("View/Settings/SelectionControlsView")
local InputControlsView = require("View/Settings/InputControlsView")

local function ControlsStylingSettingsViewFunction()
    Buttons.Submenu(L("settingsmenu.simplecontrols.label"), SimpleControlsView, tip("settingsmenu.simplecontrols.tip"))
    Buttons.Submenu(L("settingsmenu.selectioncontrols.label"), SelectionControlsView, tip("settingsmenu.selectioncontrols.tip"))
    Buttons.Submenu(L("settingsmenu.inputcontrols.label"), InputControlsView, tip("settingsmenu.inputcontrols.tip"))
end

local ControlsStylingSettingsView = { 
    title = "Controls Styling", 
    view = ControlsStylingSettingsViewFunction 
}

return ControlsStylingSettingsView
