local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local SmartFastLock = {}

SmartFastLock.toggleFastLock = { value = false }
SmartFastLock.handles = {}
SmartFastLock.appliedToWeaponID = nil

function SmartFastLock.SetFastLock(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(SmartFastLock.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("SmartFastLock: removed modifiers from %s", tostring(SmartFastLock.appliedToWeaponID)))
        SmartFastLock.handles = {}
        SmartFastLock.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.SmartGunAdsTimeToLock, gameStatModifierType.Multiplier, 0.1 },
            { gamedataStatType.SmartGunHipTimeToLock, gameStatModifierType.Multiplier, 0.05 },
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(SmartFastLock.handles, id)
            end
        end

        SmartFastLock.appliedToWeaponID = weaponID
        Logger.Log(string.format("SmartFastLock: applied modifiers to %s", tostring(weaponID)))
    end
end

function SmartFastLock.Tick(deltaTime)
    if not SmartFastLock.toggleFastLock.value then
        if #SmartFastLock.handles > 0 then
            SmartFastLock.SetFastLock(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #SmartFastLock.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= SmartFastLock.appliedToWeaponID then
            SmartFastLock.SetFastLock(true)
            Logger.Log(string.format("SmartFastLock: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            SmartFastLock.SetFastLock(false)
        end
    end
end

return SmartFastLock
