local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Submenus = require("UI/Core/SubmenuManager")
local Particles = require("UI/Effects/Particles")
local State = require("Controls/State")

local Header = {}

local LOGO_W, LOGO_H = 833.594, 68.359
local LOGO_PATHS = {
    {{8.398,0},{76.758,0},{74.365,19.531},{25.537,19.531},{21.924,48.828},{51.221,48.828},{51.807,43.945},{27.393,43.945},{29.834,24.414},{73.779,24.414},{68.359,68.359},{0,68.359}},
    {{691.992,0},{760.352,0},{757.959,19.531},{709.131,19.531},{705.518,48.828},{734.814,48.828},{735.4,43.945},{710.986,43.945},{713.428,24.414},{757.373,24.414},{751.953,68.359},{683.594,68.359}},
    {{374.609,0},{442.969,0},{440.576,19.531},{391.748,19.531},{391.162,24.414},{439.99,24.414},{437.549,43.945},{388.721,43.945},{388.135,48.828},{436.963,48.828},{434.57,68.359},{366.211,68.359}},
    {{447.852,0},{516.211,0},{513.818,19.531},{464.99,19.531},{464.404,24.414},{513.232,24.414},{510.791,43.945},{461.963,43.945},{461.377,48.828},{510.205,48.828},{507.813,68.359},{439.453,68.359}},
    {{765.234,0},{833.594,0},{831.201,19.531},{782.373,19.531},{781.787,24.414},{830.615,24.414},{825.195,68.359},{756.836,68.359},{759.229,48.828},{808.057,48.828},{808.643,43.945},{759.814,43.945}},
    {{270.947,48.828},{274.561,19.531},{225.732,19.531},{228.125,0},{296.484,0},{288.086,68.359},{219.727,68.359},{225.146,24.414},{244.678,24.414},{241.65,48.828}},
    {{301.367,0},{369.727,0},{367.334,19.531},{318.506,19.531},{317.92,24.414},{366.748,24.414},{364.307,43.945},{315.479,43.945},{312.5,68.359},{292.969,68.359}},
    {{664.893,68.359},{634.18,33.35},{629.883,68.359},{610.352,68.359},{618.75,0},{632.568,0},{663.281,35.01},{667.578,0},{687.109,0},{678.711,68.359}},
    {{512.695,68.359},{521.094,0},{540.625,0},{534.619,48.828},{583.447,48.828},{581.055,68.359}},
    {{73.242,68.359},{81.641,0},{150,0},{141.602,68.359}},
    {{146.484,68.359},{154.883,0},{223.242,0},{214.844,68.359}},
    {{613.867,0},{605.469,68.359},{585.938,68.359},{594.336,0}},
    {{128.076,19.531},{98.779,19.531},{95.166,48.828},{124.463,48.828}},
    {{201.318,19.531},{172.021,19.531},{168.408,48.828},{197.705,48.828}}
}

-- Compiled segments for fast drawing
local SEGMENTS = {}
for _, path in ipairs(LOGO_PATHS) do
    for i = 1, #path do
        local p1, p2 = path[i], path[i % #path + 1]
        table.insert(SEGMENTS, {p1=p1, p2=p2, cx=(p1[1] + p2[1]) * 0.5})
    end
end

local function Blend(c1, c2, f)
    local a1, r1, g1, b1 = math.floor(c1/16777216)%256, math.floor(c1/65536)%256, math.floor(c1/256)%256, c1%256
    local a2, r2, g2, b2 = math.floor(c2/16777216)%256, math.floor(c2/65536)%256, math.floor(c2/256)%256, c2%256
    return (math.floor(a1+(a2-a1)*f)*16777216) + (math.floor(r1+(r2-r1)*f)*65536) + (math.floor(g1+(g2-g1)*f)*256) + math.floor(b1+(b2-b1)*f)
end

function Header.Draw(menuX, menuY, menuW)
    local header = UI.Header
    local x, y, w, h = menuX, menuY, menuW, header.Height

    DrawHelpers.RectFilled(x, y, w, h, header.BackgroundColor, header.Rounding, ImDrawFlags.RoundCornersTop)

    -- Layout constants
    local logoScale = (h * 0.35) / LOGO_H
    local maxWidth = w * 0.9
    if (LOGO_W * logoScale) > maxWidth then logoScale = maxWidth / LOGO_W end
    
    local logoX = x + (w - (LOGO_W * logoScale)) * 0.5
    local logoY = y + (h - (LOGO_H * logoScale)) * 0.5
    
    -- Render network particles if enabled
    if State.particlesNetworkEnabled and State.particlesNetworkEnabled.value then
        Particles.Render(x, y, w, h, header.TextColor, nil, "header")
    end

    local baseColor = UI.ColPalette.MainAccent
    local time = ImGui.GetTime()
    local shimmerWidth = 150.0 * logoScale
    local shimmerX = logoX + ((time % 3.0) / 3.0) * (LOGO_W * logoScale + shimmerWidth * 2) - shimmerWidth

    for i = 1, #SEGMENTS do
        local seg = SEGMENTS[i]
        local x1, y1 = logoX + seg.p1[1] * logoScale, logoY + seg.p1[2] * logoScale
        local x2, y2 = logoX + seg.p2[1] * logoScale, logoY + seg.p2[2] * logoScale
        
        local dist = math.abs(logoX + seg.cx * logoScale - shimmerX)
        local col, thickness = baseColor, 1.2
        
        if dist < shimmerWidth then
            local f = (1.0 - (dist / shimmerWidth)) ^ 2
            col = Blend(baseColor, 0xFFFFFFFF, f)
            thickness = 1.2 + (0.8 * f)
        end
        DrawHelpers.Line(x1, y1, x2, y2, col, thickness)
    end
end

function Header.GetDebugInfo()
    return ""
end

return Header
