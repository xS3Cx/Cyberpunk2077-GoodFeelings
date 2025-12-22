local UI = require("UI/Core/Style")
local InfoBox = require("UI/Elements/InfoBox")
local OptionRow = require("UI/Elements/OptionRow")
local State = require("Controls/State")

local Option = {}
Option.menuX, Option.menuY, Option.menuW, Option.menuH = 0, 0, 0, 0

---@param x number
---@param y number
---@param w number
function Option.SetMenuBounds(x, y, w, h)
    Option.menuX, Option.menuY, Option.menuW, Option.menuH = x, y, w, h
end

---@param left string|nil
---@param center string|nil
---@param right string|nil
---@param tip string|nil
---@return boolean clicked
function Option.Option(left, center, right, tip)
    local clicked, pos = OptionRow.Draw(Option.menuX, Option.menuY, Option.menuW, Option.menuH, left, center, right, nil, nil, false)
    if OptionRow.IsSelected() then
        InfoBox.SetText(tip or "")
    end
    return clicked, pos
end


---@param left string|nil
---@param center string|nil
---@param right string|nil
---@return boolean always false (break rows don’t click)
function Option.Break(left, center, right)
    OptionRow.Draw(Option.menuX, Option.menuY, Option.menuW, Option.menuH, left, center, right, UI.BreakRow.Text, UI.BreakRow.HighlightBg, true)
    return false
end




return Option
