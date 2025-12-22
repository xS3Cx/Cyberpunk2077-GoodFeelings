local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local HipfireAccuracy = {}

HipfireAccuracy.toggleHipfireAccuracy = { value = false }
HipfireAccuracy.handles = {}
HipfireAccuracy.appliedToWeaponID = nil

function HipfireAccuracy.SetHipfireAccuracy(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(HipfireAccuracy.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("HipfireAccuracy: removed modifiers from %s", tostring(HipfireAccuracy.appliedToWeaponID)))
        HipfireAccuracy.handles = {}
        HipfireAccuracy.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.SpreadMinX, gameStatModifierType.Multiplier, 0.05 },
            { gamedataStatType.SpreadMinY, gameStatModifierType.Multiplier, 0.05 },
            { gamedataStatType.SpreadMaxX, gameStatModifierType.Multiplier, 0.05 },
            { gamedataStatType.SpreadMaxY, gameStatModifierType.Multiplier, 0.05 },
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(HipfireAccuracy.handles, id)
            end
        end

        HipfireAccuracy.appliedToWeaponID = weaponID
        Logger.Log(string.format("HipfireAccuracy: applied modifiers to %s", tostring(weaponID)))
    end
end

function HipfireAccuracy.Tick(deltaTime)
    if not HipfireAccuracy.toggleHipfireAccuracy.value then
        if #HipfireAccuracy.handles > 0 then
            HipfireAccuracy.SetHipfireAccuracy(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #HipfireAccuracy.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= HipfireAccuracy.appliedToWeaponID then
            HipfireAccuracy.SetHipfireAccuracy(true)
            Logger.Log(string.format("HipfireAccuracy: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            HipfireAccuracy.SetHipfireAccuracy(false)
        end
    end
end

return HipfireAccuracy
