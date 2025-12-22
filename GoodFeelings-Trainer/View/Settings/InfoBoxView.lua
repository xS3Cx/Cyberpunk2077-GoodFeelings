local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")

local paddingRef = { value = UI.InfoBox.Padding, min = 0, max = 50 }
local spacingRef = { value = UI.InfoBox.Spacing, min = 0, max = 50 }
local roundingRef = { value = UI.InfoBox.Rounding, min = 0, max = 30 }
local cpsRef = { value = UI.InfoBox.CharsPerSecond, min = 20, max = 500 }
local rotateRef = { value = UI.InfoBox.FallbackRotateSeconds, min = 1, max = 60 }

local function InfoBoxViewFunction()
    Buttons.Option(L("settings.infobox.reset.label"), tip("settings.infobox.reset.tip"), ResetUI.ResetInfoBox)

    Buttons.Break(L("settings.infobox.label"))
    if Buttons.Int(L("settings.infobox.padding.label"), paddingRef, tip("settings.infobox.padding.tip")) then
        UI.InfoBox.Padding = paddingRef.value
    end
    if Buttons.Int(L("settings.infobox.spacing.label"), spacingRef, tip("settings.infobox.spacing.tip")) then
        UI.InfoBox.Spacing = spacingRef.value
    end
    if Buttons.Float(L("settings.infobox.rounding.label"), roundingRef, tip("settings.infobox.rounding.tip")) then
        UI.InfoBox.Rounding = roundingRef.value
    end
    if Buttons.Int(L("settings.infobox.cps.label"), cpsRef, tip("settings.infobox.cps.tip")) then
        UI.InfoBox.CharsPerSecond = cpsRef.value
    end
    if Buttons.Int(L("settings.infobox.rotate.label"), rotateRef, tip("settings.infobox.rotate.tip")) then
        UI.InfoBox.FallbackRotateSeconds = rotateRef.value
    end

    Buttons.ColorHex(L("settings.infobox.textcolor.label"), UI.InfoBox, "TextColor", tip("settings.infobox.textcolor.tip"))
    Buttons.ColorHex(L("settings.infobox.background.label"), UI.InfoBox, "BackgroundColor", tip("settings.infobox.background.tip"))
    Buttons.ColorHex(L("settings.infobox.border.label"), UI.InfoBox, "BorderColor", tip("settings.infobox.border.tip"))
end

local InfoBoxView = { title = "settings.infobox.title", view = InfoBoxViewFunction }

return InfoBoxView
