-- View/FxPlayer/FxPlayerView.lua
local UI = require("UI")
local Buttons = UI.Buttons

local FxPlayer = require('FxPlayer/modules/fxPlayer')
local effects = FxPlayer.FilterAllEffectToMenu()

-- Dynamically extract categories from effect paths
local function ExtractCategories()
    local categorySet = {}
    local categories = {}
    
    for _, effect in pairs(effects) do
        -- Extract main category from path (e.g., "camera", "characters", "devices")
        -- Pattern: base\fx\CATEGORY\...
        local category = string.match(effect.effect, "base\\fx\\([^\\]+)\\")
        if category and not categorySet[category] then
            categorySet[category] = true
            table.insert(categories, category)
        end
    end
    
    table.sort(categories)
    return categories
end

local categories = ExtractCategories()

-- Create category view function
local function CreateCategoryView(categoryName)
    local searchText = { value = "" }
    
    return function()
        Buttons.Break("Search")
        Buttons.Text("Filter", searchText, "Filter effects by name")
        
        local filteredEffects = {}
        
        -- Filter effects for this category
        for _, effect in pairs(effects) do
            local matchesCategory = string.find(effect.effect, "base\\fx\\" .. categoryName .. "\\")
            local matchesSearch = searchText.value == "" or string.find(string.lower(effect.name), string.lower(searchText.value))
            
            if matchesCategory and matchesSearch then
                table.insert(filteredEffects, effect)
            end
        end
        
        Buttons.Break(string.format("Effects (%d)", #filteredEffects))
        
        for _, effect in pairs(filteredEffects) do
            if Buttons.Option(effect.name, "Spawn this effect in front of player") then
                local playerEntity = Game.GetPlayer()
                local playerCoords = playerEntity:GetWorldPosition()
                local playerForward = playerEntity:GetWorldForward()

                local transform = WorldTransform.new()
                transform:SetOrientation(playerEntity:GetWorldOrientation())
                transform:SetPosition(Vector4.new(
                    playerCoords.x + playerForward.x * 2, 
                    playerCoords.y + playerForward.y * 2, 
                    playerCoords.z, 
                    0
                ))

                FxPlayer.PlayEffectOnCoords(transform, effect.effect)
                UI.Notification.Success("Spawned: " .. effect.name)
            end
        end
    end
end

-- Generate category submenus dynamically
local categoryViews = {}
for _, category in ipairs(categories) do
    local displayName = category:sub(1,1):upper() .. category:sub(2) -- Capitalize first letter
    categoryViews[category] = {
        title = displayName,
        view = CreateCategoryView(category)
    }
end

-- Create "All Effects" view
local allEffectsSearch = { value = "" }
local allEffectsView = {
    title = "All Effects",
    view = function()
        Buttons.Break("Search")
        Buttons.Text("Filter", allEffectsSearch, "Search across all effects")
        
        local filteredEffects = {}
        
        for _, effect in pairs(effects) do
            local matchesSearch = allEffectsSearch.value == "" or string.find(string.lower(effect.name), string.lower(allEffectsSearch.value))
            
            if matchesSearch then
                table.insert(filteredEffects, effect)
            end
        end
        
        Buttons.Break(string.format("Effects (%d)", #filteredEffects))
        
        for _, effect in pairs(filteredEffects) do
            if Buttons.Option(effect.name, "Spawn this effect in front of player") then
                local playerEntity = Game.GetPlayer()
                local playerCoords = playerEntity:GetWorldPosition()
                local playerForward = playerEntity:GetWorldForward()

                local transform = WorldTransform.new()
                transform:SetOrientation(playerEntity:GetWorldOrientation())
                transform:SetPosition(Vector4.new(
                    playerCoords.x + playerForward.x * 2, 
                    playerCoords.y + playerForward.y * 2, 
                    playerCoords.z, 
                    0
                ))

                FxPlayer.PlayEffectOnCoords(transform, effect.effect)
                UI.Notification.Success("Spawned: " .. effect.name)
            end
        end
    end
}

local function FxPlayerViewFunction()
    Buttons.Break("Effect Categories")
    
    -- All Effects submenu first
    Buttons.Submenu("All Effects", allEffectsView, "Browse and search all effects")
    
    -- Create submenu for each category
    for _, category in ipairs(categories) do
        local displayName = category:sub(1,1):upper() .. category:sub(2)
        Buttons.Submenu(displayName, categoryViews[category], "Browse " .. displayName .. " effects")
    end
end

return {
    title = "FX Player",
    view = FxPlayerViewFunction
}
