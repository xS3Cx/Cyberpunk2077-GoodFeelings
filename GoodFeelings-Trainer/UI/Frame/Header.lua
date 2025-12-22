local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Submenus = require("UI/Core/SubmenuManager")

local Header = {}

---@param menuX number
---@param menuY number
---@param menuW number
function Header.Draw(menuX, menuY, menuW)
    local header = UI.Header
    local x, y, w, h = menuX, menuY, menuW, header.Height

    DrawHelpers.RectFilled(x, y, w, h, header.BackgroundColor)

    local titleX = x + 10
    local titleY = y + (h - header.FontSize) * 0.5
    DrawHelpers.Text(titleX, titleY, header.TextColor, header.Text, header.FontSize)

    local breadcrumb = L(Submenus.GetBreadcrumbTitle()) or ""
    local breadcrumbWidth = ImGui.CalcTextSize(breadcrumb)
    local breadcrumbX = x + w - breadcrumbWidth - 10
    local breadcrumbY = y + h - header.FontSizeSub - 5
    DrawHelpers.Text(breadcrumbX, breadcrumbY, header.TextColor, breadcrumb, header.FontSizeSub)

    DrawHelpers.Line(x, y + h - 1, x + w, y + h - 1, header.BorderColor, 1.0)
end

return Header
