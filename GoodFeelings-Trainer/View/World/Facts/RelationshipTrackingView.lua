-- View/World/Facts/RelationshipTrackingView.lua
local UI = require("UI")
local Buttons = UI.Buttons

local GameFacts = require("Utils").Facts
local Facts = require("Features/World").Facts

local function RelationshipTrackingViewFunction()
    for _, entry in ipairs(GameFacts.RelationshipTrackingFacts) do
        local rawValue = Facts.Get(entry.id)
        local display = (rawValue ~= nil and rawValue ~= "") and tostring(rawValue) or "Not Available"
        Buttons.OptionExtended(entry.name, nil, display)
    end
end

return {
    title = "Relationship Tracking",
    view = RelationshipTrackingViewFunction
}
