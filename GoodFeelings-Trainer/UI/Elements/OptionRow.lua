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
        if clicked then State.currentOption = State.optionIndex end
    end

    if hovered and not isSeparator then
        DrawHelpers.RectFilled(pos.x, pos.y, pos.w, pos.h, UI.OptionRow.HoverBg, UI.OptionRow.Rounding)
    end
    if pos.isActive and not isSeparator then
        UI.OptionRow.SmoothY = UI.OptionRow.SmoothY + (pos.y - UI.OptionRow.SmoothY) * UI.OptionRow.SmoothSpeed
        DrawHelpers.RectFilled(pos.x, UI.OptionRow.SmoothY, pos.w, pos.h,
            highlightColor or UI.OptionRow.HighlightBg, UI.OptionRow.Rounding)
    end

    local c = textColor or UI.OptionRow.Text
    local padding = UI.OptionRow.LabelOffsetX

    if isSeparator then
        local lineY = pos.y + pos.h * 0.5
        local padding = 10 -- Or use UI.OptionRow.LabelOffsetX
        
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
            local rw = ImGui.CalcTextSize(truncated)
            local rx = pos.x + pos.w - padding - rw
            DrawHelpers.Text(rx, pos.fontY, c, truncated)
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
