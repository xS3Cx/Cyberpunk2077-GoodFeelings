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
        local breadcrumbY = math.floor(y + (h - secondHeader.FontSize) * 0.5) + 0.5

        -- Calculate Background Rect for Hover
        local paddingX = 8.0
        local paddingY = 2.0
        local bgX = breadcrumbX - paddingX
        local bgY = breadcrumbY - paddingY
        local bgW = breadcrumbWidth + paddingX * 2
        local bgH = secondHeader.FontSize + paddingY * 2

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
        ImGui.ImDrawListAddText(drawlist, secondHeader.FontSize, breadcrumbX, breadcrumbY, secondHeader.TextColor, breadcrumb)
    end

    -- Draw Version (Left)
    local versionText = "1.0.0"
    local versionY = math.floor(y + (h - secondHeader.FontSize) * 0.5) + 0.5
    local versionX = x + 10.0
    local drawlist = ImGui.GetWindowDrawList()
    ImGui.ImDrawListAddText(drawlist, secondHeader.FontSize, versionX, versionY, secondHeader.TextColor, versionText)

    -- Draw Option Count (Right)
    local current = State.currentOption or 1
    local total = State.optionCount or State.optionIndex or 1 -- State.optionIndex seems to be total count based on usage in EasyTrainers
    local countText = string.format("%d\\%d", current, total)
    local countWidth = ImGui.CalcTextSize(countText)
    -- Adjust width for font size scaling if needed, but CalcTextSize usually uses current font. 
    -- If custom font size is used, we need to scale.
    local currentFontSize = ImGui.GetFontSize()
    if secondHeader.FontSize ~= currentFontSize then
         countWidth = countWidth * (secondHeader.FontSize / currentFontSize)
    end

    local countX = math.floor(x + w - countWidth - 10.0) + 0.5
    ImGui.ImDrawListAddText(drawlist, secondHeader.FontSize, countX, versionY, secondHeader.TextColor, countText)
end

return SecondHeader
