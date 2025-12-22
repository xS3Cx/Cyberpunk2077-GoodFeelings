local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Option = require("UI/Options/Option")
local State = require("Controls/State")

local Numeric = {}

---@param label string
---@param ref table { value:number, enabled:boolean|nil, min:number|nil, max:number|nil, step:number|nil }
---@param tip string|nil
---@param isFloat boolean true = float, false = int
---@param onClick boolean|nil true = only return true on click
---@return boolean changed
function Numeric.Option(label, ref, tip, isFloat, onClick)
    local keyTip = isFloat and L("optionmanager.float_toggle_tip") or L("optionmanager.inttoggle_tip")
    local fullTip = keyTip..(tip and ("\n\n"..tip) or "")
    local clicked,pos = Option.Option(label,"","",fullTip)
    if not pos then return false end

    local size = UI.Numeric.ToggleSize
    local spacing = UI.Numeric.ToggleSpacing
    local fpad = UI.Numeric.BoxFramePadding
    local tpad = UI.Numeric.BoxTextPadding
    local minVal = ref.min or 0
    local maxVal = ref.max or (isFloat and 1 or 100)
    local step = ref.step or (isFloat and UI.Numeric.DefaultFloatStep or UI.Numeric.DefaultIntStep)
    local oldVal,oldEnabled = ref.value,ref.enabled

    if pos.isActive then
        if State.leftPressed then
            ref.value = ref.value-step
            if ref.value < minVal then ref.value = maxVal end
        elseif State.rightPressed then
            ref.value = ref.value+step
            if ref.value > maxVal then ref.value = minVal end
        elseif ref.enabled ~= nil and State.selectPressed then
            ref.enabled = not ref.enabled
        end
    end

    if isFloat then
        local d = UI.Numeric.Decimals or 2
        ref.value = tonumber(string.format("%."..d.."f",math.max(minVal,math.min(maxVal,ref.value))))
    else
        ref.value = math.max(minVal,math.min(maxVal,ref.value))
    end

    local valueText = isFloat
        and string.format("%."..(UI.Numeric.Decimals or 2).."f / %.2f",ref.value,maxVal)
        or string.format("%d / %d",ref.value,maxVal)

    local vw = ImGui.CalcTextSize(valueText)
    local toggleX = pos.x+pos.w-UI.Layout.LabelOffsetX-(ref.enabled ~= nil and size or 0)
    local valueX = toggleX-vw-(ref.enabled ~= nil and spacing or 0)

    DrawHelpers.RectFilled(valueX-fpad,pos.y+tpad,
        vw+(ref.enabled ~= nil and size+spacing or 0)+fpad*2,
        pos.h-tpad*2,UI.Numeric.FrameBg,UI.Layout.FrameRounding)

    local txtColor = (ref.enabled == false) and UI.Numeric.DisabledColor or UI.Numeric.TextColor
    DrawHelpers.Text(valueX,pos.fontY,txtColor,valueText)

    if ref.enabled ~= nil then
        local ty = pos.y+(pos.h-size)*0.5
        DrawHelpers.Rect(toggleX,ty,size,size,UI.Numeric.TextColor,UI.Layout.FrameRounding)
        if ref.enabled then
            local inset = UI.Toggle.Inset
            DrawHelpers.RectFilled(toggleX+inset,ty+inset,
                size-inset*2,size-inset*2,UI.Toggle.OnColor,UI.Layout.FrameRounding-2)
        end
    end

    if onClick then
        return clicked
    else
        return clicked or (ref.value ~= oldVal) or (ref.enabled ~= oldEnabled)
    end
end

return Numeric
