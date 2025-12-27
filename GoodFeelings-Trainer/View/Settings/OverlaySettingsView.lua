local Buttons = require("UI").Buttons
local State = require("Controls/State")

local function OverlaySettingsViewFunction()
    Buttons.Toggle("Master Overlay Toggle", State.showOverlay, "Enable or disable all on-screen overlay elements")
    
    Buttons.Break("Panels")
    Buttons.Toggle("Show Top Overlay", State.overlayShowTop, "Toggle the top-left info panel")
    Buttons.Toggle("Show Bottom Overlay", State.overlayShowWatermark, "Toggle the bottom-left watermark/URL")
    
    Buttons.Break("Top Panel Content")
    Buttons.Toggle("Display Title", State.overlayShowTitle, "Show 'GoodFeelings' in the top overlay")
    Buttons.Toggle("Display Mod Version", State.overlayShowModVersion, "Show mod version (v1.0.3) in the top overlay")
    Buttons.Toggle("Display Time", State.overlayShowTime, "Show system clock in the top overlay")
    Buttons.Toggle("Display FPS", State.overlayShowFPS, "Show real-time FPS counter in the top overlay")
    
    Buttons.Break("Bottom Panel Content")
    Buttons.Toggle("Display Game Version", State.overlayShowGameVersion, "Show game version in the bottom-right corner")
end

local OverlaySettingsView = { title = "Overlay Settings", view = OverlaySettingsViewFunction }

return OverlaySettingsView
