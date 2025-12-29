local Vehicle = require("Utils/Vehicle")
local Notification = require("UI").Notification
local Logger = require("Core/Logger")

local VehicleAppearance = {}

function VehicleAppearance.RandomizeMounted()
    local veh = Vehicle.GetMountedVehicleSafe()
    if not veh then
        Notification.Info("No mounted vehicle to randomize")
        return false
    end

    -- For vehicles, we can use ScheduleAppearanceChange with an empty string to randomize
    -- or we can try to toggle between appearances if we want more control.
    -- Simple randomization for now as requested.
    
    pcall(function()
        veh:ScheduleAppearanceChange("")
    end)

    Notification.Info("Vehicle Appearance Randomized")
    return true
end

return VehicleAppearance
