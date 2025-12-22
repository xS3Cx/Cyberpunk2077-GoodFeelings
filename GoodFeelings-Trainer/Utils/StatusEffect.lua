local Logger = require("Core/Logger")

local StatusEffect = {}
local active = {}

function StatusEffect.Set(effect, enable)
    local statusSystem = Game.GetStatusEffectSystem()
    local player = Game.GetPlayer()
    if not (statusSystem and player) then return end

    local entityID = player:GetEntityID()
    if enable then
        if not active[effect] then
            statusSystem:ApplyStatusEffect(entityID, effect, player:GetRecordID(), entityID)
            active[effect] = true
            Logger.Log("StatusEffect: applied " .. tostring(effect))
        end
    else
        if active[effect] then
            statusSystem:RemoveStatusEffect(entityID, effect)
            active[effect] = nil
            Logger.Log("StatusEffect: removed " .. tostring(effect))
        end
    end
end

function StatusEffect.IsActive(effect)
    return active[effect] == true
end

-- Checks directly with the game’s status effect system unlike the above func
function StatusEffect.Has(effect)
    local statusSystem = Game.GetStatusEffectSystem()
    local player = Game.GetPlayer()
    if not (statusSystem and player) then return false end
    return statusSystem:HasStatusEffect(player:GetEntityID(), effect)
end

--- Remove all restrictions we applied
function StatusEffect.ClearAll()
    local statusSystem = Game.GetStatusEffectSystem()
    local player = Game.GetPlayer()
    if not (statusSystem and player) then return end

    local entityID = player:GetEntityID()
    for effect, _ in pairs(active) do
        statusSystem:RemoveStatusEffect(entityID, effect)
        Logger.Log("StatusEffect: cleared " .. tostring(effect))
    end
    active = {}
end

return StatusEffect
