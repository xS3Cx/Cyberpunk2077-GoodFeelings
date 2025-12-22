local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Option = require("UI/Options/Option")
local OptionRow = require("UI/Elements/OptionRow")
local State = require("Controls/State")

local StringCycler = {}

---@param label string
---@param ref table { index:number }
---@param options table<string> list of labels
---@param tip string|nil
---@param tip onClick|nil If set to true it'll only return true onclick
---@return boolean changed
function StringCycler.Option(label, ref, options, tip, onClick)
    local keyTip = L("optionmanager.stringcycler_tip")
    local fullTip = keyTip .. (tip and ("\n\n" .. tip) or "")

    local clicked, pos = Option.Option(label, "", "", fullTip)
    if not pos then return false end

    local idx = ref.index or 1
    local text = L(options[idx]) or "None"
    local tw = ImGui.CalcTextSize(text)

    local fpad, tpad = UI.StringCycler.FramePadding, UI.StringCycler.TextPadding
    local bx = pos.x + pos.w - UI.Layout.LabelOffsetX - tw - fpad * 2
    local by, bw, bh = pos.y + tpad, tw + fpad * 2, pos.h - tpad * 2

    DrawHelpers.RectFilled(bx, by, bw, bh, UI.StringCycler.FrameBg, UI.StringCycler.BoxRounding)
    DrawHelpers.Text(bx + fpad, pos.fontY, UI.StringCycler.ValueColor, text)

    if pos.isActive then
        if State.leftPressed then
            ref.index = (idx - 2) % #options + 1
            return not onClick
        elseif State.rightPressed then
            ref.index = idx % #options + 1
            return not onClick
        end
    end

    return clicked
end

return StringCycler
