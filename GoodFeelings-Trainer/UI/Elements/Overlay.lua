local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local State = require("Controls/State")

local Overlay = {}

function Overlay.Render()
    if not State.showOverlay or not State.showOverlay.value then 
        return 
    end
    
    local screenW, screenH = GetDisplayResolution()
    local padX = 8
    local rounding = 3.0
    local bgColor = UI.Base.Header.BackgroundColor or 0xFF080808
    local textColor = UI.Base.Header.TextColor or 0xFFE67505
    local scale = UI.Base.Layout.Scale or 1.0
    
    local baseFontSize = ImGui.GetFontSize() or 18
    local scaledFontSize = baseFontSize * scale
    local boxH = 20 * scale
    
    -- 1. TOP LEFT PANEL
    if State.overlayShowTop and State.overlayShowTop.value then
        local segments = {}
        
        -- Build content based on settings
        if State.overlayShowTitle and State.overlayShowTitle.value then
            table.insert(segments, { text = "GoodFeelings", color = textColor, type = "brand" })
        end
        
        if State.overlayShowTime and State.overlayShowTime.value then
            if #segments > 0 then table.insert(segments, { text = " | ", color = textColor, type = "sep" }) end
            table.insert(segments, { text = os.date("%H:%M:%S"), color = 0xFFFFFFFF, type = "data" })
        end
        
        if State.overlayShowFPS and State.overlayShowFPS.value then
            if #segments > 0 then table.insert(segments, { text = " | ", color = textColor, type = "sep" }) end
            local FPSTracker = require("Utility/FPSTracker")
            table.insert(segments, { text = string.format("%.1f FPS", FPSTracker.GetFPS()), color = 0xFFFFFFFF, type = "data" })
        end

        if #segments > 0 then
            -- Calculate total width
            local combinedText = ""
            for _, s in ipairs(segments) do combinedText = combinedText .. s.text end
            
            local textW, textH = ImGui.CalcTextSize(combinedText)
            local actualTextW = textW * scale
            local actualTextH = textH * scale
            local boxW = actualTextW + (padX * 2 * scale)
            
            ImGui.SetNextWindowPos(10, 10)
            ImGui.SetNextWindowSize(boxW, boxH)
            
            ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, rounding)
            ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
            ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, { 0, 0 })
            ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)
            ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.Colors.Transparent)
            
            if ImGui.Begin("##Overlay_TopLeft", ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings) then
                local winX, winY = ImGui.GetWindowPos()
                DrawHelpers.RectFilled(winX, winY, boxW, boxH, bgColor, rounding)
                
                local currentX = winX + (boxW - actualTextW) / 2
                local centerY = winY + (boxH - actualTextH) / 2
                
                for _, s in ipairs(segments) do
                    DrawHelpers.Text(currentX, centerY, s.color, s.text, scaledFontSize)
                    currentX = currentX + (ImGui.CalcTextSize(s.text) * scale)
                end
                ImGui.End()
            end
            ImGui.PopStyleColor(2)
            ImGui.PopStyleVar(3)
        end
    end

    -- 2. BOTTOM LEFT PANEL (Watermark)
    if State.overlayShowWatermark and State.overlayShowWatermark.value then
        local urlText = "https://goodfeelings.cc"
        local authorSep = " | "
        local authorText = "By AlexZero"
        
        -- Colors
        local blueLinkColor = 0xFFEE9900 -- Nice visible blue (ABGR)
        
        local combinedText = urlText .. authorSep .. authorText
        local urlTextW, urlTextH = ImGui.CalcTextSize(combinedText)
        
        local actualUrlW = urlTextW * scale
        local actualUrlH = urlTextH * scale
        local urlBoxW = actualUrlW + (padX * 2 * scale)
        
        ImGui.SetNextWindowPos(10, screenH - boxH - 10)
        ImGui.SetNextWindowSize(urlBoxW, boxH)
        
        ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, rounding)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, { 0, 0 })
        ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)
        ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.Colors.Transparent)
        
        if ImGui.Begin("##Overlay_BottomLeft", ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings) then
            local winX, winY = ImGui.GetWindowPos()
            DrawHelpers.RectFilled(winX, winY, urlBoxW, boxH, bgColor, rounding)
            
            local currentX = winX + (urlBoxW - actualUrlW) / 2
            local centerY = winY + (boxH - actualUrlH) / 2
            
            -- Draw URL (Blue)
            DrawHelpers.Text(currentX, centerY, blueLinkColor, urlText, scaledFontSize)
            currentX = currentX + (ImGui.CalcTextSize(urlText) * scale)
            
            -- Draw Separator (Accent)
            DrawHelpers.Text(currentX, centerY, textColor, authorSep, scaledFontSize)
            currentX = currentX + (ImGui.CalcTextSize(authorSep) * scale)
            
            -- Draw Author (White)
            DrawHelpers.Text(currentX, centerY, 0xFFFFFFFF, authorText, scaledFontSize)
            
            ImGui.End()
        end
        ImGui.PopStyleColor(2)
        ImGui.PopStyleVar(3)
    end
end

return Overlay
