local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local LowStaminaCost = {}

LowStaminaCost.toggleLowStaminaCost = { value = false }
LowStaminaCost.handles = {}
LowStaminaCost.appliedToWeaponID = nil

function LowStaminaCost.SetLowStaminaCost(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(LowStaminaCost.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("LowStaminaCost: removed modifiers from %s", tostring(LowStaminaCost.appliedToWeaponID)))
        LowStaminaCost.handles = {}
        LowStaminaCost.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.StaminaCostReduction, gameStatModifierType.Additive, -2, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(LowStaminaCost.handles, id)
        end

        LowStaminaCost.appliedToWeaponID = weaponID
        Logger.Log(string.format("LowStaminaCost: applied modifiers to %s", tostring(weaponID)))
    end
end

function LowStaminaCost.Tick(deltaTime)
    if not LowStaminaCost.toggleLowStaminaCost.value then
        if #LowStaminaCost.handles > 0 then
            LowStaminaCost.SetLowStaminaCost(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #LowStaminaCost.handles == 0) and Weapon.IsMeleeEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= LowStaminaCost.appliedToWeaponID then
            LowStaminaCost.SetLowStaminaCost(true)
            Logger.Log(string.format("LowStaminaCost: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            LowStaminaCost.SetLowStaminaCost(false)
        end
    end
end

return LowStaminaCost
