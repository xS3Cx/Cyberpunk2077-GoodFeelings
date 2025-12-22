local Self = require("Features/Self")
local Buttons = require("UI").Buttons
local Prevention = require("Utils").Prevention

local function SelfViewFunction()
    Buttons.Toggle(L("self.godmode.label"), Self.GodMode.enabled, tip("self.godmode.tip"))
    Buttons.Toggle(L("self.invisibility.label"), Self.Invisibility.enabled, tip("self.invisibility.tip"))
    Buttons.Toggle(L("self.superspeed.label"), Self.SuperSpeed.enabled, tip("self.superspeed.tip"))
    Buttons.Float(L("self.playerspeedmultiplier.label"), Self.StatModifiers.Movement.speedMultiplier, tip("self.playerspeedmultiplier.tip"))
    Buttons.Float(L("self.jumpheightmultiplier.label"), Self.StatModifiers.Movement.jumpMultiplier, tip("self.jumpheightmultiplier.tip"))
    Buttons.Toggle(L("self.quicksilversandevistan.label"), Self.StatModifiers.Movement.toggleQuicksilver, tip("self.quicksilversandevistan.tip"))
    Buttons.Toggle(L("self.noclip.label"), Self.NoClip.toggleNoClip, tip("self.noclip.tip"))
    Buttons.Toggle(L("self.infinitejump.label"), Self.InfiniteJumps.enabled, tip("self.infinitejump.tip")) 
    -- Buttons.Toggle(L("self.infiniteairdash.label"), Self.InfiniteAirDash.enabled, tip("self.infiniteairdash.tip")) 

    Buttons.Break(L("self.wanted.label"))
    Buttons.Toggle(L("self.neverwanted.label"), Self.WantedLevel.tickNeverWanted, tip("self.neverwanted.tip"))
    Buttons.Int(L("self.wantedlevel.label"), Self.WantedLevel.heldWantedLevel, tip("self.wantedlevel.tip"))
    Buttons.Option(L("self.clearwanted.label"), tip("self.clearwanted.tip"), function()
        Self.WantedLevel.tickClearWanted.value = true
    end)

    Buttons.Break(L("self.healthdefense.label"))
    Buttons.Toggle(L("self.refillhealth.label"), Self.StatModifiers.Enhancements.toggleSetHealthFull, tip("self.refillhealth.tip"))
    Buttons.Toggle(L("self.healthregen.label"), Self.StatModifiers.Enhancements.toggleHealthRegen, tip("self.healthregen.tip"))
    Buttons.Toggle(L("self.armorboost.label"), Self.StatModifiers.Enhancements.toggleArmor, tip("self.armorboost.tip"))
    Buttons.Toggle(L("self.resistances.label"), Self.StatModifiers.Enhancements.toggleResistances, tip("self.resistances.tip"))
    Buttons.Toggle(L("self.combatregen.label"), Self.StatModifiers.Enhancements.toggleCombatRegen, tip("self.combatregen.tip"))
    Buttons.Toggle(L("self.nofalldamage.label"), Self.StatModifiers.Enhancements.toggleFallDamage, tip("self.nofalldamage.tip"))

    Buttons.Break(L("self.stealthhacking.label"))
    Buttons.Toggle(L("self.nonthreat.label"), Self.StatModifiers.Stealth.toggleDetection, tip("self.nonthreat.tip"))
    Buttons.Toggle(L("self.lowtracerate.label"), Self.StatModifiers.Stealth.toggleTrace, tip("self.lowtracerate.tip"))
    Buttons.Toggle(L("self.refillmemory.label"), Self.StatModifiers.Enhancements.toggleSetMemoryFull, tip("self.refillmemory.tip"))
end

local SelfView = { title = "self.title", view = SelfViewFunction }

return SelfView
