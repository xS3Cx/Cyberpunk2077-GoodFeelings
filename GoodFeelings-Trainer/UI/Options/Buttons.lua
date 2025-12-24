local Submenus = require("UI/Core/SubmenuManager")

local Option = require("UI/Options/Option")
local Toggle = require("UI/Options/Toggle")
local Dropdown = require("UI/Options/Dropdown")
local Numeric = require("UI/Options/Numeric")
local Radio = require("UI/Options/Radio")
local StringCycler = require("UI/Options/StringCycler")
local ColorPicker = require("UI/Options/ColorPicker")
local BindButton = require("UI/Options/BindButton")
local TextInput = require("UI/Options/TextInput")

local OptionConfig = require("Config/OptionConfig")

local Buttons = {}

function Buttons.Option(label, tip, action)
    if Option.Option(label, "", "", tip) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.OptionExtended(left, center, right, tip, action)
    if Option.Option(left, center, right, tip) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.Break(left, center, right)
    return Option.Break(left, center, right)
end

local Style = require("UI/Core/Style")

function Buttons.Submenu(label, submenuId, tip, action)
    local arrow = (Style and Style.Dropdown and Style.Dropdown.ArrowRight) or ">"
    if Option.Option(label, "", arrow, tip) then
        if submenuId then Submenus.OpenSubmenu(submenuId) end
        if action then action() end
        return true
    end
    return false
end

function Buttons.Toggle(label, ref, tip, action)
    if Toggle.Option(label, ref, tip) then
        OptionConfig.Save() -- Save all toggle state immediately - Probably should do this in a much better way
        if action then action() end
        return true
    end
    return false
end

function Buttons.GhostToggle(label, ref, tip, action)
    if Toggle.Option(label, ref, tip) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.Int(label, ref, tip, action)
    if Numeric.Option(label, ref, tip, false, false) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.Float(label, ref, tip, action)
    if Numeric.Option(label, ref, tip, true, false) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.IntClick(label, ref, tip, action)
    if Numeric.Option(label, ref, tip, false, true) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.FloatClick(label, ref, tip, action)
    if Numeric.Option(label, ref, tip, true, true) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.Dropdown(label, ref, options, tip)
    Dropdown.Option(label, ref, options, tip)
end

function Buttons.Radio(label, ref, options, tip, action)
    if Radio.Option(label, ref, options, tip) then
        if action then action() end
        return true
    end
    return false
end

function Buttons.StringCycler(label, ref, options, tip)
    return StringCycler.Option(label, ref, options, tip)
end

function Buttons.StringCyclerClick(label, ref, options, tip)
    return StringCycler.Option(label, ref, options, tip, true)
end

function Buttons.Color(label, ref, tip)
    return ColorPicker.Option(label, ref, tip)
end

function Buttons.Bind(label, action, tip)
    return BindButton.Option(label, action, tip)
end

function Buttons.ColorHex(label, tbl, key, tip)
    tbl._meta = tbl._meta or {}
    tbl._meta[key] = tbl._meta[key] or {}

    local ref = tbl._meta[key]
    local hex = tbl[key]

    local f = ImGui.ColorConvertU32ToFloat4(hex)
    ref.Red = math.floor(f[1] * 255)
    ref.Green = math.floor(f[2] * 255)
    ref.Blue = math.floor(f[3] * 255)
    ref.Alpha = math.floor(f[4] * 255)

    if Buttons.Color(label, ref, tip) then
        tbl[key] = ImGui.ColorConvertFloat4ToU32({
            ref.Red / 255, ref.Green / 255, ref.Blue / 255, ref.Alpha / 255
        })
    end
end

function Buttons.Text(label, ref, tip, action)
    if TextInput.Option(label, ref, tip) then
        if action then action(ref.value) end
        return true
    end
    return false
end

return Buttons
