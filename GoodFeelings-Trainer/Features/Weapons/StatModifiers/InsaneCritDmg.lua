local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local InsaneCritDmg = {}

InsaneCritDmg.toggleInsaneCritDmg = { value = false }
InsaneCritDmg.handles = {}
InsaneCritDmg.appliedToWeaponID = nil

function InsaneCritDmg.SetInsaneCritDmg(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(InsaneCritDmg.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("InsaneCritDmg: removed modifiers from %s", tostring(InsaneCritDmg.appliedToWeaponID)))
        InsaneCritDmg.handles = {}
        InsaneCritDmg.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.CritDamage, gameStatModifierType.Additive, 100000, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(InsaneCritDmg.handles, id)
        end

        InsaneCritDmg.appliedToWeaponID = weaponID
        Logger.Log(string.format("InsaneCritDmg: applied modifiers to %s", tostring(weaponID)))
    end
end

function InsaneCritDmg.Tick(deltaTime)
    if not InsaneCritDmg.toggleInsaneCritDmg.value then
        if #InsaneCritDmg.handles > 0 then
            InsaneCritDmg.SetInsaneCritDmg(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #InsaneCritDmg.handles == 0) then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= InsaneCritDmg.appliedToWeaponID then
            InsaneCritDmg.SetInsaneCritDmg(true)
            Logger.Log(string.format("InsaneCritDmg: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            InsaneCritDmg.SetInsaneCritDmg(false)
        end
    end
end

return InsaneCritDmg
