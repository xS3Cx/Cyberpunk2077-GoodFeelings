local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local FastReload = {}

FastReload.toggleFastReload = { value = false }
FastReload.handles = {}
FastReload.appliedToWeaponID = nil
FastReload.lastCheckTime = 0
FastReload.checkInterval = 1

function FastReload.SetFastReload(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        if #FastReload.handles > 0 then
            for _, id in ipairs(FastReload.handles) do
                StatModifiers.Remove(id)
            end
            Logger.Log(string.format("FastReload: removed modifiers from %s", tostring(FastReload.appliedToWeaponID)))
        end
        FastReload.handles = {}
        FastReload.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.ReloadTimeBase, gameStatModifierType.Multiplier, 0.2 },
            { gamedataStatType.ReloadEndTime, gameStatModifierType.Multiplier, 0.1 },
            { gamedataStatType.EmptyReloadTime, gameStatModifierType.Multiplier, 0.2 },
            { gamedataStatType.EmptyReloadEndTime,gameStatModifierType.Multiplier, 0.1 }
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(FastReload.handles, id)
            end
        end

        FastReload.appliedToWeaponID = weaponID
        Logger.Log(string.format("FastReload: applied modifiers to %s", tostring(weaponID)))
    end
end

function FastReload.Tick(deltaTime)
    if not FastReload.toggleFastReload.value then
        if #FastReload.handles > 0 then
            FastReload.SetFastReload(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #FastReload.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= FastReload.appliedToWeaponID then
            Logger.Log(string.format("FastReload: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            FastReload.SetFastReload(true)
            FastReload.SetFastReload(false)
        end
    end
end

return FastReload
