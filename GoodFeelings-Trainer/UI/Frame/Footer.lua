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

    DrawHelpers.RectFilled(x, y, w, h, footer.BackgroundColor, footer.Rounding, ImDrawFlags.RoundCornersBottom)

    -- Render network particles if enabled
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
end

return Footer
