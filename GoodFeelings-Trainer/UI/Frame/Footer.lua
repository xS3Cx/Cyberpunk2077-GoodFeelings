local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local State = require("Controls/State")

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

    DrawHelpers.RectFilled(x, y, w, h, footer.BackgroundColor)

    local current = State.currentOption or 1
    local total   = State.optionIndex or 1
    local visible = State.maxVisible or 1

    local currentPage = math.floor((current - 1) / visible) + 1
    local totalPages  = math.floor((total + visible - 1) / visible)

    local leftText = footer.Text
    if State.mouseEnabled then
        leftText = leftText .. " | Cursor Enabled"
    end

    local rightText = string.format("Opt: %d | Pg: %d/%d", current, currentPage, totalPages)

    DrawHelpers.Line(x, y, x + w, y, footer.BorderColor, 1.0)

    local leftX  = x + 10
    local rightX = x + w - ImGui.CalcTextSize(rightText) + 15
    local textY  = y + (h - footer.FontSize) * 0.5

    DrawHelpers.Text(leftX,  textY, footer.TextColor, leftText,  footer.FontSize)
    DrawHelpers.Text(rightX, textY, footer.TextColor, rightText, footer.FontSize)
end

return Footer
