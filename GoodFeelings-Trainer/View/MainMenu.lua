local UI = require("UI")
local Logger = require("Core/Logger")

local OptionBOUND = require("UI/Options/Option")
local DrawHelpers = require("UI/Core/DrawHelpers")
local OptionRow = require("UI/Elements/OptionRow")

local Header = require("UI/Frame/Header")
local SecondHeader = require("UI/Frame/SecondHeader")
local Footer = require("UI/Frame/Footer")
local SnowBackground = require("UI/Frame/SnowBackground")

local SelfConfig = require("Features/Self/SelfConfig")
local WeaponsConfig = require("Features/Weapons/WeaponConfig")

local TelportConfig = require("Features/Teleports/TeleportConfig")
local VehicleConfig = require("Features/Vehicles/VehicleConfig")
local WorldConfig = require("Features/World/WorldConfig")
local ControlsConfig = require("Controls/ControlsConfig")

local SelfView = require("View/Self/SelfMenuView")
local SelfDevelopmentView = require("View/Self/SelfDevelopment")
local SelfModifiersView = require("View/Self/SelfModifierView")
local TeleportView = require("View/Teleports/TeleportView")
local WeaponView = require("View/Weapons/WeaponMenuView")
local VehicleMenuView = require("View/Vehicle/VehicleMenuView")
local SettingsView        = require("View/Settings/SettingsView")
local WeatherView         = require("View/World/WeatherView")
local TimeView            = require("View/World/TimeView")
local GameFactsView       = require("View/World/FactView")
local ItemBrowserView     = require("View/Items/ItemBrowserView")

local testToggle          = { value = false }
local testInt             = { value = 5, min = 0, max = 10 }
local testFloat           = { value = 0.5, min = 0.0, max = 1.0, step = 0.1, enabled = true }
local dropdownRef         = { index = 2, expanded = false }
local dropdownRef2        = { index = 2, expanded = false }
local languages           = { "English", "French", "Spanish", "German", "Japanese" }
local weaponTypes         = { "Pistol", "SMG", "Rifle", "Shotgun", "Sniper" }
local selectedTarget      = { index = 1 }
local targetOptions       = { "Player", "Weapon", "Vehicle" }
local stringRef           = { index = 1 }
local colorRef            = { Red = 128, Green = 200, Blue = 255, Alpha = 255 }
local textRef             = { value = "" }

local function SecondaryView()
    if UI.Buttons.Option("Basic Option", "This is a basic option") then
        Logger.Log("Basic option clicked")
    end

    UI.Buttons.Option("Centered Option")
    UI.Buttons.Break("Section Break")

    if UI.Buttons.Option("Option 1") then
        Logger.Log("Option 1 clicked")
    end

    if UI.Buttons.Text("Enter Name", textRef, "Type your custom text") then
        Logger.Log("You typed: " .. (textRef.value or ""))
    end

    UI.Buttons.Bind("Open Menu", "TOGGLE", "Rebind the open/close key")
    UI.Buttons.Bind("Up Navigation", "UP", "Rebind menu navigation up")
    UI.Buttons.Bind("Down Navigation", "DOWN", "Rebind menu navigation down")
    UI.Buttons.Bind("Back", "BACK", "Rebind back key")

    UI.Buttons.Color("Pick Color", colorRef, "Adjust RGBA color")
    UI.Buttons.Dropdown("Weapon Type", dropdownRef, weaponTypes, "Pick a weapon type")
    UI.Buttons.Dropdown("Language", dropdownRef2, languages, "Pick a language")
    UI.Buttons.Toggle("Test Toggle", testToggle, "Toggle something")
    UI.Buttons.Int("Test Int", testInt, "Adjust integer")
    UI.Buttons.Float("Test Float", testFloat, "Adjust float value")
    UI.Buttons.Radio("Target", selectedTarget, targetOptions, "Choose target")
    UI.Buttons.StringCycler("Cycle String", stringRef, { "One", "Two", "Three" }, "Cycle through strings")
end
local testMenu = { title = "Test Menu", view = SecondaryView }

local function getIcon(id, alt)
    return (IconGlyphs and IconGlyphs[id]) or alt or ""
end

local function MainMenuView()
    UI.Buttons.Submenu(getIcon("AccountCircle", "[P]") .. " " .. L("mainmenu.self.label"), SelfView, tip("mainmenu.self.tip"))
    if UI.Buttons.Submenu(getIcon("Hammer", "[D]") .. " " .. L("mainmenu.development.label"), SelfDevelopmentView, tip("mainmenu.development.tip")) then
        UI.Notification.Warning(L("mainmenu.development.warning"))
    end
    UI.Buttons.Submenu(getIcon("Flash", "[M]") .. " " .. L("mainmenu.modifiers.label"), SelfModifiersView, tip("mainmenu.modifiers.tip"))
    UI.Buttons.Submenu(getIcon("MapMarker", "[T]") .. " " .. L("mainmenu.teleport.label"), TeleportView, tip("mainmenu.teleport.tip"))
    UI.Buttons.Submenu(getIcon("Pistol", "[W]") .. " " .. L("mainmenu.weapon.label"), WeaponView, tip("mainmenu.weapon.tip"))
    UI.Buttons.Submenu(getIcon("Car", "[V]") .. " " .. L("mainmenu.vehicle.label"), VehicleMenuView, tip("mainmenu.vehicle.tip"))
    if UI.Buttons.Submenu(getIcon("HelpCircle", "[F]") .. " " .. L("mainmenu.facts.label"), GameFactsView, tip("mainmenu.facts.tip")) then
        UI.Notification.Warning(L("mainmenu.facts.warning"))
    end
    UI.Buttons.Submenu(getIcon("Clock", "[T]") .. " " .. L("mainmenu.time.label"), TimeView, tip("mainmenu.time.tip"))
    UI.Buttons.Submenu(getIcon("WeatherCloudy", "[W]") .. " " .. L("mainmenu.weather.label"), WeatherView, tip("mainmenu.weather.tip"))
    UI.Buttons.Submenu(getIcon("Database", "[I]") .. " " .. L("mainmenu.items.label"), ItemBrowserView, tip("mainmenu.items.tip"))
    UI.Buttons.Submenu(getIcon("Cog", "[S]") .. " " .. L("mainmenu.settingsmenu.label"), SettingsView, tip("mainmenu.settingsmenu.tip"))
end

local MainMenu = { title = "GoodFeelings", view = MainMenuView }
local initialized = false

function MainMenu.Initialize()
    if not initialized then
        UI.SubmenuManager.OpenSubmenu(MainMenu)
        ControlsConfig()
        SelfConfig()
        WeaponsConfig()
        VehicleConfig()
        TelportConfig()
        WorldConfig()
        SnowBackground.Init()
        UI.Notification.Info("GoodFeelings initialized!")
        initialized = true
    end
end


function MainMenu.Render(x, y, w, h)
    OptionBOUND.SetMenuBounds(x, y, w, h)
    OptionRow.Begin()
    
    SnowBackground.Render(x, y, w, h)
    
    Header.Draw(x, y, w)
    SecondHeader.Draw(x, y, w, UI.Style.Header.Height or 65)
    
    local view = UI.SubmenuManager.GetCurrentView()
    if view then view() end
    
    Footer.Draw(x, y, w, h)
end

return MainMenu
