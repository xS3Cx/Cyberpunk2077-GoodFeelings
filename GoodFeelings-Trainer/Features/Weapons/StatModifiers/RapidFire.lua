local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local RapidFire = {}

RapidFire.toggleRapidFire = { value = false }
RapidFire.handles = {}
RapidFire.appliedToWeaponID = nil

function RapidFire.SetRapidFire(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(RapidFire.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("RapidFire: removed modifiers from %s", tostring(RapidFire.appliedToWeaponID)))
        RapidFire.handles = {}
        RapidFire.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.CycleTime, gameStatModifierType.Multiplier, 0.1, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(RapidFire.handles, id)
        end

        RapidFire.appliedToWeaponID = weaponID
        Logger.Log(string.format("RapidFire: applied modifiers to %s", tostring(weaponID)))
    end
end

function RapidFire.Tick(deltaTime)
    if not RapidFire.toggleRapidFire.value then
        if #RapidFire.handles > 0 then
            RapidFire.SetRapidFire(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #RapidFire.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= RapidFire.appliedToWeaponID then
            RapidFire.SetRapidFire(true)
            Logger.Log(string.format("RapidFire: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            RapidFire.SetRapidFire(false)
        end
    end
end

return RapidFire
