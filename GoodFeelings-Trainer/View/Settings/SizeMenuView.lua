local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")

local function SizeMenuView()
    local Layout = UI.Base.Layout
    
    if Buttons.Option(L("settings.size.reset.label"), tip("settings.size.reset.tip"), function() 
        ResetUI.ResetSize()
        UI.ApplyScale()
    end) then
    end

    Buttons.Break(L("settings.size.dimensions.label"))

    -- Width
    -- We need a ref table for float sliders
    local widthRef = { value = Layout.WindowWidth, min = 300.0, max = 1000.0, step = 10.0 }
    if Buttons.Float(L("settings.size.dimensions.width.label"), widthRef, tip("settings.size.dimensions.width.tip")) then
        Layout.WindowWidth = widthRef.value
        UI.ApplyScale()
    end

    -- Dynamic Height Toggle
    local dynRef = { value = Layout.DynamicHeight }
    if Buttons.Toggle(L("settings.size.dimensions.dynamic.label"), dynRef, tip("settings.size.dimensions.dynamic.tip")) then
        Layout.DynamicHeight = dynRef.value
        UI.ApplyScale()
    end

    -- Height (only if Dynamic is off)
    if not Layout.DynamicHeight then
        local heightRef = { value = Layout.WindowHeight, min = 200.0, max = 1200.0, step = 10.0 }
        if Buttons.Float(L("settings.size.dimensions.height.label"), heightRef, tip("settings.size.dimensions.height.tip")) then
            Layout.WindowHeight = heightRef.value
            UI.ApplyScale()
        end
    end

    Buttons.Break(L("settings.size.scaling.label"))

    -- Scale
    local scaleRef = { value = Layout.Scale, min = 0.5, max = 2.0, step = 0.1 }
    if Buttons.Float(L("settings.size.scaling.scale.label"), scaleRef, tip("settings.size.scaling.scale.tip")) then
        Layout.Scale = scaleRef.value
        UI.ApplyScale()
    end
end

local Menu = { title = "settings.size.title", view = SizeMenuView }
return Menu
