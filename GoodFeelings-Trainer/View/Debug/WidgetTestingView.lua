-- View/Debug/WidgetTestingView.lua
local UI = require("UI")
local InkWidgetHelper = require("modules/InkWidgetHelper")

local WidgetTestingView = {}

-- Shared state for test widgets
local testWidgets = {}
local textInput = { value = "Debug Text Test" }
local fontSizeInput = { value = 30, min = 10, max = 200 }
local textTopMargin = { value = 500, min = 0, max = 2160 }

local atlasInput = { value = "base\\gameplay\\gui\\widgets\\hud_corpo\\hud_corpo.inkatlas" }
local partInput = { value = "logoArasaka" }
local imageSize = { value = 100, min = 10, max = 1000 }
local imageTopMargin = { value = 300, min = 0, max = 2160 }

local function GetHUDParent()
	local inkSystem = GameInstance.GetInkSystem()
	if not inkSystem then return nil end
	local layer = inkSystem:GetLayer("inkHUDLayer")
	if not layer then return nil end
	return layer:GetVirtualWindow()
end

local function ClearTestWidgets()
    for _, widget in ipairs(testWidgets) do
        if widget then
            widget:SetVisible(false)
        end
    end
    testWidgets = {}
    UI.Notification.Info("Test widgets cleared!")
end

local function CreateTextTest()
    local parent = GetHUDParent()
    if not parent then 
        UI.Notification.Error("HUD Parent not found!")
        return 
    end

    local res = Game.GetUISystem() and Game.GetUISystem():GetCurrentWindowSize() or {X=1920, Y=1080}
    local scaleFactor = res.X / 1920.0
    
    local widget = InkWidgetHelper.createText(
        "DebugText_" .. #testWidgets,
        textInput.value,
        {0, textTopMargin.value, 0, 0},
        fontSizeInput.value,
        "MainColors.Blue",
        parent,
        scaleFactor
    )
    
    -- Center horizontally
    local textSize = widget:GetDesiredSize()
    local leftMargin = (res.X - (textSize.X * scaleFactor)) / 2
    widget:SetMargin(leftMargin / scaleFactor, textTopMargin.value, 0, 0)
    
    table.insert(testWidgets, widget)
    UI.Notification.Success("Text created!")
end

local function CreateImageTest()
    local parent = GetHUDParent()
    if not parent then 
        UI.Notification.Error("HUD Parent not found!")
        return 
    end

    local res = Game.GetUISystem() and Game.GetUISystem():GetCurrentWindowSize() or {X=1920, Y=1080}
    local scaleFactor = res.X / 1920.0

    local widget = InkWidgetHelper.createImage(
        "DebugImage_" .. #testWidgets,
        atlasInput.value,
        partInput.value,
        {0, imageTopMargin.value, 0, 0},
        {imageSize.value, imageSize.value},
        1.0,
        parent,
        scaleFactor,
        "MainColors.Red"
    )

    -- Center horizontally
    local leftMargin = (res.X - (imageSize.value * scaleFactor)) / 2
    widget:SetMargin(leftMargin / scaleFactor, imageTopMargin.value, 0, 0)

    table.insert(testWidgets, widget)
    UI.Notification.Success("Image created!")
end

local function WidgetTestingViewFunction()
    UI.Buttons.Break("Text Widget Test")
    UI.Buttons.Text("Content", textInput, "Text to display")
    UI.Buttons.Int("Font Size", fontSizeInput, "Font size in pixels")
    UI.Buttons.Int("Top Margin", textTopMargin, "Vertical position")
    if UI.Buttons.Option("Spawn Text", "Create an inkText widget on HUD") then
        CreateTextTest()
    end

    UI.Buttons.Break("Image Widget Test")
    UI.Buttons.Text("Atlas Path", atlasInput, "Full path to .inkatlas")
    UI.Buttons.Text("Part Name", partInput, "atlasPartName in the atlas")
    UI.Buttons.Int("Size", imageSize, "Width and Height")
    UI.Buttons.Int("Top Margin", imageTopMargin, "Vertical position")
    if UI.Buttons.Option("Spawn Image", "Create an inkImage widget on HUD") then
        CreateImageTest()
    end

    UI.Buttons.Break("Cleanup")
    if UI.Buttons.Option("Clear All Test Widgets", "Hide all spawned debug widgets") then
        ClearTestWidgets()
    end
end

local WidgetTestingView = { 
    title = "Widget Testing", 
    view = WidgetTestingViewFunction 
}

return WidgetTestingView
