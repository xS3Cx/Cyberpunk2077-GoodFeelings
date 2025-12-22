local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local AdsAccuracy = {}

AdsAccuracy.toggleAdsAccuracy = { value = false }
AdsAccuracy.handles = {}
AdsAccuracy.appliedToWeaponID = nil

function AdsAccuracy.SetAdsAccuracy(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(AdsAccuracy.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("AdsAccuracy: removed modifiers from %s", tostring(AdsAccuracy.appliedToWeaponID)))
        AdsAccuracy.handles = {}
        AdsAccuracy.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.SpreadAdsMinX, gameStatModifierType.Multiplier, 0.05 },
            { gamedataStatType.SpreadAdsMinY, gameStatModifierType.Multiplier, 0.05 },
            { gamedataStatType.SpreadAdsMaxX, gameStatModifierType.Multiplier, 0.05 },
            { gamedataStatType.SpreadAdsMaxY, gameStatModifierType.Multiplier, 0.05 },
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(AdsAccuracy.handles, id)
            end
        end

        AdsAccuracy.appliedToWeaponID = weaponID
        Logger.Log(string.format("AdsAccuracy: applied modifiers to %s", tostring(weaponID)))
    end
end

function AdsAccuracy.Tick(deltaTime)
    if not AdsAccuracy.toggleAdsAccuracy.value then
        if #AdsAccuracy.handles > 0 then
            AdsAccuracy.SetAdsAccuracy(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #AdsAccuracy.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= AdsAccuracy.appliedToWeaponID then
            AdsAccuracy.SetAdsAccuracy(true)
            Logger.Log(string.format("AdsAccuracy: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            AdsAccuracy.SetAdsAccuracy(false)
        end
    end
end

return AdsAccuracy
