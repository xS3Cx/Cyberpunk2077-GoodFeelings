local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local BladeCarnage = {}

BladeCarnage.toggleBladeCarnage = { value = false }
BladeCarnage.handles = {}
BladeCarnage.appliedToWeaponID = nil

function BladeCarnage.SetBladeCarnage(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(BladeCarnage.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("BladeCarnage: removed modifiers from %s", tostring(BladeCarnage.appliedToWeaponID)))
        BladeCarnage.handles = {}
        BladeCarnage.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.HitDismembermentFactor, gameStatModifierType.Additive, 10000, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(BladeCarnage.handles, id)
        end

        BladeCarnage.appliedToWeaponID = weaponID
        Logger.Log(string.format("BladeCarnage: applied modifiers to %s", tostring(weaponID)))
    end
end

function BladeCarnage.Tick(deltaTime)
    if not BladeCarnage.toggleBladeCarnage.value then
        if #BladeCarnage.handles > 0 then
            BladeCarnage.SetBladeCarnage(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #BladeCarnage.handles == 0) and Weapon.IsMeleeEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= BladeCarnage.appliedToWeaponID then
            BladeCarnage.SetBladeCarnage(true)
            Logger.Log(string.format("BladeCarnage: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            BladeCarnage.SetBladeCarnage(false)
        end
    end
end

return BladeCarnage
