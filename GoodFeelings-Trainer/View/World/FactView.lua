local UI = require("UI")
local Buttons = UI.Buttons

local function GameFactsView()
    -- Main Categories
    Buttons.Submenu("Romance Flags", require("View/World/Facts/RomanceFlagsView"), "Manage romance-related game facts")
    Buttons.Submenu("Story Outcomes", require("View/World/Facts/StoryOutcomesView"), "Manage story outcome flags")
    Buttons.Submenu("Skippy States", require("View/World/Facts/SkippyStatesView"), "Manage smart weapon (Skippy) states")
    Buttons.Submenu("Gameplay Toggles", require("View/World/Facts/GameplayTogglesView"), "Toggle gameplay-related facts")
    Buttons.Submenu("World Events", require("View/World/Facts/WorldEventsView"), "Manage world event flags")
    Buttons.Submenu("Censorship", require("View/World/Facts/CensorshipView"), "Manage censorship-related flags")
    Buttons.Submenu("Relationship Tracking", require("View/World/Facts/RelationshipTrackingView"), "View relationship tracking values")
end

return {
    title = "gamefacts.title",
    view = GameFactsView
}
