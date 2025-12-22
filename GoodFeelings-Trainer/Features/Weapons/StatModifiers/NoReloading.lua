local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local NoReloading = {}

NoReloading.toggleNoReloading = { value = false }
NoReloading.handles = {}
NoReloading.appliedToWeaponID = nil

function NoReloading.SetNoReloading(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        if #NoReloading.handles > 0 then
            for _, id in ipairs(NoReloading.handles) do
                StatModifiers.Remove(id)
            end
            Logger.Log(string.format("NoReloading: removed modifier from %s", tostring(NoReloading.appliedToWeaponID)))
        end
        NoReloading.handles = {}
        NoReloading.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.NumShotsToFire, gameStatModifierType.Multiplier, 0, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(NoReloading.handles, id)
        end

        NoReloading.appliedToWeaponID = weaponID
        Logger.Log(string.format("NoReloading: applied modifier to %s", tostring(weaponID)))
    end
end

function NoReloading.Tick(deltaTime)
    if not NoReloading.toggleNoReloading.value then
        if #NoReloading.handles > 0 then
            NoReloading.SetNoReloading(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #NoReloading.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= NoReloading.appliedToWeaponID then
            NoReloading.SetNoReloading(true)
            Logger.Log(string.format("NoReloading: Weapon changed > reapplying modifier to %s", tostring(newWeaponID)))
            NoReloading.SetNoReloading(false)
        end
    end
end

return NoReloading
