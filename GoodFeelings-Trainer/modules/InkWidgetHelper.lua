local InkWidgetHelper = {}

-- === Core Creation Functions ===

function InkWidgetHelper.createText(name, text, margin, fontSize, color, parent, scaleFactor)
    scaleFactor = scaleFactor or 1.0
    local widget = inkText.new()
    widget:SetName(name); CName.add(name)
    widget:SetStyle(ResRef.FromName("base\\gameplay\\gui\\common\\main_colors.inkstyle"))
    widget:SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily")
    widget:SetMargin(margin[1]*scaleFactor, margin[2]*scaleFactor, margin[3]*scaleFactor, margin[4]*scaleFactor)
    widget:BindProperty("tintColor", color)
    widget:SetFontStyle("Bold")
    widget:SetLetterCase("OriginalCase")
    widget:SetFontSize(math.floor(fontSize * scaleFactor))
    widget:SetText(text)
    if parent then widget:Reparent(parent) end
    return widget
end

function InkWidgetHelper.createImage(name, atlasPath, partName, margin, size, opacity, parent, scaleFactor, color)
    scaleFactor = scaleFactor or 1.0
    local image = inkImage.new()
    image:SetName(CName.new(name))
    image:SetAtlasResource(ResRef.FromName(atlasPath))
    image:SetTexturePart(CName.new(partName))
    image:SetMargin(margin[1]*scaleFactor, margin[2]*scaleFactor, margin[3]*scaleFactor, margin[4]*scaleFactor)
    image:SetSize(size[1]*scaleFactor, size[2]*scaleFactor)
    image:SetOpacity(opacity or 1.0)
    image:SetVisible(true)
    
    if color then
        -- If it's a string like "MainColors.Red", use BindProperty
        if type(color) == "string" then
            image:SetStyle(ResRef.FromName("base\\gameplay\\gui\\common\\main_colors.inkstyle"))
            image:BindProperty("tintColor", CName.new(color))
        else
            -- If it's an HDRColor/Color object, use SetTintColor
            image:SetTintColor(color)
        end
    end
    
    if parent then image:Reparent(parent) end
    return image
end

function InkWidgetHelper.createRectangle(name, margin, size, color, opacity, parent, scaleFactor)
    scaleFactor = scaleFactor or 1.0
    local rect = inkRectangle.new()
    rect:SetName(name); CName.add(name)
    rect:SetStyle(ResRef.FromName("base\\gameplay\\gui\\common\\main_colors.inkstyle"))
    rect:SetMargin(margin[1]*scaleFactor, margin[2]*scaleFactor, margin[3]*scaleFactor, margin[4]*scaleFactor)
    rect:SetSize(size[1]*scaleFactor, size[2]*scaleFactor)
    rect:SetOpacity(opacity or 1.0)
    rect:BindProperty("tintColor", color)
    if parent then rect:Reparent(parent) end
    return rect
end

-- === Layout & Styling Helpers ===

function InkWidgetHelper.setVisibility(widgets, visible)
    if type(widgets) == "table" then
        for _, widget in pairs(widgets) do
            if widget.SetVisible then
                widget:SetVisible(visible)
            end
        end
    elseif widgets and widgets.SetVisible then
        widgets:SetVisible(visible)
    end
end

function InkWidgetHelper.createAlertWidgets(parent, topMargin, height)
    local ALERT_HEIGHT = height or 60
    local PADDING = topMargin or 20
    
    return {
        borderTop = InkWidgetHelper.createRectangle(
            "InkWidgetHelper_BorderTop",
            {0, PADDING, 0, 0},
            {0, 2},
            "MainColors.Yellow",
            1.0,
            parent,
            1.0
        ),
        borderBottom = InkWidgetHelper.createRectangle(
            "InkWidgetHelper_BorderBottom",
            {0, PADDING + ALERT_HEIGHT - 2, 0, 0},
            {0, 2},
            "MainColors.Yellow",
            1.0,
            parent,
            1.0
        ),
        borderLeft = InkWidgetHelper.createRectangle(
            "InkWidgetHelper_BorderLeft",
            {0, PADDING, 0, 0},
            {2, ALERT_HEIGHT},
            "MainColors.Yellow",
            1.0,
            parent,
            1.0
        ),
        borderRight = InkWidgetHelper.createRectangle(
            "InkWidgetHelper_BorderRight",
            {0, PADDING, 0, 0},
            {2, ALERT_HEIGHT},
            "MainColors.Yellow",
            1.0,
            parent,
            1.0
        ),
        background = InkWidgetHelper.createRectangle(
            "InkWidgetHelper_Background",
            {2, PADDING + 2, 2, 0},
            {0, ALERT_HEIGHT - 4},
            "MainColors.Red",
            0.5,
            parent,
            1.0
        ),
        text = InkWidgetHelper.createText(
            "InkWidgetHelper_Text",
            "",
            {0, PADDING, 0, 0},
            24,
            "MainColors.Blue",
            parent,
            1.0
        )
    }
end

function InkWidgetHelper.setAlertWidgetProperties(alertWidgets, text, vSize, gameRes, PADDING)
    -- Calculate the scaling factor based on the horizontal resolution (1920 is 1080p width)
    local scaleFactor = gameRes.X / 1920.0
    
    -- The PADDING constant passed from init.lua is assumed to be the 1080p base padding.
    local scaledPadding = math.floor(PADDING * scaleFactor)
    
    -- vSize is the user-defined font size (also based on 1080p)
    local scaledVSize = math.floor(vSize * scaleFactor)
    
    alertWidgets.text:SetFontSize(scaledVSize)
    alertWidgets.text:SetText(text)

    -- Count lines
    local lineCount = 0
    for _ in string.gmatch(text, "[^\n]+") do
        lineCount = lineCount + 1
    end

    -- Calculate dynamic height with 20% extra spacing, all scaled
    -- The base font size is scaled (scaledVSize)
    local lineHeight = (scaledVSize + math.floor(4 * scaleFactor)) * 1.2
    local textHeight = math.floor(lineCount * lineHeight)
    local boxHeight = math.floor(textHeight * 1.2)

    -- Width based on longest line, also scaled
    local longestLine = ""
    for line in string.gmatch(text, "[^\n]+") do
        if #line > #longestLine then longestLine = line end
    end
    
    -- The magic number 0.435 is a character width multiplier, which should be consistent.
    -- However, the total text width calculation also needs to be scaled.
    local textWidth = #longestLine * vSize * 0.435 * scaleFactor
    
    -- The hardcoded width margin (40) is also scaled
    local totalWidth = textWidth + math.floor(40 * scaleFactor)
    
    local leftMargin = (gameRes.X - totalWidth) / 2
    local rightMargin = leftMargin

    -- Get scaled border thickness (base is 2)
    local scaledBorderThickness = math.max(1, math.floor(2 * scaleFactor))

    -- Background
    alertWidgets.background:SetSize(totalWidth - scaledBorderThickness * 2, boxHeight - scaledBorderThickness * 2)
    alertWidgets.background:SetMargin(
        leftMargin + scaledBorderThickness, 
        scaledPadding + scaledBorderThickness, 
        rightMargin + scaledBorderThickness, 
        0
    )

    -- Borders
    alertWidgets.borderTop:SetSize(totalWidth, scaledBorderThickness)
    alertWidgets.borderTop:SetMargin(leftMargin, scaledPadding, rightMargin, 0)

    alertWidgets.borderBottom:SetSize(totalWidth, scaledBorderThickness)
    alertWidgets.borderBottom:SetMargin(leftMargin, scaledPadding + boxHeight - scaledBorderThickness, rightMargin, 0)

    alertWidgets.borderLeft:SetSize(scaledBorderThickness, boxHeight)
    alertWidgets.borderLeft:SetMargin(leftMargin, scaledPadding, rightMargin + totalWidth - scaledBorderThickness, 0)

    alertWidgets.borderRight:SetSize(scaledBorderThickness, boxHeight)
    alertWidgets.borderRight:SetMargin(leftMargin + totalWidth - scaledBorderThickness, scaledPadding, rightMargin, 0)

    -- Text
    -- The text is centered vertically within the box.
    local verticalOffset = scaledPadding + ((boxHeight - textHeight) / 2)
    
    -- The inner margin of the text box (4) is also scaled
    local textInnerMargin = math.floor(4 * scaleFactor)
    
    alertWidgets.text:SetSize(totalWidth - textInnerMargin * 2, textHeight)
    alertWidgets.text:SetMargin(
        leftMargin + textInnerMargin, 
        verticalOffset, 
        rightMargin + textInnerMargin, 
        0
    )

    -- Show all
    InkWidgetHelper.setVisibility(alertWidgets, true)
end

-- === Extra Utility Functions ===

function InkWidgetHelper.setText(widget, fmt, val)
    if widget then widget:SetText(string.format(fmt, val)) end
end

function InkWidgetHelper.setVisibility(widgets, visible)
    for _, w in pairs(widgets) do if w then w:SetVisible(visible) end end
end

-- === Specialized Widget Builders (Used by my "Bespoke Benchmarks" mod) ===

function InkWidgetHelper.createLabel(name, text, margin, parent, scaleFactor)
    return InkWidgetHelper.createText(name, text, margin, 27, "MainColors.Blue", parent, scaleFactor)
end

function InkWidgetHelper.createValue(name, margin, parent, scaleFactor)
    return InkWidgetHelper.createText(name, "0.0", margin, 29, "MainColors.Yellow", parent, scaleFactor)
end

function InkWidgetHelper.createFPS(name, margin, parent, scaleFactor)
    return InkWidgetHelper.createText(name, "FPS: 0", margin, 37, "MainColors.Blue", parent, scaleFactor)
end

function InkWidgetHelper.createBackground(name, margin, size, parent, scaleFactor)
    --return InkWidgetHelper.createImage(name, "base\\gameplay\\gui\\widgets\\hud_johnny\\atlas_common.inkatlas", "cell_hud_qh_fg", margin, size, 0.75, parent, scaleFactor, "MainColors.Red")
    return InkWidgetHelper.createRectangle(name, margin, size, "MainColors.Red", 0.2, parent, scaleFactor)
end

function InkWidgetHelper.createBorder(name, parent, scaleFactor)
    return InkWidgetHelper.createRectangle(name, {0,0,0,0}, {0,0}, "MainColors.Yellow", 0.7, parent, scaleFactor)
end

return InkWidgetHelper
