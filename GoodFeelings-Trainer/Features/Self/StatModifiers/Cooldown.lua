local StatModifiers = require("Utils").StatModifiers


local Cooldown = {}

Cooldown.toggleHeal = { value = false }
Cooldown.toggleGrenade = { value = false }
Cooldown.toggleProjectile = { value = false }
Cooldown.toggleCloak = { value = false }
Cooldown.toggleSande = { value = false }
Cooldown.toggleBerserk = { value = false }
Cooldown.toggleKeren = { value = false }
Cooldown.toggleOverclock = { value = false }
Cooldown.toggleQuickhack = { value = false }
Cooldown.toggleHackCost = { value = false }
Cooldown.toggleMemoryRegen = { value = false }

Cooldown.healHandle = nil
function Cooldown.SetHealCooldown(remove)
    if remove then
        if Cooldown.healHandle then StatModifiers.Remove(Cooldown.healHandle) end
    else
        Cooldown.healHandle = StatModifiers.Create(gamedataStatType.HealingItemsChargesRegenMult, gameStatModifierType.Additive, 10000.0)
        StatModifiers.Apply(Cooldown.healHandle)
    end
end

Cooldown.grenadeHandle = nil
function Cooldown.SetGrenadeCooldown(remove)
    if remove then
        if Cooldown.grenadeHandle then StatModifiers.Remove(Cooldown.grenadeHandle) end
    else
        Cooldown.grenadeHandle = StatModifiers.Create(gamedataStatType.GrenadesChargesRegenMult, gameStatModifierType.Additive, 10000.0)
        StatModifiers.Apply(Cooldown.grenadeHandle)
    end
end

Cooldown.projectileHandle = nil
function Cooldown.SetProjectileCooldown(remove)
    if remove then
        if Cooldown.projectileHandle then StatModifiers.Remove(Cooldown.projectileHandle) end
    else
        Cooldown.projectileHandle = StatModifiers.Create(gamedataStatType.ProjectileLauncherChargesRegenMult, gameStatModifierType.Additive, 10000.0)
        StatModifiers.Apply(Cooldown.projectileHandle)
    end
end

Cooldown.cloakHandle1 = nil
Cooldown.cloakHandle2 = nil
function Cooldown.SetCloakCooldown(remove)
    if remove then
        if Cooldown.cloakHandle1 then StatModifiers.Remove(Cooldown.cloakHandle1) end
        if Cooldown.cloakHandle2 then StatModifiers.Remove(Cooldown.cloakHandle2) end
    else
        Cooldown.cloakHandle1 = StatModifiers.Create(gamedataStatType.OpticalCamoRechargeDuration, gameStatModifierType.Multiplier, 0.01)
        Cooldown.cloakHandle2 = StatModifiers.Create(gamedataStatType.OpticalCamoChargesRegenRate, gameStatModifierType.Additive, 100.0)
        StatModifiers.Apply(Cooldown.cloakHandle1)
        StatModifiers.Apply(Cooldown.cloakHandle2)
    end
end

Cooldown.sandeHandle = nil
function Cooldown.SetSandevistanCooldown(remove)
    if remove then
        if Cooldown.sandeHandle then StatModifiers.Remove(Cooldown.sandeHandle) end
    else
        Cooldown.sandeHandle = StatModifiers.Create(gamedataStatType.TimeDilationSandevistanRechargeDuration, gameStatModifierType.Multiplier, 0.01)
        StatModifiers.Apply(Cooldown.sandeHandle)
    end
end

Cooldown.berserkHandle = nil
function Cooldown.SetBerserkCooldown(remove)
    if remove then
        if Cooldown.berserkHandle then StatModifiers.Remove(Cooldown.berserkHandle) end
    else
        Cooldown.berserkHandle = StatModifiers.Create(gamedataStatType.BerserkChargesRegenRate, gameStatModifierType.Additive, 100.0)
        StatModifiers.Apply(Cooldown.berserkHandle)
    end
end

Cooldown.kerenHandle = nil
function Cooldown.SetKerenzikovCooldown(remove)
    if remove then
        if Cooldown.kerenHandle then StatModifiers.Remove(Cooldown.kerenHandle) end
    else
        Cooldown.kerenHandle = StatModifiers.Create(gamedataStatType.KerenzikovCooldownDuration, gameStatModifierType.Multiplier, 0.01)
        StatModifiers.Apply(Cooldown.kerenHandle)
    end
end

Cooldown.overHandle1 = nil
Cooldown.overHandle2 = nil
function Cooldown.SetOverclockCooldown(remove)
    if remove then
        if Cooldown.overHandle1 then StatModifiers.Remove(Cooldown.overHandle1) end
        if Cooldown.overHandle2 then StatModifiers.Remove(Cooldown.overHandle2) end
    else
        Cooldown.overHandle1 = StatModifiers.Create(gamedataStatType.CyberdeckOverclockRegenRate, gameStatModifierType.Additive, 100.0)
        Cooldown.overHandle2 = StatModifiers.Create(gamedataStatType.CyberdeckOverclockCooldown, gameStatModifierType.Multiplier, 0.01)
        StatModifiers.Apply(Cooldown.overHandle1)
        StatModifiers.Apply(Cooldown.overHandle2)
    end
end

Cooldown.quickhackHandle = nil
function Cooldown.SetQuickhackCooldown(remove)
    if remove then
        if Cooldown.quickhackHandle then StatModifiers.Remove(Cooldown.quickhackHandle) end
    else
        Cooldown.quickhackHandle = StatModifiers.Create(gamedataStatType.QuickhacksCooldownReduction, gameStatModifierType.Additive, 1.0)
        StatModifiers.Apply(Cooldown.quickhackHandle)
    end
end

Cooldown.hackCostHandle = nil
function Cooldown.SetQuickhackCost(remove)
    if remove then
        if Cooldown.hackCostHandle then StatModifiers.Remove(Cooldown.hackCostHandle) end
    else
        Cooldown.hackCostHandle = StatModifiers.Create(gamedataStatType.MemoryCostReduction, gameStatModifierType.Additive, 10000.0)
        StatModifiers.Apply(Cooldown.hackCostHandle)
    end
end

Cooldown.memoryRegenHandle = nil
function Cooldown.SetMemoryRegeneration(remove)
    if remove then
        if Cooldown.memoryRegenHandle then StatModifiers.Remove(Cooldown.memoryRegenHandle) end
    else
        Cooldown.memoryRegenHandle = StatModifiers.Create(gamedataStatType.MemoryRegenRateMult, gameStatModifierType.Additive, 100.0)
        StatModifiers.Apply(Cooldown.memoryRegenHandle)
    end
end

return Cooldown
