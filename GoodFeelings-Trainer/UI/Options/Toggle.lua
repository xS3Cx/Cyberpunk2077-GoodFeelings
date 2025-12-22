local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Option = require("UI/Options/Option")

local Toggle = {}

---@param label string
---@param ref table { value:boolean }
---@param tip string|nil
---@return boolean clicked
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
---@param ref table { value:boolean }
---@param tip string|nil
---@return boolean clicked
function Toggle.Option(label, ref, tip)
    local clicked,pos = Option.Option(label,"","",tip)
    if not pos then return false end

    -- Animation logic
    animCache[label] = animCache[label] or (ref.value and 1.0 or 0.0)
    local target = ref.value and 1.0 or 0.0
    local speed = UI.Toggle.AnimSpeed or 0.2
    
    animCache[label] = animCache[label] + (target - animCache[label]) * speed
    local t = animCache[label]
    
    -- Snap if close
    if math.abs(target - t) < 0.01 then t = target end

    local height = UI.Toggle.Size
    local width = height * (UI.Toggle.WidthFactor or 1.55)
    local radius = height * 0.5
    
    local tx = pos.x + pos.w - UI.Layout.LabelOffsetX - width
    local ty = pos.y + (pos.h - height) * 0.5

    -- Determine colors based on state
    local bgOff = UI.Toggle.OffColor or UI.ColPalette.ToggleOff
    local bgOn = UI.Toggle.OnColor or UI.ColPalette.ToggleOn
    local thumbOff = UI.Toggle.OffThumbColor or UI.ColPalette.ToggleOffThumb
    local thumbOn = UI.Toggle.OnThumbColor or UI.ColPalette.ToggleOnThumb

    local col_bg = LerpColor(bgOff, bgOn, t)
    local col_thumb = LerpColor(thumbOff, thumbOn, t)

    -- Draw Background Pill
    DrawHelpers.RectFilled(tx, ty, width, height, col_bg, radius)

    -- Draw Circular Dot (Thumb)
    local dotStart = tx + radius
    local dotEnd = tx + width - radius
    local dotX = dotStart + (dotEnd - dotStart) * t
    local dotY = ty + radius
    local dotRadius = radius - (UI.Toggle.Inset or 1.5)
    
    local drawlist = ImGui.GetWindowDrawList()
    ImGui.ImDrawListAddCircleFilled(drawlist, dotX, dotY, dotRadius, col_thumb)

    if clicked then ref.value = not ref.value end
    return clicked
end

return Toggle
