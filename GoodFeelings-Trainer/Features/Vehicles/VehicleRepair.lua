local Notification = require("UI").Notification
local Logger = require("Core/Logger")
local Vehicle = require("Utils/Vehicle")

local VehicleRepairs = {}

function VehicleRepairs.IsVehicleDamaged()
    local veh = Vehicle.GetMountedVehicleSafe()
    if not veh then return false end

    local vps = veh:GetVehiclePS()
    return vps and vps:GetIsDestroyed() or false
end

function VehicleRepairs.RepairMounted()
    local veh = Vehicle.GetMountedVehicleSafe()
    if not veh then
        Notification.Info("No mounted vehicle to repair")
        return false
    end

    local vps = veh:GetVehiclePS()
    local vc  = veh:GetVehicleComponent()
    if not (vps and vc) then
        Logger.Log("VehicleRepair: missing VehiclePS/VehicleComponent")
        return false
    end

    vc.damageLevel = 0

    local type = veh:GetVehicleType().value
    if type ~= "Bike" then
        vc.bumperFrontState = 0
        vc.bumperBackState  = 0

        local parts = {
            "hood_destruction",
            "wheel_f_l_destruction",
            "wheel_f_r_destruction",
            "bumper_b_destruction",
            "bumper_f_destruction",
            "door_f_l_destruction",
            "door_f_r_destruction",
            "trunk_destruction",
            "bumper_b_destruction_side_2",
            "bumper_f_destruction_side_2"
        }

        for _, part in ipairs(parts) do
            AnimationControllerComponent.SetInputFloat(veh, part, 0.0)
        end
    end

    if veh:GetFlatTireIndex() >= 0 then
        for i = 0, 3 do
            veh:ToggleBrokenTire(i, false)
        end
    end

    veh:DestructionResetGrid()
    veh:DestructionResetGlass()
    vc:UpdateDamageEngineEffects()
    vc:RepairVehicle()
    vc:VehicleVisualDestructionSetup()

    vps:CloseAllVehDoors(true)
    vps:CloseAllVehWindows()
    vps:ForcePersistentStateChanged()

    Logger.Log("VehicleRepair: fully repaired mounted vehicle")
    return true
end

return VehicleRepairs
