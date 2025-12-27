local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local State = require("Controls/State")
local BindManager = require("Features/BindManager")

local OptionRow = {}
OptionRow.optionIndex = 0

function OptionRow.Begin()
    State.optionIndex = 0
    State.visualIndex = 0
    State.separatorCount = 0
    State.tipSetByHover = false
end

local function UpdateScroll(menuH)
    local L = UI.Layout
    local h = State.targetHeight or menuH or 0
    local headerHeight = (UI.Header.Height or 0) + (UI.SecondHeader.Height or 0)
    local avail = h - L.OptionPaddingY * 2 - headerHeight - (UI.Footer.Height or 0)

    local maxLimit = L.MaxVisibleOptions or 16
    local bias = (L.OptionHeight * 0.5)
    State.maxVisible = math.min(maxLimit, math.max(1, math.floor((avail + L.ItemSpacing.y + bias) / (L.OptionHeight + L.ItemSpacing.y))))

    -- Scroll Logic Fix for Separators (Sliding Window):
    -- Instead of pages, we just ensure the selected visual index is within the visible range.
    
    local targetVisual = State.lastVisualSelection or (State.currentOption or 1)
    
    -- Initialize if nil
    if not State.startOpt then State.startOpt = 1 end

    -- Slide window down if target is above visible range
    if targetVisual > (State.startOpt + State.maxVisible - 1) then
        State.startOpt = targetVisual - State.maxVisible + 1
    end
    
    -- Slide window up if target is below visible range
    if targetVisual < State.startOpt then
        State.startOpt = targetVisual
    end
    
    State.endOpt = State.startOpt + State.maxVisible - 1
end

---@param menuX number
---@param menuY number
---@param menuW number
---@return table pos {x:number, y:number, w:number, h:number, fontY:number, isActive:boolean}
local function DrawBrandedArrow(dl, x0, y0, size, strokeColor, direction)
    local fillColor = UI.OptionRow.HighlightBg or 0x44000000
    local s = size / 25.0
    
    local p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y, p5x, p5y
    
    if direction == "down" then
        -- Properly Rotated 90 degrees clockwise for "Down"
        local cx, cy = x0 + 12.5 * s, y0 + 12.5 * s
        local function rot(px, py)
            local rx, ry = px - 12.5, py - 12.5
            return cx - ry * s, cy + rx * s
        end
        p1x, p1y = rot(21.807, 12.5)
        p2x, p2y = rot(1.717, 0.9)
        p3x, p3y = rot(4.371, 2.533)
        p4x, p4y = rot(4.371, 22.463)
        p5x, p5y = rot(1.717, 24.096)
    else
        -- Default: Right-pointing
        p1x, p1y = x0 + 21.807 * s, y0 + 12.5 * s
        p2x, p2y = x0 + 1.717 * s, y0 + 0.9 * s
        p3x, p3y = x0 + 4.371 * s, y0 + 2.533 * s
        p4x, p4y = x0 + 4.371 * s, y0 + 22.463 * s
        p5x, p5y = x0 + 1.717 * s, y0 + 24.096 * s
    end
    
    ImGui.ImDrawListAddTriangleFilled(dl, p1x, p1y, p2x, p2y, p3x, p3y, fillColor)
    ImGui.ImDrawListAddTriangleFilled(dl, p1x, p1y, p3x, p3y, p4x, p4y, fillColor)
    ImGui.ImDrawListAddTriangleFilled(dl, p1x, p1y, p4x, p4y, p5x, p5y, fillColor)
    
    local thickness = 2.0
    ImGui.ImDrawListAddLine(dl, p1x, p1y, p2x, p2y, strokeColor, thickness)
    ImGui.ImDrawListAddLine(dl, p2x, p2y, p3x, p3y, strokeColor, thickness)
    ImGui.ImDrawListAddLine(dl, p3x, p3y, p4x, p4y, strokeColor, thickness)
    ImGui.ImDrawListAddLine(dl, p4x, p4y, p5x, p5y, strokeColor, thickness)
    ImGui.ImDrawListAddLine(dl, p5x, p5y, p1x, p1y, strokeColor, thickness)
end

function OptionRow.calcPosition(menuX, menuY, menuW, menuH)
    if State.visualIndex == 1 then
        UpdateScroll(menuH)
    end
    if State.visualIndex < (State.startOpt or 1) or State.visualIndex > (State.endOpt or 1) then
        return nil
    end

    local L = UI.Layout
    local rel = State.visualIndex - State.startOpt
    local headerHeight = (UI.Header.Height or 0) + (UI.SecondHeader.Height or 0)

    local x = menuX + L.OptionPaddingX
    local y = menuY + L.OptionPaddingY + headerHeight + rel * (L.OptionHeight + L.ItemSpacing.y)
    local w = menuW - L.OptionPaddingX * 2
    local h = L.OptionHeight
    local fontY = y + (h - ImGui.GetFontSize()) * 0.5
    local isActive = (State.optionIndex == State.currentOption)

    return { x = x, y = y, w = w, h = h, fontY = fontY, isActive = isActive }
end


---@return boolean hovered, boolean clicked
local function mouseInteraction(pos)
    if not (State.overlayOpen or State.mouseEnabled) then
        return false, false
    end

    local mx, my = ImGui.GetMousePos()
    local hovered = mx >= pos.x and mx <= pos.x + pos.w and my >= pos.y and my <= pos.y + pos.h
    return hovered, hovered and ImGui.IsMouseClicked(0)
end

local function TruncateTextToFit(text, maxWidth) -- I don't see myself using this anywhere else to be fair you shall be local
    if not text or text == "" then return "" end
    local width = ImGui.CalcTextSize(text)
    if width <= maxWidth then
        return text
    end
    local dots = "..."
    local dotsW = ImGui.CalcTextSize(dots)
    for i = #text, 1, -1 do
        local sub = text:sub(1, i)
        local w = ImGui.CalcTextSize(sub)
        if w + dotsW <= maxWidth then
            return sub .. dots
        end
    end
    return dots
end

---@param menuX number
---@param menuY number
---@param menuW number
---@param left string|nil
---@param center string|nil
---@param right string|nil
---@param textColor integer|nil Override text color
---@param highlightColor integer|nil Override highlight color
---@return boolean clicked
function OptionRow.Draw(menuX, menuY, menuW, menuH, left, center, right, textColor, highlightColor, isSeparator)
    State.visualIndex = State.visualIndex + 1
    State.optionIndex = State.optionIndex + 1

    if isSeparator then
        -- Auto-skip separators during navigation
        if State.optionIndex == State.currentOption then
             if State.upPressed then
                 State.currentOption = State.optionIndex - 1
             else
                 State.currentOption = State.optionIndex + 1
             end
        end
    else
        if State.optionIndex == State.currentOption then
            State.lastVisualSelection = State.visualIndex
        end
    end

    local pos = OptionRow.calcPosition(menuX, menuY, menuW, menuH) 
    if not pos then return false, nil end

    local hovered, clicked = false, false
    if not isSeparator then
        hovered, clicked = mouseInteraction(pos)
        pos.hovered = hovered
        if clicked then State.currentOption = State.optionIndex end
    end

    if pos.isActive and not isSeparator then
        UI.OptionRow.SmoothY = UI.OptionRow.SmoothY + (pos.y - UI.OptionRow.SmoothY) * UI.OptionRow.SmoothSpeed
        
        local color = highlightColor or UI.OptionRow.HighlightBg
        local borderColor = UI.ColPalette.MainAccent
        local scale = UI.Base.Layout.Scale or 1.0
        local cutSize = 10 * scale
        local y1 = UI.OptionRow.SmoothY
        
        DrawHelpers.BeveledRectFilled(pos.x, y1, pos.w, pos.h, color, cutSize)
        DrawHelpers.BeveledRect(pos.x, y1, pos.w, pos.h, borderColor, cutSize, 3.0)
    end

    local c = textColor or (hovered and UI.ColPalette.MainAccent or UI.OptionRow.Text)
    local padding = UI.OptionRow.LabelOffsetX

    if isSeparator then
        local lineY = pos.y + pos.h * 0.5
        local padding = 5 -- Default padding for categories (separators)
        
        local text = left
        if not text or text == "" then text = center end
        
        if text and text ~= "" then
            local tw = ImGui.CalcTextSize(text)
            local cx = pos.x + (pos.w - tw) * 0.5
            local lineGap = 10
            
            -- Draw text centered
            DrawHelpers.Text(cx, pos.fontY, c, text)
            
            -- Draw lines on both sides
            local lineX1_start = pos.x + padding
            local lineX1_end = cx - lineGap
            if lineX1_end > lineX1_start then
                DrawHelpers.Line(lineX1_start, lineY, lineX1_end, lineY, c, 1.0)
            end
            
            local lineX2_start = cx + tw + lineGap
            local lineX2_end = pos.x + pos.w - padding
            if lineX2_end > lineX2_start then
                DrawHelpers.Line(lineX2_start, lineY, lineX2_end, lineY, c, 1.0)
            end
        end
    else
        if left and left ~= "" then
            -- Attempt to detect icon at the start (UTF-8 character > 127 usually start with 0xEF for icons in these fonts)
            local firstByte = string.byte(left, 1) or 0
            if firstByte >= 0xE0 then -- Heuristic for icon fonts (PUA range)
                -- Find first space to separate icon from text
                local spacePos = left:find(" ")
                if spacePos then
                    local icon = left:sub(1, spacePos - 1)
                    local rest = left:sub(spacePos + 1)
                    
                    local iconW = ImGui.CalcTextSize(icon)
                    local offset = UI.Layout.IconOffsetY or 1.0
                    
                    DrawHelpers.Text(pos.x + padding, pos.fontY + offset, c, icon)
                    DrawHelpers.Text(pos.x + padding + iconW + 4, pos.fontY, c, rest)
                else
                    DrawHelpers.Text(pos.x + padding, pos.fontY, c, left)
                end
            else
                DrawHelpers.Text(pos.x + padding, pos.fontY, c, left)
            end
        end
        if (not center or center == "") and not isSeparator then
            local statusText, statusCol = BindManager.GetStatus(left)
            if statusText then
                local tw = ImGui.CalcTextSize(statusText)
                local cx = pos.x + (pos.w - tw) * 0.5
                DrawHelpers.Text(cx, pos.fontY, statusCol, statusText)
            end
        elseif center and center ~= "" then
            local tw = ImGui.CalcTextSize(center)
            local cx = pos.x + (pos.w - tw) * 0.5
            DrawHelpers.Text(cx, pos.fontY, c, center)
        end
        if right and right ~= "" then
            local gap = UI.Layout.ItemSpacing.x or 6
            local avail = pos.w - padding * 2 - ImGui.CalcTextSize(left or "")
            local truncated = TruncateTextToFit(right, avail - gap)
            
            -- Try to find last space to separate text from potential icon
            local lastSpace = truncated:match("^.*()" .. " ")
            
            if lastSpace and lastSpace > 1 then
                -- Split on last space - assume format is "text icon"
                local textPart = truncated:sub(1, lastSpace - 1)
                local iconPart = truncated:sub(lastSpace + 1)
                
                local textW = ImGui.CalcTextSize(textPart)
                local totalW = ImGui.CalcTextSize(truncated)
                local rx = pos.x + pos.w - padding - totalW
                local offset = UI.Layout.IconOffsetY or 1.0
                local extraDown = 1.0 -- Extra adjustment for right-side icons
                
                -- Render text without offset
                DrawHelpers.Text(rx, pos.fontY, c, textPart)
                
                -- Detect if iconPart should be a branded SVG arrow
                local iconByte = string.byte(iconPart, 1) or 0
                local shouldBeSVG = (iconByte >= 0xE0) or (iconPart == ">") or (iconPart == "v")
                
                if shouldBeSVG then
                    local arrowSize = 14
                    local arrowX = rx + textW + 4
                    local arrowY = pos.fontY + (ImGui.GetFontSize() - arrowSize) / 2 + 2
                    
                    -- Improved direction detection
                    local isDown = (iconPart == "v") or (UI.Dropdown and iconPart == UI.Dropdown.ArrowDown)
                    local dir = isDown and "down" or "right"
                    
                    DrawBrandedArrow(ImGui.GetWindowDrawList(), arrowX, arrowY, arrowSize, UI.ColPalette.MainAccent, dir)
                else
                    DrawHelpers.Text(rx + textW + 4, pos.fontY + offset + extraDown, UI.ColPalette.MainAccent, iconPart)
                end
            else
                -- No space found - could be standalone icon (submenu arrow)
                local rw = ImGui.CalcTextSize(truncated)
                local rx = pos.x + pos.w - padding - rw
                
                -- Detect if truncated (standalone) should be a branded SVG arrow
                local firstByte = string.byte(truncated, 1) or 0
                local shouldBeSVG = (firstByte >= 0xE0) or (truncated == ">") or (truncated == "v")
                
                if shouldBeSVG then
                    local arrowSize = 14
                    local arrowX = pos.x + pos.w - padding - arrowSize - 2
                    local arrowY = pos.fontY + (ImGui.GetFontSize() - arrowSize) / 2 + 2
                    
                    local isDown = (truncated == "v") or (UI.Dropdown and truncated == UI.Dropdown.ArrowDown)
                    local dir = isDown and "down" or "right"
                    
                    DrawBrandedArrow(ImGui.GetWindowDrawList(), arrowX, arrowY, arrowSize, UI.ColPalette.MainAccent, dir)
                else
                    -- Regular text, no offset
                    DrawHelpers.Text(rx, pos.fontY, c, truncated)
                end
            end
        end
    end

    return not isSeparator and pos.isActive and (State.selectPressed or clicked), pos
end


function OptionRow.IsSelected()
    return State.optionIndex == State.currentOption
end

---@param menuX number
---@param menuY number
---@param menuW number
---@return boolean
function OptionRow.IsHovered(menuX, menuY, menuW, menuH)
    if not (State.overlayOpen or State.mouseEnabled) then return false end
    local pos = OptionRow.calcPosition(menuX, menuY, menuW, menuH)
    if not pos then return false end
    local mx, my = ImGui.GetMousePos()
    return mx >= pos.x and mx <= pos.x + pos.w and my >= pos.y and my <= pos.y + pos.h
end

return OptionRow
