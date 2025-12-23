local Logger = require("Core/Logger")
local State = require("Controls/State")
local Bindings = require("Controls/Bindings")
local Restrictions = require("Controls/Restrictions")
local Navigation = require("Controls/Navigation")
local Cursor = require("Controls/Cursor")
local BindManager = require("Features/BindManager")

local SubmenuManager = require("UI/Core/SubmenuManager")
local GameHUD = require("Core/cp2077-cet-kit/GameHUD")

local Handler = {}

Handler.scrollDelayBase = 200
Handler.scrollMinDelay = 30
Handler.accelThreshold = 1250
Handler.accelStep = 20

local holdStart = { up = 0, down = 0, left = 0, right = 0 }
local lastTick = { up = 0, down = 0, left = 0, right = 0, select = 0, back = 0, misc = 0, toggle = 0, toggleMouse = 0 }
local scrollDelay = { up = Handler.scrollDelayBase, down = Handler.scrollDelayBase, left = Handler.scrollDelayBase, right =
Handler.scrollDelayBase }

local function getScrollDelay(key, now)
    if holdStart[key] == 0 then holdStart[key] = now end
    local heldTime = now - holdStart[key]
    if heldTime > Handler.accelThreshold then
        return math.max(Handler.scrollMinDelay, scrollDelay[key] - Handler.accelStep)
    else
        return Handler.scrollDelayBase
    end
end


local initialized = false

function Handler.Update()
    local now = os.clock() * 1000
    State.upPressed, State.downPressed = false, false
    State.leftPressed, State.rightPressed = false, false
    State.selectPressed, State.backPressed = false, false
    State.miscPressed = false

    Restrictions.Update()
    Cursor.Update()

    if(not initialized ) then
        State.InitializeTracking()
        BindManager.Initialize()
        initialized = true
    end

    BindManager.Update()

    -- We don't need the menu closing or opening in case you're binding the main open key
    if State.bindingKey then
        return
    end


    if Bindings.IsActionDown("TOGGLE") and now - lastTick.toggle > Handler.scrollDelayBase then
        State.ToggleMenu()
        Logger.Log("Controls: Menu toggled " .. tostring(State.menuOpen))
        lastTick.toggle = now
    end

    if not State.menuOpen then
        holdStart.up, holdStart.down, holdStart.left, holdStart.right = 0, 0, 0, 0
        return
    end

    if State.typingEnabled then
        return
    end


    if Bindings.IsActionDown("UP") and now - lastTick.up > scrollDelay.up then
        State.upPressed = true
        lastTick.up = now
        scrollDelay.up = getScrollDelay("up", now)
        GameHUD.PlaySound("ui_menu_onpress")
    elseif not Bindings.IsActionDown("UP") then
        holdStart.up, scrollDelay.up = 0, Handler.scrollDelayBase
    end

    if Bindings.IsActionDown("DOWN") and now - lastTick.down > scrollDelay.down then
        State.downPressed = true
        lastTick.down = now
        scrollDelay.down = getScrollDelay("down", now)
        GameHUD.PlaySound("ui_menu_onpress")
    elseif not Bindings.IsActionDown("DOWN") then
        holdStart.down, scrollDelay.down = 0, Handler.scrollDelayBase
    end

    if Bindings.IsActionDown("LEFT") and now - lastTick.left > scrollDelay.left then
        State.leftPressed = true
        lastTick.left = now
        scrollDelay.left = getScrollDelay("left", now)
        GameHUD.PlaySound("ui_menu_onpress")
    elseif not Bindings.IsActionDown("LEFT") then
        holdStart.left, scrollDelay.left = 0, Handler.scrollDelayBase
    end

    if Bindings.IsActionDown("RIGHT") and now - lastTick.right > scrollDelay.right then
        State.rightPressed = true
        lastTick.right = now
        scrollDelay.right = getScrollDelay("right", now)
        GameHUD.PlaySound("ui_menu_onpress")
    elseif not Bindings.IsActionDown("RIGHT") then
        holdStart.right, scrollDelay.right = 0, Handler.scrollDelayBase
    end

    if Bindings.IsActionDown("SELECT") and now - lastTick.select > Handler.scrollDelayBase then
        if State.typingEnabled then return end
        State.selectPressed = true
        lastTick.select = now
    end

    if Bindings.IsActionDown("BACK") and now - lastTick.back > Handler.scrollDelayBase then
        State.backPressed = true
        SubmenuManager.CloseSubmenu()
        lastTick.back = now
    end

    if Bindings.IsActionDown("MISC") and now - lastTick.misc > Handler.scrollDelayBase then
        State.miscPressed = true
        lastTick.misc = now
    end

    if Bindings.IsActionDown("TOGGLE_MOUSE") and now - lastTick.toggleMouse > Handler.scrollDelayBase then
        State.ToggleMouse()
        lastTick.toggleMouse = now
    end
    Navigation.ApplyNavigation()
end

return Handler
