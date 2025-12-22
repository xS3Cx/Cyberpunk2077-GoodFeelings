local Logger = require("Core/Logger")
local Inventory = require("Utils").Inventory
local WeaponLoader = require("Utils/DataExtractors/WeaponLoader")

local WeaponActions = {}

function WeaponActions.GiveAllWallWeapons()
    local wallWeapons = WeaponLoader:Filter(function(w) return w.onWall end)
    for _, w in ipairs(wallWeapons) do
        Inventory.GiveItem(w.id, 1)
    end
    Logger.Log("WeaponActions: Gave all wall weapons.")
end

function WeaponActions.RemoveAllWeapons(rarity)
    local inventoryItems = Inventory:GetAllItems()
    for _, item in ipairs(inventoryItems) do
        if item and item.id and tostring(item.id):find("^Items%.") then
            local weaponData = WeaponLoader:GetById(item.id)
            if weaponData then
                local isMatch = not rarity or (weaponData.rarity and weaponData.rarity:lower() == rarity:lower())
                if isMatch then
                    Inventory.RemoveItem(item.id, item.count or 1)
                end
            end
        end
    end
    Logger.Log("WeaponActions: Removed weapons" .. (rarity and (" of rarity " .. rarity) or " (all)."))
end

function WeaponActions.GiveAllIconicWeapons()
    local iconicWeapons = WeaponLoader:Filter(function(w) return w.iconic end)
    for _, w in ipairs(iconicWeapons) do
        Inventory.GiveItem(w.id, 1)
    end
    Logger.Log("WeaponActions: Gave all iconic weapons.")
end

function WeaponActions.GiveWeaponsByCategory(category)
    local filtered = WeaponLoader:Filter(function(w) return w.category == category end)
    for _, w in ipairs(filtered) do
        Inventory.GiveItem(w.id, 1)
    end
    Logger.Log("WeaponActions: Gave all weapons in category " .. tostring(category))
end

function WeaponActions.GiveWeaponsByRarity(rarity)
    local filtered = WeaponLoader:Filter(function(w) return (w.rarity or ""):lower() == rarity:lower() end)
    for _, w in ipairs(filtered) do
        Inventory.GiveItem(w.id, 1)
    end
    Logger.Log("WeaponActions: Gave all " .. tostring(rarity) .. " weapons.")
end

function WeaponActions.RemoveBaseWeapons()
    WeaponActions.RemoveAllWeapons("Common")
    WeaponActions.RemoveAllWeapons("Base")
    Logger.Log("WeaponActions: Removed base/common weapons.")
end

return WeaponActions
