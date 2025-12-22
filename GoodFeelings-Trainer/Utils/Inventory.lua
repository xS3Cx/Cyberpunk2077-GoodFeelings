local Logger = require("Core/Logger")

local Inventory = {}

function Inventory.GiveItem(tweakID, quantity)
    if not tweakID or tweakID == "" then
        Logger.Log("Inventory: invalid TweakDBID passed to GiveItem")
        return false
    end

    quantity = quantity or 1

    local success, err = pcall(function()
        Game.AddToInventory(tweakID, quantity)
    end)

    if success then
        Logger.Log(string.format("Inventory: gave %d x %s", quantity, tweakID))
        return true
    else
        Logger.Log(string.format("Inventory: failed to give item %s (%s)", tweakID, tostring(err)))
        return false
    end
end

function Inventory.RemoveItem(tweakID, quantity)
    if not tweakID or tweakID == "" then
        Logger.Log("Inventory: invalid TweakDBID passed to RemoveItem")
        return false
    end

    if not TweakDB:GetRecord(tweakID) then
        Logger.Log(string.format("Inventory: '%s' is not a valid item ID", tweakID))
        return false
    end

    quantity = quantity or 1

    local player = Game.GetPlayer()
    local ts = Game.GetTransactionSystem()
    local itemList = { ts:GetItemList(player) }
    local removed = false

    for _, item in ipairs(itemList[2]) do
        local itemID = item:GetID()
        local currentQuantity = ts:GetItemQuantity(player, itemID)
        local currentID = TDBID.ToStringDEBUG(itemID.id)

        if currentID == tweakID and currentQuantity >= quantity then
            local displayName = Game.GetLocalizedTextByKey(TDB.GetLocKey(itemID.id .. ".displayName")) or currentID
            ts:RemoveItemByTDBID(player, tweakID, quantity)
            Logger.Log(string.format("Inventory: removed %d x %s", quantity, displayName))
            removed = true
            break
        end
    end

    if not removed then
        Logger.Log(string.format("Inventory: item not found or insufficient quantity (%s)", tweakID))
    end

    return removed
end

-- Get all items (returns table of {id, name, quantity, raw})
function Inventory.GetAllItems()
    local player = Game.GetPlayer()
    local ts = Game.GetTransactionSystem()
    local success, itemList = ts:GetItemList(player)
    local result = {}

    if not success then return result end

    for _, item in ipairs(itemList) do
        local itemID = item:GetID()
        local tdbid = TDBID.ToStringDEBUG(itemID.id)
        local name = Game.GetLocalizedTextByKey(TDB.GetLocKey(tdbid .. ".displayName"))
        if not name or name == "" then name = tdbid end

        table.insert(result, {
            id = tdbid,
            name = name,
            quantity = item.quantity or 1,
            raw = item
        })
    end

    return result
end

function Inventory.SpawnItemDropInFront(tweakDBIDStr, spawnDist)
    local player = Game.GetPlayer()
    if not player then return false end

    local forward = player:GetWorldForward()
    local offset = Vector3.new(forward.x * spawnDist, forward.y * spawnDist, 0.5)

    local transform = player:GetWorldTransform()
    local pos = transform.Position:ToVector4()
    local spawnPos = Vector4.new(pos.x + offset.x, pos.y + offset.y, pos.z + offset.z, 1.0)

    transform:SetPosition(transform, spawnPos)

    local itemID = ItemID.FromTDBID(tweakDBIDStr)
    local tags = { CName.new("EasyTrainer") }

    local lootMgr = Game.GetLootManager()
    local success = lootMgr:SpawnItemDrop(player, itemID, spawnPos, Quaternion.new(0, 0, 0, 1))

    if success then
        Logger.Log(string.format("Inventory: spawned %s at (%.2f, %.2f, %.2f)", tweakDBIDStr, spawnPos.x, spawnPos.y, spawnPos.z))
    else
        Logger.Log("Inventory: failed to spawn item drop")
    end

    return success
end

return Inventory
