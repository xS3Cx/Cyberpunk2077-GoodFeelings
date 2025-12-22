-- View/Settings/ScrollingMenuView.lua
local UI = require("UI")

local maxVisibleRef = {
    value = UI.Style.Base.Layout.MaxVisibleOptions or 16,
    min = 5,
    max = 30
}

local function ScrollingMenuViewFunction()
    -- Sync ref value with style in case it was changed elsewhere (reset, load)
    maxVisibleRef.value = UI.Style.Base.Layout.MaxVisibleOptions or 16

    if UI.Buttons.Int(L("settingsmenu.scrolling.maxvisible.label"), maxVisibleRef, tip("settingsmenu.scrolling.maxvisible.tip"), function()
        UI.Style.Base.Layout.MaxVisibleOptions = maxVisibleRef.value
        UI.Style.ApplyScale()
    end) then
        -- Action handled in callback
    end

    if UI.Buttons.Option(L("settingsmenu.scrolling.reset.label"), L("settingsmenu.scrolling.reset.tip")) then
        UI.Style.Base.Layout.MaxVisibleOptions = 16
        UI.Style.ApplyScale()
    end
end

local ScrollingMenuView = { title = "settingsmenu.scrolling.label", view = ScrollingMenuViewFunction }

return ScrollingMenuView
