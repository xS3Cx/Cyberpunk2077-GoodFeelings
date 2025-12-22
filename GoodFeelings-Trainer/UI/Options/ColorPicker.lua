local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Option = require("UI/Options/Option")
local OptionRow = require("UI/Elements/OptionRow")
local State = require("Controls/State")

local ColorPicker = {}

---@param label string
---@param ref table { Red:number, Green:number, Blue:number, Alpha:number }
---@param tip string|nil
---@return boolean changed
function ColorPicker.Option(label, ref, tip)
    local keyTip = L("optionmanager.color_tip")
    local fullTip = (tip and (tip.."\n\n") or "")..keyTip
    local clicked,pos = Option.Option(label,"","",fullTip)
    if not pos then return false end

    local size = UI.ColorPicker.ChannelBoxSize
    local sx = pos.x+pos.w-UI.Layout.LabelOffsetX-size
    local sy = pos.y+(pos.h-size)*0.5
    local u32 = ImGui.ColorConvertFloat4ToU32({ref.Red/255,ref.Green/255,ref.Blue/255,ref.Alpha/255})
    DrawHelpers.RectFilled(sx,sy,size,size,u32,UI.ColorPicker.Rounding)

    ref._expanded = ref._expanded or false
    ref._reveal = ref._reveal or 0
    ref._lastFrame = ref._lastFrame or 0
    if clicked then
        ref._expanded = not ref._expanded
        if ref._expanded then
            ref._reveal,ref._lastFrame = 0,ImGui.GetFrameCount()
        end
    end
    if not ref._expanded then return false end

    local names = {"- Red","- Green","- Blue","- Alpha"}
    local keys = {"Red","Green","Blue","Alpha"}
    local cur = ImGui.GetFrameCount()
    local fpo = UI.Dropdown.FramesPerOption or 3
    local changed = false

    if ref._reveal < 4 and cur-ref._lastFrame >= fpo then
        ref._reveal,ref._lastFrame = ref._reveal+1,cur
    end

    for i=1,ref._reveal do
        local k,row,val = keys[i],names[i],ref[keys[i]] or 0
        local rowClicked,p = Option.Option(row,"","",nil)
        if not p then break end

        local valueText = string.format("%d / 255",val)
        local vw = ImGui.CalcTextSize(valueText)
        local boxW,boxH = vw+10,p.h-UI.ColorPicker.RowSpacing
        local boxX = p.x+p.w-UI.Layout.LabelOffsetX-UI.ColorPicker.PreviewBoxSize-boxW-UI.ColorPicker.ChannelPadding
        local boxY = p.y+(p.h-boxH)*0.5
        DrawHelpers.RectFilled(boxX,boxY,boxW,boxH,UI.ColorPicker.FrameBg,UI.ColorPicker.Rounding)
        DrawHelpers.Text(boxX+5,p.fontY,UI.ColorPicker.TextColor,valueText)

        local px = p.x+p.w-UI.Layout.LabelOffsetX-UI.ColorPicker.PreviewBoxSize
        local py = p.y+(p.h-UI.ColorPicker.PreviewBoxSize)*0.5
        local prev = {0,0,0,1}
        prev[i] = val/255
        local u = ImGui.ColorConvertFloat4ToU32(prev)
        DrawHelpers.Rect(px,py,UI.ColorPicker.PreviewBoxSize,UI.ColorPicker.PreviewBoxSize,UI.ColorPicker.BorderColor,UI.ColorPicker.Rounding)
        DrawHelpers.RectFilled(px+2,py+2,UI.ColorPicker.PreviewBoxSize-4,UI.ColorPicker.PreviewBoxSize-4,u,UI.ColorPicker.Rounding-2)

        if p.isActive then
            if State.leftPressed then val = val==0 and 255 or val-1 changed = true
            elseif State.rightPressed then val = val==255 and 0 or val+1 changed = true end
            ref[k] = val
        end
    end

    return changed
end

return ColorPicker
