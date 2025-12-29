local UI = require("UI")

local DebugMenuView = {}

local function DebugViewFunction()
    -- Main Categories
    UI.Buttons.Submenu("Widget Testing", require("View/Debug/WidgetTestingView"), "Test text and image widget spawning on HUD")
    UI.Buttons.Submenu("HUD Messages", require("View/Debug/HUDMessagesView"), "Test native HUD messages")
    UI.Buttons.Submenu("Audio Testing", require("View/Debug/AudioTestingView"), "Test in-game sound effects and audio")
    UI.Buttons.Submenu("Notification Testing", require("View/Debug/NotificationTestingView"), "Test various in-game notification types")
end

local DebugMenuView = { title = "Debug Tools", view = DebugViewFunction }
return DebugMenuView
