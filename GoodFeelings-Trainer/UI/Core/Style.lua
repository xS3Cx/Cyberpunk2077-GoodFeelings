local UI = {}

-- Colors use ARGB hex format: 0xAARRGGBB
-- AA = Alpha (opacity, FF = solid, 00 = transparent)
-- RR = Red   (00–FF)
-- GG = Green (00–FF)
-- BB = Blue  (00–FF)
UI.ColPalette = {
    PureWhite = 0xFFFFFFFF,
    MediumGray = 0xFFAAAAAA,
    NearBlackGray = 0xFF1A1A1A,
    DarkCharcoal = 0xFF202020,
    SteelBorderGray = 0xFF505A6E,
    CoolSkyBlue = 0xFF3A6EA5,
    SoftCyanHighlight = 0xA05A3C1E,
    HotCyberPink = 0xFFFF1493,
    DesaturatedSlateBlue = 0xFF788CA0,
    
    Transparent = 0x00000000,
    
    GlowGreen = 0xFF88FF00,
    GlowYellow = 0xFF88FFFF,
    
    SoftRed = 0xFF8080F0,
    SoftWhite = 0xFFC8C8C8,
    SoftYellow = 0xFF80D0D0,

}

UI.Colors = {
    Text = UI.ColPalette.PureWhite,
    MutedText = UI.ColPalette.DesaturatedSlateBlue,
    Background = UI.ColPalette.NearBlackGray,
    FrameBg = UI.ColPalette.DarkCharcoal,
    Border = UI.ColPalette.SteelBorderGray,
    Highlight = UI.ColPalette.CoolSkyBlue,
    HoverBg = UI.ColPalette.SoftCyanHighlight,
    Active = UI.ColPalette.HotCyberPink,
    Transparent = UI.ColPalette.Transparent,
}

UI.Layout = {
    Padding = 14.0,
    FrameRounding = 10.0,
    FrameHeight = 22.0,
    OptionHeight = 28.0,
    OptionPaddingX = 3.0,
    OptionPaddingY = 5.0,
    LabelOffsetX = 8.0,
    ItemSpacing = { x = 8.0, y = 2.0 },
    FramePadding = { x = 4.0, y = 0.5 },
}

UI.OptionRow = {
    HoverBg = UI.Colors.HoverBg,
    HighlightBg = UI.Colors.Highlight,
    Text = UI.Colors.Text,
    MutedText = UI.Colors.MutedText,
    Rounding = UI.Layout.FrameRounding,
    LabelOffsetX= UI.Layout.LabelOffsetX,

    SmoothY = 0,
    SmoothSpeed = 0.25,
}

UI.Header = {
    Height = 40.0,
    BackgroundColor = UI.Colors.Background,
    TextColor = UI.Colors.Text,
    BorderColor = UI.Colors.Border,

    FontSize = 18.0,
    FontSizeSub = 16.0,
    Text = "GoodFeelings"
}

UI.Footer = {
    Height = 25.0,
    BackgroundColor = UI.Colors.Background,
    TextColor = UI.ColPalette.MediumGray,
    BorderColor = UI.Colors.Border,
    FontSize = 12.0,
    Text = "Beta 1.3.1 | By Avi"
}


UI.Notification = {
    Width = 300.0,
    Padding = 15.0,
    Spacing = 6.0,
    Rounding = 6.0,
    SlideDistance = 40.0,
    AnimDuration = 0.2,

    BackgroundColor = UI.ColPalette.DarkCharcoal,
    BorderColor = UI.ColPalette.SteelBorderGray,

    ProgressHeight = 4.0,
    ProgressOffsetY = -2.0,
    ProgressColors = {
        Default = UI.ColPalette.CoolSkyBlue,
        info = UI.ColPalette.PureWhite,
        success = UI.ColPalette.GlowGreen,
        warning = UI.ColPalette.GlowYellow,
        error = UI.ColPalette.SoftRed,
    },

    TypeColors = {
        info = UI.ColPalette.PureWhite,
        success = UI.ColPalette.GlowGreen,
        warning = UI.ColPalette.GlowYellow,
        error = UI.ColPalette.SoftRed,
    }
}

UI.InfoBox = {
    Padding = 14.0,      
    Rounding = UI.Layout.FrameRounding,
    Spacing = 15.0, -- distance from menu to infobox
    TextColor = UI.Colors.Text,
    BackgroundColor = UI.ColPalette.DarkCharcoal,
    BorderColor = UI.ColPalette.SteelBorderGray,

    CharsPerSecond = 175.0,    
    FallbackRotateSeconds = 10.0, 
}


UI.BreakRow = {
    Text = UI.Colors.MutedText, 
    HighlightBg = UI.ColPalette.Transparent,
}

UI.Dropdown = {
    ArrowRight = IconGlyphs.ArrowExpand,
    ArrowDown = IconGlyphs.ArrowExpandAll,

    FramesPerOption = 3, 
    RevealFrameDelay = 3, 

    TextColor = UI.Colors.Text,
    SelectedColor = UI.ColPalette.CoolSkyBlue,

    RowPrefix = "- ",  
}

UI.Toggle = {
    Size = 18.0,
    Rounding = UI.Layout.FrameRounding,
    Inset = 2.0,

    StatePadding = 6.0,
    StateSpacing = 8.0,

    OnColor = UI.ColPalette.SoftWhite,
    OffColor = UI.ColPalette.Transparent,
    BorderColor = UI.Colors.Text,
    FrameBg = UI.Colors.FrameBg,
    TextColor = UI.Colors.Text,
}

UI.Numeric = {
    ToggleSize = 18.0,
    ToggleSpacing = 10.0,
    BoxFramePadding = 6.0,
    BoxTextPadding = 3.0,

    FrameBg = UI.Colors.FrameBg,
    TextColor = UI.Colors.Text,
    DisabledColor = UI.Colors.MutedText,

    Decimals = 2,
    DefaultIntStep = 1,
    DefaultFloatStep = 0.1,
}

UI.Radio = {
    Radius = 6.0,
    LineThickness = 1.5,
    Segments = 20,

    SelectedColor = UI.Toggle.OnColor,
    UnselectedColor = UI.Colors.Text,
}

UI.StringCycler = {
    FramePadding = 6.0,
    TextPadding = 3.0,
    BoxRounding = UI.Layout.FrameRounding,
    FrameBg = UI.Colors.FrameBg,
    ValueColor = UI.ColPalette.CoolSkyBlue,
}


UI.ColorPicker = {
    ChannelBoxSize = 24.0, 
    ChannelPadding = 6.0,
    PreviewBoxSize = 18.0, 
    RowSpacing = 2.0, 

    FrameBg = UI.Colors.FrameBg,
    TextColor = UI.Colors.Text,
    BorderColor = UI.Colors.Border,
    Rounding = UI.Layout.FrameRounding,
}

UI.TextInput = {
    Width = 400.0,
    Height = 140.0,
    Padding = 14.0,
    Rounding = UI.Layout.FrameRounding,
    BackgroundColor = UI.ColPalette.DarkCharcoal,
    BorderColor = UI.ColPalette.SteelBorderGray,
    TextColor = UI.Colors.Text,
    ButtonSpacing = 10.0,
}

UI.Background = {
    MasterEnabled = true,

    SnowEnabled = true,
    SnowPileEnabled = true,
    SnowmanEnabled = true,

    Gravity = 30,
    WindSway = 0.6,
    SpawnRate = 0.025,
    SnowDensity = 1,
    PileLayers = 2,
    PileColumns = 80,

    SnowColor = 0xFFEFEFFF,
    PeeColor = 0xFF88FFFF,

    SnowBrightness = 1.0,
    SnowTwinkle = true,
    SnowflakeSizeMin = 1.2,
    SnowflakeSize = 2.0,

    YellowSnowChance = 0.000001,
    PeeSnowEnabled = false,

    LightsEnabled = true,
    LightSpacing = 20,
    LightRadius = 5,
    LightSpeed = 2.5,
    LightBrightness = 1.0,
    TwinkleEnabled = true,
    
    LightColor1 = 0xFFFF4040,
    LightColor2 = 0xFF40FF40,
    LightColor3 = 0xFFFFFF40,
    LightColor4 = 0xFF40C0FF,
    LightColor5 = 0xFFFF80FF,
}




return UI
