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
    local bgColor = UI.Base.Header.BackgroundColor or UI.ColPalette.UIBackground
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
            -- Add version right after title
            if State.overlayShowModVersion and State.overlayShowModVersion.value then
                local versionText = " v" .. (MOD_VERSION or "1.0.3")
                table.insert(segments, { text = versionText, color = 0xFFFFFFFF, type = "version" })
            end
        end
        
        if State.overlayShowTime and State.overlayShowTime.value then
            if #segments > 0 then table.insert(segments, { text = " | ", color = textColor, type = "sep" }) end
            
            local clockIcon = (IconGlyphs and (IconGlyphs.ClockTimeEightOutline or IconGlyphs["clock-time-eight-outline"])) or "[clock]"
            table.insert(segments, { text = clockIcon .. " ", color = textColor, type = "icon" })
            
            table.insert(segments, { text = os.date("%H:%M:%S"), color = 0xFFFFFFFF, type = "data" })
        end
        
        if State.overlayShowFPS and State.overlayShowFPS.value then
            if #segments > 0 then table.insert(segments, { text = " | ", color = textColor, type = "sep" }) end
            local FPSTracker = require("Utility/FPSTracker")
            local fps = FPSTracker.GetFPS()
            
            -- Determine icon based on FPS
            local iconKey = "SpeedometerMedium"
            local iconName = "speedometer-medium"
            
            if fps < 58.0 then
                iconKey = "SpeedometerSlow"
                iconName = "speedometer-slow"
            elseif fps > 70.0 then
                iconKey = "Speedometer"
                iconName = "speedometer"
            end
            
            local fpsIcon = (IconGlyphs and (IconGlyphs[iconKey] or IconGlyphs[iconName])) or "["..iconName.."]"
            
            table.insert(segments, { text = fpsIcon .. " ", color = textColor, type = "icon" })
            table.insert(segments, { text = string.format("%.1f FPS", fps), color = 0xFFFFFFFF, type = "data" })
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
                
                local currentX = winX + padX * scale -- Same as watermark base padding
                local centerY = winY + (boxH - actualTextH) / 2
                
                for _, s in ipairs(segments) do
                    local segFontSize = scaledFontSize
                    local segY = centerY
                    
                    if s.type == "icon" then
                        -- Only scale up bee icon, keep other icons at 85%
                        if s.text == (IconGlyphs and IconGlyphs.Bee) then
                            segFontSize = scaledFontSize * 1.2 -- Larger bee icon
                            -- No vertical offset for bee icon - align with text baseline
                            -- segY stays at centerY
                        else
                            segFontSize = scaledFontSize * 0.85 -- Other icons stay at 85%
                            local iconOffset = (UI.Base.Layout.IconOffsetY or 1.0) * scale
                            local manualExtra = 2.0 * scale -- Increased from 1.0 to lower icon
                            segY = segY + iconOffset + manualExtra
                        end
                    end
                    
                    DrawHelpers.Text(currentX, segY, s.color, s.text, segFontSize)
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
        local urlText = " https://goodfeelings.cc"
        local authorSep = " | "
        local authorText = "By AlexZero "
        local iconDev = (IconGlyphs and (IconGlyphs.DevTo or IconGlyphs["dev-to"])) or "[dev-to]"
        
        -- Measure content
        local urlW = ImGui.CalcTextSize(urlText) * scale
        local sepW = ImGui.CalcTextSize(authorSep) * scale
        local autW = ImGui.CalcTextSize(authorText) * scale
        local idW = ImGui.CalcTextSize(iconDev) * scale
        
        local totalContentW = urlW + sepW + autW + idW
        local totalContentH = scaledFontSize -- Use the actual font size being drawn
        
        local boxW = totalContentW + (padX * 2 * scale)
        
        ImGui.SetNextWindowPos(10, screenH - boxH - 10)
        ImGui.SetNextWindowSize(boxW, boxH)
        
        ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, rounding)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, { 0, 0 })
        ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)
        ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.Colors.Transparent)
        
        if ImGui.Begin("##Overlay_BottomLeft", ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings) then
            local winX, winY = ImGui.GetWindowPos()
            DrawHelpers.RectFilled(winX, winY, boxW, boxH, bgColor, rounding)
            
            local currentX = winX + (boxW - totalContentW) / 2
            -- More precise vertical centering based on font height vs box height
            local centerY = winY + (boxH - totalContentH) * 0.5
            
            -- Apply Icon Offset like in OptionRow
            local iconOffset = (UI.Base.Layout.IconOffsetY or 1.0) * scale
            local manualExtra = 2.0 * scale -- Same as top overlay
            -- Draw URL
            DrawHelpers.Text(currentX, centerY, textColor, urlText)
            currentX = currentX + urlW
            
            -- Draw Separator
            DrawHelpers.Text(currentX, centerY, textColor, authorSep)
            currentX = currentX + sepW
            
            -- Draw Author
            DrawHelpers.Text(currentX, centerY, 0xFFFFFFFF, authorText)
            currentX = currentX + autW
            
            -- Draw [dev-to]
            DrawHelpers.Text(currentX, centerY + iconOffset + manualExtra, textColor, iconDev)
            
            ImGui.End()
        end
        ImGui.PopStyleColor(2)
        ImGui.PopStyleVar(3)
    end

    -- 3. BOTTOM RIGHT PANEL (Game Version)
    if State.overlayShowGameVersion and State.overlayShowGameVersion.value then
        local gameVersionValue = "Unknown"
        if gameGameVersion and gameGameVersion.Current then
            gameVersionValue = tostring(gameGameVersion.Current.value)
        end
        local gameVersionText = "Game: v" .. gameVersionValue
        
        local gameVerW = ImGui.CalcTextSize(gameVersionText) * scale
        local gameVerBoxW = gameVerW + (padX * 2 * scale)
        
        ImGui.SetNextWindowPos(screenW - gameVerBoxW - 10, screenH - boxH - 10)
        ImGui.SetNextWindowSize(gameVerBoxW, boxH)
        
        ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, rounding)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, { 0, 0 })
        ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)
        ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.Colors.Transparent)
        
        if ImGui.Begin("##Overlay_BottomRight", ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings) then
            local winX, winY = ImGui.GetWindowPos()
            DrawHelpers.RectFilled(winX, winY, gameVerBoxW, boxH, bgColor, rounding)
            
            local textX = winX + padX * scale
            local textY = winY + (boxH - scaledFontSize) * 0.5
            
            -- Draw "Game:" in accent color
            DrawHelpers.Text(textX, textY, textColor, "Game: ", scaledFontSize)
            local gameTextW = ImGui.CalcTextSize("Game: ") * scale
            
            -- Draw version in white
            DrawHelpers.Text(textX + gameTextW, textY, 0xFFFFFFFF, "v" .. gameVersionValue, scaledFontSize)
            
            ImGui.End()
        end
        ImGui.PopStyleColor(2)
        ImGui.PopStyleVar(3)
    end
end

return Overlay
