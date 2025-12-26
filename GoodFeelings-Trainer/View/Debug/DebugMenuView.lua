local UI = require("UI")
local InkWidgetHelper = require("modules/InkWidgetHelper")
local Logger = require("Core/Logger")
local GameHUD = require("Core/cp2077-cet-kit/GameHUD")

local DebugMenuView = {}

-- State for Test Widgets
local testWidgets = {}
local textInput = { value = "Debug Text Test" }
local fontSizeInput = { value = 30, min = 10, max = 200 }
local textTopMargin = { value = 500, min = 0, max = 2160 }

local atlasInput = { value = "base\\gameplay\\gui\\widgets\\hud_corpo\\hud_corpo.inkatlas" }
local partInput = { value = "logoArasaka" }
local imageSize = { value = 100, min = 10, max = 1000 }
local imageTopMargin = { value = 300, min = 0, max = 2160 }

local hudMessageInput = { value = "Custom HUD Message" }
local hudWarningInput = { value = "Critical Battery Warning!" }
local hudWarningDuration = { value = 5, min = 1, max = 30 }
local soundInput = { value = "ui_phone_sms_incoming" }

local soundLibrary = {
    "ui_hacking_access_granted",
    "ui_hacking_access_denied",
    "ui_jingle_quest_success",
    "ui_jingle_chip_malfunction",
    "ui_messenger_select",
    "ui_menu_close",
    "ui_menu_onpress",
    "ui_menu_map_pin_created",
    "ui_menu_map_pin_on",
    "ui_menu_value_up",
    "ui_main_menu_open_tab",
    "ui_popup_lore_open"
}
local soundLibraryRef = { index = 1 }

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
            -- We can't easily destroy widgets in ink, but hiding is usually enough for testing
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

local function DebugViewFunction()
    UI.Buttons.Break("Text Test")
    UI.Buttons.Text("Content", textInput, "Text to display")
    UI.Buttons.Int("Font Size", fontSizeInput, "Font size in pixels")
    UI.Buttons.Int("Top Margin", textTopMargin, "Vertical position")
    if UI.Buttons.Option("Spawn Text", "Create an inkText widget on HUD") then
        CreateTextTest()
    end

    UI.Buttons.Break("Image Load Test")
    UI.Buttons.Text("Atlas Path", atlasInput, "Full path to .inkatlas")
    UI.Buttons.Text("Part Name", partInput, "atlasPartName in the atlas")
    UI.Buttons.Int("Size", imageSize, "Width and Height")
    UI.Buttons.Int("Top Margin", imageTopMargin, "Vertical position")
    if UI.Buttons.Option("Spawn Image", "Create an inkImage widget on HUD") then
        CreateImageTest()
    end

    UI.Buttons.Break("Native HUD Messages")
    UI.Buttons.Text("Message Content", hudMessageInput, "Message for GameHUD.ShowMessage")
    if UI.Buttons.Option("Send Message", "Trigger native on-screen message") then
        GameHUD.ShowMessage(hudMessageInput.value)
    end

    UI.Buttons.Break("Native HUD Warnings")
    UI.Buttons.Text("Warning Content", hudWarningInput, "Text for GameHUD.ShowWarning")
    UI.Buttons.Int("Duration (sec)", hudWarningDuration, "How long warning stays visible")
    if UI.Buttons.Option("Send Warning", "Trigger native warning notification") then
        GameHUD.ShowWarning(hudWarningInput.value, hudWarningDuration.value)
    end

    UI.Buttons.Break("Interactive Sound Library")
    if UI.Buttons.StringCycler("Select Sound", soundLibraryRef, soundLibrary, "Use Left/Right to change sound") then
        GameHUD.PlaySound(soundLibrary[soundLibraryRef.index])
    end
    if UI.Buttons.Option("Play Selected", "Play the currently selected sound from the list") then
        GameHUD.PlaySound(soundLibrary[soundLibraryRef.index])
    end

    UI.Buttons.Text("Custom Sound", soundInput, "Type any in-game sound event name")
    if UI.Buttons.Option("Play Custom", "Play the specific sound event entered above") then
        GameHUD.PlaySound(soundInput.value)
    end

    UI.Buttons.Break("Cleanup")
    if UI.Buttons.Option("Clear All Test Widgets", "Hide all spawned debug widgets") then
        ClearTestWidgets()
    end
    
end

local DebugMenuView = { title = "Debug Tools", view = DebugViewFunction }
return DebugMenuView
