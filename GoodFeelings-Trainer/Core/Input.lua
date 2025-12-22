local Input = {}
local ETInput = nil

local Logger = require("Core/Logger")

function Input.Initialize()
    ETInput = EasyInputHandler.new()
    if ETInput then
        Logger.Log("Input: EasyInputHandler initialized")
    else
        Logger.Log("Input: Failed to initialize EasyInputHandler. Check Redscript install.")
    end
end

-- Always use this to fetch
local function GetETInput()
    if not ETInput then
        Input.Initialize()
    end
    return ETInput
end

local lastDevice = "Keyboard"

---Update and return the last active input device  
---Checks keyboard and gamepad activity, defaults to Unknown  
---@return string Keyboard, string Controller, string Unknown  
function Input.UpdateDevice()
    local et = GetETInput()
    if et:IsKeyboardActive() then
        lastDevice = "Keyboard"
    elseif et:IsGamepadActive() then
        lastDevice = "Controller"
    end
    return lastDevice -- This should be OK right?
end


function Input.GetLastDevice()
    return lastDevice
end

function Input.IsController()
    return lastDevice == "Controller"
end

function Input.IsKeyboard()
    return lastDevice == "Keyboard"
end


Input.VK = {
    UP = 0x26,
    DOWN = 0x28,
    LEFT = 0x25,
    RIGHT = 0x27,

    ENTER = 0x0D,
    BACKSPACE = 0x08,
    ESCAPE = 0x1B,
    TAB = 0x09,
    SHIFT = 0x10,
    CTRL = 0x11,
    ALT = 0x12,
    SPACE = 0x20,
}

for i = 0, 9 do Input.VK[tostring(i)] = 0x30 + i end
for c = 65, 90 do Input.VK[string.char(c)] = c end
for i = 1, 24 do Input.VK["F" .. i] = 0x70 + (i - 1) end
for i = 0, 9 do Input.VK["NUMPAD" .. i] = 0x60 + i end

Input.VK.NUMPAD_MULTIPLY = 0x6A
Input.VK.NUMPAD_ADD = 0x6B
Input.VK.NUMPAD_SUBTRACT = 0x6D
Input.VK.NUMPAD_DECIMAL = 0x6E
Input.VK.NUMPAD_DIVIDE = 0x6F

Input.GP = {
    DPAD_UP = 0x0001,
    DPAD_DOWN = 0x0002,
    DPAD_LEFT = 0x0004,
    DPAD_RIGHT = 0x0008,

    START = 0x0010,
    BACK = 0x0020,

    LEFT_STICK = 0x0040,
    RIGHT_STICK = 0x0080,

    LEFT_BUMPER = 0x0100,
    RIGHT_BUMPER = 0x0200,

    LEFT_TRIGGER = 0x0400,
    RIGHT_TRIGGER = 0x0800,

    A = 0x1000,
    B = 0x2000,
    X = 0x4000,
    Y = 0x8000,
}

Input.GP_AXIS = {
    LEFT_X = 0,
    LEFT_Y = 1,
    RIGHT_X = 2,
    RIGHT_Y = 3,
    LEFT_TRIGGER = 4,
    RIGHT_TRIGGER = 5,
}


---Check if a virtual key is currently pressed.  
---Pass a Windows virtual key code, e.g. Input.VK.SPACE or 0x41 for A.  
---@param vk integer Virtual key code  
---@return boolean True if the key is currently held down  
function Input.IsKeyDown(vk)
    return GetETInput():IsKeyPressed(vk)
end

---Get the last pressed virtual key code.  
---@return integer Virtual key code (Windows VK)  
function Input.GetPressedKey()
    return GetETInput():GetPressedKey()
end

---Check if a specific gamepad button is pressed.  
---Pass one of the XInput button flags from Input.GP, e.g. Input.GP.A.  
---@param btn integer XInput gamepad button flag  
---@return boolean True if the button is currently held down  
function Input.IsButtonDown(btn)
    return GetETInput():IsGamepadButtonPressed(btn)
end

---Get the last pressed gamepad button code.  
---@return integer Button flag from Input.GP  
function Input.GetPressedButton()
    return GetETInput():GetPressedGamepadButton()
end

---Show or hide the mouse cursor.  
---@param enable boolean True = show, false = hide  
---@return boolean New cursor visibility state  
function Input.ShowCursor(enable)
    return GetETInput():ShowCursor(enable)
end

---Check if the mouse cursor is visible.  
---@return boolean  
function Input.IsCursorVisible()
    return GetETInput():IsCursorVisible()
end

---Check if the left stick is tilted in a specific direction.  
---Valid directions: up, down, left, right,  
---upleft, upright, downleft, downright.  
---@param dir string  
---@return boolean  
function Input.IsLeftStickDirection(dir)
    return GetETInput():IsLeftStickDirection(dir)
end

---Check if the right stick is tilted in a specific direction.  
---Valid directions: up, down, left, right,  
---upleft, upright, downleft, downright.  
---@param dir string  
---@return boolean  
function Input.IsRightStickDirection(dir)
    return GetETInput():IsRightStickDirection(dir)
end

---Get raw axis value from the gamepad.  
---Usually in the range -32768..32767 depending on axis.  
---@param axis integer Axis ID (see Input.GP_AXIS)  
---@return integer  
function Input.GetGamepadAxis(axis)
    return GetETInput():GetGamepadAxis(axis)
end

---Get raw left trigger value.  
---@return integer Range usually 0–65535  
function Input.GetLeftTrigger()
    return GetETInput():GetLeftTrigger()
end

---Get raw right trigger value.  
---@return integer Range usually 0–65535  
function Input.GetRightTrigger()
    return GetETInput():GetRightTrigger()
end

---Get normalized left trigger value (0.0–1.0).  
---@return number  
function Input.GetLeftTriggerNormalized()
    return GetETInput():GetLeftTriggerNormalized()
end

---Get normalized right trigger value (0.0–1.0).  
---@return number  
function Input.GetRightTriggerNormalized()
    return GetETInput():GetRightTriggerNormalized()
end

---Set gamepad vibration (dual motors).  
---@param left integer Left motor strength (0–65535)  
---@param right integer Right motor strength (0–65535)  
---@return boolean Success  
function Input.SetVibration(left, right)
    return GetETInput():SetGamepadVibration(left, right)
end

return Input
