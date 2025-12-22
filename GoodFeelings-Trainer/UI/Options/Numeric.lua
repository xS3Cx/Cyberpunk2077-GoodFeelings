local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Option = require("UI/Options/Option")
local State = require("Controls/State")

local Numeric = {}

local animCache = {}

local function split(c)
    local a = math.floor(c / 16777216) % 256
    local r = math.floor(c / 65536) % 256
    local g = math.floor(c / 256) % 256
    local b = c % 256
    return a, r, g, b
end

local function LerpColor(c1, c2, t)
    local a1, r1, g1, b1 = split(c1)
    local a2, r2, g2, b2 = split(c2)
    local a = math.floor(a1 + (a2 - a1) * t)
    local r = math.floor(r1 + (r2 - r1) * t)
    local g = math.floor(g1 + (g2 - g1) * t)
    local b = math.floor(b1 + (b2 - b1) * t)
    return a * 16777216 + r * 65536 + g * 256 + b
end

---@param label string
---@param ref table { value:number, enabled:boolean|nil, min:number|nil, max:number|nil, step:number|nil }
---@param tip string|nil
---@param isFloat boolean true = float, false = int
---@param onClick boolean|nil true = only return true on click
---@return boolean changed
function Numeric.Option(label, ref, tip, isFloat, onClick)
    local keyTip = isFloat and L("optionmanager.float_toggle_tip") or L("optionmanager.inttoggle_tip")
    local fullTip = keyTip..(tip and ("\n\n"..tip) or "")
    local clicked,pos = Option.Option(label,"","",fullTip)
    if not pos then return false end

    local size = UI.Numeric.ToggleSize
    local spacing = UI.Numeric.ToggleSpacing
    local fpad = UI.Numeric.BoxFramePadding
    local tpad = UI.Numeric.BoxTextPadding
    local minVal = ref.min or 0
    local maxVal = ref.max or (isFloat and 1 or 100)
    local step = ref.step or (isFloat and UI.Numeric.DefaultFloatStep or UI.Numeric.DefaultIntStep)
    local oldVal,oldEnabled = ref.value,ref.enabled

    if pos.isActive then
        if State.leftPressed then
            ref.value = ref.value-step
            if ref.value < minVal then ref.value = maxVal end
        elseif State.rightPressed then
            ref.value = ref.value+step
            if ref.value > maxVal then ref.value = minVal end
        end
    end

    if clicked and ref.enabled ~= nil then
        ref.enabled = not ref.enabled
    end

    if isFloat then
        local d = UI.Numeric.Decimals or 2
        ref.value = tonumber(string.format("%."..d.."f",math.max(minVal,math.min(maxVal,ref.value))))
    else
        ref.value = math.max(minVal,math.min(maxVal,ref.value))
    end

    local valueText = isFloat
        and string.format("%."..(UI.Numeric.Decimals or 2).."f / %.2f",ref.value,maxVal)
        or string.format("%d / %d",ref.value,maxVal)

    local vw = ImGui.CalcTextSize(valueText)
    local pillHeight = UI.Toggle.Size or 18
    local pillWidth = pillHeight * (UI.Toggle.WidthFactor or 1.55)
    local spacing = UI.Numeric.ToggleSpacing or 10
    
    -- Positioning: [Value Box] [Spacing] [Pill Toggle] (from right to left)
    local toggleX = pos.x + pos.w - UI.Layout.LabelOffsetX - (ref.enabled ~= nil and pillWidth or -spacing)
    local valueX = toggleX - vw - (ref.enabled ~= nil and spacing or 0)
    
    local fpad = UI.Numeric.BoxFramePadding or 6
    local tpad = UI.Numeric.BoxTextPadding or 3
    
    -- Draw Value Box
    DrawHelpers.RectFilled(valueX - fpad, pos.y + tpad, vw + fpad*2, pos.h - tpad*2, UI.Numeric.FrameBg, UI.Layout.FrameRounding)
    
    local txtColor = UI.Numeric.TextColor or UI.ColPalette.SolidBlueHighlight
    DrawHelpers.Text(valueX, pos.fontY, txtColor, valueText)

    -- Draw Toggle (if applicable)
    if ref.enabled ~= nil then
        -- Animation logic
        local animKey = label.."_toggle"
        animCache[animKey] = animCache[animKey] or (ref.enabled and 1.0 or 0.0)
        local target = ref.enabled and 1.0 or 0.0
        local speed = UI.Toggle.AnimSpeed or 0.2
        
        animCache[animKey] = animCache[animKey] + (target - animCache[animKey]) * speed
        local t = animCache[animKey]
        if math.abs(target - t) < 0.01 then t = target end

        local radius = pillHeight * 0.5
        local ty = pos.y + (pos.h - pillHeight) * 0.5
        
        local bgOff = UI.Toggle.OffColor or UI.ColPalette.ToggleOff
        local bgOn = UI.Toggle.OnColor or UI.ColPalette.ToggleOn
        local thumbOff = UI.Toggle.OffThumbColor or UI.ColPalette.ToggleOffThumb
        local thumbOn = UI.Toggle.OnThumbColor or UI.ColPalette.ToggleOnThumb

        local col_bg = LerpColor(bgOff, bgOn, t)
        local col_thumb = LerpColor(thumbOff, thumbOn, t)

        -- Draw Background Pill
        DrawHelpers.RectFilled(toggleX, ty, pillWidth, pillHeight, col_bg, radius)

        -- Draw Circular Dot (Thumb)
        local dotStart = toggleX + radius
        local dotEnd = toggleX + pillWidth - radius
        local dotX = dotStart + (dotEnd - dotStart) * t
        local dotY = ty + radius
        local dotRadius = radius - (UI.Toggle.Inset or 1.5)
        
        local drawlist = ImGui.GetWindowDrawList()
        ImGui.ImDrawListAddCircleFilled(drawlist, dotX, dotY, dotRadius, col_thumb)
    end

    if onClick then
        return clicked
    else
        return clicked or (ref.value ~= oldVal) or (ref.enabled ~= oldEnabled)
    end
end

return Numeric
