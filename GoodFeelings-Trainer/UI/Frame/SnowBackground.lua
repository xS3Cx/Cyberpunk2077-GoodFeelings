local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")

local SnowBackground = {
    flakes = {},
    pileHeight = {},
    pileColor = {},
    lastTime = os.clock(),
    lastMenuPos = { x = 0, y = 0 },

    spawnTimer = 0,

    snowman = { enabled = true, built = false, x = 0, y = 0 },
    twinklePhase = 0,

    resetRequested = false
}

local function initPiles(cfg)
    SnowBackground.pileHeight = {}
    SnowBackground.pileColor = {}
    for i = 1, cfg.PileColumns do
        SnowBackground.pileHeight[i] = math.random() * 3
        SnowBackground.pileColor[i] = cfg.SnowColor
    end
end

function SnowBackground.Init()
    local cfg = UI.Background

    SnowBackground.flakes = {}
    SnowBackground.spawnTimer = 0
    SnowBackground.lastTime = os.clock()
    SnowBackground.lastMenuPos = { x = 0, y = 0 }

    SnowBackground.snowman.enabled = cfg.SnowmanEnabled
    SnowBackground.snowman.built = false

    initPiles(cfg)
end

function SnowBackground.Reset()
    SnowBackground.resetRequested = false
    SnowBackground.Init()
end

local function randomFlakeColor(cfg)
    if cfg.PeeSnowEnabled and math.random() < cfg.YellowSnowChance then
        return cfg.PeeColor
    end
    return cfg.SnowColor
end

local function spawnFlake(menuX, menuW, cfg)
    return {
        x = menuX + math.random() * menuW,
        y = 5,
        vy = math.random() * 10,
        r = cfg.SnowflakeSizeMin + math.random() * cfg.SnowflakeSize,
        phase = math.random() * math.pi * 2,
        color = randomFlakeColor(cfg)
    }
end

local function updateSnow(dt, menuX, menuY, menuW, menuH, footerH)
    local cfg = UI.Background
    local flakes = SnowBackground.flakes
    local pileHeight = SnowBackground.pileHeight
    local pileColor = SnowBackground.pileColor

    local lp = SnowBackground.lastMenuPos
    local dx, dy = menuX - lp.x, menuY - lp.y
    lp.x, lp.y = menuX, menuY

    if #pileHeight == 0 then
        initPiles(cfg)
    end

    if cfg.SnowEnabled then
        SnowBackground.spawnTimer = SnowBackground.spawnTimer + dt
        if SnowBackground.spawnTimer >= cfg.SpawnRate then
            SnowBackground.spawnTimer = 0
            for _ = 1, cfg.SnowDensity do
                flakes[#flakes + 1] = spawnFlake(menuX, menuW, cfg)
            end
        end
    end

    local left = menuX + 5
    local right = menuX + menuW - 5
    local bottom = menuY + menuH - footerH - 3
    local maxHeight = cfg.PileLayers * 6.0
    local cw = (right - left) / cfg.PileColumns

    for i = #flakes, 1, -1 do
        local f = flakes[i]
        f.x = f.x - dx
        f.y = f.y - dy
        f.vy = f.vy + cfg.Gravity * dt * 0.25
        f.x = f.x + math.sin((os.clock() + f.phase) * cfg.WindSway) * 8 * dt
        f.y = f.y + f.vy * dt

        if f.x < left + f.r then f.x = left + f.r end
        if f.x > right - f.r then f.x = right - f.r end

        local col = math.max(1, math.min(cfg.PileColumns, math.floor((f.x - left) / cw)))
        local pileY = bottom - pileHeight[col]

        if f.y >= pileY - f.r then
            if cfg.SnowPileEnabled and pileHeight[col] < maxHeight then
                for n = -2, 2 do
                    local ni = col + n
                    if ni >= 1 and ni <= cfg.PileColumns then
                        local falloff = 1.0 - math.abs(n) * 0.25
                        pileHeight[ni] = math.min(maxHeight, pileHeight[ni] + f.r * falloff)
                        if math.random() < cfg.YellowSnowChance then
                            pileColor[ni] = cfg.PeeColor
                        end
                    end
                end
            end
            table.remove(flakes, i)
        end
    end

    for i = 2, cfg.PileColumns - 1 do
        local avg = (pileHeight[i - 1] + pileHeight[i] + pileHeight[i + 1]) / 3
        pileHeight[i] = pileHeight[i] + (avg - pileHeight[i]) * 0.05 + (math.random() - 0.5) * 0.15
        if pileHeight[i] < 0 then pileHeight[i] = 0 end
    end

    local s = SnowBackground.snowman
    if cfg.SnowPileEnabled and s.enabled then
        local avgH = 0
        for _, h in ipairs(pileHeight) do avgH = avgH + h end
        avgH = avgH / #pileHeight

        if not s.built and avgH >= maxHeight * 0.65 then
            s.built = true
            s.x = menuX + menuW * 0.5
            s.y = bottom - avgH - 10
        elseif s.built and avgH < maxHeight * 0.4 then
            s.built = false
        end
    end
end

local function drawLights(drawlist, x, y, w)
    local cfg = UI.Background
    if not cfg.LightsEnabled then return end

    local spacing = cfg.LightSpacing
    local radius = cfg.LightRadius
    local count = math.floor(w / spacing)

    SnowBackground.twinklePhase = SnowBackground.twinklePhase + 0.02
    local t = os.clock() * cfg.LightSpeed

    local colors = {
        cfg.LightColor1,
        cfg.LightColor2,
        cfg.LightColor3,
        cfg.LightColor4,
        cfg.LightColor5
    }

    for i = 1, count do
        local cx = x + i * spacing
        local cy = y + 18 + math.sin(t * 1.5 + i * 0.8) * 4

        local base = colors[((i - 1) % #colors) + 1]

        local tw = cfg.TwinkleEnabled
            and (0.75 + 0.25 * math.sin(SnowBackground.twinklePhase * 2 + i * 0.6))
            or 1

        local a = math.floor((180 + 75 * tw) * cfg.LightBrightness)
        ImGui.ImDrawListAddCircleFilled(
            drawlist,
            cx,
            cy,
            radius * (0.9 + tw * 0.2),
            a * 0x1000000 + (base % 0x1000000)
        )
    end
end


function SnowBackground.Render(menuX, menuY, menuW, menuH)
    local cfg = UI.Background
    if not cfg.MasterEnabled then return end

    if SnowBackground.resetRequested then
        SnowBackground.Reset()
    end

    local now = os.clock()
    local dt = now - SnowBackground.lastTime
    SnowBackground.lastTime = now

    updateSnow(dt, menuX, menuY, menuW, menuH, UI.Footer.Height)

    local drawlist = ImGui.GetWindowDrawList()
    local left = menuX + 5
    local right = menuX + menuW - 5
    local bottom = menuY + menuH - UI.Footer.Height - 3  -- Use Footer.Height instead of hardcoded 30
    local cw = (right - left) / cfg.PileColumns
    local clock = os.clock()

    if cfg.SnowPileEnabled then
        for i = 1, cfg.PileColumns - 1 do
            local x1 = left + (i - 0.5) * cw
            local x2 = left + (i + 0.5) * cw
            local h = SnowBackground.pileHeight[i]
            local bump = math.sin(i * 0.35 + clock * 0.5) * 0.6
            local color = 0xFF000000 + (SnowBackground.pileColor[i] % 0x1000000)
            ImGui.ImDrawListAddRectFilled(drawlist, x1, bottom - h - bump, x2, bottom, color)
        end
    end

    for _, f in ipairs(SnowBackground.flakes) do
        local flicker = cfg.SnowTwinkle and (0.8 + 0.2 * math.sin(clock * 4 + f.x)) or 1
        local a = math.floor(190 * flicker * cfg.SnowBrightness)
        ImGui.ImDrawListAddCircleFilled(drawlist, f.x, f.y, f.r, a * 0x1000000 + (f.color % 0x1000000))
    end

    local s = SnowBackground.snowman
    if s.enabled and s.built and cfg.SnowPileEnabled then
        local c = cfg.SnowColor
        ImGui.ImDrawListAddCircleFilled(drawlist, s.x, s.y, 8, c)
        ImGui.ImDrawListAddCircleFilled(drawlist, s.x, s.y - 10, 6, c)
        ImGui.ImDrawListAddCircleFilled(drawlist, s.x, s.y - 18, 4, c)
        ImGui.ImDrawListAddRectFilled(drawlist, s.x - 5, s.y - 27, s.x + 5, s.y - 23, 0xFF000000)
        ImGui.ImDrawListAddRectFilled(drawlist, s.x - 7, s.y - 23, s.x + 7, s.y - 22, 0xFF000000)
        ImGui.ImDrawListAddTriangleFilled(drawlist, s.x, s.y - 18, s.x + 5, s.y - 17, s.x, s.y - 16, UI.ColPalette.SoftRed)
        ImGui.ImDrawListAddCircleFilled(drawlist, s.x - 2, s.y - 11, 0.7, 0xFF000000)
        ImGui.ImDrawListAddCircleFilled(drawlist, s.x + 2, s.y - 11, 0.7, 0xFF000000)
    end

    drawLights(drawlist, menuX + 10, menuY + UI.Header.Height - 10, menuW - 20)
end

return SnowBackground
