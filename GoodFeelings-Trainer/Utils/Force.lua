local Logger = require("Core/Logger")

local Force = {}

function Force.ApplyImpulse(entity, impulse)
    if not entity or not impulse then return end

    local pos4 = entity:GetWorldPosition()
    local pos3 = Vector3.new(pos4.x, pos4.y, pos4.z)

    local evt = PhysicalImpulseEvent.new()
    evt.worldImpulse = impulse
    evt.worldPosition = pos3
    evt.radius = 1.0
    entity:QueueEvent(evt)

    -- Logger.Log(string.format("ApplyImpulse: (%.2f, %.2f, %.2f)", impulse.x, impulse.y, impulse.z))
end

-- Nitrous impulse logic adapted from Redscript implementation by MisterChedda
function Force.ApplyNitroImpulse(vehicle, baseForce, multiplier, dt)
    if not vehicle then return end

    local reportedMass = vehicle.GetTotalMass and vehicle:GetTotalMass() or 1500
    local minimumMassThreshold = 1500.0
    local massToUse = math.max(reportedMass, minimumMassThreshold)

    local effectiveImpulse = (baseForce / massToUse) * multiplier * dt

    local baselineFriction = 1.0
    local currentFriction = math.max(vehicle.longitudinalFrictionMultiplier or 1.0, 0.1)
    local frictionScale = math.min(math.max(currentFriction / baselineFriction, 0.6), 1.4)
    effectiveImpulse = effectiveImpulse * frictionScale

    local bb = vehicle:GetBlackboard()
    local speedMph = 0
    if bb then
        local defs = GetAllBlackboardDefs()
        speedMph = bb:GetFloat(defs.Vehicle.SpeedValue) or 0
    end
    local speedKph = speedMph * 1.60934
    local dampingStart, dampingMax, maxDamp = 85, 140, 0.6
    if speedKph > dampingStart then
        local range = math.max(dampingMax - dampingStart, 1)
        local progress = math.min(math.max((speedKph - dampingStart) / range, 0), 1)
        local scale = 1.0 + (maxDamp - 1.0) * progress -- lerp 1→0.6
        effectiveImpulse = effectiveImpulse * scale
    end

    if effectiveImpulse <= 0.01 then return end

    local forward = vehicle:GetWorldForward()
    local pos = vehicle:GetWorldPosition()
    local up = vehicle:GetWorldUp()
    local verticalOffset = 0.0

    verticalOffset = 0.1

    local impulsePos = Vector3.new(pos.x + up.x * verticalOffset,
                                   pos.y + up.y * verticalOffset,
                                   pos.z + up.z * verticalOffset)

    local evt = PhysicalImpulseEvent.new()
    evt.worldPosition = impulsePos
    evt.worldImpulse = Vector3.new(
        forward.x * effectiveImpulse,
        forward.y * effectiveImpulse,
        forward.z * effectiveImpulse
    )
    evt.radius = 1.0
    vehicle:QueueEvent(evt)

    -- Logger.Log(string.format("Nitro impulse: %.2f", effectiveImpulse))
end

function Force.ApplyForceToEntity(entity, forwardVal, rightVal, upVal, scaleByMass)
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

    -- Logger.Log(string.format("ApplyForceToEntity: F=%.2f R=%.2f U=%.2f -> (%.2f, %.2f, %.2f)", forwardVal, rightVal, upVal, impulse.x, impulse.y, impulse.z))
end


function Force.SetVelocityForward(entity, speed)
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
function Force.OscillateForward(entity, dt) -- this doesn't works but maybe one day
    if not entity then return end
    oscTimer = oscTimer + dt
    local value = math.sin(oscTimer * oscFreq * math.pi * 2) * oscSpeed
    Force.SetVelocityForward(entity, value)
end

return Force
