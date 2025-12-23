local State = require("Controls/State")
local GameHUD = require("Core/cp2077-cet-kit/GameHUD")

local SubmenuManager = {}

SubmenuManager.menuStack   = {}
SubmenuManager.optionStack = {}
SubmenuManager.currentMenuIndex = -1

---@param submenu table { title = string, view = function }
function SubmenuManager.OpenSubmenu(submenu)
    if #SubmenuManager.optionStack > 0 then
        SubmenuManager.optionStack[#SubmenuManager.optionStack] = State.currentOption or 1
    end

    table.insert(SubmenuManager.menuStack, submenu)
    table.insert(SubmenuManager.optionStack, 1) 

    if #SubmenuManager.optionStack > 10 then
        table.remove(SubmenuManager.optionStack, 1)
    end

    SubmenuManager.currentMenuIndex = SubmenuManager.currentMenuIndex + 1
    State.currentOption = 1
    GameHUD.PlaySound("ui_menu_map_pin_on")
end

function SubmenuManager.CloseSubmenu()
    if #SubmenuManager.menuStack > 1 then
        table.remove(SubmenuManager.menuStack)
        table.remove(SubmenuManager.optionStack)

        SubmenuManager.currentMenuIndex = SubmenuManager.currentMenuIndex - 1

        local restoreIndex = SubmenuManager.optionStack[#SubmenuManager.optionStack]
        State.currentOption = restoreIndex or 1
    else
        State.currentOption = 1
    end
    GameHUD.PlaySound("ui_menu_close")
end

function SubmenuManager.GetBreadcrumbTitle()
    local stack = SubmenuManager.menuStack
    if #stack == 0 then return "" end
    return stack[#stack].title or ""
end

function SubmenuManager.IsAtRootMenu()
    return #SubmenuManager.menuStack <= 1
end

function SubmenuManager.GetCurrentView()
    local top = SubmenuManager.menuStack[#SubmenuManager.menuStack]
    return top and top.view
end

return SubmenuManager
