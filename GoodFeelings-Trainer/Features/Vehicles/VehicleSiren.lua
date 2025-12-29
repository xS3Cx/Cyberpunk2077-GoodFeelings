local VehicleLights = require("Features/Vehicles/VehicleLights")

local VehicleSiren = {
    enabled = { value = false },
    timer = 0,
    state = 0, -- 0: Red, 1: Blue
    interval = 0.3
}

local RED = Color.new({ Red = 255, Green = 0, Blue = 0, Alpha = 255 })
local BLUE = Color.new({ Red = 0, Green = 0, Blue = 255, Alpha = 255 })
local OFF = Color.new({ Red = 0, Green = 0, Blue = 0, Alpha = 255 })

function VehicleSiren.Tick(dt)
    if not VehicleSiren.enabled.value then 
        if VehicleSiren.state ~= -1 then
            VehicleLights.ResetAllLightColors()
            VehicleSiren.state = -1
        end
        return 
    end

    VehicleSiren.timer = VehicleSiren.timer + dt
    if VehicleSiren.timer >= VehicleSiren.interval then
        VehicleSiren.timer = 0
        VehicleSiren.state = (VehicleSiren.state + 1) % 2
        
        if VehicleSiren.state == 0 then
            VehicleLights.SetAllLightsColor(RED)
        else
            VehicleLights.SetAllLightsColor(BLUE)
        end
    end
end

return VehicleSiren
