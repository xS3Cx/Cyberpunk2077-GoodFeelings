local ConfigManager = require("Config/OptionConfig")

local State = require("Controls/State")

State.menuOpen = true
State.mouseEnabled = false

local function RegisterMenuOptions()
    ConfigManager.Register("toggle.trackMenuOpen", State.trackMenuOpen, true)
    ConfigManager.Register("toggle.trackMouseOn", State.trackMouseOn, true)
    ConfigManager.Register("toggle.showOverlay", State.showOverlay, true)
    ConfigManager.Register("overlay.showWatermark", State.overlayShowWatermark, true)
    ConfigManager.Register("overlay.showTop", State.overlayShowTop, true)
    ConfigManager.Register("overlay.showTitle", State.overlayShowTitle, true)
    ConfigManager.Register("overlay.showTime", State.overlayShowTime, true)
    ConfigManager.Register("overlay.showFPS", State.overlayShowFPS, true)
    ConfigManager.Register("overlay.showModVersion", State.overlayShowModVersion, true)
    ConfigManager.Register("overlay.showGameVersion", State.overlayShowGameVersion, true)
    ConfigManager.Register("overlay.showPing", State.overlayShowPing, true)
    ConfigManager.Register("overlay.showCoords", State.overlayShowCoords, true)
    ConfigManager.Register("overlay.showZone", State.overlayShowZone, true)
    ConfigManager.Register("overlay.showStreet", State.overlayShowStreet, true)
    ConfigManager.Register("overlay.showVehicle", State.overlayShowVehicle, true)
    ConfigManager.Register("overlay.showServer", State.overlayShowServer, true)
end


return RegisterMenuOptions
