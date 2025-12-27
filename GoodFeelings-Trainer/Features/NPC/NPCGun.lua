local Weapon = require("Utils").Weapon
local NPCSpawner = require("Features/NPC/NPCSpawner")

local NPCGun = {}
local cooldown = 0.5
local lastSpawnTime = 0

NPCGun.enabled = { value = false }
NPCGun.currentEnemy = nil

function NPCGun.Tick()
    if not NPCGun.enabled.value then return end
    if not NPCGun.currentEnemy then return end
    
    if not Weapon.IsShootingRanged() then return end

    local currentTime = os.clock()
    if currentTime - lastSpawnTime < cooldown then return end

    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    if not player or not targetingSystem then return end

    local lookAt = targetingSystem:GetLookAtPosition(player, true, false)
    if not lookAt then return end

    local spawnPos = Vector4.new(lookAt.x, lookAt.y, lookAt.z, 1.0)
    local facing = player:GetWorldOrientation():ToEulerAngles()
    
    -- Face the player (rotate 180 degrees relative to player facing)
    local spawnYaw = facing.yaw + 180
    
    NPCSpawner.SpawnAt(NPCGun.currentEnemy, spawnPos, spawnYaw)
    
    lastSpawnTime = currentTime
end

return NPCGun
