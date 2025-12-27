local StatusEffectBrowser = {
    currentEffect = nil,
    targetMode = { value = "player" } -- "player" or "npc"
}

function StatusEffectBrowser.ApplyEffect(effectId, target)
    target = target or Game.GetPlayer()
    
    if not target then
        return false
    end
    
    local statusEffectSystem = Game.GetStatusEffectSystem()
    if not statusEffectSystem then
        return false
    end
    
    local entityId = target:GetEntityID()
    if not entityId then
        return false
    end
    
    -- Apply the status effect
    statusEffectSystem:ApplyStatusEffect(entityId, effectId)
    StatusEffectBrowser.currentEffect = effectId
    
    return true
end

function StatusEffectBrowser.ApplyToPlayer(effectId)
    return StatusEffectBrowser.ApplyEffect(effectId, Game.GetPlayer())
end

function StatusEffectBrowser.ApplyToTarget(effectId)
    local player = Game.GetPlayer()
    if not player then return false end
    
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
    if not target then
        return false
    end
    
    return StatusEffectBrowser.ApplyEffect(effectId, target)
end

function StatusEffectBrowser.RemoveEffect(effectId, target)
    target = target or Game.GetPlayer()
    
    if not target then
        return false
    end
    
    local statusEffectSystem = Game.GetStatusEffectSystem()
    if not statusEffectSystem then
        return false
    end
    
    local entityId = target:GetEntityID()
    if not entityId then
        return false
    end
    
    statusEffectSystem:RemoveStatusEffect(entityId, effectId)
    
    if StatusEffectBrowser.currentEffect == effectId then
        StatusEffectBrowser.currentEffect = nil
    end
    
    return true
end

function StatusEffectBrowser.GetCurrentEffect()
    return StatusEffectBrowser.currentEffect
end

return StatusEffectBrowser
