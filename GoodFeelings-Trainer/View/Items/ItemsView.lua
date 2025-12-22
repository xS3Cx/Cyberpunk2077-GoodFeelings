-- View/Items/ItemsView.lua
local UI        = require("UI")
local Buttons   = UI.Buttons
local Inventory = require("Utils").Inventory
local Items     = require("Features/Items/")

local CraftingComponents = Items.CraftingComponents
local Consumables        = Items.Consumables
local ItemBuffs          = Items.Buffs
local ItemActions        = Items.Actions
local ItemModRecipes     = Items.ModRecipes
local ItemQuickhackRecipes = Items.QuickhackRecipes
local ItemWeaponRecipes  = Items.WeaponRecipes
local ItemClothingRecipes= Items.ClothingRecipes
local ItemGrenadeRecipes = Items.GrenadeRecipes

local refs = {
    allCrafting   = { value = 1, min = 1, max = 999, step = 1 },
    itemComp      = { value = 1, min = 1, max = 999, step = 1 },
    quickhackComp = { value = 1, min = 1, max = 999, step = 1 },
    upgradeComp   = { value = 1, min = 1, max = 999, step = 1 },
    allConsum     = { value = 1, min = 1, max = 999, step = 1 },
    bounceBacks   = { value = 1, min = 1, max = 999, step = 1 },
    maxDocs       = { value = 1, min = 1, max = 999, step = 1 },
    boosters      = { value = 1, min = 1, max = 999, step = 1 },
    allBuffs      = { value = 1, min = 1, max = 999, step = 1 },
}

-- === Give All submenu ===
local function ItemsGiveAllView()
    Buttons.IntClick("Give All Crafting Components", refs.allCrafting,
        "Gives all crafting components at once.", function()
            ItemActions.GiveAllCraftingComponents(refs.allCrafting.value)
        end)

    Buttons.IntClick("Give Item Components", refs.itemComp,
        "Gives basic item components.", function()
            ItemActions.GiveItemComponents(refs.itemComp.value)
        end)

    Buttons.IntClick("Give Quickhack Components", refs.quickhackComp,
        "Gives quickhack components.", function()
            ItemActions.GiveQuickhackComponents(refs.quickhackComp.value)
        end)

    Buttons.IntClick("Give Upgrade Components", refs.upgradeComp,
        "Gives upgrade components.", function()
            ItemActions.GiveUpgradeComponents(refs.upgradeComp.value)
        end)

    Buttons.IntClick("Give All Consumables", refs.allConsum,
        "Gives all consumables (MaxDocs, BounceBacks, Boosters).", function()
            ItemActions.GiveAllConsumables(refs.allConsum.value)
        end)

    Buttons.IntClick("Give MaxDocs", refs.maxDocs,
        "Gives all MaxDocs.", function()
            ItemActions.GiveMaxDocs(refs.maxDocs.value)
        end)

    Buttons.IntClick("Give BounceBacks", refs.bounceBacks,
        "Gives all BounceBacks.", function()
            ItemActions.GiveBounceBacks(refs.bounceBacks.value)
        end)

    Buttons.IntClick("Give Boosters", refs.boosters,
        "Gives all boosters.", function()
            ItemActions.GiveBoosters(refs.boosters.value)
        end)

    Buttons.IntClick("Give All Buffs", refs.allBuffs,
        "Gives all buffs (blackmarket, boosters, food).", function()
            ItemActions.GiveAllBuffs(refs.allBuffs.value)
        end)
end

local giveAllMenu = { title = "Give All", view = ItemsGiveAllView }

local compRefs, consumRefs, buffRefs = nil, nil, nil

local function ItemsMainView()
    if not compRefs then
        compRefs = {}
        for i, _ in ipairs(CraftingComponents) do
            compRefs[i] = { value = 1, min = 1, max = 5000, step = 1 }
        end
    end
    if not consumRefs then
        consumRefs = {}
        for i, _ in ipairs(Consumables) do
            consumRefs[i] = { value = 1, min = 1, max = 5000, step = 1 }
        end
    end
    if not buffRefs then
        buffRefs = {}
        for i, _ in ipairs(ItemBuffs) do
            buffRefs[i] = { value = 1, min = 1, max = 5000, step = 1 }
        end
    end

    Buttons.Submenu("Give All", giveAllMenu, "Bulk give items by category")
    Buttons.Option("Give All Mod Recipes", "Unlocks every cyberware & weapon mod recipe.",
        ItemModRecipes.GiveAllModRecipes)
    Buttons.Option("Give All Quickhack Recipes", "Unlocks all quickhack crafting recipes.",
        ItemQuickhackRecipes.GiveAllQuickhackRecipes)
    Buttons.Option("Give All Weapon Recipes", "Unlocks all weapon crafting recipes.",
        ItemWeaponRecipes.GiveAllWeaponRecipes)
    Buttons.Option("Give All Clothing Recipes", "Unlocks all clothing recipes.",
        ItemClothingRecipes.GiveAllClothingRecipes)
    Buttons.Option("Give All Grenade Recipes", "Unlocks all grenade crafting recipes.",
        ItemGrenadeRecipes.GiveAllGrenadeRecipes)

    local lastGroup = nil
    for i, data in ipairs(CraftingComponents) do
        if data.group ~= lastGroup then
            Buttons.Break("", data.group)
            lastGroup = data.group
        end
        local ref = compRefs[i]
        Buttons.IntClick(data.name, ref,
            "Give: " .. data.name, function()
                Inventory.GiveItem(data.id, ref.value)
            end)
    end

    lastGroup = nil
    for i, data in ipairs(Consumables) do
        if data.group ~= lastGroup then
            Buttons.Break("", data.group)
            lastGroup = data.group
        end
        local ref = consumRefs[i]
        Buttons.IntClick(data.name, ref,
            "Give: " .. data.name, function()
                Inventory.GiveItem(data.id, ref.value)
            end)
    end

    lastGroup = nil
    for i, data in ipairs(ItemBuffs) do
        if data.group ~= lastGroup then
            Buttons.Break("", data.group)
            lastGroup = data.group
        end
        local ref = buffRefs[i]
        Buttons.IntClick(data.name, ref,
            "Give: " .. data.name, function()
                Inventory.GiveItem(data.id, ref.value)
            end)
    end
end

return { title = "Items", view = ItemsMainView }
