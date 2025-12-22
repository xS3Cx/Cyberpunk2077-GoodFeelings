-- Features/ForceGun.lua
local Logger = require("Core/Logger")
local Force = require("Utils/Force")
local Weapon = require("Utils/Weapon")

local ForceGun = {}

ForceGun.enabled = { value = false }
local heldTarget = nil
local launchPower = 25000.0

function ForceGun.Tick(dt)
    if not ForceGun.enabled.value then
        heldTarget = nil
        return
    end

    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    if not player or not targetingSystem then return end

    if player.isAiming and not heldTarget then
        heldTarget = targetingSystem:GetLookAtObject(player, true, false)
    end

    if heldTarget and Weapon.IsPlayerShooting() then
        local camOrigin = player:GetWorldPosition()
        local lookAt = targetingSystem:GetLookAtPosition(player, true, false)

        local dir = {
            x = lookAt.x - camOrigin.x,
            y = lookAt.y - camOrigin.y,
            z = lookAt.z - camOrigin.z
        }
        local mag = math.sqrt(dir.x^2 + dir.y^2 + dir.z^2)
        dir.x, dir.y, dir.z = dir.x / mag, dir.y / mag, dir.z / mag

        local impulse = Vector3.new(
            dir.x * launchPower,
            dir.y * launchPower,
            dir.z * launchPower
        )

        Force.ApplyImpulse(heldTarget, impulse)
        
        heldTarget = nil
    end
end

return ForceGun
