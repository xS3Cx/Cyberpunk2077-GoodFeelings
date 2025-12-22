-- UI/Options/TextInput.lua
local UI = require("UI/Core/Style")
local Option = require("UI/Options/Option")
local Controls = require("Controls/State")

local TextInput = {}
local activeRef = nil
local buffer = ""

---@param label string
---@param ref table { value:string|nil, capturing:boolean|nil }
---@param tip string|nil
---@return boolean changed
function TextInput.Option(label, ref, tip)
    local display = ref.value or ""

    local clicked, pos = Option.Option(label, nil, display, tip)
    if not pos then return false end

    if clicked then
        ref.capturing = true
        activeRef = ref
        buffer = ref.value or ""
        Controls.mouseEnabled = true
        Controls.typingEnabled = true
    end
    if ref.capturing then
        local sw, sh = GetDisplayResolution()
        local winW, winH = UI.TextInput.Width, UI.TextInput.Height
        local x, y = (sw - winW) / 2, (sh - winH) / 2

        ImGui.SetNextWindowPos(x, y)
        ImGui.SetNextWindowSize(winW, winH)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, UI.TextInput.Rounding)
        ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.TextInput.BackgroundColor)
        ImGui.PushStyleColor(ImGuiCol.Border, UI.TextInput.BorderColor)

        ImGui.Begin("##TextInputCapture",
            ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoMove +
            ImGuiWindowFlags.NoResize)

        ImGui.TextColored(UI.TextInput.TextColor, label)
        ImGui.Separator()

        local newText, changed = ImGui.InputText("##txtinput", buffer, 256)
        if changed then buffer = newText end

        if ImGui.Button("OK") then
            ref.value = buffer
            ref.capturing = false
            activeRef = nil
            Controls.mouseEnabled = false
            Controls.typingEnabled = false
            ImGui.End()
            ImGui.PopStyleColor(2)
            ImGui.PopStyleVar()
            return true
        end
        ImGui.SameLine(0, UI.TextInput.ButtonSpacing)
        if ImGui.Button("Cancel") then
            ref.capturing = false
            activeRef = nil
            Controls.mouseEnabled = false
            Controls.typingEnabled = false
        end

        ImGui.End()
        ImGui.PopStyleColor(2)
        ImGui.PopStyleVar()
    end


    return false
end

return TextInput
