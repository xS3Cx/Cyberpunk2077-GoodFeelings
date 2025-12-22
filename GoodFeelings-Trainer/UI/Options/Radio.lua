local UI = require("UI/Core/Style")
local Option = require("UI/Options/Option")

local Radio = {}

---@param label string
---@param ref table { index:number }
---@param options table<string>
---@param tip string|nil
---@return boolean changed
function Radio.Option(label, ref, options, tip)
    local changed = false
    for i,optionLabel in ipairs(options) do
        local isSel = (ref.index == i)
        local clicked,pos = Option.Option(optionLabel,"","",tip)
        if pos then
            local r = UI.Radio.Radius
            local cx = pos.x+pos.w-UI.Layout.LabelOffsetX-r
            local cy = pos.y+pos.h*0.5
            local dl = ImGui.GetWindowDrawList()
            if isSel then
                ImGui.ImDrawListAddCircleFilled(dl,cx,cy,r,UI.Radio.SelectedColor)
            else
                ImGui.ImDrawListAddCircle(dl,cx,cy,r,UI.Radio.UnselectedColor,UI.Radio.Segments,UI.Radio.LineThickness)
            end
            if clicked then
                ref.index = i
                changed = true
            end
        end
    end
    return changed
end

return Radio
