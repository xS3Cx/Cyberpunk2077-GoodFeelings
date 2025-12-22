-- Core/Nitro.lua
local Input  = require("Core/Input")
local Event  = require("Core/Event")
local Logger = require("Core/Logger")
local Force  = require("Utils/Force")

local VehicleNitro = {
    multiplier = {
        value = 1.5,
        min = 1.0,
        max = 100.0,
        step = 0.5,
        enabled = false
    },

    baseForce = 50000.0,
    dt = 0.05
}

function VehicleNitro.Tick(dt)
    if VehicleNitro.multiplier.enabled then
        local vehicle = Game.GetPlayer():GetMountedVehicle()
        if not vehicle then return end
        if Input.IsKeyDown(Input.VK.SHIFT) or Input.IsButtonDown(Input.GP.X) then
            vehicle:ToggleHorn(false, false)
            Force.ApplyNitroImpulse(
                vehicle,
                VehicleNitro.baseForce,
                (VehicleNitro.multiplier.value * 100),
                VehicleNitro.dt
            )
        end
    end
end

return VehicleNitro
