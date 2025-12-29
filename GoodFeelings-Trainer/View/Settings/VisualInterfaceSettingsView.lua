-- View/Settings/VisualInterfaceSettingsView.lua
local Buttons = require("UI").Buttons

local LayoutView = require("View/Settings/LayoutView")
local FrameView = require("View/Settings/FrameView")
local SnowBackground = require("View/Settings/SnowBackgroundView")

local function VisualInterfaceSettingsViewFunction()
    Buttons.Submenu("Size Menu", require("View/Settings/SizeMenuView"), "Adjust menu size and scale")
    Buttons.Submenu(L("settingsmenu.layout.label"), LayoutView, tip("settingsmenu.layout.tip"))
    Buttons.Submenu(L("settingsmenu.frame.label"), FrameView, tip("settingsmenu.frame.tip"))
    Buttons.Submenu(L("settingsmenu.scrolling.label"), require("View/Settings/ScrollingMenuView"), tip("settingsmenu.scrolling.tip"))
    Buttons.Submenu("Particles", require("View/Settings/ParticlesMenuView"), "Configure particle effects in header")
    Buttons.Submenu(L("settingsmenu.snowbackground.label"), SnowBackground, tip("settingsmenu.snowbackground.tip"))
end

local VisualInterfaceSettingsView = { 
    title = "Visual & Interface", 
    view = VisualInterfaceSettingsViewFunction 
}

return VisualInterfaceSettingsView
