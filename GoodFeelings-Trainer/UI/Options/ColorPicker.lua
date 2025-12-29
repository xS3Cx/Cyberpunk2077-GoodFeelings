local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Option = require("UI/Options/Option")
local State = require("Controls/State")

local ColorPicker = {}

local function HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return r * 255, g * 255, b * 255
end

local function RGBtoHSV(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max
    local d = max - min
    s = max == 0 and 0 or d / max
    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v
end

---@param label string
---@param ref table { Red:number, Green:number, Blue:number, Alpha:number }
---@param tip string|nil
---@return boolean changed
function ColorPicker.Option(label, ref, tip)
    local keyTip = L("optionmanager.color_tip")
    local fullTip = (tip and (tip.."\n\n") or "")..keyTip
    local clicked, pos = Option.Option(label, "", "", fullTip)
    if not pos then return false end

    local scale = UI.Base.Layout.Scale or 1.0
    local sliderWidth = 200 * scale
    local sliderHeight = 20 * scale
    local sliderX = pos.x + pos.w - UI.Layout.LabelOffsetX - sliderWidth
    local sliderY = pos.y + (pos.h - sliderHeight) * 0.5

    -- Reserve space in ImGui layout for the slider
    ImGui.SetCursorPos(sliderX - pos.x, sliderY - pos.y)
    ImGui.Dummy(sliderWidth, sliderHeight)

    -- Initialize mode if not set (1=RGB, 2=Saturation, 3=Brightness, 4=Alpha)
    ref._sliderMode = ref._sliderMode or 1
    
    -- Handle right-click to cycle modes
    local mouseX, mouseY = ImGui.GetMousePos()
    local isHovered = mouseX >= sliderX and mouseX <= sliderX + sliderWidth and 
                      mouseY >= sliderY and mouseY <= sliderY + sliderHeight
    
    if isHovered and ImGui.IsMouseClicked(1) then  -- Right click
        ref._sliderMode = (ref._sliderMode % 4) + 1
    end
    
    -- Draw gradient based on current mode
    local dl = ImGui.GetWindowDrawList()
    local steps = 100
    local stepWidth = sliderWidth / steps
    
    if ref._sliderMode == 1 then
        -- RGB Mode - Rainbow gradient
        for i = 0, steps - 1 do
            local hue = i / steps
            local r, g, b = HSVtoRGB(hue, 1.0, 1.0)
            local col1 = ImGui.ColorConvertFloat4ToU32({r/255, g/255, b/255, 1.0})
            
            local nextHue = (i + 1) / steps
            local r2, g2, b2 = HSVtoRGB(nextHue, 1.0, 1.0)
            local col2 = ImGui.ColorConvertFloat4ToU32({r2/255, g2/255, b2/255, 1.0})
            
            local x1 = sliderX + i * stepWidth
            local x2 = sliderX + (i + 1) * stepWidth
            
            ImGui.ImDrawListAddRectFilledMultiColor(dl, x1, sliderY, x2, sliderY + sliderHeight, col1, col2, col2, col1)
        end
    elseif ref._sliderMode == 2 then
        -- Saturation Mode - Gray to Full Color
        local h, s, v = RGBtoHSV(ref.Red, ref.Green, ref.Blue)
        for i = 0, steps - 1 do
            local sat = i / steps
            local r, g, b = HSVtoRGB(h, sat, v)
            local col1 = ImGui.ColorConvertFloat4ToU32({r/255, g/255, b/255, 1.0})
            
            local sat2 = (i + 1) / steps
            local r2, g2, b2 = HSVtoRGB(h, sat2, v)
            local col2 = ImGui.ColorConvertFloat4ToU32({r2/255, g2/255, b2/255, 1.0})
            
            local x1 = sliderX + i * stepWidth
            local x2 = sliderX + (i + 1) * stepWidth
            
            ImGui.ImDrawListAddRectFilledMultiColor(dl, x1, sliderY, x2, sliderY + sliderHeight, col1, col2, col2, col1)
        end
    elseif ref._sliderMode == 3 then
        -- Brightness Mode - Black to White
        for i = 0, steps - 1 do
            local brightness = i / steps
            local gray = brightness * 255
            local col1 = ImGui.ColorConvertFloat4ToU32({gray/255, gray/255, gray/255, 1.0})
            
            local brightness2 = (i + 1) / steps
            local gray2 = brightness2 * 255
            local col2 = ImGui.ColorConvertFloat4ToU32({gray2/255, gray2/255, gray2/255, 1.0})
            
            local x1 = sliderX + i * stepWidth
            local x2 = sliderX + (i + 1) * stepWidth
            
            ImGui.ImDrawListAddRectFilledMultiColor(dl, x1, sliderY, x2, sliderY + sliderHeight, col1, col2, col2, col1)
        end
    else
        -- Alpha Mode - Transparency gradient
        for i = 0, steps - 1 do
            local alpha = i / steps
            local col1 = ImGui.ColorConvertFloat4ToU32({ref.Red/255, ref.Green/255, ref.Blue/255, alpha})
            
            local alpha2 = (i + 1) / steps
            local col2 = ImGui.ColorConvertFloat4ToU32({ref.Red/255, ref.Green/255, ref.Blue/255, alpha2})
            
            local x1 = sliderX + i * stepWidth
            local x2 = sliderX + (i + 1) * stepWidth
            
            ImGui.ImDrawListAddRectFilledMultiColor(dl, x1, sliderY, x2, sliderY + sliderHeight, col1, col2, col2, col1)
        end
    end
    
    -- Border
    DrawHelpers.Rect(sliderX, sliderY, sliderWidth, sliderHeight, 0xFFFFFFFF, 2 * scale, 1.5)

    -- Get/update current value based on mode
    if ref._sliderMode == 1 then
        local h, s, v = RGBtoHSV(ref.Red, ref.Green, ref.Blue)
        ref._hue = ref._hue or h
    elseif ref._sliderMode == 2 then
        local h, s, v = RGBtoHSV(ref.Red, ref.Green, ref.Blue)
        ref._saturation = ref._saturation or s
    elseif ref._sliderMode == 3 then
        -- For brightness mode, calculate grayscale value
        ref._grayscale = ref._grayscale or ((ref.Red + ref.Green + ref.Blue) / 3 / 255)
    else
        ref._alpha = ref._alpha or (ref.Alpha / 255)
    end
    
    -- Handle interaction
    local changed = false
    
    -- Mouse interaction
    if isHovered and ImGui.IsMouseDown(0) then
        local t = (mouseX - sliderX) / sliderWidth
        t = math.max(0, math.min(1, t))
        
        if ref._sliderMode == 1 then
            -- RGB Mode - change hue
            ref._hue = t
            local r, g, b = HSVtoRGB(t, 1.0, 1.0)
            ref.Red = math.floor(r)
            ref.Green = math.floor(g)
            ref.Blue = math.floor(b)
        elseif ref._sliderMode == 2 then
            -- Saturation Mode - change saturation
            ref._saturation = t
            local h, s, v = RGBtoHSV(ref.Red, ref.Green, ref.Blue)
            local r, g, b = HSVtoRGB(h, t, v)
            ref.Red = math.floor(r)
            ref.Green = math.floor(g)
            ref.Blue = math.floor(b)
        elseif ref._sliderMode == 3 then
            -- Brightness Mode - set to grayscale
            ref._grayscale = t
            local gray = math.floor(t * 255)
            ref.Red = gray
            ref.Green = gray
            ref.Blue = gray
        else
            -- Alpha Mode - change alpha
            ref._alpha = t
            ref.Alpha = math.floor(t * 255)
        end
        changed = true
    end
    
    -- Keyboard interaction (when option is active)
    if pos.isActive then
        local State = require("Controls/State")
        local Input = require("Core/Input")
        
        -- Space key (VK code 32) or R3 button to cycle modes - detect just pressed
        ref._spaceWasDown = ref._spaceWasDown or false
        ref._r3WasDown = ref._r3WasDown or false
        
        local spaceDown = Input.IsKeyDown(32)  -- Space key
        local r3Down = Input.IsButtonDown(Input.GP.RIGHT_STICK)  -- R3 button
        
        if (spaceDown and not ref._spaceWasDown) or (r3Down and not ref._r3WasDown) then
            ref._sliderMode = (ref._sliderMode % 4) + 1
            changed = true
        end
        ref._spaceWasDown = spaceDown
        ref._r3WasDown = r3Down
        
        -- Arrow keys to adjust value
        local step = 0.01  -- 1% per key press
        local delta = 0
        
        if State.leftPressed then
            delta = -step
        elseif State.rightPressed then
            delta = step
        end
        
        if delta ~= 0 then
            if ref._sliderMode == 1 then
                -- RGB Mode
                ref._hue = math.max(0, math.min(1, ref._hue + delta))
                local r, g, b = HSVtoRGB(ref._hue, 1.0, 1.0)
                ref.Red = math.floor(r)
                ref.Green = math.floor(g)
                ref.Blue = math.floor(b)
            elseif ref._sliderMode == 2 then
                -- Saturation Mode
                ref._saturation = math.max(0, math.min(1, ref._saturation + delta))
                local h, s, v = RGBtoHSV(ref.Red, ref.Green, ref.Blue)
                local r, g, b = HSVtoRGB(h, ref._saturation, v)
                ref.Red = math.floor(r)
                ref.Green = math.floor(g)
                ref.Blue = math.floor(b)
            elseif ref._sliderMode == 3 then
                -- Brightness Mode
                ref._grayscale = math.max(0, math.min(1, ref._grayscale + delta))
                local gray = math.floor(ref._grayscale * 255)
                ref.Red = gray
                ref.Green = gray
                ref.Blue = gray
            else
                -- Alpha Mode
                ref._alpha = math.max(0, math.min(1, ref._alpha + delta))
                ref.Alpha = math.floor(ref._alpha * 255)
            end
            changed = true
        end
    end
    
    -- Get indicator position based on mode
    local indicatorX
    if ref._sliderMode == 1 then
        indicatorX = sliderX + ref._hue * sliderWidth
    elseif ref._sliderMode == 2 then
        indicatorX = sliderX + ref._saturation * sliderWidth
    elseif ref._sliderMode == 3 then
        indicatorX = sliderX + ref._grayscale * sliderWidth
    else
        indicatorX = sliderX + ref._alpha * sliderWidth
    end
    
    local iconScale = 0.5 * scale
    
    -- Branded Icon Data (same as particles)
    local ICON_VERTS = {
        {21.807, 12.5},   -- P1 (Center Tip)
        {1.717, 0.9},     -- P2 (Top Outer)
        {4.371, 2.533},   -- P3 (Top Inner)
        {4.371, 22.463},  -- P4 (Bottom Inner)
        {1.717, 24.096}   -- P5 (Bottom Outer)
    }
    
    -- Use accent color
    local accentColor = UI.ColPalette.MainAccent or 0xFF00D9FF
    local fillColor = UI.ColPalette.MainAccentAlpha or 0x4000D9FF
    local outlineColor = accentColor
    
    -- Top indicator (pointing down at current position)
    local topY = sliderY
    local angleTop = math.pi * 0.5  -- 90 degrees - pointing down
    local cosTop, sinTop = math.cos(angleTop), math.sin(angleTop)
    
    local verticesTop = {}
    for i = 1, 5 do
        local ix, iy = (ICON_VERTS[i][1] - 12.5) * iconScale, (ICON_VERTS[i][2] - 12.5) * iconScale
        local vx = indicatorX + (ix * cosTop - iy * sinTop)
        local vy = topY + (ix * sinTop + iy * cosTop)
        verticesTop[i] = {vx, vy}
    end
    
    -- Draw top icon
    ImGui.ImDrawListAddTriangleFilled(dl, verticesTop[1][1], verticesTop[1][2], verticesTop[2][1], verticesTop[2][2], verticesTop[3][1], verticesTop[3][2], fillColor)
    ImGui.ImDrawListAddTriangleFilled(dl, verticesTop[1][1], verticesTop[1][2], verticesTop[3][1], verticesTop[3][2], verticesTop[4][1], verticesTop[4][2], fillColor)
    ImGui.ImDrawListAddTriangleFilled(dl, verticesTop[1][1], verticesTop[1][2], verticesTop[4][1], verticesTop[4][2], verticesTop[5][1], verticesTop[5][2], fillColor)
    ImGui.ImDrawListAddLine(dl, verticesTop[1][1], verticesTop[1][2], verticesTop[2][1], verticesTop[2][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesTop[2][1], verticesTop[2][2], verticesTop[3][1], verticesTop[3][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesTop[3][1], verticesTop[3][2], verticesTop[4][1], verticesTop[4][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesTop[4][1], verticesTop[4][2], verticesTop[5][1], verticesTop[5][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesTop[5][1], verticesTop[5][2], verticesTop[1][1], verticesTop[1][2], outlineColor, 1.0)
    
    -- Bottom indicator (pointing up at current position)
    local bottomY = sliderY + sliderHeight
    local angleBottom = -math.pi * 0.5  -- -90 degrees - pointing up
    local cosBottom, sinBottom = math.cos(angleBottom), math.sin(angleBottom)
    
    local verticesBottom = {}
    for i = 1, 5 do
        local ix, iy = (ICON_VERTS[i][1] - 12.5) * iconScale, (ICON_VERTS[i][2] - 12.5) * iconScale
        local vx = indicatorX + (ix * cosBottom - iy * sinBottom)
        local vy = bottomY + (ix * sinBottom + iy * cosBottom)
        verticesBottom[i] = {vx, vy}
    end
    
    -- Draw bottom icon
    ImGui.ImDrawListAddTriangleFilled(dl, verticesBottom[1][1], verticesBottom[1][2], verticesBottom[2][1], verticesBottom[2][2], verticesBottom[3][1], verticesBottom[3][2], fillColor)
    ImGui.ImDrawListAddTriangleFilled(dl, verticesBottom[1][1], verticesBottom[1][2], verticesBottom[3][1], verticesBottom[3][2], verticesBottom[4][1], verticesBottom[4][2], fillColor)
    ImGui.ImDrawListAddTriangleFilled(dl, verticesBottom[1][1], verticesBottom[1][2], verticesBottom[4][1], verticesBottom[4][2], verticesBottom[5][1], verticesBottom[5][2], fillColor)
    ImGui.ImDrawListAddLine(dl, verticesBottom[1][1], verticesBottom[1][2], verticesBottom[2][1], verticesBottom[2][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesBottom[2][1], verticesBottom[2][2], verticesBottom[3][1], verticesBottom[3][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesBottom[3][1], verticesBottom[3][2], verticesBottom[4][1], verticesBottom[4][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesBottom[4][1], verticesBottom[4][2], verticesBottom[5][1], verticesBottom[5][2], outlineColor, 1.0)
    ImGui.ImDrawListAddLine(dl, verticesBottom[5][1], verticesBottom[5][2], verticesBottom[1][1], verticesBottom[1][2], outlineColor, 1.0)

    return changed
end

return ColorPicker
