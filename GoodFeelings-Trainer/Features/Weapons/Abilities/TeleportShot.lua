local Weapon = require("Utils").Weapon
local Teleport = require("Utils").Teleport 

local TeleportShot = {}
local cooldown = 0.5
local lastTeleportTime = -1

TeleportShot.enabled = { value = false }


local TeleportShot = {}
local cooldown = 0.5
local lastTeleportTime = -1

TeleportShot.enabled = { value = false }

-- Same as the FlyingThunderGod but since I don't know how to track hitscans in the game,
-- this checks where the player's looking and then waits for them to shoot
function TeleportShot.Tick()
    if not TeleportShot.enabled.value then return end
    if not Weapon.IsShootingRanged() then return end

    local currentTime = os.clock()
    if currentTime - lastTeleportTime < cooldown then return end

    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    if not player or not targetingSystem then return end

    local camOrigin = player:GetWorldPosition()
    local facing = player:GetWorldOrientation():ToEulerAngles()
    local lookAt = targetingSystem:GetLookAtPosition(player, true, false)
    if not lookAt then return end

    local teleportPos = Vector4.new(lookAt.x, lookAt.y, lookAt.z, 1.0)

    Teleport.TeleportEntity(player, teleportPos, facing)

    lastTeleportTime = currentTime
end

return TeleportShot
