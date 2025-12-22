local StatModifiers = require("Utils").StatModifiers



local Movement = {}

Movement.speedMultiplier = {
    value = 5.0,
    min = 1.0,
    max = 5.0,
    step = 0.1,
    enabled = false
}

Movement.jumpMultiplier = {
    value = 3.0,
    min = 1.0,
    max = 15.0,
    step = 0.5,
    enabled = false
}

Movement.sandevistanTimeScaleMultiplier = {
    value = 0.1,
    min = 0.001,
    max = 1.0,
    step = 0.01,
    enabled = false
}

Movement.sandevistanDurationMultiplier = {
    value = 2.5,
    min = 0.1,
    max = 30.0,
    step = 0.5,
    enabled = false
}

Movement.canJumpToggle = { value = false }


Movement.toggleQuicksilver = { value = false }
Movement.quicksilverDuration = { value = 100.0 }
Movement.quicksilverTimeScale = { value = 0.005 }

Movement.canJumpHandle = nil
function Movement.SetCanJump(remove)
    if remove then
        if Movement.canJumpHandle then
            StatModifiers.Remove(Movement.canJumpHandle)
            Movement.canJumpHandle = nil
        end
    else
        Movement.canJumpHandle = StatModifiers.Create(gamedataStatType.CanJump, gameStatModifierType.Additive, 1.0)
        StatModifiers.Apply(Movement.canJumpHandle)
    end
end

Movement.speedHandle = nil
function Movement.SetMaxSpeed(remove, value)
    if remove then
        if Movement.speedHandle then StatModifiers.Remove(Movement.speedHandle) end
    else
        Movement.speedHandle = StatModifiers.Create(gamedataStatType.MaxSpeed, gameStatModifierType.Multiplier, value)
        StatModifiers.Apply(Movement.speedHandle)
    end
end

Movement.jumpHandle = nil
function Movement.SetSuperJump(remove, value)
    if remove then
        if Movement.jumpHandle then StatModifiers.Remove(Movement.jumpHandle) end
    else
        Movement.jumpHandle = StatModifiers.Create(gamedataStatType.JumpHeight, gameStatModifierType.Multiplier, value)
        StatModifiers.Apply(Movement.jumpHandle)
    end
end

Movement.sandeTimeHandle = nil
function Movement.SetSandevistanTimeScale(remove, value)
    if remove then
        if Movement.sandeTimeHandle then StatModifiers.Remove(Movement.sandeTimeHandle) end
    else
        Movement.sandeTimeHandle = StatModifiers.Create(gamedataStatType.TimeDilationSandevistanTimeScale, gameStatModifierType.Multiplier, value)
        StatModifiers.Apply(Movement.sandeTimeHandle)
    end
end

Movement.sandeDurationHandle = nil
function Movement.SetSandevistanDuration(remove, value)
    if remove then
        if Movement.sandeDurationHandle then StatModifiers.Remove(Movement.sandeDurationHandle) end
    else
        Movement.sandeDurationHandle = StatModifiers.Create(gamedataStatType.TimeDilationSandevistanDuration, gameStatModifierType.Multiplier, value)
        StatModifiers.Apply(Movement.sandeDurationHandle)
    end
end

Movement.quicksilverDurationHandle = nil
Movement.quicksilverTimeScaleHandle = nil

function Movement.SetQuicksilver(remove)
    if remove then
        if Movement.quicksilverDurationHandle then
            StatModifiers.Remove(Movement.quicksilverDurationHandle)
            Movement.quicksilverDurationHandle = nil
        end
        if Movement.quicksilverTimeScaleHandle then
            StatModifiers.Remove(Movement.quicksilverTimeScaleHandle)
            Movement.quicksilverTimeScaleHandle = nil
        end
    else
        Movement.quicksilverDurationHandle = StatModifiers.Create(gamedataStatType.TimeDilationSandevistanDuration, gameStatModifierType.Multiplier, 100.0)
        StatModifiers.Apply(Movement.quicksilverDurationHandle)

        Movement.quicksilverTimeScaleHandle = StatModifiers.Create(gamedataStatType.TimeDilationSandevistanTimeScale, gameStatModifierType.Multiplier, 0.005)
        StatModifiers.Apply(Movement.quicksilverTimeScaleHandle)
    end
end


return Movement
