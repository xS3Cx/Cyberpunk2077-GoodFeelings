local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")

local gravityRef = { value = UI.Background.Gravity, min = 0, max = 200 }
local windRef = { value = UI.Background.WindSway, min = 0, max = 2, step = 0.01 }
local spawnRef = { value = UI.Background.SpawnRate, min = 0.001, max = 0.2, step = 0.001 }
local pileRef = { value = UI.Background.PileLayers, min = 1, max = 10 }
local columnsRef = { value = UI.Background.PileColumns, min = 10, max = 200 }
local densityRef = { value = UI.Background.SnowDensity, min = 1, max = 10 }
local brightRef = { value = UI.Background.SnowBrightness, min = 0.1, max = 3.0, step = 0.1 }
local sizeMinRef = { value = UI.Background.SnowflakeSizeMin, min = 0.5, max = 5.0, step = 0.1 }
local sizeVarRef = { value = UI.Background.SnowflakeSize, min = 0.5, max = 5.0, step = 0.1 }
local yellowChanceRef = { value = UI.Background.YellowSnowChance, min = 0.0, max = 1.0, step = 0.0001 }

local lightSpacingRef = { value = UI.Background.LightSpacing, min = 5, max = 100 }
local lightRadiusRef = { value = UI.Background.LightRadius, min = 1, max = 20 }
local lightSpeedRef = { value = UI.Background.LightSpeed, min = 0.1, max = 10.0, step = 0.1 }
local lightBrightRef = { value = UI.Background.LightBrightness, min = 0.1, max = 3.0, step = 0.1 }



local function SnowBackgroundViewFunction()
    Buttons.Option(L("settings.snow.reset.label"), tip("settings.snow.reset.tip"), ResetUI.ResetSnowBackground)

    Buttons.Break(L("settings.snow.section.general"))

    Buttons.Toggle(L("settings.snow.master.label"), { value = UI.Background.MasterEnabled }, tip("settings.snow.master.tip"), function()
        UI.Background.MasterEnabled = not UI.Background.MasterEnabled
    end)

    Buttons.Toggle(L("settings.snow.enabled.label"), { value = UI.Background.SnowEnabled }, tip("settings.snow.enabled.tip"), function()
        UI.Background.SnowEnabled = not UI.Background.SnowEnabled
    end)

    Buttons.Toggle(L("settings.snow.pile.label"), { value = UI.Background.SnowPileEnabled }, tip("settings.snow.pile.tip"), function()
        UI.Background.SnowPileEnabled = not UI.Background.SnowPileEnabled
    end)

    Buttons.Toggle(L("settings.snow.snowman.label"), { value = UI.Background.SnowmanEnabled }, tip("settings.snow.snowman.tip"), function()
        UI.Background.SnowmanEnabled = not UI.Background.SnowmanEnabled
    end)

    Buttons.Break(L("settings.snow.physics.label"))

    if Buttons.Float(L("settings.snow.gravity.label"), gravityRef, tip("settings.snow.gravity.tip")) then
        UI.Background.Gravity = gravityRef.value
    end

    if Buttons.Float(L("settings.snow.wind.label"), windRef, tip("settings.snow.wind.tip")) then
        UI.Background.WindSway = windRef.value
    end

    if Buttons.Float(L("settings.snow.spawnrate.label"), spawnRef, tip("settings.snow.spawnrate.tip")) then
        UI.Background.SpawnRate = spawnRef.value
    end

    if Buttons.Int(L("settings.snow.pilelayers.label"), pileRef, tip("settings.snow.pilelayers.tip")) then
        UI.Background.PileLayers = pileRef.value
    end

    if Buttons.Int(L("settings.snow.pilecolumns.label"), columnsRef, tip("settings.snow.pilecolumns.tip")) then
        UI.Background.PileColumns = columnsRef.value
    end

    if Buttons.Int(L("settings.snow.density.label"), densityRef, tip("settings.snow.density.tip")) then
        UI.Background.SnowDensity = densityRef.value
    end

    Buttons.Break(L("settings.snow.appearance.label"))

    if Buttons.Float(L("settings.snow.brightness.label"), brightRef, tip("settings.snow.brightness.tip")) then
        UI.Background.SnowBrightness = brightRef.value
    end

    Buttons.ColorHex(L("settings.snow.color.label"), UI.Background, "SnowColor", tip("settings.snow.color.tip"))
    Buttons.ColorHex(L("settings.snow.peecolor.label"), UI.Background, "PeeColor", tip("settings.snow.peecolor.tip"))

    Buttons.Toggle(L("settings.snow.peeenabled.label"), { value = UI.Background.PeeSnowEnabled }, tip("settings.snow.peeenabled.tip"), function()
        UI.Background.PeeSnowEnabled = not UI.Background.PeeSnowEnabled
    end)

    if Buttons.Float(L("settings.snow.peechance.label"), yellowChanceRef, tip("settings.snow.peechance.tip")) then
        UI.Background.YellowSnowChance = yellowChanceRef.value
    end

    Buttons.Toggle(L("settings.snow.twinkle.label"), { value = UI.Background.SnowTwinkle }, tip("settings.snow.twinkle.tip"), function()
        UI.Background.SnowTwinkle = not UI.Background.SnowTwinkle
    end)

    if Buttons.Float(L("settings.snow.flakemin.label"), sizeMinRef, tip("settings.snow.flakemin.tip")) then
        UI.Background.SnowflakeSizeMin = sizeMinRef.value
    end

    if Buttons.Float(L("settings.snow.flakevar.label"), sizeVarRef, tip("settings.snow.flakevar.tip")) then
        UI.Background.SnowflakeSize = sizeVarRef.value
    end

    Buttons.Break(L("settings.snow.section.lights"))

    Buttons.Toggle(L("settings.snow.lights.enabled.label"), { value = UI.Background.LightsEnabled }, tip("settings.snow.lights.enabled.tip"), function()
        UI.Background.LightsEnabled = not UI.Background.LightsEnabled
    end)

    if Buttons.Int(L("settings.snow.lights.spacing.label"), lightSpacingRef, tip("settings.snow.lights.spacing.tip")) then
        UI.Background.LightSpacing = lightSpacingRef.value
    end

    if Buttons.Float(L("settings.snow.lights.speed.label"), lightSpeedRef, tip("settings.snow.lights.speed.tip")) then
        UI.Background.LightSpeed = lightSpeedRef.value
    end

    if Buttons.Int(L("settings.snow.lights.radius.label"), lightRadiusRef, tip("settings.snow.lights.radius.tip")) then
        UI.Background.LightRadius = lightRadiusRef.value
    end

    if Buttons.Float(L("settings.snow.lights.brightness.label"), lightBrightRef, tip("settings.snow.lights.brightness.tip")) then
        UI.Background.LightBrightness = lightBrightRef.value
    end

    Buttons.Toggle(L("settings.snow.lights.twinkle.label"), { value = UI.Background.TwinkleEnabled }, tip("settings.snow.lights.twinkle.tip"), function()
        UI.Background.TwinkleEnabled = not UI.Background.TwinkleEnabled
    end)

    Buttons.Break(L("settings.snow.lights.colors.label"))

    Buttons.ColorHex(L("settings.snow.lights.colors.index.label") .. " 1", UI.Background, "LightColor1", tip("settings.snow.lights.colors.index.tip"))
    Buttons.ColorHex(L("settings.snow.lights.colors.index.label") .. " 2", UI.Background, "LightColor2", tip("settings.snow.lights.colors.index.tip"))
    Buttons.ColorHex(L("settings.snow.lights.colors.index.label") .. " 3", UI.Background, "LightColor3", tip("settings.snow.lights.colors.index.tip"))
    Buttons.ColorHex(L("settings.snow.lights.colors.index.label") .. " 4", UI.Background, "LightColor4", tip("settings.snow.lights.colors.index.tip"))
    Buttons.ColorHex(L("settings.snow.lights.colors.index.label") .. " 5", UI.Background, "LightColor5", tip("settings.snow.lights.colors.index.tip"))

end

local SnowBackgroundView = { title = "settings.snow.title", view = SnowBackgroundViewFunction }
return SnowBackgroundView
