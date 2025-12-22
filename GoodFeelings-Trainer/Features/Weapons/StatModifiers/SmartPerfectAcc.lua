local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local SmartPerfectAcc = {}

SmartPerfectAcc.togglePerfectAcc = { value = false }
SmartPerfectAcc.handles = {}
SmartPerfectAcc.appliedToWeaponID = nil

function SmartPerfectAcc.SetPerfectAcc(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(SmartPerfectAcc.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("SmartPerfectAcc: removed modifiers from %s", tostring(SmartPerfectAcc.appliedToWeaponID)))
        SmartPerfectAcc.handles = {}
        SmartPerfectAcc.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.SmartGunHitProbability, gameStatModifierType.Additive, 1 },
            { gamedataStatType.SmartGunStartingAccuracy, gameStatModifierType.Additive, 1 },
            { gamedataStatType.SmartGunMissDelay, gameStatModifierType.Multiplier, 0 },
            { gamedataStatType.SmartGunMissRadius, gameStatModifierType.Multiplier, 0 },
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(SmartPerfectAcc.handles, id)
            end
        end

        SmartPerfectAcc.appliedToWeaponID = weaponID
        Logger.Log(string.format("SmartPerfectAcc: applied modifiers to %s", tostring(weaponID)))
    end
end

function SmartPerfectAcc.Tick(deltaTime)
    if not SmartPerfectAcc.togglePerfectAcc.value then
        if #SmartPerfectAcc.handles > 0 then
            SmartPerfectAcc.SetPerfectAcc(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #SmartPerfectAcc.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= SmartPerfectAcc.appliedToWeaponID then
            SmartPerfectAcc.SetPerfectAcc(true)
            Logger.Log(string.format("SmartPerfectAcc: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            SmartPerfectAcc.SetPerfectAcc(false)
        end
    end
end

return SmartPerfectAcc
