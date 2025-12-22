local State = {}
local ConfigManager = require("Config/OptionConfig")

State.trackMenuOpen = { value = true }
State.trackMouseOn = { value = false }

State.menuOpen = true
State.mouseEnabled = false
State.overlayOpen = false
State.typingEnabled = false

State.optionIndex = 0
State.currentOption = 1
State.currentOption = 1
State.maxVisible = 0
State.optionCount = 0
State.currentHeight = 0
State.targetHeight = 0
State.menuCounts = {}
State.lastMenuTitle = ""

State.upPressed = false
State.downPressed = false
State.leftPressed = false
State.rightPressed = false
State.selectPressed = false
State.backPressed = false
State.miscPressed = false

State.bindingKey = false

function State.IsMenuOpen()
    return State.menuOpen
end

function State.ToggleMenu()
    State.menuOpen = not State.menuOpen
    State.SyncTracking()
    return State.menuOpen
end


function State.IsMouseEnabled()
    return State.mouseEnabled
end


function State.ToggleMouse()
    State.mouseEnabled = not State.mouseEnabled
    State.SyncTracking()
    return State.mouseEnabled
end

function State.SyncTracking()
    State.trackMenuOpen.value = State.menuOpen
    State.trackMouseOn.value = State.mouseEnabled
    ConfigManager.Save()
end

function State.InitializeTracking()
    if State.trackMenuOpen and State.trackMenuOpen.value ~= nil then
        State.menuOpen = State.trackMenuOpen.value
    end
    if State.trackMouseOn and State.trackMouseOn.value ~= nil then
        State.mouseEnabled = State.trackMouseOn.value
    end
end


return State
