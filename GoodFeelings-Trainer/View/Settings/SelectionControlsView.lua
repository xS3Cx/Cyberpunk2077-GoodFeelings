local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")
local toggleSizeRef = { value = UI.Toggle.Size, min = 8, max = 40 }
local toggleRoundingRef = { value = UI.Toggle.Rounding, min = 0, max = 20 }
local toggleInsetRef = { value = UI.Toggle.Inset, min = 0, max = 10 }
local toggleStatePaddingRef = { value = UI.Toggle.StatePadding, min = 0, max = 20 }
local toggleStateSpacingRef = { value = UI.Toggle.StateSpacing, min = 0, max = 20 }

local radioRadiusRef = { value = UI.Radio.Radius, min = 2, max = 20 }
local radioThicknessRef = { value = UI.Radio.LineThickness, min = 0.5, max = 5.0, step = 0.1 }
local radioSegmentsRef = { value = UI.Radio.Segments, min = 3, max = 40 }

local exampleToggleRef = { value = true }
local exampleRadioRef = { index = 1 }
local exampleRadioOptions = { "Plugged In", "Disconnected" }

local function SelectionControlsViewFunction()
    Buttons.Option(L("settings.selectioncontrols.reset.label"), tip("settings.selectioncontrols.reset.tip"), ResetUI.ResetSelectionControls)

    Buttons.Break(L("settings.selectioncontrols.toggle.label"))
    if Buttons.Int(L("settings.selectioncontrols.toggle.size.label"), toggleSizeRef, tip("settings.selectioncontrols.toggle.size.tip")) then
        UI.Toggle.Size = toggleSizeRef.value
    end
    if Buttons.Float(L("settings.selectioncontrols.toggle.rounding.label"), toggleRoundingRef, tip("settings.selectioncontrols.toggle.rounding.tip")) then
        UI.Toggle.Rounding = toggleRoundingRef.value
    end
    if Buttons.Int(L("settings.selectioncontrols.toggle.inset.label"), toggleInsetRef, tip("settings.selectioncontrols.toggle.inset.tip")) then
        UI.Toggle.Inset = toggleInsetRef.value
    end
    if Buttons.Int(L("settings.selectioncontrols.toggle.statepadding.label"), toggleStatePaddingRef, tip("settings.selectioncontrols.toggle.statepadding.tip")) then
        UI.Toggle.StatePadding = toggleStatePaddingRef.value
    end
    if Buttons.Int(L("settings.selectioncontrols.toggle.statespacing.label"), toggleStateSpacingRef, tip("settings.selectioncontrols.toggle.statespacing.tip")) then
        UI.Toggle.StateSpacing = toggleStateSpacingRef.value
    end

    Buttons.ColorHex(L("settings.selectioncontrols.toggle.oncolor.label"), UI.Toggle, "OnColor", tip("settings.selectioncontrols.toggle.oncolor.tip"))
    Buttons.ColorHex(L("settings.selectioncontrols.toggle.offcolor.label"), UI.Toggle, "OffColor", tip("settings.selectioncontrols.toggle.offcolor.tip"))
    Buttons.ColorHex(L("settings.selectioncontrols.toggle.bordercolor.label"), UI.Toggle, "BorderColor", tip("settings.selectioncontrols.toggle.bordercolor.tip"))
    Buttons.ColorHex(L("settings.selectioncontrols.toggle.framebg.label"), UI.Toggle, "FrameBg", tip("settings.selectioncontrols.toggle.framebg.tip"))
    Buttons.ColorHex(L("settings.selectioncontrols.toggle.textcolor.label"), UI.Toggle, "TextColor", tip("settings.selectioncontrols.toggle.textcolor.tip"))

    Buttons.Break(L("settings.selectioncontrols.toggleexample.label"))
    Buttons.Toggle(L("settings.selectioncontrols.toggleexample.example.label"), exampleToggleRef, tip("settings.selectioncontrols.toggleexample.example.tip"))

    Buttons.Break(L("settings.selectioncontrols.radio.label"))
    if Buttons.Int(L("settings.selectioncontrols.radio.radius.label"), radioRadiusRef, tip("settings.selectioncontrols.radio.radius.tip")) then
        UI.Radio.Radius = radioRadiusRef.value
    end
    if Buttons.Float(L("settings.selectioncontrols.radio.linethickness.label"), radioThicknessRef, tip("settings.selectioncontrols.radio.linethickness.tip")) then
        UI.Radio.LineThickness = radioThicknessRef.value
    end
    if Buttons.Int(L("settings.selectioncontrols.radio.segments.label"), radioSegmentsRef, tip("settings.selectioncontrols.radio.segments.tip")) then
        UI.Radio.Segments = radioSegmentsRef.value
    end

    Buttons.ColorHex(L("settings.selectioncontrols.radio.selectedcolor.label"), UI.Radio, "SelectedColor", tip("settings.selectioncontrols.radio.selectedcolor.tip"))
    Buttons.ColorHex(L("settings.selectioncontrols.radio.unselectedcolor.label"), UI.Radio, "UnselectedColor", tip("settings.selectioncontrols.radio.unselectedcolor.tip"))

    Buttons.Break(L("settings.selectioncontrols.radioexample.label"))
    Buttons.Radio(L("settings.selectioncontrols.radioexample.example.label"), exampleRadioRef, exampleRadioOptions, tip("settings.selectioncontrols.radioexample.example.tip"))
end

local SelectionControlsView = { title = "settings.selectioncontrols.title", view = SelectionControlsViewFunction }

return SelectionControlsView

