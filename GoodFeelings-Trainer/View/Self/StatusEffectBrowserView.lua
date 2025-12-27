local Buttons = require("UI").Buttons
local StatusEffectLoader = require("Utils/DataExtractors/StatusEffectLoader")
local StatusEffectBrowser = require("Features/Self/StatusEffectBrowser")
local Notification = require("UI").Notification

-- Search state
local searchQuery = { value = "" }
local searchResults = {}
local lastQuery = ""

-- Category views
local categoryViews = {}

local function ApplyEffectToPlayer(effect)
    if StatusEffectBrowser.ApplyToPlayer(effect.id) then
        Notification.Success("Applied: " .. effect.displayName)
    else
        Notification.Error("Failed to apply: " .. effect.displayName)
    end
end

local function ApplyEffectToTarget(effect)
    if StatusEffectBrowser.ApplyToTarget(effect.id) then
        Notification.Success("Applied to target: " .. effect.displayName)
    else
        Notification.Error("No valid target or failed to apply")
    end
end

local function CreateEffectOption(effect)
    local current = StatusEffectBrowser.GetCurrentEffect()
    local marker = (current == effect.id) and " [X]" or ""
    
    Buttons.OptionExtended(
        effect.displayName .. marker,
        "",
        "Apply",
        "Click to apply this status effect",
        function()
            ApplyEffectToPlayer(effect)
        end
    )
end

-- Category view generator
local function CreateCategoryView(categoryName)
    return function()
        local effects = StatusEffectLoader:GetCategory(categoryName)
        
        if #effects == 0 then
            Buttons.Option("No effects in this category", "")
            return
        end
        
        Buttons.Break("Apply To")
        Buttons.Option("Apply to Player (Default)", "Click effect to apply to yourself")
        Buttons.Option("Apply to Target", "Look at NPC and click effect", function()
            Notification.Info("Look at an NPC and click an effect to apply it")
        end)
        
        Buttons.Break(categoryName .. " Effects (" .. #effects .. ")")
        
        for _, effect in ipairs(effects) do
            CreateEffectOption(effect)
        end
    end
end

-- Quick Set views
local quickSetViews = {}

local function CreateQuickSetView(setData)
    return function()
        Buttons.Break(setData.name .. " (" .. #setData.effects .. ")")
        
        for _, effect in ipairs(setData.effects) do
            CreateEffectOption(effect)
        end
    end
end

-- Search view
local function SearchViewFunction()
    Buttons.Text("Search Effects", searchQuery, "Type to filter effects by name")
    
    if searchQuery.value ~= lastQuery then
        lastQuery = searchQuery.value
        searchResults = StatusEffectLoader:Search(searchQuery.value)
    end
    
    Buttons.Break("Search Results (" .. #searchResults .. ")")
    
    if #searchResults == 0 then
        Buttons.Option("No results found", "Try a different search term")
        return
    end
    
    for _, effect in ipairs(searchResults) do
        CreateEffectOption(effect)
    end
end

local SearchView = { title = "Search Effects", view = SearchViewFunction }

-- Initialize category views
local function InitializeCategoryViews()
    if next(categoryViews) ~= nil then return end
    
    local categories = StatusEffectLoader:GetCategories()
    
    for _, categoryName in ipairs(categories) do
        categoryViews[categoryName] = {
            title = categoryName .. " Effects",
            view = CreateCategoryView(categoryName)
        }
    end
end

-- Initialize quick set views
local function InitializeQuickSetViews()
    if next(quickSetViews) ~= nil then return end
    
    local quickSets = StatusEffectLoader:GetQuickSets()
    
    for _, setData in ipairs(quickSets) do
        table.insert(quickSetViews, {
            title = setData.name,
            view = CreateQuickSetView(setData)
        })
    end
end

-- Main browser view
local function StatusEffectBrowserViewFunction()
    InitializeCategoryViews()
    InitializeQuickSetViews()
    
    Buttons.Break("Quick Access")
    Buttons.Submenu("Search Effects", SearchView, "Search for effects by name")
    
    Buttons.Break("Quick Sets")
    for _, quickSet in ipairs(quickSetViews) do
        Buttons.Submenu(quickSet.title, quickSet, "Pre-selected useful effects")
    end
    
    Buttons.Break("Categories")
    for _, categoryName in ipairs(StatusEffectLoader:GetCategories()) do
        local view = categoryViews[categoryName]
        if view then
            Buttons.Submenu(view.title, view, "Browse " .. categoryName:lower() .. " effects")
        end
    end
    
    Buttons.Break("Current Status")
    local current = StatusEffectBrowser.GetCurrentEffect()
    if current then
        local effect = StatusEffectLoader:GetById(current)
        if effect then
            Buttons.Option("Active: " .. effect.displayName, "Last applied effect")
        end
    else
        Buttons.Option("No effect applied", "")
    end
end

local StatusEffectBrowserView = { 
    title = "Status Effect Browser", 
    view = StatusEffectBrowserViewFunction 
}

return StatusEffectBrowserView
