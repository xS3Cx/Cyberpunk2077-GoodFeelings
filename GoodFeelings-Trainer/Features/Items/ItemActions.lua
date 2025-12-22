local Logger = require("Core/Logger")
local Inventory = require("Utils").Inventory

local CraftingComponents = require("Features/Items/ItemsCraftingComponents")
local Consumables = require("Features/Items/ItemsConsumables")
local ItemBuffs = require("Features/Items/ItemsBuffs")

local ItemActions = {}

local function GiveAll(list, amount, label)
    amount = amount or 1
    for _, data in ipairs(list) do
        Inventory.GiveItem(data.id, amount)
    end
    Logger.Log(("ItemActions: Gave all %s x%d."):format(label, amount))
end

local function GiveByGroup(list, group, amount, label)
    amount = amount or 1
    for _, data in ipairs(list) do
        if data.group == group then
            Inventory.GiveItem(data.id, amount)
        end
    end
    Logger.Log(("ItemActions: Gave %s (%s) x%d."):format(label, group, amount))
end

function ItemActions.GiveAllCraftingComponents(amount)
    GiveAll(CraftingComponents, amount, "crafting components")
end

function ItemActions.GiveItemComponents(amount)
    GiveByGroup(CraftingComponents, "ItemComponent", amount, "item components")
end

function ItemActions.GiveQuickhackComponents(amount)
    GiveByGroup(CraftingComponents, "QuickhackComponent", amount, "quickhack components")
end

function ItemActions.GiveUpgradeComponents(amount)
    GiveByGroup(CraftingComponents, "UpgradeComponent", amount, "upgrade components")
end

function ItemActions.GiveSpecialComponents(amount)
    GiveByGroup(CraftingComponents, "Special", amount, "special crafting components")
end

function ItemActions.GiveAllConsumables(amount)
    GiveAll(Consumables, amount, "consumables")
end

function ItemActions.GiveMaxDocs(amount)
    GiveByGroup(Consumables, "MaxDoc", amount, "MaxDocs")
end

function ItemActions.GiveBounceBacks(amount)
    GiveByGroup(Consumables, "BounceBack", amount, "BounceBacks")
end

function ItemActions.GiveBoosters(amount)
    GiveByGroup(Consumables, "Booster", amount, "boosters")
end

function ItemActions.GiveAllBuffs(amount)
    GiveAll(ItemBuffs, amount, "buffs")
end

function ItemActions.GiveBuffsByGroup(group, amount)
    GiveByGroup(ItemBuffs, group, amount, "buffs")
end

return ItemActions
