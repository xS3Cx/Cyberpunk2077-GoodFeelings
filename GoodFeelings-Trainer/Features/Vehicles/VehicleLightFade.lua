local Vehicle = require("Utils/Vehicle")
local VehicleLights = require("Features/Vehicles/VehicleLights")

local VehicleLightFade = {}

VehicleLightFade.toggleRGBFade = { value = false }

local frametimeRGB = 0
local RGBFadeRed, RGBFadeGreen, RGBFadeBlue = 255, 0, 0

function VehicleLightFade.TickFade(delta)
    if not VehicleLightFade.toggleRGBFade.value then return end


    if not Vehicle.GetMountedVehicleSafe() then
        return
    end
    
    frametimeRGB = frametimeRGB + (delta * 1000)
    if frametimeRGB > 5 then
        frametimeRGB = 0

        if RGBFadeRed > 0 and RGBFadeBlue == 0 then
            RGBFadeRed = RGBFadeRed - 1
            RGBFadeGreen = RGBFadeGreen + 1
        elseif RGBFadeGreen > 0 and RGBFadeRed == 0 then
            RGBFadeGreen = RGBFadeGreen - 1
            RGBFadeBlue = RGBFadeBlue + 1
        elseif RGBFadeBlue > 0 and RGBFadeGreen == 0 then
            RGBFadeRed = RGBFadeRed + 1
            RGBFadeBlue = RGBFadeBlue - 1
        end

        RGBFadeRed   = math.max(0, math.min(255, RGBFadeRed))
        RGBFadeGreen = math.max(0, math.min(255, RGBFadeGreen))
        RGBFadeBlue  = math.max(0, math.min(255, RGBFadeBlue))

        local color  = Color.new({
            Red   = RGBFadeRed,
            Green = RGBFadeGreen,
            Blue  = RGBFadeBlue,
            Alpha = 255
        })

        VehicleLights.SetAllLightsColor(color)
    end
end


return VehicleLightFade
