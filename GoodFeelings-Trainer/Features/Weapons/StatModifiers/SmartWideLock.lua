local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local SmartWideLock = {}

SmartWideLock.toggleWideLock = { value = false }
SmartWideLock.handles = {}
SmartWideLock.appliedToWeaponID = nil

function SmartWideLock.SetWideLock(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(SmartWideLock.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("SmartWideLock: removed modifiers from %s", tostring(SmartWideLock.appliedToWeaponID)))
        SmartWideLock.handles = {}
        SmartWideLock.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local stats = {
            gamedataStatType.SmartGunAdsLockingAnglePitch,
            gamedataStatType.SmartGunAdsLockingAngleYaw,
            gamedataStatType.SmartGunAdsTargetableAnglePitch,
            gamedataStatType.SmartGunAdsTargetableAngleYaw,
            gamedataStatType.SmartGunHipLockingAnglePitch,
            gamedataStatType.SmartGunHipLockingAngleYaw,
            gamedataStatType.SmartGunHipTargetableAnglePitch,
            gamedataStatType.SmartGunHipTargetableAngleYaw,
        }

        for _, stat in ipairs(stats) do
            local id = StatModifiers.CreateForWeapon(stat, gameStatModifierType.Additive, 1, weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(SmartWideLock.handles, id)
            end
        end

        SmartWideLock.appliedToWeaponID = weaponID
        Logger.Log(string.format("SmartWideLock: applied modifiers to %s", tostring(weaponID)))
    end
end

function SmartWideLock.Tick(deltaTime)
    if not SmartWideLock.toggleWideLock.value then
        if #SmartWideLock.handles > 0 then
            SmartWideLock.SetWideLock(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #SmartWideLock.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= SmartWideLock.appliedToWeaponID then
            SmartWideLock.SetWideLock(true)
            Logger.Log(string.format("SmartWideLock: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            SmartWideLock.SetWideLock(false)
        end
    end
end

return SmartWideLock
