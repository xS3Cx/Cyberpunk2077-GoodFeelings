local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local NoRecoil = {}

NoRecoil.toggleNoRecoil = { value = false }
NoRecoil.handles = {}
NoRecoil.appliedToWeaponID = nil

function NoRecoil.SetNoRecoil(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        if #NoRecoil.handles > 0 then
            for _, id in ipairs(NoRecoil.handles) do
                StatModifiers.Remove(id)
            end
            Logger.Log(string.format("NoRecoil: removed modifiers from %s", tostring(NoRecoil.appliedToWeaponID)))
        end
        NoRecoil.handles = {}
        NoRecoil.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.RecoilKickMin, gameStatModifierType.Multiplier, 0 },
            { gamedataStatType.RecoilKickMax, gameStatModifierType.Multiplier, 0 },
            { gamedataStatType.RecoilUseDifferentStatsInADS, gameStatModifierType.Multiplier, 0 }
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(NoRecoil.handles, id)
            end
        end

        NoRecoil.appliedToWeaponID = weaponID
        Logger.Log(string.format("NoRecoil: applied modifiers to %s", tostring(weaponID)))
    end
end

function NoRecoil.Tick(deltaTime)
    if not NoRecoil.toggleNoRecoil.value then
        if #NoRecoil.handles > 0 then
            NoRecoil.SetNoRecoil(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #NoRecoil.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= NoRecoil.appliedToWeaponID then
            NoRecoil.SetNoRecoil(true)
            Logger.Log(string.format("NoRecoil: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            NoRecoil.SetNoRecoil(false)
        end
    end
end

return NoRecoil
