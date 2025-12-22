-- View/Settings/NavigationSettingsView.lua
local Buttons = require("UI").Buttons
local Handler = require("Controls/Handler")
local NavigationConfig = require("Config/NavigationConfig")
local Bindings = require("Controls/Bindings")

local scrollDelayRef = { value = Handler.scrollDelayBase, min = 50, max = 1000 }
local minDelayRef = { value = Handler.scrollMinDelay, min = 1, max = 200 }
local accelThresholdRef = { value = Handler.accelThreshold, min = 100, max = 5000 }
local accelStepRef = { value = Handler.accelStep, min = 1, max = 100 }

local function NavigationSettingsViewFunction()
    Buttons.Option(L("settings.navigation.save.label"), tip("settings.navigation.save.tip"), NavigationConfig.Save)
    Buttons.Option(L("settings.navigation.load.label"), tip("settings.navigation.load.tip"), NavigationConfig.Load)
    Buttons.Option(L("settings.navigation.reset.label"), tip("settings.navigation.reset.tip"), NavigationConfig.Reset)
    Buttons.Option(L("settings.navigation.resetbindings.label"), tip("settings.navigation.resetbindings.tip"), Bindings.ResetAll)

    Buttons.Break(L("settings.navigation.bindings.label"))

    Buttons.Bind(L("settings.navigation.bindings.openmenu.label"), "TOGGLE", tip("settings.navigation.bindings.openmenu.tip"))
    Buttons.Bind(L("settings.navigation.bindings.togglemouse.label"), "TOGGLE_MOUSE", tip("settings.navigation.bindings.togglemouse.tip"))
    Buttons.Bind(L("settings.navigation.bindings.up.label"), "UP", tip("settings.navigation.bindings.up.tip"))
    Buttons.Bind(L("settings.navigation.bindings.down.label"), "DOWN", tip("settings.navigation.bindings.down.tip"))
    Buttons.Bind(L("settings.navigation.bindings.left.label"), "LEFT", tip("settings.navigation.bindings.left.tip"))
    Buttons.Bind(L("settings.navigation.bindings.right.label"), "RIGHT", tip("settings.navigation.bindings.right.tip"))
    Buttons.Bind(L("settings.navigation.bindings.select.label"), "SELECT", tip("settings.navigation.bindings.select.tip"))
    Buttons.Bind(L("settings.navigation.bindings.back.label"), "BACK", tip("settings.navigation.bindings.back.tip"))
    Buttons.Bind(L("settings.navigation.bindings.misc.label"), "MISC", tip("settings.navigation.bindings.misc.tip"))

    Buttons.Break(L("settings.navigation.speed.label"))
    if Buttons.Int(L("settings.navigation.speed.scrolldelay.label"), scrollDelayRef, tip("settings.navigation.speed.scrolldelay.tip")) then
        Handler.scrollDelayBase = scrollDelayRef.value
    end
    if Buttons.Int(L("settings.navigation.speed.scrollmindelay.label"), minDelayRef, tip("settings.navigation.speed.scrollmindelay.tip")) then
        Handler.scrollMinDelay = minDelayRef.value
    end
    if Buttons.Int(L("settings.navigation.speed.accelthreshold.label"), accelThresholdRef, tip("settings.navigation.speed.accelthreshold.tip")) then
        Handler.accelThreshold = accelThresholdRef.value
    end
    if Buttons.Int(L("settings.navigation.speed.accelstep.label"), accelStepRef, tip("settings.navigation.speed.accelstep.tip")) then
        Handler.accelStep = accelStepRef.value
    end
end

local NavigationSettingsView = { title = "settings.navigation.title", view = NavigationSettingsViewFunction }

return NavigationSettingsView
