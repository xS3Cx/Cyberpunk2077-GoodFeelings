local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local State = require("Controls/State")

local Scrollbar = {}

---@param menuX number
---@param menuY number
---@param menuW number
---@param menuH number
function Scrollbar.Render(menuX, menuY, menuW, menuH)
    -- Get option count
    local SubmenuManager = require("UI/Core/SubmenuManager")
    local currentTitle = SubmenuManager.GetBreadcrumbTitle()
    local total = State.menuCounts and State.menuCounts[currentTitle] or State.optionCount or 0
    local visible = State.maxVisible or 16
    local start = State.startOpt or 1

    -- Always render - let visual size show if scrolling is active
    -- Check if scrolling is actually needed
    if total <= visible or total == 0 then
        return
    end

    -- Calculate dimensions
    local scale = UI.Layout.Scale or 1.0
    local width = 8.0 * scale -- Wider track
    local thumbW = 4.0 * scale -- Thinner thumb
    
    local headerH = (UI.Header.Height or 65) + (UI.SecondHeader.Height or 30)
    local footerH = (UI.Footer.Height or 35)
    local paddingY = (UI.Layout.OptionPaddingY or 0)
    
    local scrollH = menuH - headerH - footerH - (paddingY * 2)
    local scrollY = menuY + headerH + paddingY
    local gap = 6.0 * scale -- Larger gap from menu
    local scrollX = menuX - width - gap

    -- Create overlay window (like InfoBox does)
    ImGui.SetNextWindowPos(scrollX, scrollY)
    ImGui.SetNextWindowSize(width, scrollH)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 0.0)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
    ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.Colors.Transparent)

    ImGui.Begin("##ScrollbarWindow", ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings)

    local winX, winY = ImGui.GetWindowPos()
    
    local winX, winY = ImGui.GetWindowPos()
    
    -- Draw track (slightly more transparent than main menu)
    local trackColor = 0xB3000000
    local rounding = UI.Layout.FrameRounding or 4.0
    DrawHelpers.RectFilled(winX, winY, width, scrollH, trackColor, rounding)
    
    -- Draw thumb with padding so it doesn't touch edges
    local thumbPadding = 2.0
    local thumbColor = UI.Footer.TextColor
    local thumbH = math.max(20.0, scrollH * (visible / total))
    
    local maxScroll = total - visible
    local currentScroll = math.min(maxScroll, math.max(0, start - 1))
    local fraction = maxScroll > 0 and (currentScroll / maxScroll) or 0
    
    -- Apply padding to thumb position and height
    -- Logic: Move from 'padding' top to 'padding' bottom
    -- Range = scrollH - thumbH
    local thumbY = winY + thumbPadding + ((scrollH - thumbH) * fraction)
    local thumbHPadded = thumbH - thumbPadding * 2
    local thumbX = winX + (width - thumbW) * 0.5 -- Center thumb in track
    
    DrawHelpers.RectFilled(thumbX, thumbY, thumbW, thumbHPadded, thumbColor, rounding)

    ImGui.End()
    ImGui.PopStyleColor(2)
    ImGui.PopStyleVar(2)
end

return Scrollbar
