local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local ShotgunSpray = {}

ShotgunSpray.toggleShotgunSpray = { value = false }
ShotgunSpray.normalizeDamage = true
ShotgunSpray.handles = {}
ShotgunSpray.appliedToWeaponID = nil

function ShotgunSpray.SetShotgunSpray(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(ShotgunSpray.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("ShotgunSpray: removed modifiers from %s", tostring(ShotgunSpray.appliedToWeaponID)))
        ShotgunSpray.handles = {}
        ShotgunSpray.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local projID = StatModifiers.CreateForWeapon(gamedataStatType.ProjectilesPerShot, gameStatModifierType.Additive, 15, weaponID)
        if projID then
            StatModifiers.Apply(projID)
            table.insert(ShotgunSpray.handles, projID)
        end

        if ShotgunSpray.normalizeDamage then
            local dmgID = StatModifiers.CreateForWeapon(gamedataStatType.DamagePerHit, gameStatModifierType.Multiplier, 0.1, weaponID)
            if dmgID then
                StatModifiers.Apply(dmgID)
                table.insert(ShotgunSpray.handles, dmgID)
            end
        end

        ShotgunSpray.appliedToWeaponID = weaponID
        Logger.Log(string.format("ShotgunSpray: applied modifiers to %s", tostring(weaponID)))
    end
end

function ShotgunSpray.Tick(deltaTime)
    if not ShotgunSpray.toggleShotgunSpray.value then
        if #ShotgunSpray.handles > 0 then
            ShotgunSpray.SetShotgunSpray(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #ShotgunSpray.handles == 0) and Weapon.IsRangedEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= ShotgunSpray.appliedToWeaponID then
            ShotgunSpray.SetShotgunSpray(true)
            Logger.Log(string.format("ShotgunSpray: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            ShotgunSpray.SetShotgunSpray(false)
        end
    end
end

return ShotgunSpray
