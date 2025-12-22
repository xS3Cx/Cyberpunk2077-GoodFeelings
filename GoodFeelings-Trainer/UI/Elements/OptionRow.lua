local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local State = require("Controls/State")

local OptionRow = {}
OptionRow.optionIndex = 0

function OptionRow.Begin()
    State.optionIndex = 0
end

local function UpdateScroll(menuH)
    local L = UI.Layout
    local h = State.targetHeight or menuH or 0
    local headerHeight = (UI.Header.Height or 0) + (UI.SecondHeader.Height or 0)
    local avail = h - L.OptionPaddingY * 2 - headerHeight - (UI.Footer.Height or 0)

    State.maxVisible = math.max(1, math.floor((avail + L.ItemSpacing.y) / (L.OptionHeight + L.ItemSpacing.y)))

    local cur = (State.currentOption or 1) - 1
    State.startOpt = math.floor(cur / State.maxVisible) * State.maxVisible + 1
    State.endOpt   = State.startOpt + State.maxVisible - 1
end

---@param menuX number
---@param menuY number
---@param menuW number
---@return table pos {x:number, y:number, w:number, h:number, fontY:number, isActive:boolean}
function OptionRow.calcPosition(menuX, menuY, menuW, menuH)
    if State.optionIndex == 1 then
        UpdateScroll(menuH)
    end
    if State.optionIndex < (State.startOpt or 1) or State.optionIndex > (State.endOpt or 1) then
        return nil
    end

    local L = UI.Layout
    local rel = State.optionIndex - State.startOpt
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
function OptionRow.Draw(menuX, menuY, menuW, menuH, left, center, right, textColor, highlightColor)
    State.optionIndex = State.optionIndex + 1
    local pos = OptionRow.calcPosition(menuX, menuY, menuW, menuH) 
    if not pos then return false, nil end

    local hovered, clicked = mouseInteraction(pos)
    if clicked then State.currentOption = State.optionIndex end

    if hovered then
        DrawHelpers.RectFilled(pos.x, pos.y, pos.w, pos.h, UI.OptionRow.HoverBg, UI.OptionRow.Rounding)
    end
    if pos.isActive then
        UI.OptionRow.SmoothY = UI.OptionRow.SmoothY + (pos.y - UI.OptionRow.SmoothY) * UI.OptionRow.SmoothSpeed
        DrawHelpers.RectFilled(pos.x, UI.OptionRow.SmoothY, pos.w, pos.h,
            highlightColor or UI.OptionRow.HighlightBg, UI.OptionRow.Rounding)
    end

    local c = textColor or UI.OptionRow.Text
    local padding = UI.OptionRow.LabelOffsetX

    if left and left ~= "" then
        DrawHelpers.Text(pos.x + padding, pos.fontY, c, left)
    end
    if center and center ~= "" then
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

    return pos.isActive and (State.selectPressed or clicked), pos
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
