local Buttons = require("UI").Buttons

local Self = require("Features/Self")
local Cooldown = Self.StatModifiers.Cooldown
local StatModifiers = Self.StatModifiers


local CustomModifiersView = require("View/Self/CustomModifiersView")

local function PlayerStatsView()
    Buttons.Toggle(L("modifiers.infinitestamina.label"), StatModifiers.Enhancements.toggleInfiniteStamina, tip("modifiers.infinitestamina.tip"))
    Buttons.Toggle(L("modifiers.infiniteoxygen.label"), StatModifiers.Enhancements.toggleInfiniteOxygen, tip("modifiers.infiniteoxygen.tip"))
    Buttons.Toggle(L("modifiers.refillstamina.label"), StatModifiers.Enhancements.toggleSetStaminaFull, tip("modifiers.refillstamina.tip"))
    Buttons.Toggle(L("modifiers.refilloxygen.label"), StatModifiers.Enhancements.toggleSetOxygenFull, tip("modifiers.refilloxygen.tip"))

    Buttons.Break(L("modifiers.cooldowns"))
    Buttons.Toggle(L("modifiers.cooldownheal.label"), Cooldown.toggleHeal, tip("modifiers.cooldownheal.tip"))
    Buttons.Toggle(L("modifiers.cooldowngrenade.label"), Cooldown.toggleGrenade, tip("modifiers.cooldowngrenade.tip"))
    Buttons.Toggle(L("modifiers.cooldownprojectile.label"), Cooldown.toggleProjectile, tip("modifiers.cooldownprojectile.tip"))
    Buttons.Toggle(L("modifiers.cooldowncloak.label"), Cooldown.toggleCloak, tip("modifiers.cooldowncloak.tip"))
    Buttons.Toggle(L("modifiers.cooldownsande.label"), Cooldown.toggleSande, tip("modifiers.cooldownsande.tip"))
    Buttons.Toggle(L("modifiers.cooldownberserk.label"), Cooldown.toggleBerserk, tip("modifiers.cooldownberserk.tip"))
    Buttons.Toggle(L("modifiers.cooldownkeren.label"), Cooldown.toggleKeren, tip("modifiers.cooldownkeren.tip"))
    Buttons.Toggle(L("modifiers.cooldownoverclock.label"), Cooldown.toggleOverclock, tip("modifiers.cooldownoverclock.tip"))
    Buttons.Toggle(L("modifiers.cooldownquickhacks.label"), Cooldown.toggleQuickhack, tip("modifiers.cooldownquickhacks.tip"))

    Buttons.Break(L("modifiers.memorystats"))
    Buttons.Toggle(L("modifiers.reducequickhackcost.label"), Cooldown.toggleHackCost, tip("modifiers.reducequickhackcost.tip"))
    Buttons.Toggle(L("modifiers.memoryregen.label"), Cooldown.toggleMemoryRegen, tip("modifiers.memoryregen.tip"))
    Buttons.Float(L("modifiers.setmemorystat.label"), StatModifiers.Enhancements.memoryStatValue, tip("modifiers.setmemorystat.tip"))

    Buttons.Break(L("modifiers.mobility"))
    Buttons.Toggle(L("modifiers.airthrusterboots.label"), Self.AirThrusterBoots.enabled, tip("modifiers.airthrusterboots.tip"))
    Buttons.Toggle(L("modifiers.airhover.label"), Self.AdvancedMobility.toggleAirHover, tip("modifiers.airhover.tip"))
    Buttons.Int(L("modifiers.carrycapacity.label"), StatModifiers.Utility.capacityValue, tip("modifiers.carrycapacity.tip"))

    Buttons.Break(L("modifiers.sandevistan"))
    Buttons.Float(L("modifiers.sandevistanduration.label"), StatModifiers.Movement.sandevistanDurationMultiplier, tip("modifiers.sandevistanduration.tip"))
    Buttons.Float(L("modifiers.sandevistanscale.label"), StatModifiers.Movement.sandevistanTimeScaleMultiplier, tip("modifiers.sandevistanscale.tip"))
end

return {
    title = "modifiers.title",
    view = PlayerStatsView
}
