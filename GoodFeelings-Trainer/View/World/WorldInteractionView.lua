local UI = require("UI")
local Buttons = UI.Buttons
local WorldInteractions = require("Features/World/WorldInteractions")

local function WorldInteractionViewFunction()
    Buttons.Break(L("worldinteractions.doors.label"))
    Buttons.Option(
        L("worldinteractions.toggledoor.label"),
        L("worldinteractions.toggledoor.tip"),
        WorldInteractions.ToggleDoor
    )
    Buttons.Option(
        L("worldinteractions.destroydoor.label"),
        L("worldinteractions.destroydoor.tip"),
        WorldInteractions.DestroyDoor
    )
    Buttons.Toggle(
        L("worldinteractions.onclickdoor.label"),
        WorldInteractions.toggleClickDoor,
        L("worldinteractions.onclickdoor.tip")
    )
    Buttons.Break(L("worldinteractions.devices.label"))
    Buttons.Option(
        L("worldinteractions.toggledevices.label"),
        L("worldinteractions.toggledevices.tip"),
        WorldInteractions.ToggleDevices
    )
    Buttons.Toggle(
        L("worldinteractions.onclickdevice.label"),
        WorldInteractions.toggleClickDevice,
        L("worldinteractions.onclickdevice.tip")
    )
    Buttons.Break(L("worldinteractions.npc.label"))
    Buttons.Toggle(
        L("worldinteractions.npc_kill.label"),
        WorldInteractions.toggleInstantKill,
        L("worldinteractions.npc_kill.tip")
    )
    Buttons.Option(
        L("worldinteractions.randomizenpc.label"),
        L("worldinteractions.randomizenpc.tip"),
        WorldInteractions.RandomizeAppearance
    )
end

local WorldInteractionView = {
    title = "worldinteractions.title",
    view = WorldInteractionViewFunction
}

return WorldInteractionView
