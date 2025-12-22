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
    local screenW, screenH = GetDisplayResolution()

    local boxW = menuW
    local textW, textH = ImGui.CalcTextSize(InfoBox.animatedText, false, boxW - 2 * pad)
    local boxH = textH + 2 * pad

    local belowY = menuY + menuH + spacing
    local aboveY = menuY - boxH - spacing
    local useAbove = (belowY + boxH > screenH)
    local finalY = useAbove and aboveY or belowY
    local finalX = menuX

    ImGui.SetNextWindowPos(finalX, finalY)
    ImGui.SetNextWindowSize(boxW, boxH)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, N.Rounding or UI.Layout.FrameRounding)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
    ImGui.PushStyleColor(ImGuiCol.Border, UI.Colors.Transparent)

    ImGui.Begin("##InfoBoxWindow", ImGuiWindowFlags.NoDecoration + ImGuiWindowFlags.NoInputs + ImGuiWindowFlags.NoSavedSettings)

    local winX, winY = ImGui.GetWindowPos()
    local wrapWidth = boxW - 2 * pad
    DrawHelpers.RectFilled(winX, winY, boxW, boxH, N.BackgroundColor, N.Rounding)
    DrawHelpers.TextWrapped(winX + pad, winY + pad, N.TextColor, InfoBox.animatedText, wrapWidth)

    ImGui.End()
    ImGui.PopStyleColor()
    ImGui.PopStyleVar(2)
end

return InfoBox
