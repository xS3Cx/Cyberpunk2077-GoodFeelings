-- View/Debug/HUDMessagesView.lua
local UI = require("UI")
local GameHUD = require("Core/cp2077-cet-kit/GameHUD")

local HUDMessagesView = {}

local hudMessageInput = { value = "Custom HUD Message" }

local function HUDMessagesViewFunction()
    UI.Buttons.Break("HUD Messages")
    UI.Buttons.Text("Message Content", hudMessageInput, "Message for GameHUD.ShowMessage")
    if UI.Buttons.Option("Send Message", "Trigger native on-screen message") then
        GameHUD.ShowMessage(hudMessageInput.value)
    end
end

local HUDMessagesView = { 
    title = "HUD Messages", 
    view = HUDMessagesViewFunction 
}

return HUDMessagesView
