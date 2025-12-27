local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")

local InfoBox = {}

InfoBox.currentText = ""
InfoBox.lastText = ""
InfoBox.animatedText = ""
InfoBox.charIndex = 0
InfoBox.animStartTime = 0.0
InfoBox.isFallback = false
InfoBox.lastFallbackTime = 0.0

local _seeded = false
local lastTipIndex = -1

local function seedRngOnce()
    if _seeded then return end
    local t = tostring(os.time()):reverse()
    math.randomseed(tonumber(t:sub(1, 6)))
    _seeded = true
end

function InfoBox.GetRandomFallbackTip()
    seedRngOnce()
    local tips = {
        "Just don't run straight through the main story. Side jobs and gigs are a big part of the game, mix it up.",
        "Don't rush it. Don't drive to objectives when you have the chance - a stroll through Night City is a fuckin' experience, man.",
        "Messed up your build? Head to the Development menu to adjust your perks and skills.",
        "Keep dying or stuck on a mission? Try enabling God Mode in the Self menu.",
        "Want to clean up your ride list? Go to the Vehicle menu > Vehicle List to lock or unlock any vehicle.",
        "Inventory cluttered? Head to the Weapon menu, switch to Inventory Mode, and remove what you don't want.",
        "Lost your stash weapon? Use the Weapon Inventory menu to recover stash or iconic weapons.",
        "Running low on funds? Check the Development > Resources menu - hand yourself a few extra eddies.",
        "Want the free Rayfield Caliburn? Look in the Vehicle menu, or find it in the Badlands tunnel container.",
        "Too lazy to drive to a ripperdoc? Open the Teleport menu - vendor locations are ready to go.",
        "Spent too many perk points or need more relic points? Development menu's got you covered in the Resources tab.",
        "Like walking Night City but it's too slow? Check the Self menu - you can boost your walk speed.",
        "Looking for iconic weapons? Use the Weapon Inventory filters to find wall stash and iconic gear.",
        "Some in-game actions get blocked while using arrow keys. Switch to controller input to avoid it.",
        "You can hold D-Pad Right + A to open GoodFeelings on controller. (Not configurable right now.)"
    }
    local newIndex
    repeat newIndex = math.random(1, #tips) until newIndex ~= lastTipIndex
    lastTipIndex = newIndex
    return tips[newIndex]
end

local function setFallback(now)
    InfoBox.currentText = InfoBox.GetRandomFallbackTip()
    InfoBox.isFallback = true
    InfoBox.lastFallbackTime = now or ImGui.GetTime()
end

function InfoBox.SetText(text)
    local hasText = (type(text) == "string") and text:match("%S") ~= nil
    if hasText then
        if text ~= InfoBox.currentText then
            InfoBox.currentText = text
            InfoBox.isFallback = false
        end
    else
        if not InfoBox.isFallback then
            setFallback()
        end
    end
end

function InfoBox.Render(menuX, menuY, menuW, menuH)
    local now = ImGui.GetTime()
    local N = UI.InfoBox

    local rotateSec = N.FallbackRotateSeconds or 10.0
    if (not InfoBox.currentText) or InfoBox.currentText == "" then
        setFallback(now)
    elseif InfoBox.isFallback and (now - InfoBox.lastFallbackTime >= rotateSec) then
        setFallback(now)
    end

    if InfoBox.currentText ~= InfoBox.lastText then
        InfoBox.lastText = InfoBox.currentText
        InfoBox.animatedText = ""
        InfoBox.charIndex = 0
        InfoBox.animStartTime = now
    end

    local cps = N.CharsPerSecond or 100.0
    local targetChars = math.floor((now - InfoBox.animStartTime) * cps)
    if targetChars > InfoBox.charIndex then
        InfoBox.charIndex = math.min(targetChars, #InfoBox.currentText)
        InfoBox.animatedText = InfoBox.currentText:sub(1, InfoBox.charIndex)
    end

    local pad = N.Padding or 14.0
    local spacing = N.Spacing or 15.0
    local scale = UI.Base.Layout.Scale or 1.0
    local screenW, screenH = GetDisplayResolution()


    local icon = (IconGlyphs and (
        IconGlyphs.InformationSlabCircle or 
        IconGlyphs["information-slab-circle"] or
        IconGlyphs.Information or
        IconGlyphs.InformationOutline or
        IconGlyphs["information-outline"] or
        IconGlyphs.HelpCircle or
        IconGlyphs["help-circle"]
    )) or "ℹ" 
    
    local baseFontSize = ImGui.GetFontSize() or 18
    local scaledFontSize = baseFontSize * scale
    local iconFontSize = scaledFontSize * 0.85 
    local iconOffset = (UI.Base.Layout.IconOffsetY or 1.0) * scale
    local manualExtra = 1.0 * scale
    local iconGap = 8.0 * scale

    local boxW = menuW
    
    -- Measure content like Overlay does
    local iconW = ImGui.CalcTextSize(icon) * scale
    local textWrapWidth = (boxW - (2 * pad) - iconW - iconGap) / scale
    local _, textH = ImGui.CalcTextSize(InfoBox.animatedText, false, textWrapWidth)
    local actualTextH = textH * scale
    
    local boxH = actualTextH + (2 * pad)

    local belowY = menuY + menuH + spacing
    local finalY = (belowY + boxH > screenH) and (menuY - boxH - spacing) or belowY
    local finalX = menuX

    ImGui.SetNextWindowPos(finalX, finalY)
    ImGui.SetNextWindowSize(boxW, boxH)
    
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, N.Rounding or UI.Layout.FrameRounding)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, { 0, 0 })
    ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, UI.Colors.Transparent)

    ImGui.Begin("##InfoBoxWindow", ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings)

    local winX, winY = ImGui.GetWindowPos()
    
    local dl = ImGui.GetWindowDrawList()
    local borderColor = N.BorderColor
    local scale = UI.Base.Layout.Scale or 1.0
    local cutSize = math.floor(10 * scale)
    
    local boxW_i = math.floor(boxW)
    local boxH_i = math.floor(boxH)
    local x1, y1 = math.floor(winX), math.floor(winY)
    local x2, y2 = x1 + boxW_i, y1 + boxH_i
    
    ImGui.ImDrawListAddRectFilled(dl, x1, y1, x2 - cutSize, y2, N.BackgroundColor)
    ImGui.ImDrawListAddRectFilled(dl, x2 - cutSize, y1, x2, y2 - cutSize, N.BackgroundColor)
    ImGui.ImDrawListAddTriangleFilled(dl, x2 - cutSize, y2 - cutSize, x2, y2 - cutSize, x2 - cutSize, y2, N.BackgroundColor)
    
    local thickness = 3.0
    local e2 = thickness * 0.5
    local e = 0.30
    
    DrawHelpers.Line(x1 - e2, y1, x2 + e2, y1, borderColor, thickness)
    DrawHelpers.Line(x1, y1 - e2, x1, y2 + e2, borderColor, thickness)
    DrawHelpers.Line(x2, y1 - e2, x2, y2 - cutSize + e, borderColor, thickness)
    DrawHelpers.Line(x2, y2 - cutSize, x2 - cutSize, y2, borderColor, thickness)
    DrawHelpers.Line(x2 - cutSize + e, y2, x1 - e2, y2, borderColor, thickness)
    
    local iconHeight = ImGui.CalcTextSize(icon)
    local iconY = winY + (boxH - iconHeight) / 2 + 5.5
    DrawHelpers.Text(winX + pad, iconY, UI.ColPalette.MainAccent, icon, iconFontSize)
    
    local textX = winX + pad + iconW + iconGap
    local textWrapWidth = boxW - (2 * pad) - iconW - iconGap
    DrawHelpers.TextWrapped(textX, winY + pad, N.TextColor, InfoBox.animatedText, textWrapWidth)
    
    ImGui.End()
    ImGui.PopStyleColor(2)
    ImGui.PopStyleVar(3)
end

return InfoBox
