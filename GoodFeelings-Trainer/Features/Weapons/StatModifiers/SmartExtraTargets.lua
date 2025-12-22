local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local SmartExtraTargets = {}

SmartExtraTargets.toggleExtraTargets = { value = false }
SmartExtraTargets.handles = {}
SmartExtraTargets.appliedToWeaponID = nil

function SmartExtraTargets.SetExtraTargets(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(SmartExtraTargets.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("SmartExtraTargets: removed modifiers from %s", tostring(SmartExtraTargets.appliedToWeaponID)))
        SmartExtraTargets.handles = {}
        SmartExtraTargets.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.SmartGunMaxLockedPointsPerTarget, gameStatModifierType.Additive, 2 },
            { gamedataStatType.SmartGunAdsMaxLockedTargets, gameStatModifierType.Additive, 15 },
            { gamedataStatType.SmartGunHipMaxLockedTargets, gameStatModifierType.Additive, 15 },
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(SmartExtraTargets.handles, id)
            end
        end

        SmartExtraTargets.appliedToWeaponID = weaponID
        Logger.Log(string.format("SmartExtraTargets: applied modifiers to %s", tostring(weaponID)))
    end
end

function SmartExtraTargets.Tick(deltaTime)
    if not SmartExtraTargets.toggleExtraTargets.value then
        if #SmartExtraTargets.handles > 0 then
            SmartExtraTargets.SetExtraTargets(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #SmartExtraTargets.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= SmartExtraTargets.appliedToWeaponID then
            SmartExtraTargets.SetExtraTargets(true)
            Logger.Log(string.format("SmartExtraTargets: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            SmartExtraTargets.SetExtraTargets(false)
        end
    end
end

return SmartExtraTargets
