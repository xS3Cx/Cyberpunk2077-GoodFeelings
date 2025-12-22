local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")

local optionHeightRef = { value = UI.Layout.OptionHeight, min = 10, max = 80 }
local paddingXRef = { value = UI.Layout.OptionPaddingX, min = 0, max = 65 }
local paddingYRef = { value = UI.Layout.OptionPaddingY, min = 0, max = 65 }
local frameRoundingRef = { value = UI.Layout.FrameRounding, min = 0, max = 30 }
local frameHeightRef = { value = UI.Layout.FrameHeight, min = 10, max = 80 }
local labelOffsetRef = { value = UI.Layout.LabelOffsetX, min = 0, max = 40 }
local itemSpacingXRef = { value = UI.Layout.ItemSpacing.x, min = 0, max = 50 }
local itemSpacingYRef = { value = UI.Layout.ItemSpacing.y, min = 0, max = 50 }
local framePaddingXRef = { value = UI.Layout.FramePadding.x, min = 0, max = 50 }
local framePaddingYRef = { value = UI.Layout.FramePadding.y, min = 0, max = 50 }

local smoothSpeedRef = { value = UI.OptionRow.SmoothSpeed, min = 0.01, max = 1.0, step = 0.01 }

local function LayoutOptionRowViewFunction()
    Buttons.Option(L("settings.layout.reset.label"), tip("settings.layout.reset.tip"), ResetUI.ResetLayout)

    Buttons.Break(L("settings.layout.layout.label"))
    if Buttons.Int(L("settings.layout.layout.optionheight.label"), optionHeightRef, tip("settings.layout.layout.optionheight.tip")) then
        UI.Layout.OptionHeight = optionHeightRef.value
    end
    if Buttons.Int(L("settings.layout.layout.frameheight.label"), frameHeightRef, tip("settings.layout.layout.frameheight.tip")) then
        UI.Layout.FrameHeight = frameHeightRef.value
    end
    if Buttons.Int(L("settings.layout.layout.paddingx.label"), paddingXRef, tip("settings.layout.layout.paddingx.tip")) then
        UI.Layout.OptionPaddingX = paddingXRef.value
    end
    if Buttons.Int(L("settings.layout.layout.paddingy.label"), paddingYRef, tip("settings.layout.layout.paddingy.tip")) then
        UI.Layout.OptionPaddingY = paddingYRef.value
    end
    if Buttons.Int(L("settings.layout.layout.labeloffsetx.label"), labelOffsetRef, tip("settings.layout.layout.labeloffsetx.tip")) then
        UI.Layout.LabelOffsetX = labelOffsetRef.value
        UI.OptionRow.LabelOffsetX = labelOffsetRef.value
    end
    if Buttons.Float(L("settings.layout.layout.framerounding.label"), frameRoundingRef, tip("settings.layout.layout.framerounding.tip")) then
        UI.Layout.FrameRounding = frameRoundingRef.value
        UI.OptionRow.Rounding = frameRoundingRef.value
    end
    
    Buttons.ColorHex(L("settings.layout.layout.backgroundcolor.label"), UI.Colors, "Background", tip("settings.layout.layout.backgroundcolor.tip"))

    if Buttons.Int(L("settings.layout.layout.itemspacingx.label"), itemSpacingXRef, tip("settings.layout.layout.itemspacingx.tip")) then
        UI.Layout.ItemSpacing.x = itemSpacingXRef.value
    end
    if Buttons.Int(L("settings.layout.layout.itemspacingy.label"), itemSpacingYRef, tip("settings.layout.layout.itemspacingy.tip")) then
        UI.Layout.ItemSpacing.y = itemSpacingYRef.value
    end
    if Buttons.Float(L("settings.layout.layout.framepaddingx.label"), framePaddingXRef, tip("settings.layout.layout.framepaddingx.tip")) then
        UI.Layout.FramePadding.x = framePaddingXRef.value
    end
    if Buttons.Float(L("settings.layout.layout.framepaddingy.label"), framePaddingYRef, tip("settings.layout.layout.framepaddingy.tip")) then
        UI.Layout.FramePadding.y = framePaddingYRef.value
    end

    Buttons.Break(L("settings.layout.optionrow.label"))
    if Buttons.Float(L("settings.layout.optionrow.smoothspeed.label"), smoothSpeedRef, tip("settings.layout.optionrow.smoothspeed.tip")) then
        UI.OptionRow.SmoothSpeed = smoothSpeedRef.value
    end
    Buttons.ColorHex(L("settings.layout.optionrow.text.label"), UI.OptionRow, "Text", tip("settings.layout.optionrow.text.tip"))
    Buttons.ColorHex(L("settings.layout.optionrow.mutedtext.label"), UI.OptionRow, "MutedText", tip("settings.layout.optionrow.mutedtext.tip"))
    Buttons.ColorHex(L("settings.layout.optionrow.hoverbg.label"), UI.OptionRow, "HoverBg", tip("settings.layout.optionrow.hoverbg.tip"))
    Buttons.ColorHex(L("settings.layout.optionrow.highlightbg.label"), UI.OptionRow, "HighlightBg", tip("settings.layout.optionrow.highlightbg.tip"))
end

local LayoutOptionRowView = { title = "settings.layout.title", view = LayoutOptionRowViewFunction }

return LayoutOptionRowView