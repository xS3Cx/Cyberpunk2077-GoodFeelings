local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local OptionManager = require("UI/Options/Option")

local Notification = {}
Notification.active = {}

local function resolveAutoPosition()
    local menuX, menuY = OptionManager.menuX or 0, OptionManager.menuY or 0
    local screenW, screenH = GetDisplayResolution()
    local topHalf = menuY < screenH / 2
    local leftHalf = menuX < screenW / 2

    if topHalf and leftHalf then return "TopRight"
    elseif topHalf then return "TopLeft"
    elseif leftHalf then return "BottomRight"
    else return "BottomLeft" end
end

local function push(msg, duration, position, ntype)
    table.insert(Notification.active, {
        msg = msg,
        time = os.clock(),
        duration = duration or 3.0,
        pos = (position == "Auto" or not position) and resolveAutoPosition() or position,
        type = ntype or "info"
    })
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Info(msg, duration, position)
    push(msg, duration, position, "info")
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Success(msg, duration, position)
    push(msg, duration, position, "success")
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Warning(msg, duration, position)
    push(msg, duration, position, "warning")
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Error(msg, duration, position)
    push(msg, duration, position, "error")
end

local function estimateWrappedHeight(text, maxWidth)
    local totalWidth, lines = 0, 1
    for word in text:gmatch("%S+") do
        local wordWidth = ImGui.CalcTextSize(word .. " ")
        totalWidth = totalWidth + wordWidth
        if totalWidth > maxWidth then
            lines = lines + 1
            totalWidth = wordWidth
        end
    end
    return lines * ImGui.GetTextLineHeight()
end

local function getNotificationPosition(pos, dynamicHeight, stackOffset, screenW, screenH)
    local N = UI.Notification
    local pad, width = N.Padding, N.Width
    if pos == "TopLeft" then
        return pad, pad + stackOffset
    elseif pos == "TopRight" then
        return screenW - width - pad, pad + stackOffset
    elseif pos == "TopCenter" then
        return (screenW - width) / 2, pad + stackOffset
    elseif pos == "BottomLeft" then
        return pad, screenH - pad - dynamicHeight - stackOffset
    elseif pos == "BottomRight" then
        return screenW - width - pad, screenH - pad - dynamicHeight - stackOffset
    elseif pos == "BottomCenter" then
        return (screenW - width) / 2, screenH - pad - dynamicHeight - stackOffset
    end
    return pad, pad + stackOffset
end

local function applySlideOffset(pos, x, y, elapsed, remaining)
    local N = UI.Notification
    local anim = N.AnimDuration
    local offset = 0

    if elapsed < anim then
        offset = (1 - elapsed / anim) * N.SlideDistance
    elseif remaining < anim then
        offset = (1 - remaining / anim) * N.SlideDistance
    end

    if pos:find("Right") then x = x + offset
    elseif pos:find("Left") then x = x - offset
    else y = y - offset end

    return x, y
end

local function drawNotificationWindow(i, x, y, dynamicHeight, msg, progress, ntype)
    local N = UI.Notification
    local pad, width, rounding = N.Padding, N.Width, N.Rounding

    ImGui.SetNextWindowPos(x, y)
    ImGui.SetNextWindowSize(width, dynamicHeight)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, rounding)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
    ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)

    ImGui.Begin("##Notification_" .. i,
        ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings)

    DrawHelpers.RectFilled(x, y, width, dynamicHeight, N.BackgroundColor, rounding)

    local color = N.TypeColors[ntype] or UI.Colors.Text
    local textX = x + pad
    local textY = y + pad
    local wrapWidth = width - pad * 2
    DrawHelpers.TextWrapped(textX, textY, color, msg, wrapWidth)

    local pColor = N.ProgressColors[ntype] or N.ProgressColors.Default
    ImGui.PushStyleColor(ImGuiCol.PlotHistogram, pColor)
    ImGui.SetCursorPosY(ImGui.GetWindowHeight() + (N.ProgressOffsetY or -2))
    ImGui.ProgressBar(progress, -1, N.ProgressHeight, "")
    ImGui.PopStyleColor()

    ImGui.End()
    ImGui.PopStyleColor()
    ImGui.PopStyleVar(2)
end

function Notification.Render()
    local N = UI.Notification
    local now = os.clock()
    local screenW, screenH = GetDisplayResolution()
    local positionStacks = {}

    for i = #Notification.active, 1, -1 do
        local n = Notification.active[i]
        local elapsed = now - n.time
        local remaining = n.duration - elapsed

        if remaining <= 0 then
            table.remove(Notification.active, i)
        else
            local progress = math.max(0, remaining / n.duration)
            local pos = n.pos or "TopLeft"
            local stackOffset = positionStacks[pos] or 0

            local textHeight = estimateWrappedHeight(n.msg, N.Width - N.Padding * 2)
            local dynamicHeight = textHeight + N.Padding * 2 + (N.ProgressHeight or 4) + 4

            local x, y = getNotificationPosition(pos, dynamicHeight, stackOffset, screenW, screenH)
            x, y = applySlideOffset(pos, x, y, elapsed, remaining)

            drawNotificationWindow(i, x, y, dynamicHeight, n.msg, progress, n.type)

            positionStacks[pos] = stackOffset + dynamicHeight + N.Spacing
        end
    end
end

return Notification
