local StatModifiers = require("Utils").StatModifiers

local Self = require("Features/Self")

local SelfTick = {}


function SelfTick.TickMovement()
   StatModifiers.HandleDynamicToggle(Self.StatModifiers.Movement.speedMultiplier, Self.StatModifiers.Movement.SetMaxSpeed)
   StatModifiers.HandleDynamicToggle(Self.StatModifiers.Movement.jumpMultiplier, Self.StatModifiers.Movement.SetSuperJump)
   StatModifiers.HandleDynamicToggle(Self.StatModifiers.Movement.sandevistanTimeScaleMultiplier, Self.StatModifiers.Movement.SetSandevistanTimeScale)
   StatModifiers.HandleDynamicToggle(Self.StatModifiers.Movement.sandevistanDurationMultiplier, Self.StatModifiers.Movement.SetSandevistanDuration)
   StatModifiers.HandleToggle(Self.StatModifiers.Movement.canJumpToggle, Self.StatModifiers.Movement.SetCanJump)

    StatModifiers.HandleToggle(Self.StatModifiers.Movement.toggleQuicksilver, Self.StatModifiers.Movement.SetQuicksilver)
end

function SelfTick.TickCooldown()
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleHeal, Self.StatModifiers.Cooldown.SetHealCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleGrenade, Self.StatModifiers.Cooldown.SetGrenadeCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleProjectile, Self.StatModifiers.Cooldown.SetProjectileCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleCloak, Self.StatModifiers.Cooldown.SetCloakCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleSande, Self.StatModifiers.Cooldown.SetSandevistanCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleBerserk, Self.StatModifiers.Cooldown.SetBerserkCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleKeren, Self.StatModifiers.Cooldown.SetKerenzikovCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleOverclock, Self.StatModifiers.Cooldown.SetOverclockCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleQuickhack, Self.StatModifiers.Cooldown.SetQuickhackCooldown)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleHackCost, Self.StatModifiers.Cooldown.SetQuickhackCost)
    StatModifiers.HandleToggle(Self.StatModifiers.Cooldown.toggleMemoryRegen, Self.StatModifiers.Cooldown.SetMemoryRegeneration)
end

function SelfTick.TickEnhancements()
    if Self.StatModifiers.Enhancements.toggleSetHealthFull.value then Self.StatModifiers.Enhancements.SetHealthFull() end
    if Self.StatModifiers.Enhancements.toggleSetStaminaFull.value then Self.StatModifiers.Enhancements.SetStaminaFull() end
    if Self.StatModifiers.Enhancements.toggleSetMemoryFull.value then Self.StatModifiers.Enhancements.SetMemoryFull() end
    if Self.StatModifiers.Enhancements.toggleSetOxygenFull.value then Self.StatModifiers.Enhancements.SetOxygenFull() end

    StatModifiers.HandleToggle(Self.StatModifiers.Enhancements.toggleHealthRegen, Self.StatModifiers.Enhancements.SetHealthRegenMods)
    StatModifiers.HandleToggle(Self.StatModifiers.Enhancements.toggleArmor, Self.StatModifiers.Enhancements.SetArmorMods)
    StatModifiers.HandleToggle(Self.StatModifiers.Enhancements.toggleFallDamage, Self.StatModifiers.Enhancements.SetFallDamageMods)
    StatModifiers.HandleToggle(Self.StatModifiers.Enhancements.toggleResistances, Self.StatModifiers.Enhancements.SetDamageResistances)
    StatModifiers.HandleToggle(Self.StatModifiers.Enhancements.toggleCombatRegen, Self.StatModifiers.Enhancements.SetCombatRegenMods)
    StatModifiers.HandleToggle(Self.StatModifiers.Enhancements.toggleInfiniteOxygen, Self.StatModifiers.Enhancements.SetInfiniteOxygen)
    StatModifiers.HandleToggle(Self.StatModifiers.Enhancements.toggleInfiniteStamina, Self.StatModifiers.Enhancements.SetInfiniteStamina)

    --StatModifiers.HandleDynamicToggle(Self.StatModifiers.Enhancements.toggleSetMemoryStat, Self.StatModifiers.Enhancements.memoryStatValue.enabled, Self.StatModifiers.Enhancements.SetMemoryStat)
end

function SelfTick.TickStealth()
    StatModifiers.HandleToggle(Self.StatModifiers.Stealth.toggleDetection, Self.StatModifiers.Stealth.SetDetectionRatelow)
    StatModifiers.HandleToggle(Self.StatModifiers.Stealth.toggleTrace, Self.StatModifiers.Stealth.SetTraceRatelow)
end

function SelfTick.TickUtility()
   StatModifiers.HandleDynamicToggle(Self.StatModifiers.Utility.capacityValue, Self.StatModifiers.Utility.SetCarryCapacityHigh)
end

function SelfTick.TickWantedLevel()
    Self.WantedLevel.Tick()
end

function SelfTick.TickOtherFeatures()
    Self.GodMode.Tick()
    Self.Invisibility.Tick()
    Self.SuperSpeed.Tick()
    Self.AirThrusterBoots.Tick()
    Self.AdvancedMobility.Tick()
    Self.NoClip.Tick()
    Self.InfiniteJumps.Tick()
    Self.Forcefield.Tick()
end

function SelfTick.TickHandler()
    SelfTick.TickMovement()
    SelfTick.TickCooldown()
    SelfTick.TickEnhancements()
    SelfTick.TickStealth()
    SelfTick.TickUtility()
    SelfTick.TickWantedLevel()
    SelfTick.TickOtherFeatures()
    
end

return SelfTick
