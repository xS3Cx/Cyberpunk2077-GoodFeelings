local UI = require("UI/Core/Style")
local Option = require("UI/Options/Option")
local State = require("Controls/State")

local Dropdown = {}

---@param label string
---@param ref table { index:number, expanded:boolean, revealProgress:number, lastRevealFrame:number }
---@param options table<string>
---@param tip string|nil
function Dropdown.Option(label, ref, options, tip)
    local keyTip = L("optionmanager.dropdown_tip")
    local fullTip = keyTip..(tip and ("\n\n"..tip) or "")

    local arrow = ref.expanded and UI.Dropdown.ArrowDown or UI.Dropdown.ArrowRight
    local selectedLabel = L(options[ref.index or 1]) or L("optionmanager.none")

    local clicked = Option.Option(label,nil,selectedLabel.." "..arrow,fullTip)
    if clicked then
        ref.expanded = not ref.expanded
        if ref.expanded then
            ref.revealProgress,ref.lastRevealFrame = 0,ImGui.GetFrameCount()
        else
            ref.revealProgress,ref.lastRevealFrame = nil,nil
            State.currentOption = State.optionIndex
        end
    end
    if not ref.expanded then return end

    local cur = ImGui.GetFrameCount()
    local fpo = UI.Dropdown.FramesPerOption or UI.Dropdown.RevealFrameDelay or 3
    if (ref.revealProgress or 0) < #options and cur-(ref.lastRevealFrame or 0) >= fpo then
        ref.revealProgress = (ref.revealProgress or 0)+1
        ref.lastRevealFrame = cur
    end

    for i=1,(ref.revealProgress or 0) do
        local rowLabel = (UI.Dropdown.RowPrefix or "- ")..L(options[i])
        local rightText = (ref.index == i) and IconGlyphs.CheckBold or ""
        if Option.Option(rowLabel,nil,rightText) then
            ref.index,ref.expanded,ref.revealProgress,ref.lastRevealFrame = i,false,nil,nil
            State.currentOption = State.optionIndex-i
            break
        end
    end
end

return Dropdown
