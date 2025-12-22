local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local AlwaysCrit = {}

AlwaysCrit.toggleAlwaysCrit = { value = false }
AlwaysCrit.handles = {}
AlwaysCrit.appliedToWeaponID = nil

function AlwaysCrit.SetAlwaysCrit(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(AlwaysCrit.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("AlwaysCrit: removed modifiers from %s", tostring(AlwaysCrit.appliedToWeaponID)))
        AlwaysCrit.handles = {}
        AlwaysCrit.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.CritChance, gameStatModifierType.Additive, 100, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(AlwaysCrit.handles, id)
        end

        AlwaysCrit.appliedToWeaponID = weaponID
        Logger.Log(string.format("AlwaysCrit: applied modifiers to %s", tostring(weaponID)))
    end
end

function AlwaysCrit.Tick(deltaTime)
    if not AlwaysCrit.toggleAlwaysCrit.value then
        if #AlwaysCrit.handles > 0 then
            AlwaysCrit.SetAlwaysCrit(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #AlwaysCrit.handles == 0) then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= AlwaysCrit.appliedToWeaponID then
            AlwaysCrit.SetAlwaysCrit(true)
            Logger.Log(string.format("AlwaysCrit: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            AlwaysCrit.SetAlwaysCrit(false)
        end
    end
end

return AlwaysCrit
