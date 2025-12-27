local UI = require("UI/Core/Style")
local DrawHelpers = require("UI/Core/DrawHelpers")
local Submenus = require("UI/Core/SubmenuManager")
local State = require("Controls/State")

local SecondHeader = {}

function SecondHeader.Draw(menuX, menuY, menuW, headerHeight)
    if not UI or not UI.SecondHeader then
        return
    end
    
    local secondHeader = UI.SecondHeader
    local x = menuX
    local y = menuY + (headerHeight or 0)
    local w = menuW
    local h = secondHeader.Height or 30.0

    DrawHelpers.RectFilled(x, y, w, h, secondHeader.BackgroundColor)
    
    -- Draw breadcrumb text (centered)
    local breadcrumb = L(Submenus.GetBreadcrumbTitle())
    if not breadcrumb or breadcrumb == "" or breadcrumb == "GoodFeelings" then
        breadcrumb = "Main Menu"
    end
    if breadcrumb and breadcrumb ~= "" then
        local breadcrumbWidth = ImGui.CalcTextSize(breadcrumb)
        local breadcrumbX = math.floor(x + (w - breadcrumbWidth) * 0.5) + 0.5
        local breadcrumbY = math.floor(y + (h - ImGui.GetFontSize()) * 0.5) + 0.5

        -- Calculate Background Rect for Hover
        local paddingX = 8.0
        local paddingY = 2.0
        local bgX = breadcrumbX - paddingX
        local bgY = breadcrumbY - paddingY
        local bgW = breadcrumbWidth + paddingX * 2
        local bgH = ImGui.GetFontSize() + paddingY * 2

        -- Check Hover/Click
        local isHovered = false
        if State.overlayOpen or State.mouseEnabled then
            local mx, my = ImGui.GetMousePos()
            if mx >= bgX and mx <= bgX + bgW and my >= bgY and my <= bgY + bgH then
                isHovered = true
                -- Draw Hover Background (Semi-transparent Black, Less Rounded)
                DrawHelpers.RectFilled(bgX, bgY, bgW, bgH, 0x80000000, 5.0)
                
                -- Handle Click
                if ImGui.IsMouseClicked(0) then
                     if not Submenus.IsAtRootMenu() then
                         Submenus.CloseSubmenu()
                     end
                end
            end
        end

        local drawlist = ImGui.GetWindowDrawList()
        ImGui.ImDrawListAddText(drawlist, ImGui.GetFontSize(), breadcrumbX, breadcrumbY, secondHeader.TextColor, breadcrumb)
    end


    local function DrawBadge(dl, bx, by, bw, bh, text, txtCol, cutLeft)
        local bgColor = UI.OptionRow.HighlightBg
        local borderColor = UI.ColPalette.MainAccent
        local scale = UI.Base.Layout.Scale or 1.0
        local cutSize = 10 * scale 
        
        local x1, y1 = bx, by
        local x2, y2 = bx + bw, by + bh
        
        if cutLeft then
            ImGui.ImDrawListAddRectFilled(dl, x1 + cutSize, y1, x2, y2, bgColor)
            ImGui.ImDrawListAddRectFilled(dl, x1, y1, x1 + cutSize, y2 - cutSize, bgColor)
            ImGui.ImDrawListAddTriangleFilled(dl, x1, y2 - cutSize, x1 + cutSize, y2 - cutSize, x1 + cutSize, y2, bgColor)
        else
            ImGui.ImDrawListAddRectFilled(dl, x1, y1, x2 - cutSize, y2, bgColor)
            ImGui.ImDrawListAddRectFilled(dl, x2 - cutSize, y1, x2, y2 - cutSize, bgColor)
            ImGui.ImDrawListAddTriangleFilled(dl, x2 - cutSize, y2 - cutSize, x2, y2 - cutSize, x2 - cutSize, y2, bgColor)
        end
        
        local thickness = 3.0
        local e2 = thickness * 0.5
        local e = 0.30
        
        if cutLeft then
            DrawHelpers.Line(x1 - e2, y1, x2 + e2, y1, borderColor, thickness)
            DrawHelpers.Line(x2, y1 - e2, x2, y2 + e2, borderColor, thickness)
            DrawHelpers.Line(x1, y1 - e2, x1, y2 - cutSize + e, borderColor, thickness)
            DrawHelpers.Line(x1, y2 - cutSize, x1 + cutSize, y2, borderColor, thickness)
            DrawHelpers.Line(x1 + cutSize - e, y2, x2 + e2, y2, borderColor, thickness)
        else
            DrawHelpers.Line(x1 - e2, y1, x2 + e2, y1, borderColor, thickness)
            DrawHelpers.Line(x1, y1 - e2, x1, y2 + e2, borderColor, thickness)
            DrawHelpers.Line(x2, y1 - e2, x2, y2 - cutSize + e, borderColor, thickness)
            DrawHelpers.Line(x2, y2 - cutSize, x2 - cutSize, y2, borderColor, thickness)
            DrawHelpers.Line(x2 - cutSize + e, y2, x1 - e2, y2, borderColor, thickness)
        end
        
        local tw, th = ImGui.CalcTextSize(text)
        DrawHelpers.Text(bx + (bw - tw) * 0.5, by + (bh - th) * 0.5, txtCol, text)
    end

    local badgeH = h * 0.8
    local badgeY = y + (h - badgeH) * 0.5
    local badgePaddingX = 8.0
    local edgePadding = 5.0 -- 5px padding from header edges

    local versionText = MOD_VERSION
    local vW = ImGui.CalcTextSize(versionText) + badgePaddingX * 2
    DrawBadge(ImGui.GetWindowDrawList(), x + edgePadding, badgeY, vW, badgeH, versionText, secondHeader.TextColor, false)

    local current = State.currentOption or 1
    local total = State.optionCount or State.optionIndex or 1
    local countText = string.format("%d\\%d", current, total)
    local cW = ImGui.CalcTextSize(countText) + badgePaddingX * 2
    DrawBadge(ImGui.GetWindowDrawList(), x + w - cW - edgePadding, badgeY, cW, badgeH, countText, secondHeader.TextColor, true)
end

return SecondHeader
