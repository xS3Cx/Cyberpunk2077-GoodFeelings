local Logger = require("Core/Logger")
local VehicleLoader = require("Utils/DataExtractors/VehicleLoader")
local Notification = require("UI").Notification

local VehicleUnlockSystem = {}

function VehicleUnlockSystem.IsUnlocked(vehicleID)
    local vs = Game.GetVehicleSystem()
    if not vs then return false end
    local recordID = TweakDBID.new(vehicleID)
    return vs:IsVehiclePlayerUnlocked(recordID)
end

function VehicleUnlockSystem.SetPlayerVehicleState(vehicleID, enable)
    local vs = Game.GetVehicleSystem()
    if not vs then return false end
    local result = vs:EnablePlayerVehicle(vehicleID, enable, not enable)
    Logger.Log(string.format("VehicleUnlock: set state for %s : %s", tostring(vehicleID), enable and "Unlocked" or "Locked"))
    return result
end

function VehicleUnlockSystem.Unlock(vehicleID)
    return VehicleUnlockSystem.SetPlayerVehicleState(vehicleID, true)
end

function VehicleUnlockSystem.Disable(vehicleID)
    return VehicleUnlockSystem.SetPlayerVehicleState(vehicleID, false)
end

function VehicleUnlockSystem.UnlockAllPlayerVehicles()
    for _, v in ipairs(VehicleLoader:GetAll()) do
        if v.id and v.id:lower():match("_player$") then
            VehicleUnlockSystem.Unlock(v.id)
        end
    end
    Notification.Info("VehicleUnlock: All Player vehicles unlocked")
end


function VehicleUnlockSystem.DisableAllPlayerVehicles()
    for _, v in ipairs(VehicleLoader:GetAll()) do
        if v.id and v.id:lower():match("_player$") then
            VehicleUnlockSystem.Disable(v.id)
        end
    end
    Notification.Info("VehicleUnlock: All Player vehicles disabled")
end



function VehicleUnlockSystem.UnlockFaction(factionName)
    for _, v in ipairs(VehicleLoader:GetAll()) do
        if v.faction == factionName then
            VehicleUnlockSystem.Unlock(v.id)

            if v.variants then
                for _, var in ipairs(v.variants) do
                    VehicleUnlockSystem.Unlock(var)
                end
            end
        end
    end

    Notification.Info("VehicleUnlock: All vehicles for faction '" .. factionName .. "' unlocked")
end

function VehicleUnlockSystem.DisableFaction(factionName)
    for _, v in ipairs(VehicleLoader:GetAll()) do
        if v.faction == factionName then
            VehicleUnlockSystem.Disable(v.id)

            if v.variants then
                for _, var in ipairs(v.variants) do
                    VehicleUnlockSystem.Disable(var)
                end
            end
        end
    end

    Notification.Info("VehicleUnlock: All vehicles for faction '" .. factionName .. "' disabled")
end

function VehicleUnlockSystem.UnlockAllModded()
    for _, v in ipairs(VehicleLoader:GetAll()) do
        if v.isModded then
            VehicleUnlockSystem.Unlock(v.id)
        end
    end
    Notification.Info("VehicleUnlock: All Add-on vehicles unlocked (with variants)")
end

function VehicleUnlockSystem.DisableAllModded()
    for _, v in ipairs(VehicleLoader:GetAll()) do
        if v.isModded then
            VehicleUnlockSystem.Disable(v.id)
        end
    end
    Notification.Info("VehicleUnlock: All Add-on vehicles locked (with variants)")
end


return VehicleUnlockSystem
