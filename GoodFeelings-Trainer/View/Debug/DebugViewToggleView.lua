-- View/Debug/DebugViewToggleView.lua
local UI = require("UI")
local Buttons = UI.Buttons

local debugViewModes = {
    "NONE",
    "CLAY", 
    "PURE_GRAY",
    "PURE_WHITE",
    "SHADOWS",
    "BASE_COLOR",
    "NORMALS",
    "ROUGHNESS",
    "METALNESS",
    "EMISSIVE",
    "MATERIAL_ID",
    "WIREFRAME",
    "OVERDRAW"
}

local modeLabels = {}
for _, mode in ipairs(debugViewModes) do
    table.insert(modeLabels, mode)
end

local selectedMode = { index = 1, expanded = false }

local function GetDebugViewModeEnum(debugView)
    if debugView == "CLAY" then return questEDebugViewMode.CLAY end
    if debugView == "PURE_GRAY" then return questEDebugViewMode.PURE_GRAY end
    if debugView == "PURE_WHITE" then return questEDebugViewMode.PURE_WHITE end
    if debugView == "SHADOWS" then return questEDebugViewMode.SHADOWS end
    if debugView == "BASE_COLOR" then return questEDebugViewMode.BASE_COLOR end
    if debugView == "NORMALS" then return questEDebugViewMode.NORMALS end
    if debugView == "ROUGHNESS" then return questEDebugViewMode.ROUGHNESS end
    if debugView == "METALNESS" then return questEDebugViewMode.METALNESS end
    if debugView == "EMISSIVE" then return questEDebugViewMode.EMISSIVE end
    if debugView == "MATERIAL_ID" then return questEDebugViewMode.MATERIAL_ID end
    if debugView == "WIREFRAME" then return questEDebugViewMode.WIREFRAME end
    if debugView == "OVERDRAW" then return questEDebugViewMode.OVERDRAW end
    return questEDebugViewMode.NONE
end

local function ChangeDebugView(newDebugView)
    local questsSys = Game.GetQuestsSystem()
    local questNode = questRenderFxManagerNodeDefinition.new()
    local renderFXManager = questSetDebugView_NodeType.new()
    renderFXManager.mode = GetDebugViewModeEnum(newDebugView)
    questNode.type = renderFXManager
    questsSys:ExecuteNode(questNode)
end

local previousMode = 1

local function DebugViewToggleViewFunction()
    Buttons.Break("Debug View Modes")
    
    Buttons.Dropdown("View Mode", selectedMode, modeLabels, "Select rendering debug view mode")
    
    -- Apply mode when changed
    if selectedMode.index ~= previousMode then
        previousMode = selectedMode.index
        local mode = debugViewModes[selectedMode.index]
        ChangeDebugView(mode)
        UI.Notification.Success("Debug View: " .. mode)
    end
    
    Buttons.Break("Quick Actions")
    
    if Buttons.Option("Reset to Normal", "Reset to normal rendering (NONE)") then
        selectedMode.index = 1
        ChangeDebugView("NONE")
        UI.Notification.Info("Reset to normal view")
    end
    
    Buttons.Break("Info")
    Buttons.OptionExtended("Current Mode", nil, debugViewModes[selectedMode.index])
end

return {
    title = "Debug View Toggle",
    view = DebugViewToggleViewFunction
}
