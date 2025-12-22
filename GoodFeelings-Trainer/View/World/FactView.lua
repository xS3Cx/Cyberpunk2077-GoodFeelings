local UI = require("UI")
local Buttons = UI.Buttons
local NotificationManager = UI.Notifier

local GameFacts = require("Utils").Facts
local Facts = require("Features/World").Facts

local factCategories = {
    { key = "RomanceFlags", label = "gamefacts.categories.romance" },
    { key = "StoryOutcomeFlags", label = "gamefacts.categories.storyoutcomes" },
    { key = "SmartWeaponStates", label = "gamefacts.categories.skippystates" },
    { key = "GameplayToggles", label = "gamefacts.categories.gameplaytoggles" },
    -- { key = "LifePathFlags", label = "gamefacts.categories.lifepath" },
    { key = "WorldEventFlags", label = "gamefacts.categories.worldevents" },
    { key = "CensorshipFlags", label = "gamefacts.categories.censorship" }
}

local factLabels = {
    "gamefacts.categories.romance",
    "gamefacts.categories.storyoutcomes",
    "gamefacts.categories.skippystates",
    "gamefacts.categories.gameplaytoggles",
    -- "gamefacts.categories.lifepath",
    "gamefacts.categories.worldevents",
    "gamefacts.categories.censorship"
}

local selectedCategory = { index = 1, expanded = false }
local initializedCategories = {}
local factToggles = {}

local function GetOrCreateToggle(entry)
    if not factToggles[entry.id] then
        factToggles[entry.id] = Facts.MakeToggle(entry.id)
    end
    return factToggles[entry.id]
end

local function InitializeCategory(categoryKey)
    if initializedCategories[categoryKey] then return end
    initializedCategories[categoryKey] = true

    for _, entry in ipairs(GameFacts.FactFlags[categoryKey]) do
        local toggle = GetOrCreateToggle(entry)
        toggle.value = Facts.IsTrue(entry.id)
    end
end

local function DrawRelationshipFacts()
    Buttons.Break(L("gamefacts.relationshiptracking.label"))
    for _, entry in ipairs(GameFacts.RelationshipTrackingFacts) do
        local rawValue = Facts.Get(entry.id)
        local display = (rawValue ~= nil and rawValue ~= "") and tostring(rawValue) or L("gamefacts.notavailable.label")
        Buttons.OptionExtended(entry.name, nil, display)
    end
end

local function GameFactsView()
    Buttons.Dropdown(
        L("gamefacts.category.label"),
        selectedCategory,
        factLabels,
        L("gamefacts.category.tip")
    )

    local categoryKey = factCategories[selectedCategory.index].key
    local categoryLabel = L(factCategories[selectedCategory.index].label)

    local entries = GameFacts.FactFlags[categoryKey]
    InitializeCategory(categoryKey)

    Buttons.Break("", tip("gamefacts.flagsbreak.tip", { category = categoryLabel }))

    for _, entry in ipairs(entries) do
        local toggle = GetOrCreateToggle(entry)
        Buttons.Toggle(entry.name, toggle, entry.desc, function()
            toggle.value = not Facts.IsTrue(entry.id)
            Facts.SetBool(entry.id, toggle.value)
            NotificationManager.Push(
                toggle.value
                    and tip("gamefacts.factnotification.enabled", { name = entry.name })
                    or tip("gamefacts.factnotification.disabled", { name = entry.name })
            )
        end)
    end
end

return {
    title = "gamefacts.title",
    view = GameFactsView
}
