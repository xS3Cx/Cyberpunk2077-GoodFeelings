local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")

local headerHeightRef = { value = UI.Header.Height, min = 20, max = 120 }
local headerFontSizeRef = { value = UI.Header.FontSize, min = 8, max = 40 }
local headerFontSizeSubRef = { value = UI.Header.FontSizeSub, min = 8, max = 40 }

local footerHeightRef = { value = UI.Footer.Height, min = 10, max = 80 }
local footerFontSizeRef = { value = UI.Footer.FontSize, min = 8, max = 30 }

local function FrameViewFunction()
    Buttons.Option(L("settings.frame.reset.label"), tip("settings.frame.reset.tip"), ResetUI.ResetFrame)

    Buttons.Break(L("settings.frame.header.label"))
    if Buttons.Int(L("settings.frame.header.height.label"), headerHeightRef, tip("settings.frame.header.height.tip")) then
        UI.Header.Height = headerHeightRef.value
    end
    if Buttons.Int(L("settings.frame.header.fontsize.label"), headerFontSizeRef, tip("settings.frame.header.fontsize.tip")) then
        UI.Header.FontSize = headerFontSizeRef.value
    end
    if Buttons.Int(L("settings.frame.header.fontsizesub.label"), headerFontSizeSubRef, tip("settings.frame.header.fontsizesub.tip")) then
        UI.Header.FontSizeSub = headerFontSizeSubRef.value
    end
    Buttons.ColorHex(L("settings.frame.header.background.label"), UI.Header, "BackgroundColor", tip("settings.frame.header.background.tip"))
    Buttons.ColorHex(L("settings.frame.header.textcolor.label"), UI.Header, "TextColor", tip("settings.frame.header.textcolor.tip"))
    Buttons.ColorHex(L("settings.frame.header.border.label"), UI.Header, "BorderColor", tip("settings.frame.header.border.tip"))

    Buttons.Break(L("settings.frame.footer.label"))
    if Buttons.Int(L("settings.frame.footer.height.label"), footerHeightRef, tip("settings.frame.footer.height.tip")) then
        UI.Footer.Height = footerHeightRef.value
    end
    if Buttons.Int(L("settings.frame.footer.fontsize.label"), footerFontSizeRef, tip("settings.frame.footer.fontsize.tip")) then
        UI.Footer.FontSize = footerFontSizeRef.value
    end
    Buttons.ColorHex(L("settings.frame.footer.background.label"), UI.Footer, "BackgroundColor", tip("settings.frame.footer.background.tip"))
    Buttons.ColorHex(L("settings.frame.footer.textcolor.label"), UI.Footer, "TextColor", tip("settings.frame.footer.textcolor.tip"))

end

local FrameView = { title = "settings.frame.title", view = FrameViewFunction }

return FrameView
