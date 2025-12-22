local Logger = require("Core/Logger")
local Notification = require("UI").Notification
local Vehicle = require("Utils/Vehicle")

local VehicleMountOnRoof = {}

function VehicleMountOnRoof.MountOnRoof()
    local veh = Vehicle.GetMountedVehicleSafe()
    if not veh then
        Notification.Info("No mounted vehicle to mount")
        return false
    end

    Vehicle.UnmountPlayer(true)

    Logger.Log("Vehicle: player placed on top of vehicle roof")
    return true
end

return VehicleMountOnRoof
