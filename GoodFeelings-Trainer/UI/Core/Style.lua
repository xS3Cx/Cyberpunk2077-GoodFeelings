local UI = {}

function UI.ApplyScale()
    local scale = UI.Base.Layout.Scale or 1.0
    
    local function process(base, active, key)
        for k, v in pairs(base) do
            if type(v) == "table" then
                if not active[k] then active[k] = {} end
                process(v, active[k], k)
            elseif type(v) == "number" then
                -- Heuristic to scale only dimensions/sizes
                -- Exclude: Colors (ARGB > 0x01000000), specific keys, and flags
                local isColor = v > 0x01000000
                local isRounding = k:find("Rounding")
                local isExcluded = (k == "Scale" or k == "MaxVisibleOptions" or k == "FramesPerOption" or k == "RevealFrameDelay" or k == "Decimals" or k == "MasterEnabled" or k:find("Enabled") or k:find("Chance") or k:find("Count") or k:find("Layers") or k:find("Columns") or k:find("Speed"))
                
                if not isColor and (not isExcluded or isRounding) and type(v) == "number" then
                    active[k] = v * scale
                else
                    active[k] = v
                end
            else
                active[k] = v
            end
        end
    end

    process(UI.Base, UI)
end

-- Colors use ARGB hex format: 0xAARRGGBB
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

    GoodFeelingsHeader = 0xFF080808,
    CustomRed = 0xFF4850F5,
    CustomBlueHighlight = 0x60E67505,
    TransparentBlack = 0xF2000000, -- 95% alpha black
    SolidBlueHighlight = 0xFFE67505, -- Solid version of CustomBlueHighlight (ABGR)

    ToggleOff = 0xFF151515,
    ToggleOffThumb = 0xFF0C0C0C,
    ToggleOn = 0xFFE67505,
    ToggleOnThumb = 0xFFFFFFFF,
}

UI.Colors = {
    Text = UI.ColPalette.PureWhite,
    MutedText = UI.ColPalette.DesaturatedSlateBlue,
    Background = UI.ColPalette.TransparentBlack,
    FrameBg = UI.ColPalette.DarkCharcoal,
    Border = UI.ColPalette.SteelBorderGray,
    Highlight = UI.ColPalette.CustomBlueHighlight,
    HoverBg = UI.ColPalette.CustomBlueHighlight,
    Active = UI.ColPalette.HotCyberPink,
    Transparent = UI.ColPalette.Transparent,
}

UI.Base = {
    Layout = {
        Padding = 14.0,
        FrameRounding = 6.40,
        FrameHeight = 22.0,
        OptionHeight = 35.0,
        OptionPaddingX = 0.0,
        OptionPaddingY = 0.0,
        LabelOffsetX = 8.0,
        ItemSpacing = { x = 8.0, y = 2.0 },
        FramePadding = { x = 4.0, y = 0.5 },
        WindowWidth = 400.0,
        WindowHeight = 500.0,
        DynamicHeight = true,
        Scale = 1.0,
        SmoothHeightSpeed = 0.15,
        MaxVisibleOptions = 16,
        IconOffsetY = 2.0,
    },
    OptionRow = {
        Rounding = 6.40,
        LabelOffsetX = 8.0,
        SmoothY = 0,
        SmoothSpeed = 0.25,
        HoverBg = 0x60E67505,
        HighlightBg = 0x60E67505,
        Text = 0xFFFFFFFF,
        MutedText = 0xFF788CA0,
    },
    Header = {
        Height = 75.0,
        FontSize = 40.0, -- Reduced size for main title
        FontSizeSub = 16.0,
        Rounding = 15.0,
        BackgroundColor = 0xFF080808,
        TextColor = 0xFFE67505,
        BorderColor = 0xFF505A6E,
        Text = "GoodFeelings",
    },
    SecondHeader = {
        Height = 30.0,
        FontSize = 13.0,
        Rounding = 15.0,
        BackgroundColor = 0xFF080808,
        TextColor = 0xFFE67505,
        BorderColor = 0xFF505A6E,
    },
    Footer = {
        Height = 35.0,
        FontSize = 18.0,
        Rounding = 15.0,
        BackgroundColor = 0xFF080808,
        TextColor = 0xFFE67505,
        Text = "https://goodfeelings.cc"
    },
    Notification = {
        Width = 300.0,
        Padding = 15.0,
        Spacing = 6.0,
        Rounding = 15.0,
        SlideDistance = 40.0,
        AnimDuration = 0.2,
        ProgressHeight = 4.0,
        ProgressOffsetY = -2.0,
        BackgroundColor = 0xFF080808,
        BorderColor = 0x00000000,
        ProgressColors = {
            Default = 0xFF3A6EA5,
            info = 0xFFFFFFFF,
            success = 0xFF88FF00,
            warning = 0xFF88FFFF,
            error = 0xFF8080F0,
        },
        TypeColors = {
            info = 0xFFE67505, -- Overlay blue
            success = 0xFF88FF00,
            warning = 0xFF88FFFF,
            error = 0xFF8080F0,
        },
    },
    InfoBox = {
        Padding = 14.0,      
        Rounding = 15.0,
        Spacing = 15.0, 
        CharsPerSecond = 175.0,    
        FallbackRotateSeconds = 10.0, 
        TextColor = 0xFFFFFFFF,
        BackgroundColor = 0xFF080808,
        BorderColor = 0x00000000,
    },
    Toggle = {
        Size = 20.0,
        WidthFactor = 1.55,
        Rounding = 6.40,
        Inset = 1.5,
        OnColor = 0xFFE67505,
        OffColor = 0xFF151515,
        OnThumbColor = 0xFFFFFFFF,
        OffThumbColor = 0xFF0C0C0C,
        AnimSpeed = 0.2,
    },
    Numeric = {
        ToggleSize = 18.0,
        ToggleSpacing = 10.0,
        BoxFramePadding = 6.0,
        BoxTextPadding = 3.0,
        Decimals = 2,
        DefaultIntStep = 1,
        DefaultFloatStep = 0.1,
        FrameBg = 0xFF151515,
        TextColor = 0xFFE67505,
        DisabledColor = 0xFF788CA0,
    },
    Radio = {
        Radius = 6.0,
        LineThickness = 1.5,
        Segments = 20,
        SelectedColor = 0xFFFFFFFF,
        UnselectedColor = 0xFFFFFFFF,
    },
    StringCycler = {
        FramePadding = 6.0,
        TextPadding = 3.0,
        BoxRounding = 6.40,
        FrameBg = 0xFF202020,
        ValueColor = 0xFF3A6EA5,
    },
    ColorPicker = {
        ChannelBoxSize = 24.0, 
        ChannelPadding = 6.0,
        PreviewBoxSize = 18.0, 
        RowSpacing = 2.0, 
        Rounding = 6.40,
        FrameBg = 0xFF202020,
        TextColor = 0xFFFFFFFF,
        BorderColor = 0xFF505A6E,
    },
    TextInput = {
        Width = 400.0,
        Height = 140.0,
        Padding = 14.0,
        Rounding = 6.40,
        ButtonSpacing = 10.0,
        BackgroundColor = 0xFF202020,
        BorderColor = 0xFF505A6E,
        TextColor = 0xFFFFFFFF,
    },
    Background = {
        MasterEnabled = false,
        SnowEnabled = false,
        SnowPileEnabled = false,
        SnowmanEnabled = false,
        Gravity = 30,
        WindSway = 0.6,
        SpawnRate = 0.025,
        SnowDensity = 1,
        PileLayers = 2,
        PileColumns = 80,
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
        SnowColor = 0xFFEFEFFF,
        PeeColor = 0xFF88FFFF,
        LightColor1 = 0xFFFF4040,
        LightColor2 = 0xFF40FF40,
        LightColor3 = 0xFFFFFF40,
        LightColor4 = 0xFF40C0FF,
        LightColor5 = 0xFFFF80FF,
    },
    BreakRow = {
        Text = 0xFFE67505, 
        HighlightBg = 0x00000000,
    },
    Dropdown = {
        ArrowRight = (IconGlyphs and (IconGlyphs.ArrowRightBoldBoxOutline or IconGlyphs["arrow-right-bold-box-outline"])) or "arrow-right-bold-box-outline",
        ArrowDown = (IconGlyphs and IconGlyphs.ArrowExpandAll) or "v",
        FramesPerOption = 3, 
        RevealFrameDelay = 3, 
        TextColor = 0xFFFFFFFF,
        SelectedColor = 0xFF3A6EA5,
        RowPrefix = "- ",  
    },
}

-- All properties are now consolidated in UI.Base and merged via ApplyScale

-- Initial call to apply scale (usually 1.0 at first)
UI.ApplyScale()

return UI
