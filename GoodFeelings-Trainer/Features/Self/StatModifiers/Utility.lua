local StatModifiers = require("Utils").StatModifiers

local Utility = {}

Utility.capacityValue = {
    value = 360,
    min = 1,
    max = 5000,
    step = 50,
    enabled = false
}

Utility.carryCapacityHandle = nil
function Utility.SetCarryCapacityHigh(remove, value)
    if remove then
        if Utility.carryCapacityHandle then
            StatModifiers.Remove(Utility.carryCapacityHandle)
            Utility.carryCapacityHandle = nil
        end
    else
        local capacity = value or 99999
        Utility.carryCapacityHandle = StatModifiers.Create(gamedataStatType.CarryCapacity, gameStatModifierType.Additive, capacity)
        StatModifiers.Apply(Utility.carryCapacityHandle)
    end
end

return Utility
