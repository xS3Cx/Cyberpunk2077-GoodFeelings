local Particles = {}

-- Particle system state
local particles = {
    positions = {},
    directions = {},
    radius = {},
    initialized = false
}

-- Configuration
local config = {
    count = 15, -- Number of particles (reduced from 1000 for performance)
    radius = 3,
    speed = 0.1,
    maxDistance = 45.0, -- Max distance for line connections
    lineAlpha = 100,
    circleAlpha = 11
}

-- Initialize particles with random positions and directions
function Particles.Setup(width, height)
    if particles.initialized then return end
    
    particles.positions = {}
    particles.directions = {}
    particles.radius = {}
    
    for i = 1, config.count do
        -- Random position within bounds
        table.insert(particles.positions, {
            x = math.random(0, width),
            y = math.random(0, height)
        })
        
        -- Random direction (-1 or 1 for x and y)
        table.insert(particles.directions, {
            x = math.random(0, 1) == 0 and -1 or 1,
            y = math.random(0, 1) == 0 and -1 or 1
        })
        
        table.insert(particles.radius, config.radius)
    end
    
    particles.initialized = true
end

-- Move particles and handle boundary collisions
local function MoveParticles(width, height)
    for i = 1, #particles.positions do
        local pos = particles.positions[i]
        local dir = particles.directions[i]
        local radius = particles.radius[i]
        
        -- Update position
        pos.x = pos.x + dir.x * config.speed
        pos.y = pos.y + dir.y * config.speed
        
        -- Bounce off edges
        if pos.x - radius < 0 or pos.x + radius > width then
            dir.x = -dir.x
            dir.y = math.random(0, 1) == 0 and -1 or 1
        end
        
        if pos.y - radius < 0 or pos.y + radius > height then
            dir.y = -dir.y
            dir.x = math.random(0, 1) == 0 and -1 or 1
        end
    end
end

-- Draw a single particle circle
local function DrawCircle(drawlist, pos, radius, color)
    -- Extract color components
    local a = math.floor(color / 16777216) % 256
    local r = math.floor(color / 65536) % 256
    local g = math.floor(color / 256) % 256
    local b = color % 256
    
    -- Draw filled circle using config alpha
    local circleColor = (config.circleAlpha * 16777216) + (r * 65536) + (g * 256) + b
    ImGui.ImDrawListAddCircleFilled(drawlist, pos.x, pos.y, radius - 1, circleColor)
end

-- Draw line between two particles
local function DrawLine(drawlist, pos1, pos2, color, radius)
    local dx = pos2.x - pos1.x
    local dy = pos2.y - pos1.y
    local distance = math.sqrt(dx * dx + dy * dy)
    
    -- Calculate alpha based on distance
    local alpha
    if distance <= 20.0 then
        alpha = 255.0
    else
        alpha = (1.0 - ((distance - 20.0) / 25.0)) * 255.0
    end
    
    if alpha < 0 then alpha = 0 end
    if alpha > 255 then alpha = 255 end
    
    -- Extract color components
    local r = math.floor(color / 65536) % 256
    local g = math.floor(color / 256) % 256
    local b = color % 256
    
    -- Draw line
    local lineColor = (math.floor(alpha) * 16777216) + (r * 65536) + (g * 256) + b
    ImGui.ImDrawListAddLine(drawlist, pos1.x, pos1.y, pos2.x, pos2.y, lineColor, 1.0)
    
    -- Draw small circles at connection points
    local circleAlpha = alpha * 0.8
    local circleColor = (math.floor(circleAlpha) * 16777216) + (r * 65536) + (g * 256) + b
    
    if distance >= 40.0 then
        ImGui.ImDrawListAddCircleFilled(drawlist, pos1.x, pos1.y, radius - 0.96, circleColor)
        ImGui.ImDrawListAddCircleFilled(drawlist, pos2.x, pos2.y, radius - 0.96, circleColor)
    elseif distance <= 20.0 then
        ImGui.ImDrawListAddCircleFilled(drawlist, pos1.x, pos1.y, radius, circleColor)
        ImGui.ImDrawListAddCircleFilled(drawlist, pos2.x, pos2.y, radius, circleColor)
    else
        local radiusFactor = 1.0 - ((distance - 20.0) / 20.0)
        local offsetFactor = 1.0 - radiusFactor
        local offset = (radius - radius * radiusFactor) * offsetFactor
        ImGui.ImDrawListAddCircleFilled(drawlist, pos1.x, pos1.y, radius - offset, circleColor)
        ImGui.ImDrawListAddCircleFilled(drawlist, pos2.x, pos2.y, radius - offset, circleColor)
    end
end

-- Main render function
function Particles.Render(x, y, width, height, color)
    if not particles.initialized then
        Particles.Setup(width, height)
    end
    
    -- Move particles
    MoveParticles(width, height)
    
    local drawlist = ImGui.GetWindowDrawList()
    
    -- Draw all particles and connections
    for i = 1, #particles.positions do
        local pos1 = particles.positions[i]
        
        -- Offset position by header position
        local offsetPos1 = { x = x + pos1.x, y = y + pos1.y }
        
        -- Draw particle
        DrawCircle(drawlist, offsetPos1, particles.radius[i], color)
        
        -- Check connections with other particles
        for j = i + 1, #particles.positions do
            local pos2 = particles.positions[j]
            local dx = pos2.x - pos1.x
            local dy = pos2.y - pos1.y
            local distance = math.sqrt(dx * dx + dy * dy)
            
            if distance <= config.maxDistance then
                local offsetPos2 = { x = x + pos2.x, y = y + pos2.y }
                DrawLine(drawlist, offsetPos1, offsetPos2, color, particles.radius[i])
            end
        end
    end
end

-- Reset particles (useful when window size changes)
function Particles.Reset()
    particles.initialized = false
    particles.positions = {}
    particles.directions = {}
    particles.radius = {}
end

return Particles
