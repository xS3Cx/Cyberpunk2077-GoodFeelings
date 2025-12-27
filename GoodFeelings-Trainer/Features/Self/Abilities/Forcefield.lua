local Explosion = require("Utils/Explosion")

local Forcefield = {}

Forcefield.enabled = { value = false }

function Forcefield.Tick()
    if not Forcefield.enabled.value then return end
    
    local player = Game.GetPlayer()
    if not player then return end
    
    local pos = player:GetWorldPosition()
    Explosion.SpawnAtPos(pos, "Attacks.ExplosionLargeKill", player, player, nil, 15.0)
end

return Forcefield
