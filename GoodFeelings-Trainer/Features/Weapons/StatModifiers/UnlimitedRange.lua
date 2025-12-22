local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local UnlimitedRange = {}

UnlimitedRange.toggleUnlimitedRange = { value = false }
UnlimitedRange.handles = {}
UnlimitedRange.appliedToWeaponID = nil

function UnlimitedRange.SetUnlimitedRange(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(UnlimitedRange.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("UnlimitedRange: removed modifiers from %s", tostring(UnlimitedRange.appliedToWeaponID)))
        UnlimitedRange.handles = {}
        UnlimitedRange.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.EffectiveRange, gameStatModifierType.Multiplier, 200 },
            { gamedataStatType.MaximumRange, gameStatModifierType.Multiplier, 200 },
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(UnlimitedRange.handles, id)
            end
        end

        UnlimitedRange.appliedToWeaponID = weaponID
        Logger.Log(string.format("UnlimitedRange: applied modifiers to %s", tostring(weaponID)))
    end
end

function UnlimitedRange.Tick(deltaTime)
    if not UnlimitedRange.toggleUnlimitedRange.value then
        if #UnlimitedRange.handles > 0 then
            UnlimitedRange.SetUnlimitedRange(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #UnlimitedRange.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= UnlimitedRange.appliedToWeaponID then
            UnlimitedRange.SetUnlimitedRange(true)
            Logger.Log(string.format("UnlimitedRange: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            UnlimitedRange.SetUnlimitedRange(false)
        end
    end
end

return UnlimitedRange
