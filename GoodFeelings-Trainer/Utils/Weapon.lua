-- Utils/Weapon.lua
local Weapon = {
    isAiming = false,
    isShooting = false,
    lastWeaponID = nil,
    hasChanged = false,
    lastCheckTime = 0,
    checkInterval = 1
}

function Weapon.HandleInputAction(action)
    local player = Game.GetPlayer()
    if not player then return end

    Weapon.isAiming = player.isAiming

    local actionName = Game.NameToString(action:GetName(action))
    local actionType = action:GetType(action).value

    if actionName == "RangedAttack" then
        if actionType == "BUTTON_PRESSED" then
            Weapon.isShooting = true
        elseif actionType == "BUTTON_RELEASED" then
            Weapon.isShooting = false
        end
    end
end

function Weapon.IsPlayerAiming()
    return Weapon.isAiming
end

function Weapon.IsPlayerShooting()
    return Weapon.isShooting
end

-- Get all ranged weapons in inventory (returns { {id, data}, ... })
function Weapon.GetAllRangedWeapons()
    local player = Game.GetPlayer()
    local ts = Game.GetTransactionSystem()
    if not player or not ts then return {} end

    local success, allItems = ts:GetItemList(player)
    if not success or type(allItems) ~= "table" then
        return {}
    end

    local ranged = {}
    for _, itemData in ipairs(allItems) do
        if itemData
            and itemData:HasTag(CName("Weapon"))
            and itemData:HasTag(CName("RangedWeapon")) then
            table.insert(ranged, {
                id   = itemData:GetID(),
                data = itemData
            })
        end
    end
    return ranged
end

-- Get equipped right-hand weapon (returns {item, itemData, itemID} or nils)
function Weapon.GetEquippedRightHand()
    local player = Game.GetPlayer()
    local ts = Game.GetTransactionSystem()
    if not player or not ts then return nil, nil, nil end

    local item = ts:GetItemInSlot(player, "AttachmentSlots.WeaponRight")
    if not item then return nil, nil, nil end

    local itemData = item:GetItemData()
    if not itemData then return item, nil, item:GetItemID() end

    return item, itemData, item:GetItemID()
end

function Weapon.IsRangedEquipped()
    local _, itemData = Weapon.GetEquippedRightHand()
    return itemData and itemData:HasTag(CName("RangedWeapon")) or false
end

function Weapon.IsMeleeEquipped()
    local _, itemData = Weapon.GetEquippedRightHand()
    return itemData and itemData:HasTag(CName("Melee")) or false -- Actually don't remember if the tags include this word but I assume they would
end

function Weapon.IsShootingRangedADS()
    return Weapon.isAiming
       and Weapon.isShooting
       and Weapon.IsRangedEquipped()
end

function Weapon.IsShootingRanged()
    return Weapon.isShooting and Weapon.IsRangedEquipped()
end

function Weapon.Tick(deltaTime)
    local _, _, itemID = Weapon.GetEquippedRightHand()
    if not itemID then return end

    if itemID ~= Weapon.lastWeaponID then
        Weapon.hasChanged = true
        Weapon.lastWeaponID = itemID
    end
end

function Weapon.HasChanged()
    if Weapon.hasChanged then
        Weapon.hasChanged = false
        return true
    end
    return false
end


function Weapon.GetCurrentWeaponID()
    return Weapon.lastWeaponID
end

return Weapon
