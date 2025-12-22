local Teleport = require("Utils/Teleport")

local FlyingThunderGod = {}
FlyingThunderGod.enabled = { value = false }

function FlyingThunderGod.Tick(eventData)
    if not FlyingThunderGod.enabled.value then return end

    local player = Game.GetPlayer()
    if not player then return end

    local instances = eventData.hitInstances
    if instances and #instances > 0 then
        
        for _, hit in ipairs(instances) do
            Teleport.TeleportEntity(player, hit.position)
        end
    end
end

return FlyingThunderGod
