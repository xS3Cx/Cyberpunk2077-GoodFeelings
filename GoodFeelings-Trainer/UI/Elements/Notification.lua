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
    -- Add GoodFeelings prefix
    local prefixedMsg = "GoodFeelings " .. msg
    
    table.insert(Notification.active, {
        msg = prefixedMsg,
        time = os.clock(),
        duration = duration or 3.0,
        pos = position or "TopCenter", -- Default to TopCenter instead of Auto
        type = ntype or "info"
    })
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Info(msg, duration, position)
    push(msg, duration, position or "TopCenter", "info")
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Success(msg, duration, position)
    push(msg, duration, position or "TopCenter", "success")
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Warning(msg, duration, position)
    push(msg, duration, position or "TopCenter", "warning")
end

---@param msg string
---@param duration? number Seconds to display (default 3)
---@param position? string "TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter, Auto"
function Notification.Error(msg, duration, position)
    push(msg, duration, position or "TopCenter", "error")
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

local function getNotificationPosition(pos, dynamicHeight, stackOffset, screenW, screenH, width)
    local N = UI.Notification
    local pad = N.Padding
    if pos == "TopLeft" then
        return pad, pad + stackOffset
    elseif pos == "TopRight" then
        return screenW - width - pad, pad + stackOffset
    elseif pos == "TopCenter" then
        return (screenW - width) / 2, 10 + stackOffset -- Same as overlay (10px from top)
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
    local rounding = 3.0 -- Same as overlay
    local scale = UI.Base.Layout.Scale or 1.0
    local padX = 8

    -- Split message into "GoodFeelings" and rest
    local prefix = "GoodFeelings "
    local rest = msg:sub(#prefix + 1) or ""
    
    -- Calculate text sizes (like overlay)
    local baseFontSize = ImGui.GetFontSize() or 18
    local scaledFontSize = baseFontSize * scale
    local textW, textH = ImGui.CalcTextSize(prefix .. rest)
    local actualTextW = textW * scale
    local actualTextH = textH * scale
    
    -- Dynamic width based on text (like overlay)
    local width = actualTextW + (padX * 2 * scale)

    ImGui.SetNextWindowPos(x, y)
    ImGui.SetNextWindowSize(width, dynamicHeight)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, rounding)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, { 0, 0 })
    ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.Colors.Transparent)

    ImGui.Begin("##Notification_" .. i,
        ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings)

    local winX, winY = ImGui.GetWindowPos()
    DrawHelpers.RectFilled(winX, winY, width, dynamicHeight, N.BackgroundColor, rounding)
    
    -- Center text in box (exactly like overlay does)
    local currentX = winX + (width - actualTextW) / 2
    local centerY = winY + (dynamicHeight - actualTextH) / 2
    
    -- Draw "GoodFeelings" in blue
    DrawHelpers.Text(currentX, centerY, UI.Base.Header.TextColor, prefix, scaledFontSize)
    
    -- Draw rest in white
    local prefixWidth = ImGui.CalcTextSize(prefix) * scale
    DrawHelpers.Text(currentX + prefixWidth, centerY, 0xFFFFFFFF, rest, scaledFontSize)

    ImGui.End()
    ImGui.PopStyleColor(2)
    ImGui.PopStyleVar(3)
end

function Notification.Render()
    local N = UI.Notification
    local now = os.clock()
    local screenW, screenH = GetDisplayResolution()
    local positionStacks = {}
    local scale = UI.Base.Layout.Scale or 1.0
    local padX = 8

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

            -- Fixed height matching overlay (20 * scale)
            local dynamicHeight = 20 * scale
            
            -- Calculate dynamic width based on text
            local textW = ImGui.CalcTextSize(n.msg)
            local actualTextW = textW * scale
            local width = actualTextW + (padX * 2 * scale)

            local x, y = getNotificationPosition(pos, dynamicHeight, stackOffset, screenW, screenH, width)
            x, y = applySlideOffset(pos, x, y, elapsed, remaining)

            drawNotificationWindow(i, x, y, dynamicHeight, n.msg, progress, n.type)

            positionStacks[pos] = stackOffset + dynamicHeight + N.Spacing
        end
    end
end

return Notification
