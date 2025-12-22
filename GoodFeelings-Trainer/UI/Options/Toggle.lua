local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Option = require("UI/Options/Option")

local Toggle = {}

---@param label string
---@param ref table { value:boolean }
---@param tip string|nil
---@return boolean clicked
function Toggle.Option(label, ref, tip)
    local clicked,pos = Option.Option(label,"","",tip)
    if not pos then return false end

    local size = UI.Toggle.Size
    local tx = pos.x+pos.w-UI.Layout.LabelOffsetX-size
    local ty = pos.y+(pos.h-size)*0.5

    if pos.isActive then
        local stateText = ref.value and L("optionmanager.on") or L("optionmanager.off")
        local w = ImGui.CalcTextSize(stateText)
        local pad,spacing = UI.Toggle.StatePadding,UI.Toggle.StateSpacing
        local sx = tx-w-(pad+spacing)
        DrawHelpers.RectFilled(sx-pad,ty-2,w+pad*2,size+4,UI.Toggle.FrameBg,UI.Toggle.Rounding)
        DrawHelpers.Text(sx,pos.fontY,UI.Toggle.TextColor,stateText)
    end

    DrawHelpers.Rect(tx,ty,size,size,UI.Toggle.BorderColor,UI.Toggle.Rounding)
    local inset = UI.Toggle.Inset
    if ref.value then
        DrawHelpers.RectFilled(tx+inset,ty+inset,size-inset*2,size-inset*2,UI.Toggle.OnColor,UI.Toggle.Rounding-2)
    else
        DrawHelpers.RectFilled(tx+inset,ty+inset,size-inset*2,size-inset*2,UI.Toggle.OffColor,UI.Toggle.Rounding-2)
    end

    if clicked then ref.value = not ref.value end
    return clicked
end

return Toggle
