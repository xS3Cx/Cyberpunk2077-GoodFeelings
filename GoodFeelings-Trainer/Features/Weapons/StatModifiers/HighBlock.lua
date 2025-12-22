local Logger = require("Core/Logger")
local StatModifiers = require("Utils/StatModifiers")
local Weapon = require("Utils/Weapon")

local HighBlock = {}

HighBlock.toggleHighBlock = { value = false }
HighBlock.handles = {}
HighBlock.appliedToWeaponID = nil

function HighBlock.SetHighBlock(remove)
    local _, itemData, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if remove then
        for _, id in ipairs(HighBlock.handles) do
            StatModifiers.Remove(id)
        end
        Logger.Log(string.format("HighBlock: removed modifiers from %s", tostring(HighBlock.appliedToWeaponID)))
        HighBlock.handles = {}
        HighBlock.appliedToWeaponID = nil
    else
        local weaponID = itemData and itemData:GetStatsObjectID()
        if not weaponID then return end

        local id = StatModifiers.CreateForWeapon(gamedataStatType.BlockFactor, gameStatModifierType.Multiplier, 100, weaponID)
        if id then
            StatModifiers.Apply(id)
            table.insert(HighBlock.handles, id)
        end

        HighBlock.appliedToWeaponID = weaponID
        Logger.Log(string.format("HighBlock: applied modifiers to %s", tostring(weaponID)))
    end
end

function HighBlock.Tick(deltaTime)
    if not HighBlock.toggleHighBlock.value then
        if #HighBlock.handles > 0 then
            HighBlock.SetHighBlock(true)
        end
        return
    end

    Weapon.Tick(deltaTime)

    if (Weapon.HasChanged() or #HighBlock.handles == 0) and Weapon.IsMeleeEquipped() then
        local newWeaponID = Weapon.GetCurrentWeaponID()
        if newWeaponID ~= HighBlock.appliedToWeaponID then
            HighBlock.SetHighBlock(true)
            Logger.Log(string.format("HighBlock: Weapon changed > reapplying modifiers to %s", tostring(newWeaponID)))
            HighBlock.SetHighBlock(false)
        end
    end
end

return HighBlock
