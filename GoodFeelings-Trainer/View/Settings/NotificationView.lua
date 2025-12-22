local Buttons = require("UI").Buttons
local UI = require("UI/Core/Style")
local ResetUI = require("UI/Core/ResetUI")
local Notification = require("UI/Elements/Notification")


local widthRef = { value = UI.Notification.Width, min = 100, max = 800 }
local paddingRef = { value = UI.Notification.Padding, min = 0, max = 50 }
local spacingRef = { value = UI.Notification.Spacing, min = 0, max = 30 }
local roundingRef = { value = UI.Notification.Rounding, min = 0, max = 20 }
local slideDistRef = { value = UI.Notification.SlideDistance, min = 0, max = 200 }
local animDurRef = { value = UI.Notification.AnimDuration, min = 0.01, max = 2.0, step = 0.01 }
local progressHeightRef = { value = UI.Notification.ProgressHeight, min = 1, max = 20 }
local progressOffsetRef = { value = UI.Notification.ProgressOffsetY, min = -20, max = 20 }

local notifPosRef = { index = 1 }
local notifPosOptions = {
    "Auto", "TopLeft", "TopRight", "TopCenter",
    "BottomLeft", "BottomRight", "BottomCenter"
}

local function NotificationViewFunction()
    Buttons.Option(L("settings.notifications.reset.label"), tip("settings.notifications.reset.tip"), ResetUI.ResetNotification)

    Buttons.Break(L("settings.notifications.layout.label"))
    if Buttons.Int(L("settings.notifications.layout.width.label"), widthRef, tip("settings.notifications.layout.width.tip")) then
        UI.Notification.Width = widthRef.value
    end
    if Buttons.Int(L("settings.notifications.layout.padding.label"), paddingRef, tip("settings.notifications.layout.padding.tip")) then
        UI.Notification.Padding = paddingRef.value
    end
    if Buttons.Int(L("settings.notifications.layout.spacing.label"), spacingRef, tip("settings.notifications.layout.spacing.tip")) then
        UI.Notification.Spacing = spacingRef.value
    end
    if Buttons.Int(L("settings.notifications.layout.rounding.label"), roundingRef, tip("settings.notifications.layout.rounding.tip")) then
        UI.Notification.Rounding = roundingRef.value
    end
    if Buttons.Int(L("settings.notifications.layout.slidedistance.label"), slideDistRef, tip("settings.notifications.layout.slidedistance.tip")) then
        UI.Notification.SlideDistance = slideDistRef.value
    end
    if Buttons.Float(L("settings.notifications.layout.animationduration.label"), animDurRef, tip("settings.notifications.layout.animationduration.tip")) then
        UI.Notification.AnimDuration = animDurRef.value
    end

    Buttons.Break(L("settings.notifications.progress.label"))
    if Buttons.Int(L("settings.notifications.progress.height.label"), progressHeightRef, tip("settings.notifications.progress.height.tip")) then
        UI.Notification.ProgressHeight = progressHeightRef.value
    end
    if Buttons.Int(L("settings.notifications.progress.offsety.label"), progressOffsetRef, tip("settings.notifications.progress.offsety.tip")) then
        UI.Notification.ProgressOffsetY = progressOffsetRef.value
    end

    Buttons.Break(L("settings.notifications.colors.label"))
    Buttons.ColorHex(L("settings.notifications.colors.background.label"), UI.Notification, "BackgroundColor", tip("settings.notifications.colors.background.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.border.label"), UI.Notification, "BorderColor", tip("settings.notifications.colors.border.tip"))

    Buttons.ColorHex(L("settings.notifications.colors.progress.default.label"), UI.Notification.ProgressColors, "Default", tip("settings.notifications.colors.progress.default.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.progress.info.label"), UI.Notification.ProgressColors, "info", tip("settings.notifications.colors.progress.info.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.progress.success.label"), UI.Notification.ProgressColors, "success", tip("settings.notifications.colors.progress.success.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.progress.warning.label"), UI.Notification.ProgressColors, "warning", tip("settings.notifications.colors.progress.warning.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.progress.error.label"), UI.Notification.ProgressColors, "error", tip("settings.notifications.colors.progress.error.tip"))

    Buttons.ColorHex(L("settings.notifications.colors.text.info.label"), UI.Notification.TypeColors, "info", tip("settings.notifications.colors.text.info.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.text.success.label"), UI.Notification.TypeColors, "success", tip("settings.notifications.colors.text.success.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.text.warning.label"), UI.Notification.TypeColors, "warning", tip("settings.notifications.colors.text.warning.tip"))
    Buttons.ColorHex(L("settings.notifications.colors.text.error.label"), UI.Notification.TypeColors, "error", tip("settings.notifications.colors.text.error.tip"))

    Buttons.Break(L("settings.notifications.position.label"))
    Buttons.Dropdown(L("settings.notifications.position.dropdown.label"), notifPosRef, notifPosOptions, tip("settings.notifications.position.dropdown.tip"))
    local pos = notifPosOptions[notifPosRef.index]

    Buttons.Break(L("settings.notifications.test.label"))
    if Buttons.Option(L("settings.notifications.test.info.label"), tip("settings.notifications.test.info.tip")) then
        Notification.Info("This is a test info notification.", 3, pos)
    end
    if Buttons.Option(L("settings.notifications.test.success.label"), tip("settings.notifications.test.success.tip")) then
        Notification.Success("This is a test success notification.", 3, pos)
    end
    if Buttons.Option(L("settings.notifications.test.warning.label"), tip("settings.notifications.test.warning.tip")) then
        Notification.Warning("This is a test warning notification.", 3, pos)
    end
    if Buttons.Option(L("settings.notifications.test.error.label"), tip("settings.notifications.test.error.tip")) then
        Notification.Error("This is a test error notification.", 3, pos)
    end
end

local NotificationView = { title = "settings.notifications.title", view = NotificationViewFunction }

return NotificationView

