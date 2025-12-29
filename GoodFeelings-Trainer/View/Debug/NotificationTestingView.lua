-- View/Debug/NotificationTestingView.lua
local UI = require("UI")

local NotificationTestingView = {}

local function TestOnscreenMessage()
    local MSG = SimpleScreenMessage.new()
    MSG.message = 'Hello World'
    MSG.isShown = true
    MSG.duration = 8.00
    Game.GetBlackboardSystem():Get(GetAllBlackboardDefs().UI_Notifications):SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(MSG), true)
end

local function TestShardMessage()
    local head = "This is a title"
    local body = "This is a message.\\n:)"
    Game.GetUISystem():QueueEvent(NotifyShardRead.new({title = head, text = body}))
end

local function TestAlertMessage()
    PreventionSystem.ShowMessage("Hello world", 10.0)
end

local function TestWarningMessage(msgType)
    local text = "Hello world"
    Game.GetPlayer():SetWarningMessage(text, msgType)
end

local function NotificationTestingViewFunction()
    UI.Buttons.Break("Notification Types")
    if UI.Buttons.Option("On-Screen Message (Screen Side)") then TestOnscreenMessage() end
    if UI.Buttons.Option("In-Game Shard Message") then TestShardMessage() end
    if UI.Buttons.Option("In-Game Alert Message") then TestAlertMessage() end
    if UI.Buttons.Option("In-Game Neutral Message") then TestWarningMessage(gameSimpleMessageType.Neutral) end
    if UI.Buttons.Option("In-Game Relic Message") then TestWarningMessage(gameSimpleMessageType.Relic) end
    if UI.Buttons.Option("In-Game Money Message") then TestWarningMessage("Money") end
end

local NotificationTestingView = { 
    title = "Notification Testing", 
    view = NotificationTestingViewFunction 
}

return NotificationTestingView
