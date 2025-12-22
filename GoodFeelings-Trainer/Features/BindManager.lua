local JsonHelper = require("Core/JsonHelper")
local Logger = require("Core/Logger")
local Input = require("Core/Input")
local State = require("Controls/State")

local BindManager = {
    filePath = "config/JSON/hotkeys.json",
    bindings = {},      -- { [label] = { key = vk, ref = table, wasDown = bool } }
    savedBindings = {}, -- { [label] = vk }
    activeSession = nil, -- { label = string, ref = table }
    waitingForRelease = false,
    
    -- Confirmation pulse
    pulseSession = nil,  -- { label = string, text = string, endTime = number }
}

-- Mapping VK to friendly names for display
local VK_NAMES = {
    [0x08] = "BACK", [0x09] = "TAB", [0x0D] = "ENTER", [0x10] = "SHIFT",
    [0x11] = "CTRL", [0x12] = "ALT", [0x1B] = "ESC", [0x20] = "SPACE",
    [0x25] = "LEFT", [0x26] = "UP", [0x27] = "RIGHT", [0x28] = "DOWN",
    [0x2E] = "DEL", [0x60] = "NUM0", [0x61] = "NUM1", [0x62] = "NUM2",
    [0x63] = "NUM3", [0x64] = "NUM4", [0x65] = "NUM5", [0x66] = "NUM6",
    [0x67] = "NUM7", [0x68] = "NUM8", [0x69] = "NUM9",
}
-- Add A-Z
for i = 65, 90 do VK_NAMES[i] = string.char(i) end
-- Add 0-9
for i = 48, 57 do VK_NAMES[i] = string.char(i) end
-- Add F1-F12
for i = 0x70, 0x7B do VK_NAMES[i] = "F" .. (i - 0x6F) end

function BindManager.GetKeyName(vk)
    return VK_NAMES[vk] or string.format("0x%X", vk)
end

function BindManager.Initialize()
    local data, err = JsonHelper.Read(BindManager.filePath)
    if data then
        BindManager.savedBindings = data
    else
        BindManager.savedBindings = {}
    end
end

function BindManager.Register(label, ref)
    if not ref or not label then return end
    
    local saved = BindManager.savedBindings[label]
    local savedKey = type(saved) == "table" and saved.key or saved
    local isDisabled = type(saved) == "table" and saved.disabled or false
    
    local existing = BindManager.bindings[label]
    
    if existing then
        existing.ref = ref
        existing.key = savedKey
        existing.disabled = isDisabled
    else
        BindManager.bindings[label] = {
            key = savedKey,
            ref = ref,
            wasDown = false,
            disabled = isDisabled
        }
    end
end

function BindManager.Update()
    local now = os.clock()

    -- 1. Manage Active Binding Session
    if BindManager.activeSession then
        if BindManager.waitingForRelease then
            if not Input.IsKeyDown(0x46) and not Input.IsKeyDown(0x47) and not Input.IsKeyDown(0x48) then
                BindManager.waitingForRelease = false
            end
            return
        end

        local key = Input.GetPressedKey()
        if key and key > 0 then
            if key == 0x46 or key == 0x47 or key == 0x48 then return end 

            if key == 0x1B then -- ESC
                BindManager.activeSession = nil
            elseif key == 0x08 then -- Backspace
                BindManager.RemoveBinding(BindManager.activeSession.label)
                BindManager.pulseSession = { 
                    label = BindManager.activeSession.label, 
                    text = "[CLEARED]", 
                    endTime = now + 2.0 
                }
                BindManager.activeSession = nil
            else
                local keyName = VK_NAMES[key] or string.format("0x%X", key)
                BindManager.SetBinding(BindManager.activeSession.label, key, BindManager.activeSession.ref)
                BindManager.pulseSession = { 
                    label = BindManager.activeSession.label, 
                    text = "[BIND: " .. keyName .. "]", 
                    endTime = now + 2.0 
                }
                BindManager.activeSession = nil
            end
        end
        return
    end

    -- 2. Process Hotkeys
    for label, data in pairs(BindManager.bindings) do
        if data.key and data.key > 0 and not data.disabled then
            local isDown = Input.IsKeyDown(data.key)
            if isDown and not data.wasDown then
                if data.ref.value ~= nil then
                    data.ref.value = not data.ref.value
                elseif data.ref.enabled ~= nil then
                    data.ref.enabled = not data.ref.enabled
                end
            end
            data.wasDown = isDown
        end
    end
end

function BindManager.SetBinding(label, key, ref)
    local existing = BindManager.bindings[label]
    local isDisabled = existing and existing.disabled or false
    
    BindManager.bindings[label] = { key = key, ref = ref, wasDown = false, disabled = isDisabled }
    BindManager.savedBindings[label] = { key = key, disabled = isDisabled }
    BindManager.Save()
end

function BindManager.SetDisabled(label, state)
    local existing = BindManager.bindings[label]
    if existing then
        existing.disabled = state
        BindManager.savedBindings[label] = { 
            key = existing.key, 
            disabled = state 
        }
        BindManager.Save()
    end
end

function BindManager.RemoveBinding(label)
    BindManager.bindings[label] = nil
    BindManager.savedBindings[label] = nil
    BindManager.Save()
end

function BindManager.Save()
    JsonHelper.Write(BindManager.filePath, BindManager.savedBindings)
end

function BindManager.GetBindings()
    return BindManager.bindings
end

function BindManager.Recruit(label, ref, isSelected)
    if not isSelected or BindManager.activeSession then return end
    
    if Input.IsKeyDown(0x46) and Input.IsKeyDown(0x47) and Input.IsKeyDown(0x48) then
        BindManager.activeSession = { label = label, ref = ref }
        BindManager.waitingForRelease = true
    end
end

--- Get status text and color for a specific option row
--- @param label string
--- @return string|nil text, integer|nil color
function BindManager.GetStatus(label)
    local now = os.clock()

    -- 1. Success Pulse
    if BindManager.pulseSession and BindManager.pulseSession.label == label then
        if now < BindManager.pulseSession.endTime then
            return BindManager.pulseSession.text, 0xFF00FF00 -- Green
        else
            BindManager.pulseSession = nil
        end
    end

    -- 2. Active Binding
    if BindManager.activeSession and BindManager.activeSession.label == label then
        if BindManager.waitingForRelease then
            return "[RELEASE F+G+H]", 0xFF00FFFF -- Yellow
        else
            -- Blink logic: white to red
            local blink = math.floor(now * 5) % 2 == 0
            local color = blink and 0xFFFFFFFF or 0xFF0000FF -- ABGR: White or Red
            return "[PRESS KEY TO BIND]", color
        end
    end

    return nil, nil
end

return BindManager
