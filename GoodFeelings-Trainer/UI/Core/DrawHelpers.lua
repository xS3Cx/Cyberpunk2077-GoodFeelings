DrawHelpers = {}

function DrawHelpers.RectFilled(x, y, w, h, color, rounding, flags)
    local drawlist = ImGui.GetWindowDrawList()
    local x2 = x + w
    local y2 = y + h
    if rounding and flags then
        ImGui.ImDrawListAddRectFilled(drawlist, x, y, x2, y2, color, rounding, flags)
    elseif rounding then
        ImGui.ImDrawListAddRectFilled(drawlist, x, y, x2, y2, color, rounding)
    else
        ImGui.ImDrawListAddRectFilled(drawlist, x, y, x2, y2, color)
    end
end

function DrawHelpers.Rect(x, y, w, h, color, rounding, flags, thickness)
    local drawlist = ImGui.GetWindowDrawList()
    local x2 = x + w
    local y2 = y + h
    if rounding and flags and thickness then
        ImGui.ImDrawListAddRect(drawlist, x, y, x2, y2, color, rounding, flags, thickness)
    elseif rounding and flags then
        ImGui.ImDrawListAddRect(drawlist, x, y, x2, y2, color, rounding, flags)
    elseif rounding then
        ImGui.ImDrawListAddRect(drawlist, x, y, x2, y2, color, rounding)
    else
        ImGui.ImDrawListAddRect(drawlist, x, y, x2, y2, color)
    end
end

function DrawHelpers.BeveledRectFilled(x, y, w, h, color, cutSize)
    local dl = ImGui.GetWindowDrawList()
    local x1, y1 = x, y
    local x2, y2 = x1 + w, y1 + h
    cutSize = cutSize or 10
    
    ImGui.ImDrawListAddRectFilled(dl, x1, y1, x2 - cutSize, y2, color)
    ImGui.ImDrawListAddRectFilled(dl, x2 - cutSize, y1, x2, y2 - cutSize, color)
    ImGui.ImDrawListAddTriangleFilled(dl, x2 - cutSize, y2 - cutSize, x2, y2 - cutSize, x2 - cutSize, y2, color)
end

function DrawHelpers.BeveledRect(x, y, w, h, color, cutSize, thickness)
    local x1, y1 = x, y
    local x2, y2 = x1 + w, y1 + h
    cutSize = cutSize or 10
    thickness = thickness or 1.0
    local e2 = thickness * 0.5
    local e = 0.30
    
    DrawHelpers.Line(x1 - e2, y1, x2 + e2, y1, color, thickness)
    DrawHelpers.Line(x1, y1 - e2, x1, y2 + e2, color, thickness)
    DrawHelpers.Line(x2, y1 - e2, x2, y2 - cutSize + e, color, thickness)
    DrawHelpers.Line(x2, y2 - cutSize, x2 - cutSize, y2, color, thickness)
    DrawHelpers.Line(x2 - cutSize + e, y2, x1 - e2, y2, color, thickness)
end

function DrawHelpers.Line(x1, y1, x2, y2, color, thickness)
    local drawlist = ImGui.GetWindowDrawList()
    if thickness then
        ImGui.ImDrawListAddLine(drawlist, x1, y1, x2, y2, color, thickness)
    else
        ImGui.ImDrawListAddLine(drawlist, x1, y1, x2, y2, color)
    end
end

function DrawHelpers.Text(x, y, color, text, fontSize, wrapWidth)
    local drawlist = ImGui.GetWindowDrawList()
    if fontSize and wrapWidth then
        ImGui.ImDrawListAddText(drawlist, fontSize, x, y, color, text, wrapWidth)
    elseif fontSize then
        ImGui.ImDrawListAddText(drawlist, fontSize, x, y, color, text)
    else
        ImGui.ImDrawListAddText(drawlist, x, y, color, text)
    end
end

function DrawHelpers.TextWrapped(x, y, color, text, wrapWidth)
    local drawlist = ImGui.GetWindowDrawList()
    local fontSize = ImGui.GetFontSize()
    ImGui.ImDrawListAddText(drawlist, fontSize, x, y, color, text, wrapWidth)
end
local textureCache = {}

function DrawHelpers.Image(x, y, width, height, texturePath, uvMinX, uvMinY, uvMaxX, uvMaxY, tintColor, borderColor)
    if not textureCache[texturePath] then
        local texture = nil
        if ImGui.LoadTexture then
            texture = ImGui.LoadTexture(texturePath)
        end
        if not texture then
            local normalizedPath = texturePath:gsub("\\", "/")
            if ImGui.LoadTexture then
                texture = ImGui.LoadTexture(normalizedPath)
            end
        end
        if texture then
            textureCache[texturePath] = texture
        else
            return false
        end
    end
    local texture = textureCache[texturePath]
    if not texture then
        return false
    end
    local drawlist = ImGui.GetWindowDrawList()
    uvMinX = uvMinX or 0.0
    uvMinY = uvMinY or 0.0
    uvMaxX = uvMaxX or 1.0
    uvMaxY = uvMaxY or 1.0
    tintColor = tintColor or 0xFFFFFFFF
    borderColor = borderColor or 0x00000000
    if ImGui.ImDrawListAddImage then
        ImGui.ImDrawListAddImage(drawlist, texture, x, y, x + width, y + height, uvMinX, uvMinY, uvMaxX, uvMaxY, tintColor, borderColor)
        return true
    end
    return false
end

return DrawHelpers
