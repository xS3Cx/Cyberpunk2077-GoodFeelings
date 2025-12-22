local Logger = require("Core/Logger")
local Buttons = require("UI").Buttons
local TestForceView = {}

local lastVehicle = nil

local force = {
    x = { value = 1 },
    y = { value = 1 },
    z = { value = 1 },
}

local tickEnabled = { value = true }
local scaleByMass = { value = true }


local function ApplyForceToEntity(entity, forwardVal, rightVal, upVal, scaleByMass)
    if not entity then return end

    local forward = entity:GetWorldForward()
    local right = entity:GetWorldRight()
    local up = entity:GetWorldUp()

    local impulse = Vector3.new(
        forward.x * forwardVal + right.x * rightVal + up.x * upVal,
        forward.y * forwardVal + right.y * rightVal + up.y * upVal,
        forward.z * forwardVal + right.z * rightVal + up.z * upVal
    )

    if scaleByMass and entity.GetTotalMass then
        local mass = entity:GetTotalMass()
        if mass and mass > 0.01 then
            local factor = 1500 / mass
            impulse = Vector3.new(impulse.x * factor, impulse.y * factor, impulse.z * factor)
        end
    end

    local pos = entity:GetWorldPosition()

    local evt = PhysicalImpulseEvent.new()
    evt.worldImpulse = impulse
    evt.worldPosition = pos
    evt.radius = 1.0
    entity:QueueEvent(evt)

    Logger.Log(string.format(
        "VehDirForce: F=%.2f R=%.2f U=%.2f => Impulse(%.2f, %.2f, %.2f)",
        forwardVal, rightVal, upVal, impulse.x, impulse.y, impulse.z
    ))
end

local function SetVelocityForward(entity, speed)
    if not entity then return end

    local forward = entity:GetWorldForward()
    if not forward then return end

    local mass = entity.GetTotalMass and entity:GetTotalMass() or 1500
    local factor = mass > 0 and (speed * mass) or speed

    local impulse = Vector3.new(forward.x * factor, forward.y * factor, forward.z * factor)

    local pos = entity:GetWorldPosition()
    local evt = PhysicalImpulseEvent.new()
    evt.worldImpulse = impulse
    evt.worldPosition = pos
    evt.radius = 1.0
    entity:QueueEvent(evt)

    Logger.Log(string.format("SetVelocityForward: speed=%.2f impulse=(%.2f, %.2f, %.2f)",
        speed, impulse.x, impulse.y, impulse.z))
end

local oscTimer = 0
local oscSpeed = 0.5
local oscFreq  = 1

local function OscillateEntityForward(entity, dt)-- it doesn't work :( life is hard
    if not entity then return end
    oscTimer = oscTimer + dt
    local value = math.sin(oscTimer * oscFreq * math.pi * 2) * oscSpeed
    SetVelocityForward(entity, value)
end


function TestForceView.Tick(dt)
    local player = Game.GetPlayer()
    if not player then return end

    local veh = player:GetMountedVehicle()
    if veh and veh ~= lastVehicle then
        lastVehicle = veh
        Logger.Log("TestForce: Stored new vehicle")
    end

    if lastVehicle then
        OscillateEntityForward(lastVehicle, dt or 0.016) -- dt ~ 1/60
    end
end

local function drawView()
    Buttons.Toggle("Enable Tick", tickEnabled)
    if tickEnabled.value then
        TestForceView.Tick()
    end

    Buttons.Toggle("Scale By Mass", scaleByMass)

    Buttons.Break("Force Test", "", "")
    local name = lastVehicle and tostring(lastVehicle:GetRecordID()) or "None"
    Buttons.OptionExtended("Stored Vehicle", name, "", nil, function() end)

    if Buttons.Option("Clear Stored Vehicle") then
        lastVehicle = nil
        Logger.Log("TestForce: Cleared stored vehicle")
    end

    Buttons.Break("Velocity Tests", "", "")
    if lastVehicle then
        if Buttons.Option("Forward Velocity (5)") then
            SetVelocityForward(lastVehicle, 5)
        end
   if Buttons.Option("Forward Velocity (5)") then
            SetVelocityForward(lastVehicle, -5)
        end
    end

    Buttons.Int("Force X", force.x)
    Buttons.Int("Force Y", force.y)
    Buttons.Int("Force Z", force.z)

    Buttons.Break("Axis Tests", "", "")
    if lastVehicle then
        if Buttons.Option("Apply X Only") then
            ApplyForceToEntity(lastVehicle, force.x.value, 0, 0)
        end
        if Buttons.Option("Apply Y Only") then
            ApplyForceToEntity(lastVehicle, 0, force.y.value, 0)
        end
        if Buttons.Option("Apply Z Only") then
            ApplyForceToEntity(lastVehicle, 0, 0, force.z.value)
        end

        Buttons.Break("Combos", "", "")
        if Buttons.Option("Apply XY Combo") then
            ApplyForceToEntity(lastVehicle, force.x.value, force.y.value, 0)
        end
        if Buttons.Option("Apply XZ Combo") then
            ApplyForceToEntity(lastVehicle, force.x.value, 0, force.z.value)
        end
        if Buttons.Option("Apply YZ Combo") then
            ApplyForceToEntity(lastVehicle, 0, force.y.value, force.z.value)
        end

        Buttons.Break("Offset Pushes", "", "")
        if Buttons.Option("Offset Left Side Push") then
            ApplyForceToEntity(lastVehicle, force.x.value, 0, 0, { x = -2 })
        end
        if Buttons.Option("Offset Right Side Push") then
            ApplyForceToEntity(lastVehicle, force.x.value, 0, 0, { x = 2 })
        end
    end
end

return {
    title = "Force Test",
    view = drawView
}
