local ConfigManager = require("Config/OptionConfig")

local State = require("Controls/State")

State.menuOpen = true
State.mouseEnabled = false

local function RegisterMenuOptions()
    ConfigManager.Register("toggle.trackMenuOpen", State.trackMenuOpen, true)
    ConfigManager.Register("toggle.trackMouseOn", State.trackMouseOn, true)
end


return RegisterMenuOptions
