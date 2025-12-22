local UI = require("UI/Core/Style")

local ResetUI = {}

function ResetUI.ResetLayout()
    UI.Base.Layout.Padding = 14.0
    UI.Base.Layout.FrameRounding = 6.40
    UI.Base.Layout.FrameHeight = 22.0
    UI.Base.Layout.OptionHeight = 35.0
    UI.Base.Layout.OptionPaddingX = 0.0
    UI.Base.Layout.OptionPaddingY = 0.0
    UI.Base.Layout.LabelOffsetX = 8.0
    UI.Base.Layout.ItemSpacing = { x = 8.0, y = 2.0 }
    UI.Base.Layout.FramePadding = { x = 4.0, y = 0.5 }
    UI.Colors.Background = 0xF2000000

    UI.Base.OptionRow.HoverBg = UI.ColPalette.CustomBlueHighlight
    UI.Base.OptionRow.HighlightBg = UI.ColPalette.CustomBlueHighlight
    UI.Base.OptionRow.Text = UI.Colors.Text
    UI.Base.OptionRow.MutedText = UI.Colors.MutedText
    UI.Base.OptionRow.Rounding = 6.40
    UI.Base.OptionRow.LabelOffsetX = UI.Base.Layout.LabelOffsetX
    UI.Base.OptionRow.SmoothY = 0
    UI.Base.OptionRow.SmoothSpeed = 0.25
    
    UI.ApplyScale()
end

function ResetUI.ResetSize()
    UI.Base.Layout.WindowWidth = 400.0
    UI.Base.Layout.WindowHeight = 500.0
    UI.Base.Layout.DynamicHeight = true
    UI.Base.Layout.Scale = 1.0
    
    UI.ApplyScale()
end

function ResetUI.ResetFrame()
    UI.Base.Header.Rounding = 15.0

    UI.Base.SecondHeader.Height = 30.0
    UI.Base.SecondHeader.FontSize = 18.0
    UI.Base.SecondHeader.Rounding = 15.0

    UI.Base.Footer.Height = 35.0
    UI.Base.Footer.FontSize = 18.0
    UI.Base.Footer.Rounding = 15.0
    UI.Base.Footer.Text = "https://goodfeelings.cc"
    
    UI.ApplyScale()
end

function ResetUI.ResetNotification()
    UI.Base.Notification.Width = 300.0
    UI.Base.Notification.Padding = 15.0
    UI.Base.Notification.Spacing = 6.0
    UI.Base.Notification.Rounding = 15.0
    UI.Base.Notification.SlideDistance = 40.0
    UI.Base.Notification.AnimDuration = 0.2
    UI.Base.Notification.BackgroundColor = UI.ColPalette.GoodFeelingsHeader
    UI.Base.Notification.BorderColor = UI.Colors.Transparent
    UI.Base.Notification.ProgressHeight = 4.0
    UI.Base.Notification.ProgressOffsetY = -2.0
    
    UI.ApplyScale()
end

function ResetUI.ResetInfoBox()
    UI.Base.InfoBox.Padding = 14.0
    UI.Base.InfoBox.Rounding = 15.0
    UI.Base.InfoBox.Spacing = 15.0
    UI.Base.InfoBox.TextColor = UI.Colors.Text
    UI.Base.InfoBox.BackgroundColor = UI.ColPalette.GoodFeelingsHeader
    UI.Base.InfoBox.BorderColor = UI.Colors.Transparent
    UI.Base.InfoBox.CharsPerSecond = 175.0
    UI.Base.InfoBox.FallbackRotateSeconds = 10.0
    
    UI.ApplyScale()
end

function ResetUI.ResetSimpleControls()
    UI.BreakRow.Text = UI.Colors.MutedText
    UI.BreakRow.HighlightBg = UI.ColPalette.Transparent

    UI.Base.Dropdown.FramesPerOption = 3
    UI.Base.Dropdown.RevealFrameDelay = 3
    UI.Base.Dropdown.TextColor = UI.Colors.Text
    UI.Base.Dropdown.SelectedColor = UI.ColPalette.CoolSkyBlue
    UI.Base.Dropdown.RowPrefix = "- "

    UI.Base.StringCycler.FramePadding = 6.0
    UI.Base.StringCycler.TextPadding = 3.0
    UI.Base.StringCycler.BoxRounding = 6.40
    UI.Base.StringCycler.FrameBg = UI.Colors.FrameBg
    UI.Base.StringCycler.ValueColor = UI.ColPalette.CoolSkyBlue
    
    UI.ApplyScale()
end

function ResetUI.ResetSelectionControls()
    UI.Base.Toggle.Size = 18.0
    UI.Base.Toggle.Rounding = 6.40
    UI.Base.Toggle.Inset = 2.0
    UI.Base.Toggle.StatePadding = 6.0
    UI.Base.Toggle.StateSpacing = 8.0
    UI.Base.Toggle.OnColor = UI.ColPalette.SoftWhite
    UI.Base.Toggle.OffColor = UI.ColPalette.SoftYellow
    UI.Base.Toggle.BorderColor = UI.Colors.Text
    UI.Base.Toggle.FrameBg = UI.Colors.FrameBg
    UI.Base.Toggle.TextColor = UI.Colors.Text

    UI.Base.Radio.Radius = 6.0
    UI.Base.Radio.LineThickness = 1.5
    UI.Base.Radio.Segments = 20
    UI.Base.Radio.SelectedColor = UI.Base.Toggle.OnColor
    UI.Base.Radio.UnselectedColor = UI.Colors.Text
    
    UI.ApplyScale()
end

function ResetUI.ResetInputControls()
    UI.Base.Numeric.ToggleSize = 18.0
    UI.Base.Numeric.ToggleSpacing = 10.0
    UI.Base.Numeric.BoxFramePadding = 6.0
    UI.Base.Numeric.BoxTextPadding = 3.0
    UI.Base.Numeric.FrameBg = UI.Colors.FrameBg
    UI.Base.Numeric.TextColor = UI.Colors.Text
    UI.Base.Numeric.DisabledColor = UI.Colors.MutedText
    UI.Base.Numeric.Decimals = 2
    UI.Base.Numeric.DefaultIntStep = 1
    UI.Base.Numeric.DefaultFloatStep = 0.1

    UI.Base.ColorPicker.ChannelBoxSize = 24.0
    UI.Base.ColorPicker.ChannelPadding = 6.0
    UI.Base.ColorPicker.PreviewBoxSize = 18.0
    UI.Base.ColorPicker.RowSpacing = 2.0
    UI.Base.ColorPicker.FrameBg = UI.Colors.FrameBg
    UI.Base.ColorPicker.TextColor = UI.Colors.Text
    UI.Base.ColorPicker.BorderColor = UI.Colors.Border
    UI.Base.ColorPicker.Rounding = 6.40
    
    UI.ApplyScale()
end

function ResetUI.ResetTextInput()
    UI.Base.TextInput.Width = 400.0
    UI.Base.TextInput.Height = 140.0
    UI.Base.TextInput.Padding = 14.0
    UI.Base.TextInput.Rounding = 6.40
    UI.Base.TextInput.BackgroundColor = UI.ColPalette.DarkCharcoal
    UI.Base.TextInput.BorderColor = UI.ColPalette.SteelBorderGray
    UI.Base.TextInput.TextColor = UI.Colors.Text
    UI.Base.TextInput.ButtonSpacing = 10.0
    
    UI.ApplyScale()
end

function ResetUI.ResetSnowBackground()
    UI.Base.Background.MasterEnabled = false
    UI.Base.Background.SnowPileEnabled = false
    UI.Base.Background.SnowEnabled = false
    UI.Base.Background.Gravity = 30
    UI.Base.Background.WindSway = 0.6
    UI.Base.Background.SpawnRate = 0.025
    UI.Base.Background.PileLayers = 2
    UI.Base.Background.PileColumns = 80
    UI.Base.Background.SnowDensity = 1
    UI.Base.Background.SnowColor = 0xFFEFEFFF
    UI.Base.Background.PeeColor = 0xFF88FFFF
    UI.Base.Background.SnowBrightness = 1.0
    UI.Base.Background.SnowTwinkle = true
    UI.Base.Background.SnowflakeSizeMin = 1.2
    UI.Base.Background.SnowflakeSize = 2.0
    UI.Base.Background.SnowmanEnabled = false
    UI.Base.Background.YellowSnowChance = 0.000001
    UI.Base.Background.PeeSnowEnabled = false

    UI.Base.Background.LightSpacing = 20
    UI.Base.Background.LightsEnabled = true
    UI.Base.Background.LightRadius = 5
    UI.Base.Background.LightSpeed = 2.5
    UI.Base.Background.LightBrightness = 1.0
    UI.Base.Background.TwinkleEnabled = true
    
    UI.ApplyScale()
end

function ResetUI.ResetAll()
    ResetUI.ResetLayout()
    ResetUI.ResetFrame()
    ResetUI.ResetNotification()
    ResetUI.ResetInfoBox()
    ResetUI.ResetSimpleControls()
    ResetUI.ResetSelectionControls()
    ResetUI.ResetInputControls()
    ResetUI.ResetTextInput() 
    ResetUI.ResetSize()
    ResetUI.ResetSnowBackground()
end

return ResetUI
