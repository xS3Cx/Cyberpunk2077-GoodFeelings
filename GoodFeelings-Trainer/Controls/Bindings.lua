local Input = require("Core/Input")
local BindingsConfig = require("Config/BindingsConfig")

local Bindings = {}

-- Utility to normalize key/button arrays (unique + sorted)
local function normalize(list)
    local seen, out = {}, {}
    for _, v in ipairs(list or {}) do
        if not seen[v] then
            table.insert(out, v)
            seen[v] = true
        end
    end
    table.sort(out)
    return out
end

Bindings.DefaultActions = {
    UP = { keys = { Input.VK.UP }, btns = { Input.GP.DPAD_UP } },
    DOWN = { keys = { Input.VK.DOWN }, btns = { Input.GP.DPAD_DOWN } },
    LEFT = { keys = { Input.VK.LEFT }, btns = { Input.GP.DPAD_LEFT } },
    RIGHT = { keys = { Input.VK.RIGHT }, btns = { Input.GP.DPAD_RIGHT } },

    SELECT = { keys = { Input.VK.ENTER }, btns = { Input.GP.A } },
    BACK = { keys = { Input.VK.BACKSPACE }, btns = { Input.GP.B } },

    MISC = { keys = { Input.VK.C }, btns = { Input.GP.LEFT_BUMPER, Input.GP.A } },

    TOGGLE = { keys = { Input.VK.F4 }, btns = { Input.GP.RIGHT_BUMPER, Input.GP.A } },
    --I don't think we need a Mouse toggle on controller OR! do we. Could maybe implement the cursor through the right stick maybe in the future.
    TOGGLE_MOUSE = { keys = { Input.VK.X }, btns = { } },

    WORLD_INTERACT = { keys = { Input.VK.Q }, btns = { Input.GP.Y } }
}

Bindings.Actions = {}
for k,v in pairs(Bindings.DefaultActions) do
    Bindings.Actions[k] = {
        keys = normalize(v.keys),
        btns = normalize(v.btns)
    }
end

-- Check if *all* keys in a list are currently pressed
local function allKeysDown(keys)
    if not keys or #keys == 0 then return false end
    for _, vk in ipairs(keys) do
        if not Input.IsKeyDown(vk) then
            return false
        end
    end
    return true
end

-- Check if *all* buttons in a list are currently pressed
local function allBtnsDown(btns)
    if not btns or #btns == 0 then return false end
    for _, gp in ipairs(btns) do
        if not Input.IsButtonDown(gp) then
            return false
        end
    end
    return true
end

--- Returns true if action combo is satisfied
function Bindings.IsActionDown(action)
    local b = Bindings.Actions[action]
    if not b then return false end
    if allKeysDown(b.keys) then return true end
    if allBtnsDown(b.btns) then return true end
    return false
end

--- Rebind a keyboard and/or controller set for an action
---@param action string
---@param newBinding table { keys? = {..}, btns? = {..} }
function Bindings.Rebind(action, newBinding)
    if not Bindings.Actions[action] then return false end
    if newBinding.keys then
        Bindings.Actions[action].keys = normalize(newBinding.keys)
    end
    if newBinding.btns then
        Bindings.Actions[action].btns = normalize(newBinding.btns)
    end
    -- BindingsConfig.Save() It's only used in bindbuttons so it already saves when it's binded successfully so there's no point of having it here
    return true
end

function Bindings.ResetAction(action)
    local def = Bindings.DefaultActions[action]
    if def then
        Bindings.Actions[action] = {
            keys = normalize(def.keys),
            btns = normalize(def.btns)
        }
    end
    BindingsConfig.Save() -- Making sure we save the binding after we reset them
end

function Bindings.ResetAll()
    for k,v in pairs(Bindings.DefaultActions) do
        Bindings.Actions[k] = {
            keys = normalize(v.keys),
            btns = normalize(v.btns)
        }
    end
    BindingsConfig.Save()
end

Bindings.Normalize = normalize

function Bindings.IsComboActive(combo)
    if combo.keys and allKeysDown(combo.keys) then return true end
    if combo.btns and allBtnsDown(combo.btns) then return true end
    return false
end

return Bindings
