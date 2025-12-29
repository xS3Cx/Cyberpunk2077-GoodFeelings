-- View/World/Facts/WorldEventsView.lua
local UI = require("UI")
local Buttons = UI.Buttons
local NotificationManager = UI.Notifier

local GameFacts = require("Utils").Facts
local Facts = require("Features/World").Facts

local factToggles = {}

local function GetOrCreateToggle(entry)
    if not factToggles[entry.id] then
        factToggles[entry.id] = Facts.MakeToggle(entry.id)
    end
    return factToggles[entry.id]
end

local function WorldEventsViewFunction()
    local entries = GameFacts.FactFlags.WorldEventFlags
    
    for _, entry in ipairs(entries) do
        local toggle = GetOrCreateToggle(entry)
        toggle.value = Facts.IsTrue(entry.id)
        
        Buttons.Toggle(entry.name, toggle, entry.desc, function()
            toggle.value = not Facts.IsTrue(entry.id)
            Facts.SetBool(entry.id, toggle.value)
            NotificationManager.Push(
                toggle.value
                    and (entry.name .. " enabled")
                    or (entry.name .. " disabled")
            )
        end)
    end
end

return {
    title = "World Events",
    view = WorldEventsViewFunction
}
