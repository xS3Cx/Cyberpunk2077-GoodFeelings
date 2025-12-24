local NPCSpawner = {}
NPCSpawner.LastStatus = nil

-- CET automatically loads db.sqlite3 from mod root as global 'db'

-- Get All Enemies
function NPCSpawner.GetAllEnemies()
    local enemies = {}
    for row in db:nrows("SELECT TDBIDName FROM Enemies ORDER BY Faction") do
        table.insert(enemies, row.TDBIDName)
    end
    return enemies
end

-- Get All Factions
function NPCSpawner.GetFactions()
    local factions = {}
    for row in db:nrows("SELECT DISTINCT Faction FROM Enemies ORDER BY Faction") do
        table.insert(factions, row.Faction)
    end
    return factions
end

-- Get All Weapons
function NPCSpawner.GetWeapons()
    local weapons = {}
    for row in db:nrows("SELECT DISTINCT Weapon FROM Enemies WHERE Human = 1 AND Faction NOT IN ('MaxTac','Psycho') ORDER BY WeaponType, WeaponKind, Weapon") do
        table.insert(weapons, row.Weapon)
    end
    return weapons
end

-- Get Enemies for Faction
function NPCSpawner.GetEnemies(faction)
    local enemies = {}
    local safeFaction = faction:gsub("'", "''") -- Escape quotes
    local q = string.format("SELECT TDBIDName FROM Enemies WHERE Faction = '%s' ORDER BY TDBIDName", safeFaction)
    
    for row in db:nrows(q) do
        table.insert(enemies, { name = row.TDBIDName, id = row.TDBIDName })
    end
    return enemies
end

-- SQL Helper
local function sqlSyntaxCheck(str)
    if str == "" then
        return "WHERE "
    else
        return "AND "
    end
end

-- Advanced Spawn with Filters (like SimpleEnemySpawner DarkSpawn)
function NPCSpawner.DarkSpawn(filters)
    local player = Game.GetPlayer()
    if not player then return end
    
    local heading = player:GetWorldForward()
    local spawnTransform = player:GetWorldTransform()
    local angles = GetSingleton('Quaternion'):ToEulerAngles(player:GetWorldOrientation())
    local playerPosition = player:GetWorldPosition()
    
    local whereClause = ""
    local enemiesTable = {}
    local enemiesCount = 0
    
    -- Build WHERE clause based on filters
    if filters.faction ~= "Random" then
        whereClause = whereClause .. sqlSyntaxCheck(whereClause)
        whereClause = whereClause .. "Faction = '" .. filters.faction .. "' "
    else
        if not filters.psycho then
            whereClause = whereClause .. sqlSyntaxCheck(whereClause)
            whereClause = whereClause .. "Faction NOT IN ('MaxTac','Psycho') "
        end
    end
    
    if filters.gender ~= "Random" then
        whereClause = whereClause .. sqlSyntaxCheck(whereClause)
        local genderDef = filters.gender == "Male" and 1 or 0
        whereClause = whereClause .. "Male = " .. genderDef .. " "
    end
    
    if filters.netrunner ~= "Random" then
        whereClause = whereClause .. sqlSyntaxCheck(whereClause)
        local netrunnerDef = filters.netrunner == "Only Netrunners" and 1 or 0
        whereClause = whereClause .. "Netrunner = " .. netrunnerDef .. " "
    end
    
    if filters.drone ~= "Random" then
        whereClause = whereClause .. sqlSyntaxCheck(whereClause)
        local droneDef = filters.drone == "Only Humans" and 1 or 0
        whereClause = whereClause .. "Human = " .. droneDef .. " "
    end
    
    -- Rarity
    whereClause = whereClause .. sqlSyntaxCheck(whereClause)
    local rarityStr = ""
    if filters.weak then rarityStr = "'Weak'" end
    if filters.normal then rarityStr = rarityStr == "" and "'Normal'" or rarityStr .. ",'Normal'" end
    if filters.rare then rarityStr = rarityStr == "" and "'Rare'" or rarityStr .. ",'Rare'" end
    if filters.elite then rarityStr = rarityStr == "" and "'Elite'" or rarityStr .. ",'Elite'" end
    whereClause = whereClause .. "Rarity IN (" .. rarityStr .. ") "
    
    -- Weapon
    if filters.weapon ~= "Random" then
        whereClause = whereClause .. sqlSyntaxCheck(whereClause)
        whereClause = whereClause .. "Weapon = '" .. filters.weapon .. "'"
    else
        whereClause = whereClause .. sqlSyntaxCheck(whereClause)
        
        local weaponKindStr = ""
        if filters.melee then weaponKindStr = "'Melee'" end
        if filters.power then weaponKindStr = weaponKindStr == "" and "'Power'" or weaponKindStr .. ",'Power'" end
        if filters.smart then weaponKindStr = weaponKindStr == "" and "'Smart'" or weaponKindStr .. ",'Smart'" end
        if filters.tech then weaponKindStr = weaponKindStr == "" and "'Tech'" or weaponKindStr .. ",'Tech'" end
        
        local weaponTypeStr = ""
        if filters.assault then weaponTypeStr = "'Assault'" end
        if filters.blunt then weaponTypeStr = weaponTypeStr == "" and "'Blunt'" or weaponTypeStr .. ",'Blunt'" end
        if filters.edged then weaponTypeStr = weaponTypeStr == "" and "'Edged'" or weaponTypeStr .. ",'Edged'" end
        if filters.hmg then weaponTypeStr = weaponTypeStr == "" and "'HMG'" or weaponTypeStr .. ",'HMG'" end
        if filters.lmg then weaponTypeStr = weaponTypeStr == "" and "'LMG'" or weaponTypeStr .. ",'LMG'" end
        if filters.pistol then weaponTypeStr = weaponTypeStr == "" and "'Pistol'" or weaponTypeStr .. ",'Pistol'" end
        if filters.precision then weaponTypeStr = weaponTypeStr == "" and "'Precision'" or weaponTypeStr .. ",'Precision'" end
        if filters.revolver then weaponTypeStr = weaponTypeStr == "" and "'Revolver'" or weaponTypeStr .. ",'Revolver'" end
        if filters.smg then weaponTypeStr = weaponTypeStr == "" and "'SMG'" or weaponTypeStr .. ",'SMG'" end
        if filters.shotgun then weaponTypeStr = weaponTypeStr == "" and "'Shotgun'" or weaponTypeStr .. ",'Shotgun'" end
        if filters.sniper then weaponTypeStr = weaponTypeStr == "" and "'Sniper'" or weaponTypeStr .. ",'Sniper'" end
        
        whereClause = whereClause .. "WeaponType IN (" .. weaponTypeStr .. ") AND WeaponKind IN (" .. weaponKindStr .. ")"
    end
    
    local query = "SELECT TDBIDName FROM Enemies " .. whereClause
    for row in db:nrows(query) do
        table.insert(enemiesTable, row.TDBIDName)
        enemiesCount = enemiesCount + 1
    end
    
    if enemiesCount ~= 0 then
        for i = 1, filters.spawnNumber do
            local rndIdx = math.random(1, enemiesCount)
            local rndPosX = math.random(-filters.spawnDistance, filters.spawnDistance)
            local rndPosY = math.random(-filters.spawnDistance, filters.spawnDistance)
            local spawnPos = Vector4.new(
                playerPosition.x - heading.x - rndPosX,
                playerPosition.y - heading.y - rndPosY,
                playerPosition.z - heading.z,
                playerPosition.w - heading.w
            )
            spawnTransform:SetPosition(spawnPos)
            spawnTransform:SetOrientationEuler(EulerAngles.new(0, 0, angles.yaw - 180))
            Game.GetPreventionSpawnSystem():RequestUnitSpawn(TweakDBID.new(enemiesTable[rndIdx]), spawnTransform)
        end
        NPCSpawner.LastStatus = "Enemy Pool: " .. enemiesCount
        
        -- Show notification
        local Notification = require("UI/Elements/Notification")
        Notification.Info("Spawned " .. filters.spawnNumber .. " enemies form pool of " .. enemiesCount, 3.0)
    else
        NPCSpawner.LastStatus = "No Results"
        local Notification = require("UI/Elements/Notification")
        Notification.Warning("No enemies found with current filters", 3.0)
    end
end

-- Simple Single Spawn
function NPCSpawner.Spawn(enemyID, spawnDistance)
    local player = Game.GetPlayer()
    if not player then return end
    
    local Teleport = require("Utils").Teleport
    local distance = spawnDistance or 3
    
    -- Use same positioning as vehicle preview
    local pos = Teleport.GetForwardOffset(distance)
    if not pos then return end
    
    pos.z = pos.z + 0.1 -- Slight Z offset to prevent underground spawn
    
    local spawnTransform = Game.GetPlayer():GetWorldTransform()
    spawnTransform:SetPosition(pos)
    
    -- Face player
    local angles = GetSingleton('Quaternion'):ToEulerAngles(player:GetWorldOrientation())
    spawnTransform:SetOrientationEuler(EulerAngles.new(0, 0, angles.yaw + 180))
    
    Game.GetPreventionSpawnSystem():RequestUnitSpawn(TweakDBID.new(enemyID), spawnTransform)
    
    -- Extract short name from TweakDBID
    local shortName = enemyID:match("([^.]+)$") or enemyID
    NPCSpawner.LastStatus = "Spawned: " .. shortName
    
    -- Show notification
    local Notification = require("UI/Elements/Notification")
    Notification.Info("Spawned NPC: " .. shortName, 2.5)
end

-- Spawn at specific position (for NPC Gun)
function NPCSpawner.SpawnAt(enemyID, position, yaw)
    local player = Game.GetPlayer()
    if not player then return end

    local spawnTransform = Game.GetPlayer():GetWorldTransform()
    spawnTransform:SetPosition(position)
    spawnTransform:SetOrientationEuler(EulerAngles.new(0, 0, yaw))
    
    Game.GetPreventionSpawnSystem():RequestUnitSpawn(TweakDBID.new(enemyID), spawnTransform)
end



return NPCSpawner
