local Buttons = require("UI").Buttons
local State = require("Controls/State")

local function ParticlesMenuViewFunction()
    -- Network Particles Toggle
    Buttons.Toggle(
        "Network Particles",
        State.particlesNetworkEnabled,
        "Enable/disable animated network particles in header background"
    )
end

local ParticlesMenuView = { title = "Particles", view = ParticlesMenuViewFunction }

return ParticlesMenuView
