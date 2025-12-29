local Vehicle = require("Utils/Vehicle")
local Teleport = require("Utils").Teleport

local VehicleFlip = {}

function VehicleFlip.FlipCurrent()
    local veh = Vehicle.GetMountedVehicleSafe()
    if not veh then return end

    local pos = veh:GetWorldPosition()
    local currentHeading = veh:GetWorldForward()
    
    -- Calculate yaw from forward vector
    local yaw = math.atan2(currentHeading.y, currentHeading.x) * (180 / math.pi)
    
    -- Reset X (Roll) and Y (Pitch) to 0, maintain Z (Yaw)
    local targetRotation = EulerAngles.new(0, 0, yaw)
    
    -- Lift slightly to avoid ground collision
    local targetPos = Vector4.new(pos.x, pos.y, pos.z + 0.5, 1.0)
    
    Teleport.TeleportEntity(veh, targetPos, targetRotation)
end

return VehicleFlip
