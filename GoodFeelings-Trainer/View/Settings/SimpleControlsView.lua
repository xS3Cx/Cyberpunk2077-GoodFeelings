local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")
local framesPerOptionRef = { value = UI.Dropdown.FramesPerOption, min = 1, max = 10 }
local revealDelayRef = { value = UI.Dropdown.RevealFrameDelay, min = 0, max = 10 }

local framePaddingRef = { value = UI.StringCycler.FramePadding, min = 0, max = 30 }
local textPaddingRef = { value = UI.StringCycler.TextPadding, min = 0, max = 30 }
local boxRoundingRef = { value = UI.StringCycler.BoxRounding, min = 0, max = 30 }

local prefixRef = { index = 1 }
local prefixOptions = { "- ", "* ", "> ", ">> ", "[ " }

local cyclerRef = { index = 1 }
local cyclerOptions = { "Netrunner", "Nomad", "Fixer", "Rockerboy" }
local dropdownRef = { index = 1, expanded = false }

local function SimpleControlsViewFunction()
    Buttons.Option(L("settings.simplecontrols.reset.label"), tip("settings.simplecontrols.reset.tip"), ResetUI.ResetSimpleControls)

    Buttons.Break(L("settings.simplecontrols.breakrow.label"))
    Buttons.ColorHex(L("settings.simplecontrols.breakrow.text.label"), UI.BreakRow, "Text", tip("settings.simplecontrols.breakrow.text.tip"))
    Buttons.ColorHex(L("settings.simplecontrols.breakrow.highlightbg.label"), UI.BreakRow, "HighlightBg", tip("settings.simplecontrols.breakrow.highlightbg.tip"))

    Buttons.Break(L("settings.simplecontrols.dropdown.label"))
    if Buttons.Int(L("settings.simplecontrols.dropdown.framesperoption.label"), framesPerOptionRef, tip("settings.simplecontrols.dropdown.framesperoption.tip")) then
        UI.Dropdown.FramesPerOption = framesPerOptionRef.value
    end
    if Buttons.Int(L("settings.simplecontrols.dropdown.revealdelay.label"), revealDelayRef, tip("settings.simplecontrols.dropdown.revealdelay.tip")) then
        UI.Dropdown.RevealFrameDelay = revealDelayRef.value
    end
    Buttons.ColorHex(L("settings.simplecontrols.dropdown.textcolor.label"), UI.Dropdown, "TextColor", tip("settings.simplecontrols.dropdown.textcolor.tip"))
    Buttons.ColorHex(L("settings.simplecontrols.dropdown.selectedcolor.label"), UI.Dropdown, "SelectedColor", tip("settings.simplecontrols.dropdown.selectedcolor.tip"))

    Buttons.Dropdown(L("settings.simplecontrols.dropdown.rowprefix.label"), prefixRef, prefixOptions, tip("settings.simplecontrols.dropdown.rowprefix.tip"))
    UI.Dropdown.RowPrefix = prefixOptions[prefixRef.index]

    Buttons.Break(L("settings.simplecontrols.dropdownexample.label"))
    Buttons.Dropdown(L("settings.simplecontrols.dropdownexample.example.label"), dropdownRef, { "Option One", "Option Two", "Option Three" }, tip("settings.simplecontrols.dropdownexample.example.tip"))

    Buttons.Break(L("settings.simplecontrols.stringcycler.label"))
    if Buttons.Int(L("settings.simplecontrols.stringcycler.framepadding.label"), framePaddingRef, tip("settings.simplecontrols.stringcycler.framepadding.tip")) then
        UI.StringCycler.FramePadding = framePaddingRef.value
    end
    if Buttons.Int(L("settings.simplecontrols.stringcycler.textpadding.label"), textPaddingRef, tip("settings.simplecontrols.stringcycler.textpadding.tip")) then
        UI.StringCycler.TextPadding = textPaddingRef.value
    end
    if Buttons.Float(L("settings.simplecontrols.stringcycler.boxrounding.label"), boxRoundingRef, tip("settings.simplecontrols.stringcycler.boxrounding.tip")) then
        UI.StringCycler.BoxRounding = boxRoundingRef.value
    end
    Buttons.ColorHex(L("settings.simplecontrols.stringcycler.framebg.label"), UI.StringCycler, "FrameBg", tip("settings.simplecontrols.stringcycler.framebg.tip"))
    Buttons.ColorHex(L("settings.simplecontrols.stringcycler.valuecolor.label"), UI.StringCycler, "ValueColor", tip("settings.simplecontrols.stringcycler.valuecolor.tip"))

    Buttons.Break(L("settings.simplecontrols.stringcyclerexample.label"))
    Buttons.StringCycler(L("settings.simplecontrols.stringcyclerexample.example.label"), cyclerRef, cyclerOptions, tip("settings.simplecontrols.stringcyclerexample.example.tip"))
end

local SimpleControlsView = { title = "settings.simplecontrols.title", view = SimpleControlsViewFunction }

return SimpleControlsView

