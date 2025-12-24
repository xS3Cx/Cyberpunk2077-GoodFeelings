local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Submenus = require("UI/Core/SubmenuManager")
local Particles = require("UI/Effects/Particles")
local State = require("Controls/State")

local Header = {}

function Header.Draw(menuX, menuY, menuW)
    local header = UI.Header
    local x, y, w, h = menuX, menuY, menuW, header.Height

    DrawHelpers.RectFilled(x, y, w, h, header.BackgroundColor, header.Rounding, ImDrawFlags.RoundCornersTop)

    -- Render network particles if enabled
    if State.particlesNetworkEnabled and State.particlesNetworkEnabled.value then
        Particles.Render(x, y, w, h, header.TextColor)
    end

    -- Draw pyramid icon
    local pyramidIcon = (IconGlyphs and IconGlyphs.Pyramid) or "▲"
    local currentFontSize = ImGui.GetFontSize()
    local iconTw, iconTh = ImGui.CalcTextSize(pyramidIcon)
    
    -- Scale icon if needed
    if header.FontSize and header.FontSize ~= currentFontSize then
        local iconScale = (header.FontSize / currentFontSize)
        iconTw = iconTw * iconScale
        iconTh = iconTh * iconScale
    end
    
    local iconX = math.floor(x + (w - iconTw) * 0.5) + 0.5
    local iconY = math.floor(y + (h - iconTh) * 0.5) + 0.5
    
    local drawlist = ImGui.GetWindowDrawList()
    local whiteColor = 0xFFFFFFFF -- White color
    ImGui.ImDrawListAddText(drawlist, header.FontSize, iconX, iconY, whiteColor, pyramidIcon)
end

function Header.GetDebugInfo()
    return ""
end

return Header
