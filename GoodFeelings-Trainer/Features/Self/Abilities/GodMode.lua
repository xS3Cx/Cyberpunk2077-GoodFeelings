local StatusEffect = require("Utils").StatusEffect

local GodMode = {}

GodMode.enabled = { value = false }

local wasApplied = false
local effectID = "BaseStatusEffect.Invulnerable"

function GodMode.DisableFallFX(_, context, _)
    if GodMode.enabled.value then
        context:SetPermanentFloatParameter('RegularLandingFallingSpeed', -6000, true)
        context:SetPermanentFloatParameter('SafeLandingFallingSpeed', -7000, true)
        context:SetPermanentFloatParameter('HardLandingFallingSpeed', -8000, true)
        context:SetPermanentFloatParameter('VeryHardLandingFallingSpeed', -9000, true)
        context:SetPermanentFloatParameter('DeathLandingFallingSpeed', -10000, true)
    end
end

function GodMode.Tick()
    if GodMode.enabled.value then
        -- If not yet applied, or if game stripped it, reapply
        if not wasApplied or not StatusEffect.Has(effectID) then
            StatusEffect.Set(effectID, true)
            wasApplied = true
        end
    elseif wasApplied then
        StatusEffect.Set(effectID, false)
        wasApplied = false
    end
end

return GodMode
