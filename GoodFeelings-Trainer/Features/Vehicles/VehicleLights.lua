local Vehicle = require("Utils/Vehicle")

local VehicleLights = {}

local lightTypes = {
    vehicleELightType.Head,
    vehicleELightType.Brake,
    vehicleELightType.LeftBlinker,
    vehicleELightType.RightBlinker,
    vehicleELightType.Reverse,
    vehicleELightType.Interior,
    vehicleELightType.Utility,
    vehicleELightType.Default,
    vehicleELightType.Blinkers
}

function VehicleLights.SetLightColor(lightType, color)
    local controller = Vehicle.GetController()
    if not controller then return end
    controller:SetLightColor(lightType, color, 0.0)
end

function VehicleLights.SetAllLightsColor(color)
    local controller = Vehicle.GetController()
    if not controller then return end
    for _, lightType in ipairs(lightTypes) do
        controller:SetLightColor(lightType, color, 0.0)
    end
end

function VehicleLights.SetLightParameters(lightType, strength, color)
    local controller = Vehicle.GetController()
    if not controller then return end
    controller:SetLightParameters(lightType, strength, color, 0.0)
end

function VehicleLights.SetLightStrength(lightType, strength)
    local controller = Vehicle.GetController()
    if not controller then return end
    controller:SetLightStrength(lightType, strength, 0.0)
end

function VehicleLights.ResetLightColor(lightType)
    local controller = Vehicle.GetController()
    if not controller then return end
    controller:ResetLightColor(lightType, 0.0)
end

function VehicleLights.ResetLightParameters(lightType)
    local controller = Vehicle.GetController()
    if not controller then return end
    controller:ResetLightParameters(lightType, 0.0)
end

function VehicleLights.ResetLightStrength(lightType)
    local controller = Vehicle.GetController()
    if not controller then return end
    controller:ResetLightStrength(lightType, 0.0)
end

function VehicleLights.ToggleLights(on, lightType)
    local controller = Vehicle.GetController()
    if not controller then return end
    controller:ToggleLights(on, lightType or nil, 0.0, "", false)
end

function VehicleLights.DisableAllLights()
    VehicleLights.SetAllLightsColor(Color.new({
        Red = 0, Green = 0, Blue = 0, Alpha = 255
    }))
end

function VehicleLights.ResetAllLightColors()
    local controller = Vehicle.GetController()
    if not controller then return end
    for _, lightType in ipairs(lightTypes) do
        controller:ResetLightColor(lightType, 0.0)
    end
end

return VehicleLights
