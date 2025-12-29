local Input = require("Core/Input")
local Force = require("Utils/Force")

local VehicleJump = {
    enabled = { value = false },
    baseForce = 150000.0,
    wasKeyDown = false
}

function VehicleJump.Tick(dt)
    if not VehicleJump.enabled.value then return end

    local player = Game.GetPlayer()
    if not player then return end
    
    local vehicle = player:GetMountedVehicle()
    if not vehicle then return end

    local isJumpPressed = Input.IsKeyDown(Input.VK.SPACE) or Input.IsButtonDown(Input.GP.A) -- A on controller for jump usually
    
    if isJumpPressed and not VehicleJump.wasKeyDown then
        local up = vehicle:GetWorldUp()
        local impulsePower = VehicleJump.baseForce
        
        local impulse = Vector3.new(
            up.x * impulsePower,
            up.y * impulsePower,
            up.z * impulsePower
        )
        
        Force.ApplyImpulse(vehicle, impulse)
    end
    
    VehicleJump.wasKeyDown = isJumpPressed
end

function VehicleJump.LaunchTargeted()
    local Notification = require("UI/Elements/Notification")
    
    local target = Game.GetTargetingSystem():GetLookAtObject(Game.GetPlayer(), false, false)
    
    if not target then
        Notification.Warning("No target found", 2)
        return
    end
    
    if not target:IsVehicle() then
        Notification.Warning("Target is not a vehicle", 2)
        return
    end

    local up = target:GetWorldUp()
    local impulsePower = VehicleJump.baseForce
    
    local impulse = Vector3.new(
        up.x * impulsePower,
        up.y * impulsePower,
        up.z * impulsePower
    )
    
    Force.ApplyImpulse(target, impulse)
end

function VehicleJump.LaunchMounted()
    local player = Game.GetPlayer()
    if not player then return end
    
    local vehicle = player:GetMountedVehicle()
    if not vehicle then return end

    local up = vehicle:GetWorldUp()
    local impulsePower = VehicleJump.baseForce
    
    local impulse = Vector3.new(
        up.x * impulsePower,
        up.y * impulsePower,
        up.z * impulsePower
    )
    
    Force.ApplyImpulse(vehicle, impulse)
end

return VehicleJump
