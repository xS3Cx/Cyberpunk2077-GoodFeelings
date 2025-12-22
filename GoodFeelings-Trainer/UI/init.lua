-- Just the core interface files used throughout the Trainer
-- Most of the other ones are just used for Internal dependencies within these or they're only used once
local UI = {}

UI.Style = require("UI/Core/Style")
UI.SubmenuManager = require("UI/Core/SubmenuManager")
UI.Notification = require("UI/Elements/Notification")
UI.Overlay = require("UI/Elements/Overlay")
UI.Buttons = require("UI/Options/Buttons")


return UI
