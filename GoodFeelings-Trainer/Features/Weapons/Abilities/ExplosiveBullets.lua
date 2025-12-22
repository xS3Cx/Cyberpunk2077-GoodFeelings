local Weapon = require("Utils").Weapon
local Explosion = require("Utils/Explosion")
local Logger = require("Core/Logger")

local ExplosiveBullets = {}
local cooldown = 0.1
local lastExplosionTime = -1

ExplosiveBullets.enabled = { value = false }

function ExplosiveBullets.Tick()
    if not ExplosiveBullets.enabled.value then return end
    if not Weapon.IsShootingRanged() then return end

    local currentTime = os.clock()
    if currentTime - lastExplosionTime < cooldown then return end

    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    if not player or not targetingSystem then return end

    local lookAt = targetingSystem:GetLookAtPosition(player, true, false)
    if not lookAt then return end

    -- Explosion.SpawnVFX(lookAt, player:GetWorldOrientation(), [[base\fx\weapons\explosives\incendiary_grenade\w_explosives_001_incendiary_ground_grenade_01.effect]])

    Explosion.SpawnAtPos(lookAt, "Attacks.LegendaryFragGrenade", player, player, nil, 3.0)

    -- Logger.Log(string.format("ExplosiveBullets: explosion triggered at (%.2f, %.2f, %.2f)", lookAt.x, lookAt.y, lookAt.z))

    lastExplosionTime = currentTime
end

return ExplosiveBullets
