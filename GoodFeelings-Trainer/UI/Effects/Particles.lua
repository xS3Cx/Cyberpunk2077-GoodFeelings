local Particles = {}

-- Multi-pool system to prevent area interference
local pools = {}

-- Configuration
local config = {
    count = 15,
    radius = 3,
    speed = 0.1,
    maxDistance = 45.0,
    circleAlpha = 11
}

local function GetPool(id, width, height)
    if not pools[id] or not pools[id].initialized then
        pools[id] = {
            positions = {},
            directions = {},
            radius = {},
            initialized = true
        }
        for i = 1, config.count do
            table.insert(pools[id].positions, { x = math.random(0, width), y = math.random(0, height) })
            table.insert(pools[id].directions, { 
                x = math.random(0, 1) == 0 and -1 or 1, 
                y = math.random(0, 1) == 0 and -1 or 1 
            })
            table.insert(pools[id].radius, config.radius)
        end
    end
    return pools[id]
end

-- Move particles and handle boundary collisions (POOL-AWARE)
local function MoveParticles(pool, width, height)
    local speed = config.speed
    for i = 1, #pool.positions do
        local pos = pool.positions[i]
        local dir = pool.directions[i]
        local radius = pool.radius[i]
        
        pos.x = pos.x + dir.x * speed
        pos.y = pos.y + dir.y * speed
        
        if pos.x - radius < 0 then pos.x = radius; dir.x = math.abs(dir.x)
        elseif pos.x + radius > width then pos.x = width - radius; dir.x = -math.abs(dir.x) end
        
        if pos.y - radius < 0 then pos.y = radius; dir.y = math.abs(dir.y)
        elseif pos.y + radius > height then pos.y = height - radius; dir.y = -math.abs(dir.y) end
    end
end

-- Branded Icon Data (Normalized 25x25)
local ICON_VERTS = {
    {21.807, 12.5},   -- P1 (Center Tip)
    {1.717, 0.9},     -- P2 (Top Outer)
    {4.371, 2.533},   -- P3 (Top Inner)
    {4.371, 22.463},  -- P4 (Bottom Inner)
    {1.717, 24.096}   -- P5 (Bottom Outer)
}

-- Main render function (BRANDED NETWORK BACKGROUND)
function Particles.Render(x, y, width, height, color, mask, poolId)
    local id = poolId or "default"
    local pool = GetPool(id, width, height)
    
    MoveParticles(pool, width, height)
    local drawlist = ImGui.GetWindowDrawList()
    
    local r = math.floor(color / 65536) % 256
    local g = math.floor(color / 256) % 256
    local b = color % 256
    
    -- Icon styling
    local iconScale = 0.45
    local iconFillColor = (config.circleAlpha * 16777216) + (r * 65536) + (g * 256) + b
    local time = os.clock()
    local outlineAlpha = 120
    local outlineCol = (outlineAlpha * 16777216) + (r * 65536) + (g * 256) + b
    
    -- Draw all icons
    for i = 1, #pool.positions do
        local p1 = pool.positions[i]
        local ax, ay = x + p1.x, y + p1.y
        
        local angle = time * 0.4 + (i * 0.5)
        local cosA, sinA = math.cos(angle), math.sin(angle)
        
        -- Zero-allocation vertex rotation (Inlined for speed)
        local i1x, i1y = (ICON_VERTS[1][1]-12.5)*iconScale, (ICON_VERTS[1][2]-12.5)*iconScale
        local v1x, v1y = ax + (i1x * cosA - i1y * sinA), ay + (i1x * sinA + i1y * cosA)
        
        local i2x, i2y = (ICON_VERTS[2][1]-12.5)*iconScale, (ICON_VERTS[2][2]-12.5)*iconScale
        local v2x, v2y = ax + (i2x * cosA - i2y * sinA), ay + (i2x * sinA + i2y * cosA)
        
        local i3x, i3y = (ICON_VERTS[3][1]-12.5)*iconScale, (ICON_VERTS[3][2]-12.5)*iconScale
        local v3x, v3y = ax + (i3x * cosA - i3y * sinA), ay + (i3x * sinA + i3y * cosA)
        
        local i4x, i4y = (ICON_VERTS[4][1]-12.5)*iconScale, (ICON_VERTS[4][2]-12.5)*iconScale
        local v4x, v4y = ax + (i4x * cosA - i4y * sinA), ay + (i4x * sinA + i4y * cosA)
        
        local i5x, i5y = (ICON_VERTS[5][1]-12.5)*iconScale, (ICON_VERTS[5][2]-12.5)*iconScale
        local v5x, v5y = ax + (i5x * cosA - i5y * sinA), ay + (i5x * sinA + i5y * cosA)

        ImGui.ImDrawListAddTriangleFilled(drawlist, v1x, v1y, v2x, v2y, v3x, v3y, iconFillColor)
        ImGui.ImDrawListAddTriangleFilled(drawlist, v1x, v1y, v3x, v3y, v4x, v4y, iconFillColor)
        ImGui.ImDrawListAddTriangleFilled(drawlist, v1x, v1y, v4x, v4y, v5x, v5y, iconFillColor)
        
        ImGui.ImDrawListAddLine(drawlist, v1x, v1y, v2x, v2y, outlineCol, 1.0)
        ImGui.ImDrawListAddLine(drawlist, v2x, v2y, v3x, v3y, outlineCol, 1.0)
        ImGui.ImDrawListAddLine(drawlist, v3x, v3y, v4x, v4y, outlineCol, 1.0)
        ImGui.ImDrawListAddLine(drawlist, v4x, v4y, v5x, v5y, outlineCol, 1.0)
        ImGui.ImDrawListAddLine(drawlist, v5x, v5y, v1x, v1y, outlineCol, 1.0)
    end
end

-- Reset specific pool or all pools
function Particles.Reset(poolId)
    if poolId then
        pools[poolId] = nil
    else
        pools = {}
    end
end

return Particles
