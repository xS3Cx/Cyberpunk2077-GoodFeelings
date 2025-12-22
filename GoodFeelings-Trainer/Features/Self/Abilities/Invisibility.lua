local StatusEffect = require("Utils").StatusEffect

local Invisibility = {}

Invisibility.enabled = { value = false }

local wasApplied = false


function Invisibility.Tick()
    local player = Game.GetPlayer()
    local statusSystem = Game.GetStatusEffectSystem()

    if Invisibility.enabled.value then
        if not wasApplied then
            StatusEffect.Set("BaseStatusEffect.Cloaked", true)
            player:SetInvisible(true)
            player:UpdateVisibility()
            wasApplied = true
        end
    elseif wasApplied then
        StatusEffect.Set("BaseStatusEffect.Cloaked", false)
        player:SetInvisible(false)
        player:UpdateVisibility()
        wasApplied = false
    end
end

return Invisibility
