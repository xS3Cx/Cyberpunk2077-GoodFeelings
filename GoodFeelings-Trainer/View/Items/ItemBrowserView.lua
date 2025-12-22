local UI = require("UI")
local Buttons = UI.Buttons
local Logger = require("Core/Logger")
local GeneralLoader = require("Utils/DataExtractors/GeneralLoader")
local ItemsView = require("View/Items/ItemsView")
local Inventory = require("Utils").Inventory

local filters = {
    quality = { index = 2 }, -- Start at common so it doesn't lag too much
    tag = { index = 1 },
    coreCW  = { value = false },
    craftable = { value = false }

}

local categorizedCache = nil
local initialized = false

local function EnsureInitialized()
    if not initialized then
        GeneralLoader:LoadAll()
        categorizedCache = GeneralLoader:Categorize()
        initialized = true
    end
end

local function BuildQualities(items)
    local list, seen = { "All" }, {}
    for _, it in ipairs(items) do
        if it.quality and not seen[it.quality] then
            seen[it.quality] = true
            table.insert(list, it.quality)
        end
    end
    return list
end

local function BuildTags(items)
    local list, seen = { "All" }, {}
    for _, it in ipairs(items) do
        if it.tags then
            for _, t in ipairs(it.tags) do
                if not seen[t] then
                    seen[t] = true
                    table.insert(list, t)
                end
            end
        end
    end
    return list
end

local function PassesFilters(item, parent, qualities, tags)
    if parent == "Cyberware" and filters.coreCW.value and not item.isCoreCW then
        return false
    end

    local q = qualities[filters.quality.index or 1]
    if q and q ~= "All" and item.quality ~= q then
        return false
    end

    local t = tags[filters.tag.index or 1]
    if t and t ~= "All" then
        local match = false
        for _, tag in ipairs(item.tags or {}) do
            if tag == t then
                match = true
                break
            end
        end
        if not match then return false end
    end

    if not filters.craftable.value and item.isCraftable then
        return false
    end

    return true
end

-- Subcategory view
local function ItemSubcategoryView(context)
    local parent, sub, items = context.parent, context.sub, context.items

    local qualities = BuildQualities(items)
    local tags      = BuildTags(items)

    if parent == "Cyberware" then
        Buttons.Toggle("Core Cyberware Only", filters.coreCW)
    end

    Buttons.StringCycler("Quality", filters.quality, qualities)
    Buttons.StringCycler("Tag", filters.tag, tags)
    Buttons.Toggle("Show Craftable Items", filters.craftable, "Toggle to show items marked as craftable")

    Buttons.Break("", sub .. " (" .. tostring(#items) .. ")")

    for _, it in ipairs(items) do
        if PassesFilters(it, parent, qualities, tags) then
            Buttons.Option(it.id, "Give item: " .. it.name, function()
                Inventory.GiveItem(it.id, 1)
            end)
        end
    end
end

local function ItemParentView(context)
    local parent, subcats = context.parent, context.subcats

    for sub, items in pairs(subcats) do
        if #items > 0 then
            local subMenu = {
                title = sub,
                view  = function() ItemSubcategoryView({ parent = parent, sub = sub, items = items }) end
            }
            Buttons.Submenu(sub, subMenu, "Browse " .. sub)
        end
    end
end

local searchRef = { value = "Junk", capturing = false }

local function SearchView()

    Buttons.Text("Search Item ID", searchRef, "Type part of an item ID to filter items. Default: Junk")
    Buttons.Break("", "Search results for: " .. (searchRef.value or ""))

    local term = (searchRef.value or ""):lower()
    if term == "" then return end

    for _, items in pairs(categorizedCache) do
        for _, subitems in pairs(items) do
            for _, it in ipairs(subitems) do
                if it.id and it.id:lower():find(term, 1, true) then
                    Buttons.Option(it.id, "Give item: " .. it.name, function()
                        Logger.Log("Give item: " .. it.id)
                    end)
                end
            end
        end
    end
end
local searchMenu = { title = "Search by ID", view = SearchView }

-- Main view
local function ItemMainView()
    EnsureInitialized()
    Buttons.Submenu("Essentials Items", ItemsView, "Give all, recipes, and consumables")
    Buttons.Submenu("Search by ID", searchMenu, "Search items by ID substring")

    Buttons.Break("", "Item Browser(Alpha)")
    
    for parent, subcats in pairs(categorizedCache) do
        local parentMenu = {
            title = parent,
            view  = function() ItemParentView({ parent = parent, subcats = subcats }) end
        }
        Buttons.Submenu(parent, parentMenu, "Browse " .. parent)
    end
end

return {
    title = "Items Menu",
    view  = ItemMainView
}
