local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local PenetrationRounds = {}

PenetrationRounds.togglePenetrationRounds = { value = false }
PenetrationRounds.handles = {}
PenetrationRounds.appliedToWeaponID = nil

function PenetrationRounds.SetPenetrationRounds(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(PenetrationRounds.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("PenetrationRounds: removed modifiers from %s", tostring(PenetrationRounds.appliedToWeaponID)))
        PenetrationRounds.handles = {}
        PenetrationRounds.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local modifiers = {
            { gamedataStatType.TechPierceEnabled, gameStatModifierType.Additive, 1 },
            { gamedataStatType.CanWeaponIgnoreArmor, gameStatModifierType.Additive, 1 },
        }

        for _, m in ipairs(modifiers) do
            local id = StatModifiers.CreateForWeapon(m[1], m[2], m[3], weaponID)
            if id then
                StatModifiers.Apply(id)
                table.insert(PenetrationRounds.handles, id)
            end
        end

        PenetrationRounds.appliedToWeaponID = weaponID
        Logger.Log(string.format("PenetrationRounds: applied modifiers to %s", tostring(weaponID)))
    end
end

function PenetrationRounds.Tick(deltaTime)
    if not PenetrationRounds.togglePenetrationRounds.value then
        if #PenetrationRounds.handles > 0 then
            PenetrationRounds.SetPenetrationRounds(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #PenetrationRounds.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= PenetrationRounds.appliedToWeaponID then
            PenetrationRounds.SetPenetrationRounds(true)
            Logger.Log(string.format("PenetrationRounds: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            PenetrationRounds.SetPenetrationRounds(false)
        end
    end
end

return PenetrationRounds
