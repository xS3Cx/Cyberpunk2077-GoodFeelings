local ConfigManager = require("Config/OptionConfig")

local Self = require("Features/Self")

local function RegisterAllSelfOptions()
    ConfigManager.Register("toggle.self.godmode", Self.GodMode.enabled, false)
    ConfigManager.Register("toggle.self.invisibility", Self.Invisibility.enabled, false)
    ConfigManager.Register("toggle.self.superspeed", Self.SuperSpeed.enabled, false)
    ConfigManager.Register("toggle.self.noclip", Self.NoClip.toggleNoClip, false)
    ConfigManager.Register("toggle.self.infinitejump", Self.InfiniteJumps.enabled, false)
    ConfigManager.Register("toggle.self.infiniteairdash", Self.InfiniteAirDash.enabled, false)
    ConfigManager.Register("toggle.self.airthrusters", Self.AirThrusterBoots.enabled, false)

    ConfigManager.Register("toggle.self.quicksilver", Self.StatModifiers.Movement.toggleQuicksilver, false)

    ConfigManager.Register("toggle.self.refillhealth", Self.StatModifiers.Enhancements.toggleSetHealthFull, false)
    ConfigManager.Register("toggle.self.refillstamina",Self.StatModifiers.Enhancements.toggleSetStaminaFull, false)
    ConfigManager.Register("toggle.self.refillmemory", Self.StatModifiers.Enhancements.toggleSetMemoryFull, false)
    ConfigManager.Register("toggle.self.refilloxygen", Self.StatModifiers.Enhancements.toggleSetOxygenFull, false)
    ConfigManager.Register("toggle.self.healthregen",  Self.StatModifiers.Enhancements.toggleHealthRegen, false)
    ConfigManager.Register("toggle.self.armorboost",   Self.StatModifiers.Enhancements.toggleArmor, false)
    ConfigManager.Register("toggle.self.nofalldamage", Self.StatModifiers.Enhancements.toggleFallDamage, false)
    ConfigManager.Register("toggle.self.resistances",  Self.StatModifiers.Enhancements.toggleResistances, false)
    ConfigManager.Register("toggle.self.combatregen",  Self.StatModifiers.Enhancements.toggleCombatRegen, false)
    ConfigManager.Register("toggle.self.infiniteoxygen", Self.StatModifiers.Enhancements.toggleInfiniteOxygen, false)
    ConfigManager.Register("toggle.self.infinitestamina", Self.StatModifiers.Enhancements.toggleInfiniteStamina, false)

    ConfigManager.Register("toggle.self.nonthreat", Self.StatModifiers.Stealth.toggleDetection, false)
    ConfigManager.Register("toggle.self.lowtrace",  Self.StatModifiers.Stealth.toggleTrace, false)

    ConfigManager.Register("toggle.self.cooldown.heal", Self.StatModifiers.Cooldown.toggleHeal, false)
    ConfigManager.Register("toggle.self.cooldown.grenade", Self.StatModifiers.Cooldown.toggleGrenade, false)
    ConfigManager.Register("toggle.self.cooldown.projectile", Self.StatModifiers.Cooldown.toggleProjectile, false)
    ConfigManager.Register("toggle.self.cooldown.cloak", Self.StatModifiers.Cooldown.toggleCloak, false)
    ConfigManager.Register("toggle.self.cooldown.sande", Self.StatModifiers.Cooldown.toggleSande, false)
    ConfigManager.Register("toggle.self.cooldown.berserk", Self.StatModifiers.Cooldown.toggleBerserk, false)
    ConfigManager.Register("toggle.self.cooldown.keren", Self.StatModifiers.Cooldown.toggleKeren, false)
    ConfigManager.Register("toggle.self.cooldown.overclock", Self.StatModifiers.Cooldown.toggleOverclock, false)
    ConfigManager.Register("toggle.self.cooldown.quickhack", Self.StatModifiers.Cooldown.toggleQuickhack, false)
    ConfigManager.Register("toggle.self.cooldown.hackcost", Self.StatModifiers.Cooldown.toggleHackCost, false)
    ConfigManager.Register("toggle.self.cooldown.memoryregen",Self.StatModifiers.Cooldown.toggleMemoryRegen, false)

end

return RegisterAllSelfOptions
