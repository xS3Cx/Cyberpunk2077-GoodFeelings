local StatusEffect = require("Utils").StatusEffect

local InfiniteAmmo = {}

InfiniteAmmo.enabled = { value = false }

local wasApplied = false
local effectID = "GameplayRestriction.InfiniteAmmo"

function InfiniteAmmo.Tick()
    if InfiniteAmmo.enabled.value then
        if not wasApplied or not StatusEffect.Has(effectID) then
            StatusEffect.Set(effectID, true)
            wasApplied = true
        end
    elseif wasApplied then
        StatusEffect.Set(effectID, false)
        wasApplied = false
    end
end

return InfiniteAmmo
