local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")

local toggleSizeRef = { value = UI.Numeric.ToggleSize, min = 8, max = 40 }
local toggleSpacingRef = { value = UI.Numeric.ToggleSpacing, min = 0, max = 30 }
local boxFramePaddingRef = { value = UI.Numeric.BoxFramePadding, min = 0, max = 30 }
local boxTextPaddingRef = { value = UI.Numeric.BoxTextPadding, min = 0, max = 30 }
local decimalsRef = { value = UI.Numeric.Decimals, min = 0, max = 6 }
local intStepRef = { value = UI.Numeric.DefaultIntStep, min = 1, max = 10 }
local floatStepRef = { value = UI.Numeric.DefaultFloatStep, min = 0.01, max = 5.0, step = 0.01 }

local channelBoxSizeRef = { value = UI.ColorPicker.ChannelBoxSize, min = 8, max = 50 }
local channelPaddingRef = { value = UI.ColorPicker.ChannelPadding, min = 0, max = 20 }
local previewBoxSizeRef = { value = UI.ColorPicker.PreviewBoxSize, min = 8, max = 50 }
local rowSpacingRef = { value = UI.ColorPicker.RowSpacing, min = 0, max = 20 }
local roundingRef = { value = UI.ColorPicker.Rounding, min = 0, max = 30 }

local numericRef = { value = 5, min = 0, max = 20, enabled = false }
local colorRef = { Red = 255, Green = 128, Blue = 64, Alpha = 255 }

local function InputControlsViewFunction()
    Buttons.Option(L("settings.inputcontrols.reset.label"), tip("settings.inputcontrols.reset.tip"), ResetUI.ResetLayout)

    Buttons.Break(L("settings.inputcontrols.numeric.label"))
    if Buttons.Int(L("settings.inputcontrols.numeric.togglesize.label"), toggleSizeRef, tip("settings.inputcontrols.numeric.togglesize.tip")) then
        UI.Numeric.ToggleSize = toggleSizeRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.numeric.togglespacing.label"), toggleSpacingRef, tip("settings.inputcontrols.numeric.togglespacing.tip")) then
        UI.Numeric.ToggleSpacing = toggleSpacingRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.numeric.boxframepadding.label"), boxFramePaddingRef, tip("settings.inputcontrols.numeric.boxframepadding.tip")) then
        UI.Numeric.BoxFramePadding = boxFramePaddingRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.numeric.boxtextpadding.label"), boxTextPaddingRef, tip("settings.inputcontrols.numeric.boxtextpadding.tip")) then
        UI.Numeric.BoxTextPadding = boxTextPaddingRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.numeric.decimals.label"), decimalsRef, tip("settings.inputcontrols.numeric.decimals.tip")) then
        UI.Numeric.Decimals = decimalsRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.numeric.defaultintstep.label"), intStepRef, tip("settings.inputcontrols.numeric.defaultintstep.tip")) then
        UI.Numeric.DefaultIntStep = intStepRef.value
    end
    if Buttons.Float(L("settings.inputcontrols.numeric.defaultfloatstep.label"), floatStepRef, tip("settings.inputcontrols.numeric.defaultfloatstep.tip")) then
        UI.Numeric.DefaultFloatStep = floatStepRef.value
    end

    Buttons.ColorHex(L("settings.inputcontrols.numeric.framebg.label"), UI.Numeric, "FrameBg", tip("settings.inputcontrols.numeric.framebg.tip"))
    Buttons.ColorHex(L("settings.inputcontrols.numeric.textcolor.label"), UI.Numeric, "TextColor", tip("settings.inputcontrols.numeric.textcolor.tip"))
    Buttons.ColorHex(L("settings.inputcontrols.numeric.disabledcolor.label"), UI.Numeric, "DisabledColor", tip("settings.inputcontrols.numeric.disabledcolor.tip"))

    Buttons.Break(L("settings.inputcontrols.numericexample.label"))
    Buttons.Int(L("settings.inputcontrols.numericexample.example.label"), numericRef, tip("settings.inputcontrols.numericexample.example.tip"))

    Buttons.Break(L("settings.inputcontrols.colorpicker.label"))
    if Buttons.Int(L("settings.inputcontrols.colorpicker.channelboxsize.label"), channelBoxSizeRef, tip("settings.inputcontrols.colorpicker.channelboxsize.tip")) then
        UI.ColorPicker.ChannelBoxSize = channelBoxSizeRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.colorpicker.channelpadding.label"), channelPaddingRef, tip("settings.inputcontrols.colorpicker.channelpadding.tip")) then
        UI.ColorPicker.ChannelPadding = channelPaddingRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.colorpicker.previewboxsize.label"), previewBoxSizeRef, tip("settings.inputcontrols.colorpicker.previewboxsize.tip")) then
        UI.ColorPicker.PreviewBoxSize = previewBoxSizeRef.value
    end
    if Buttons.Int(L("settings.inputcontrols.colorpicker.rowspacing.label"), rowSpacingRef, tip("settings.inputcontrols.colorpicker.rowspacing.tip")) then
        UI.ColorPicker.RowSpacing = rowSpacingRef.value
    end
    if Buttons.Float(L("settings.inputcontrols.colorpicker.rounding.label"), roundingRef, tip("settings.inputcontrols.colorpicker.rounding.tip")) then
        UI.ColorPicker.Rounding = roundingRef.value
    end

    Buttons.ColorHex(L("settings.inputcontrols.colorpicker.framebg.label"), UI.ColorPicker, "FrameBg", tip("settings.inputcontrols.colorpicker.framebg.tip"))
    Buttons.ColorHex(L("settings.inputcontrols.colorpicker.textcolor.label"), UI.ColorPicker, "TextColor", tip("settings.inputcontrols.colorpicker.textcolor.tip"))
    Buttons.ColorHex(L("settings.inputcontrols.colorpicker.bordercolor.label"), UI.ColorPicker, "BorderColor", tip("settings.inputcontrols.colorpicker.bordercolor.tip"))

    Buttons.Break(L("settings.inputcontrols.colorpickerexample.label"))
    Buttons.Color(L("settings.inputcontrols.colorpickerexample.example.label"), colorRef, tip("settings.inputcontrols.colorpickerexample.example.tip"))
end

local InputControlsView = { title = "settings.inputcontrols.title", view = InputControlsViewFunction }

return InputControlsView
