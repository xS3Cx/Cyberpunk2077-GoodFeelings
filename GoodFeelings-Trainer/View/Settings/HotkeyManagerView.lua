-- View/Settings/HotkeyManagerView.lua
local UI = require("UI")
local Buttons = UI.Buttons
local BindManager = require("Features/BindManager")

local function HotkeyManagerViewFunction()
    local bindings = BindManager.GetBindings()
    local count = 0
    
    -- Filter and sort labels for a consistent list
    local labels = {}
    for label, _ in pairs(bindings) do
        table.insert(labels, label)
    end
    table.sort(labels)

    for _, label in ipairs(labels) do
        local data = bindings[label]
        if data.key and data.key > 0 then
            count = count + 1
            local keyName = BindManager.GetKeyName(data.key)
            
            -- Display: [LABEL] KEY: [KEYNAME] [TOGGLE]
            -- We wrap it in a pseudo-reference to use the standard Toggle.Option or Buttons.Toggle
       
            local toggleRef = { value = not data.disabled }
            
            if Buttons.Toggle(label .. "  (KEY: " .. keyName .. ")", toggleRef, "Toggle this hotkey on/off") then
                BindManager.SetDisabled(label, not toggleRef.value)
            end
        end
    end

    if count == 0 then
        Buttons.Break("No hotkeys bound")
    end
end

local HotkeyManagerView = { title = "Binding Menu", view = HotkeyManagerViewFunction }

return HotkeyManagerView
