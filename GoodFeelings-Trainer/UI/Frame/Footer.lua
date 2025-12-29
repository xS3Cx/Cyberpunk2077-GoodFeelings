local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local State = require("Controls/State")
local SubmenuManager = require("UI/Core/SubmenuManager")
local Particles = require("UI/Effects/Particles")

local Footer = {}

---@param menuX number
---@param menuY number
---@param menuW number
---@param menuH number
function Footer.Draw(menuX, menuY, menuW, menuH)
    local footer = UI.Footer
    local x = menuX
    local y = menuY + menuH - footer.Height
    local w = menuW
    local h = footer.Height

    -- Use EXACT hardcoded value from UIBackground
    DrawHelpers.RectFilled(x, y, w, h, 0xFF040404, footer.Rounding, ImDrawFlags.RoundCornersBottom)

    -- Render network particles if enabled (same as Header)
    if State.particlesNetworkEnabled and State.particlesNetworkEnabled.value then
        Particles.Render(x, y, w, h, footer.TextColor, nil, "footer")
    end

    local text = footer.Text
    local currentFontSize = ImGui.GetFontSize()
    local textWidth = ImGui.CalcTextSize(text)
    
    if footer.FontSize and footer.FontSize ~= currentFontSize then
        textWidth = textWidth * (footer.FontSize / currentFontSize)
    end

    local textX = math.floor(x + (w - textWidth) * 0.5) + 0.5
    local textY = math.floor(y + (h - footer.FontSize) * 0.5) + 0.5

    local drawlist = ImGui.GetWindowDrawList()
    ImGui.ImDrawListAddText(drawlist, footer.FontSize, textX, textY, footer.TextColor, text)

    local title = SubmenuManager.GetBreadcrumbTitle()
    if title and title ~= "" then
        State.menuCounts[title] = State.visualIndex
    end
    State.optionCount = State.visualIndex
    
    -- Custom drag handling - allow dragging window from footer
    local mouseX, mouseY = ImGui.GetMousePos()
    local isHovered = mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h
    
    if isHovered and ImGui.IsMouseClicked(0) then
        State.isDraggingWindow = true
        State.dragOffsetX = mouseX - menuX
        State.dragOffsetY = mouseY - menuY
    end
    
    if State.isDraggingWindow then
        if ImGui.IsMouseDown(0) then
            local newX = mouseX - State.dragOffsetX
            local newY = mouseY - State.dragOffsetY
            ImGui.SetWindowPos("GoodFeelings", newX, newY)
        else
            State.isDraggingWindow = false
        end
    end
end

return Footer
