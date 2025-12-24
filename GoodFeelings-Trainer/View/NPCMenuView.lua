local UI = require("UI")
local Buttons = UI.Buttons
local NPCSpawner = require("Features/NPC/NPCSpawner")
local NPCGun = require("Features/NPC/NPCGun") -- Added NPCGun

-- State for filters
local filters = {
    faction = { index = 1, expanded = false },
    psycho = { value = false },
    gender = { index = 1, expanded = false },
    netrunner = { index = 1, expanded = false },
    drone = { index = 1, expanded = false },
    weapon = { index = 1, expanded = false },
    
    -- Rarity
    weak = { value = true },
    normal = { value = true },
    rare = { value = true },
    elite = { value = true },
    
    -- Weapon kinds
    melee = { value = true },
    power = { value = true },
    smart = { value = true },
    tech = { value = true },
    
    -- Weapon types
    assault = { value = true },
    blunt = { value = true },
    edged = { value = true },
    hmg = { value = true },
    lmg = { value = true },
    pistol = { value = true },
    precision = { value = true },
    revolver = { value = true },
    smg = { value = true },
    shotgun = { value = true },
    sniper = { value = true },
    
    -- Spawn settings
    spawnNumber = { value = 1, step = 1, min = 1, max = 30 },
    spawnDistance = { value = 3, step = 1, min = 1, max = 10 },
    invisible = { value = false }
}

-- Single enemy state
local selectedCategory = nil
local selectedEnemy = nil

-- Cache for dropdowns
local allEnemies = nil
local allFactions = nil
local allWeapons = nil
local genderOptions = {"Random", "Female", "Male"}
local netrunnerOptions = {"Random", "Only Netrunners", "No Netrunners"}
local droneOptions = {"Random", "Only Humans", "Only Drones, Mechs and Robots"}

local function InitializeData()
    if not allEnemies then
        allEnemies = NPCSpawner.GetAllEnemies()
    end
    if not allFactions then
        allFactions = NPCSpawner.GetFactions()
        table.insert(allFactions, 1, "Random")
    end
    if not allWeapons then
        allWeapons = NPCSpawner.GetWeapons()
        table.insert(allWeapons, 1, "Random")
    end
end

-- Convert filters to SimpleEnemySpawner format
local function GetFilterData()
    return {
        faction = allFactions[filters.faction.index],
        psycho = filters.psycho.value,
        gender = genderOptions[filters.gender.index],
        netrunner = netrunnerOptions[filters.netrunner.index],
        drone = droneOptions[filters.drone.index],
        weapon = allWeapons[filters.weapon.index],
        weak = filters.weak.value,
        normal = filters.normal.value,
        rare = filters.rare.value,
        elite = filters.elite.value,
        melee = filters.melee.value,
        power = filters.power.value,
        smart = filters.smart.value,
        tech = filters.tech.value,
        assault = filters.assault.value,
        blunt = filters.blunt.value,
        edged = filters.edged.value,
        hmg = filters.hmg.value,
        lmg = filters.lmg.value,
        pistol = filters.pistol.value,
        precision = filters.precision.value,
        revolver = filters.revolver.value,
        smg = filters.smg.value,
        shotgun = filters.shotgun.value,
        sniper = filters.sniper.value,
        spawnNumber = filters.spawnNumber.value,
        spawnDistance = filters.spawnDistance.value,
        invisible = filters.invisible.value
    }
end

-- Category View for Single Enemy
local function CreateCategoryView(categoryName)
    local function RenderCategory()
        local enemies = NPCSpawner.GetEnemies(categoryName)
        if not enemies or #enemies == 0 then
            ImGui.Text("No enemies found")
            return
        end
        
        for _, npc in ipairs(enemies) do
            Buttons.Option(npc.name, "Select " .. npc.name, function()
                selectedCategory = categoryName
                selectedEnemy = npc.id
                NPCGun.currentEnemy = npc.id -- Set for Gun
            end)
        end
    end
    
    return { title = categoryName, view = RenderCategory }
end

-- Generate category views
local CategoryViews = {}
local function InitializeCategoryViews()
    if next(CategoryViews) then return end
    
    InitializeData()
    for _, faction in ipairs(allFactions) do
        if faction ~= "Random" then
            CategoryViews[faction] = CreateCategoryView(faction)
        end
    end
end

-- NPC Selector View (Used to be RenderSingleEnemy)
local function RenderNPCSelector()
    InitializeData()
    InitializeCategoryViews()
    
    local sortedFactions = {}
    for _, faction in ipairs(allFactions) do
        if faction ~= "Random" then
            table.insert(sortedFactions, faction)
        end
    end
    table.sort(sortedFactions)
    
    for _, faction in ipairs(sortedFactions) do
        Buttons.Submenu(faction, CategoryViews[faction], "Browse " .. faction .. " enemies")
    end
end

local NPCSelectorView = { title = "Select NPC", view = RenderNPCSelector }

-- Group Spawn View
local function RenderGroupSpawn()
    InitializeData()
    
    -- Spawn Group Button (First Option)
    Buttons.Option("Spawn Group", "Spawn enemies with current filters", function()
        if filters.invisible.value then
            Game.GetPlayer():SetInvisible(true)
            Game.GetPlayer():UpdateVisibility()
        else
            Game.GetPlayer():SetInvisible(false)
            Game.GetPlayer():UpdateVisibility()
        end
        NPCSpawner.DarkSpawn(GetFilterData())
    end)

    -- Passive NPCs Toggle
    Buttons.Toggle("Passive NPCs", filters.invisible, "Spawned NPCs ignore player (invisible mode)")

    Buttons.Int("Enemy Number", filters.spawnNumber, "Number of enemies to spawn (1-30)")
    Buttons.Int("Spawn Distance", filters.spawnDistance, "Distance from player (1-10 meters)")
    
    Buttons.Break("Filters")
    
    Buttons.Dropdown("Faction", filters.faction, allFactions, "Select faction")
    Buttons.Toggle("Include Psychos", filters.psycho, "Include MaxTac and Psycho enemies")
    
    Buttons.Break("Rarity")
    Buttons.Toggle("Weak", filters.weak, "Include weak enemies")
    Buttons.Toggle("Normal", filters.normal, "Include normal enemies")
    Buttons.Toggle("Rare", filters.rare, "Include rare enemies")
    Buttons.Toggle("Elite", filters.elite, "Include elite enemies")
    
    -- Ensure at least one rarity is selected
    if not (filters.weak.value or filters.normal.value or filters.rare.value or filters.elite.value) then
        filters.weak.value = true
        filters.normal.value = true
        filters.rare.value = true
        filters.elite.value = true
    end
    
    Buttons.Break("Demographics")
    Buttons.Dropdown("Gender", filters.gender, genderOptions, "Filter by gender")
    Buttons.Dropdown("Netrunners", filters.netrunner, netrunnerOptions, "Filter netrunners")
    Buttons.Dropdown("Drones", filters.drone, droneOptions, "Filter drones/humans")
    
    Buttons.Break("Weapons")
    Buttons.Dropdown("Weapon", filters.weapon, allWeapons, "Select specific weapon or random")
    
    if allWeapons[filters.weapon.index] == "Random" then
        Buttons.Break("Weapon Kinds")
        Buttons.Toggle("Melee", filters.melee)
        Buttons.Toggle("Power", filters.power)
        Buttons.Toggle("Smart", filters.smart)
        Buttons.Toggle("Tech", filters.tech)
        
        -- Ensure at least one kind
        if not (filters.melee.value or filters.power.value or filters.smart.value or filters.tech.value) then
            filters.melee.value = true
            filters.power.value = true
            filters.smart.value = true
            filters.tech.value = true
        end
        
        Buttons.Break("Weapon Types")
        Buttons.Toggle("Blunt", filters.blunt)
        Buttons.Toggle("Edged", filters.edged)
        Buttons.Toggle("Revolver", filters.revolver)
        Buttons.Toggle("Pistol", filters.pistol)
        Buttons.Toggle("Shotgun", filters.shotgun)
        Buttons.Toggle("SMG", filters.smg)
        Buttons.Toggle("LMG", filters.lmg)
        Buttons.Toggle("HMG", filters.hmg)
        Buttons.Toggle("Assault", filters.assault)
        Buttons.Toggle("Precision", filters.precision)
        Buttons.Toggle("Sniper", filters.sniper)
        
        -- Ensure at least one type
        if not (filters.assault.value or filters.blunt.value or filters.edged.value or filters.hmg.value or 
                filters.lmg.value or filters.pistol.value or filters.precision.value or filters.revolver.value or 
                filters.smg.value or filters.shotgun.value or filters.sniper.value) then
            filters.assault.value = true
            filters.blunt.value = true
            filters.edged.value = true
            filters.hmg.value = true
            filters.lmg.value = true
            filters.pistol.value = true
            filters.precision.value = true
            filters.revolver.value = true
            filters.smg.value = true
            filters.shotgun.value = true
            filters.sniper.value = true
        end
    end
end

local GroupSpawnView = { title = "Group Spawn", view = RenderGroupSpawn }

-- Main Render Function
local function RenderMain()
    
    -- Select NPC Submenu
    Buttons.Submenu("Select NPC", NPCSelectorView, "Choose an NPC from categories")
    
    -- Selected NPC Display
    if selectedEnemy then
        local shortName = selectedEnemy:match("([^.]+)$") or selectedEnemy
        Buttons.OptionExtended("Selected NPC", "", shortName, "Currently selected enemy")
    else
        Buttons.OptionExtended("Selected NPC", "", "None", "No enemy selected")
    end

    -- Passive Mode
    Buttons.Toggle("Passive Mode", filters.invisible, "Spawned NPCs ignore player (invisible mode)")
    
    Buttons.Break("Spawn Options")
    
    -- NPC Gun
    Buttons.Toggle("NPC Gun", NPCGun.enabled, "Shoot to spawn selected NPC")

    -- Spawn NPC Button
    Buttons.Option("Spawn NPC", "Spawn the selected enemy", function()
        if not selectedEnemy then
            local Notification = require("UI/Elements/Notification")
            Notification.Warning("No enemy selected!", 2.0)
            return
        end
        
        if filters.invisible.value then
            Game.GetPlayer():SetInvisible(true)
            Game.GetPlayer():UpdateVisibility()
        else
            Game.GetPlayer():SetInvisible(false)
            Game.GetPlayer():UpdateVisibility()
        end
        NPCSpawner.Spawn(selectedEnemy, 3)
    end)
    
    -- Group Spawn Submenu
    Buttons.Submenu("Spawn NPC (Group)", GroupSpawnView, "Spawn multiple enemies with filters")
end

local NPCMenuView = { title = "NPC Menu", view = RenderMain }

return NPCMenuView
