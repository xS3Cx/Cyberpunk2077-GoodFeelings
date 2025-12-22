local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local InfiniteCombo = {}

InfiniteCombo.toggleInfiniteCombo = { value = false }
InfiniteCombo.handles = {}
InfiniteCombo.appliedToWeaponID = nil

function InfiniteCombo.SetInfiniteCombo(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(InfiniteCombo.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("InfiniteCombo: removed modifiers from %s", tostring(InfiniteCombo.appliedToWeaponID)))
        InfiniteCombo.handles = {}
        InfiniteCombo.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.CanMeleeInfinitelyCombo, gameStatModifierType.Additive, 1, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(InfiniteCombo.handles, id)
        end

        InfiniteCombo.appliedToWeaponID = weaponID
        Logger.Log(string.format("InfiniteCombo: applied modifiers to %s", tostring(weaponID)))
    end
end

function InfiniteCombo.Tick(deltaTime)
    if not InfiniteCombo.toggleInfiniteCombo.value then
        if #InfiniteCombo.handles > 0 then
            InfiniteCombo.SetInfiniteCombo(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #InfiniteCombo.handles == 0) and Weapon.IsMeleeEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= InfiniteCombo.appliedToWeaponID then
            InfiniteCombo.SetInfiniteCombo(true)
            Logger.Log(string.format("InfiniteCombo: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            InfiniteCombo.SetInfiniteCombo(false)
        end
    end
end

return InfiniteCombo
