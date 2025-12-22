local StatModifiers = require("Utils").StatModifiers


local Stealth = {}

Stealth.toggleDetection = { value = false }
Stealth.toggleTrace = { value = false }

Stealth.visibilityHandle = nil
Stealth.visibilityReductionHandle = nil
Stealth.helperHandle = nil

function Stealth.SetDetectionRatelow(remove)
    if remove then
        StatModifiers.Remove(Stealth.visibilityHandle)
        StatModifiers.Remove(Stealth.visibilityReductionHandle)
        StatModifiers.Remove(Stealth.helperHandle)
    else
        Stealth.visibilityHandle = StatModifiers.Create(gamedataStatType.Visibility, gameStatModifierType.Multiplier, 0.00001)
        Stealth.visibilityReductionHandle = StatModifiers.Create(gamedataStatType.VisibilityReduction, gameStatModifierType.Multiplier, 0.00001)
        Stealth.helperHandle = StatModifiers.Create(gamedataStatType.VisibilityReductionModifierHelper, gameStatModifierType.Additive, 99999999.9)

        StatModifiers.Apply(Stealth.visibilityHandle)
        StatModifiers.Apply(Stealth.visibilityReductionHandle)
        StatModifiers.Apply(Stealth.helperHandle)
    end
end

Stealth.traceHandle = nil
Stealth.iceHandle = nil

function Stealth.SetTraceRatelow(remove)
    if remove then
        StatModifiers.Remove(Stealth.traceHandle)
        StatModifiers.Remove(Stealth.iceHandle)
    else
        Stealth.traceHandle = StatModifiers.Create(gamedataStatType.RevealNetrunnerWhenHacked, gameStatModifierType.Additive, -9999.0)
        Stealth.iceHandle = StatModifiers.Create(gamedataStatType.HasICELevelBooster, gameStatModifierType.Additive, 0.0)

        StatModifiers.Apply(Stealth.traceHandle)
        StatModifiers.Apply(Stealth.iceHandle)
    end
end

return Stealth
