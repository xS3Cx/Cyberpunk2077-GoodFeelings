local UI = require("UI")
local Buttons = UI.Buttons
local WorldInteractions = require("Features/World/WorldInteractions")

local function WorldInteractionViewFunction()
    Buttons.Break("Key")
    Buttons.Bind(
        L("worldinteractions.hotkey.label"),
        "WORLD_INTERACT",
        L("worldinteractions.hotkey.tip")
    )
    Buttons.Toggle(
        L("worldinteractions.debug.label"),
        WorldInteractions.toggleDebugObject,
        L("worldinteractions.debug.tip")
    )
    Buttons.Break(L("worldinteractions.doors.label"))
    Buttons.Toggle(
        L("worldinteractions.unlockdoor.label"),
        WorldInteractions.toggleClickDoor,
        L("worldinteractions.unlockdoor.tip")
    )
    Buttons.Toggle(
        L("worldinteractions.openfakedoors.label"),
        WorldInteractions.toggleClickRemoveFakeDoor,
        L("worldinteractions.openfakedoors.tip")
    )
    Buttons.Break(L("worldinteractions.devices.label"))
    Buttons.Toggle(
        L("worldinteractions.onqdevice.label"),
        WorldInteractions.toggleClickDevice,
        L("worldinteractions.onqdevice.tip")
    )
    Buttons.Break(L("worldinteractions.npc.label"))
    Buttons.Toggle(
        L("worldinteractions.npc_kill.label"),
        WorldInteractions.toggleInstantKill,
        L("worldinteractions.npc_kill.tip")
    )
    Buttons.Toggle(
        L("worldinteractions.onqrandomize.label"),
        WorldInteractions.toggleClickRandomizeAppearance,
        L("worldinteractions.onqrandomize.tip")
    )
    Buttons.Toggle(
        L("worldinteractions.onqremotelaunch.label"),
        WorldInteractions.toggleClickRemoteLaunch,
        L("worldinteractions.onqremotelaunch.tip")
    )
end

local WorldInteractionView = {
    title = "worldinteractions.title",
    view = WorldInteractionViewFunction
}

return WorldInteractionView
