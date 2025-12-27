local Buttons = require("UI").Buttons

-- Import all category views
local CombatEffectsView = require("View/StatusEffects/CombatEffectsView")
local CyberwareEffectsView = require("View/StatusEffects/CyberwareEffectsView")
local QuickhacksEffectsView = require("View/StatusEffects/QuickhacksEffectsView")
local BuffsEffectsView = require("View/StatusEffects/BuffsEffectsView")
local DebuffsEffectsView = require("View/StatusEffects/DebuffsEffectsView")
local AllEffectsView = require("View/StatusEffects/AllEffectsView")

local function StatusEffectsMenuViewFunction()
    Buttons.Break("Status Effect Categories")
    Buttons.Submenu("Combat Effects", CombatEffectsView, "Combat-related status effects (Berserk, Sandevistan, etc.)")
    Buttons.Submenu("Cyberware Effects", CyberwareEffectsView, "Cyberware status effects (Optical Camo, Kerenzikov, etc.)")
    Buttons.Submenu("Quickhack Effects", QuickhacksEffectsView, "Quickhack status effects (Overheat, Contagion, etc.)")
    Buttons.Submenu("Buff Effects", BuffsEffectsView, "Positive status effects")
    Buttons.Submenu("Debuff Effects", DebuffsEffectsView, "Negative status effects")
    Buttons.Submenu("All Effects", AllEffectsView, "All status effects (A-Z)")
end

return { title = "Status Effects", view = StatusEffectsMenuViewFunction }
