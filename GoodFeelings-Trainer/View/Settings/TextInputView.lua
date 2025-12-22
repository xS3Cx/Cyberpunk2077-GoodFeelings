local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")
local TextInput = require("UI/Options/TextInput")
local Notification = require("UI/Elements/Notification")

local widthRef  = { value = UI.TextInput.Width,  min = 200, max = 800 }
local heightRef = { value = UI.TextInput.Height, min = 100, max = 400 }
local roundingRef = { value = UI.TextInput.Rounding, min = 0, max = 30 }
local paddingRef = { value = UI.TextInput.Padding, min = 0, max = 50 }
local spacingRef = { value = UI.TextInput.ButtonSpacing, min = 0, max = 50 }

local testInputRef = { value = "Give yourself time. Ideas'll come. Life'll shake you, roll you, maybe embrace you.", capturing = false }

local function TextInputViewFunction()
    Buttons.Option(L("settings.textinput.reset.label"), tip("settings.textinput.reset.tip"), ResetUI.ResetTextInput)

    Buttons.Break(L("settings.textinput.label"))
    if Buttons.Int(L("settings.textinput.width.label"), widthRef, tip("settings.textinput.width.tip")) then
        UI.TextInput.Width = widthRef.value
    end
    if Buttons.Int(L("settings.textinput.height.label"), heightRef, tip("settings.textinput.height.tip")) then
        UI.TextInput.Height = heightRef.value
    end
    if Buttons.Float(L("settings.textinput.rounding.label"), roundingRef, tip("settings.textinput.rounding.tip")) then
        UI.TextInput.Rounding = roundingRef.value
    end
    if Buttons.Int(L("settings.textinput.padding.label"), paddingRef, tip("settings.textinput.padding.tip")) then
        UI.TextInput.Padding = paddingRef.value
    end
    if Buttons.Int(L("settings.textinput.spacing.label"), spacingRef, tip("settings.textinput.spacing.tip")) then
        UI.TextInput.ButtonSpacing = spacingRef.value
    end

    Buttons.ColorHex(L("settings.textinput.textcolor.label"), UI.TextInput, "TextColor", tip("settings.textinput.textcolor.tip"))
    Buttons.ColorHex(L("settings.textinput.background.label"), UI.TextInput, "BackgroundColor", tip("settings.textinput.background.tip"))
    Buttons.ColorHex(L("settings.textinput.border.label"), UI.TextInput, "BorderColor", tip("settings.textinput.border.tip"))

    Buttons.Break(L("settings.textinput.example.label"))
    if TextInput.Option(L("settings.textinput.example.input.label"), testInputRef, tip("settings.textinput.example.input.tip")) then
        Notification.Info("TextInput result: " .. tostring(testInputRef.value))
    end
end

local TextInputView = { title = "settings.textinput.title", view = TextInputViewFunction }

return TextInputView

