-- View/Debug/AudioTestingView.lua
local UI = require("UI")
local GameHUD = require("Core/cp2077-cet-kit/GameHUD")

local AudioTestingView = {}

local soundInput = { value = "ui_phone_sms_incoming" }

local soundLibrary = {
    "ui_hacking_access_granted",
    "ui_hacking_access_denied",
    "ui_jingle_quest_success",
    "ui_jingle_chip_malfunction",
    "ui_messenger_select",
    "ui_menu_close",
    "ui_menu_onpress",
    "ui_menu_map_pin_created",
    "ui_menu_map_pin_on",
    "ui_menu_value_up",
    "ui_main_menu_open_tab",
    "ui_popup_lore_open"
}
local soundLibraryRef = { index = 1 }

local function AudioTestingViewFunction()
    UI.Buttons.Break("Sound Library")
    if UI.Buttons.StringCycler("Select Sound", soundLibraryRef, soundLibrary, "Use Left/Right to change sound") then
        GameHUD.PlaySound(soundLibrary[soundLibraryRef.index])
    end
    if UI.Buttons.Option("Play Selected", "Play the currently selected sound from the list") then
        GameHUD.PlaySound(soundLibrary[soundLibraryRef.index])
    end

    UI.Buttons.Break("Custom Sound")
    UI.Buttons.Text("Custom Sound", soundInput, "Type any in-game sound event name")
    if UI.Buttons.Option("Play Custom", "Play the specific sound event entered above") then
        GameHUD.PlaySound(soundInput.value)
    end
end

local AudioTestingView = { 
    title = "Audio Testing", 
    view = AudioTestingViewFunction 
}

return AudioTestingView
