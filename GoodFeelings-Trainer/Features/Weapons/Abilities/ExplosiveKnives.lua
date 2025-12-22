local Explosion = require("Utils/Explosion")
local Logger = require("Core/Logger")

local ExplosiveKnives = {}
ExplosiveKnives.enabled = { value = false }

-- cooldown to prevent spamming multiple explosions at once
local cooldown = 0.1
local lastExplosionTime = -1

---@param eventData gameprojectileHitEvent
function ExplosiveKnives.Tick(eventData)
    if not ExplosiveKnives.enabled.value then return end
    if not eventData then return end

    local currentTime = os.clock()
    if currentTime - lastExplosionTime < cooldown then return end

    local player = Game.GetPlayer()
    if not player then return end

    local instances = eventData.hitInstances
    if instances and #instances > 0 then
        for _, hit in ipairs(instances) do
            if hit and hit.position then
                Explosion.SpawnAtPos(hit.position, "Attacks.LegendaryFragGrenade", player, player, nil, 3.0)
                lastExplosionTime = currentTime
            end
        end
    end
end

return ExplosiveKnives
