local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Submenus = require("UI/Core/SubmenuManager")

local Header = {}

function Header.Draw(menuX, menuY, menuW)
    local header = UI.Header
    local x, y, w, h = menuX, menuY, menuW, header.Height

    DrawHelpers.RectFilled(x, y, w, h, header.BackgroundColor, header.Rounding, ImDrawFlags.RoundCornersTop)

    local titleText = header.Text or ""
    if titleText and titleText ~= "" then
        local currentFontSize = ImGui.GetFontSize()
        local tw, th = ImGui.CalcTextSize(titleText)
        
        local scale = 1.0
        if header.FontSize and header.FontSize ~= currentFontSize then
            scale = (header.FontSize / currentFontSize)
            tw = tw * scale
            th = th * scale
        end
        
        local titleX = math.floor(x + (w - tw) * 0.5) + 0.5
        local titleY = math.floor(y + (h - th) * 0.5) + 0.5
        
        local drawlist = ImGui.GetWindowDrawList()
        ImGui.ImDrawListAddText(drawlist, header.FontSize, titleX, titleY, header.TextColor, titleText)
    end
end

function Header.GetDebugInfo()
    return ""
end

return Header
