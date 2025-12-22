local Option = require("UI/Options/Option")
local Input = require("Core/Input")
local Bindings = require("Controls/Bindings")
local BindingsConfig = require("Config/BindingsConfig")
local Notification = require("UI/Elements/Notification")
local Language = require("Core/Language")
local State = require("Controls/State")

local BindButton = {}
-- Added: timeoutSeconds for max wait
local rebinding = { action=nil, heldKeys={}, heldBtns={}, startTime=nil, countdown=3, wasAnyDown=false, timeoutSeconds=10 }

local function formatBinding(b)
    if not b or ((not b.keys or #b.keys==0) and (not b.btns or #b.btns==0)) then
        return L("optionmanager.none")
    end
    local keyParts, btnParts = {}, {}
    if b.keys and #b.keys > 0 then
        for _,k in ipairs(b.keys) do table.insert(keyParts, Language.GetInputKey(k)) end
    end
    if b.btns and #b.btns > 0 then
        for _,bt in ipairs(b.btns) do table.insert(btnParts, Language.GetInputButton(bt)) end
    end
    local keyStr = (#keyParts>0) and table.concat(keyParts," + ") or nil
    local btnStr = (#btnParts>0) and table.concat(btnParts," + ") or nil
    if keyStr and btnStr then
        return keyStr.." | "..btnStr
    else
        return keyStr or btnStr or L("optionmanager.none")
    end
end

---@param label string
---@param action string Key from Bindings.Actions
---@param tip string|nil
---@return boolean clicked
function BindButton.Option(label, action, tip)
    local binding = Bindings.Actions[action] or {}
    local display = formatBinding(binding)

    
    if rebinding.action == action then
        local elapsed = os.clock() - (rebinding.startTime or 0)
        if elapsed < rebinding.countdown then
            local remaining = math.ceil(rebinding.countdown - elapsed)
            display = "Binding in: "..tostring(remaining)
        else
            local timeoutLeft = rebinding.timeoutSeconds - math.floor(elapsed - rebinding.countdown)
            if timeoutLeft > 0 then
                display = "Press any key to bind ("..timeoutLeft..")"
            else
                -- I don't think I've ever added a time out timer in my projects this is definitely a first I feel like a true brogrammer
                Notification.Warning("Key binding timed out. Restored original binding for "..label, 3)
                State.bindingKey = false
                rebinding.action, rebinding.heldKeys, rebinding.heldBtns, rebinding.startTime, rebinding.wasAnyDown = nil, {}, {}, nil, false
            end
        end
    end

    local clicked,pos = Option.Option(label,"",display,tip)
    if not pos then return false end

    if clicked then
        rebinding.action = action
        rebinding.heldKeys, rebinding.heldBtns = {}, {}
        rebinding.startTime = os.clock()
        rebinding.wasAnyDown = false
        State.bindingKey = true
        -- We don't want the option to be clicked and bind it with the key that was clicked so this grace is here
        Notification.Info("Get ready to bind "..label.." in 3 seconds",2)
    end

    if rebinding.action == action then
        local elapsed = os.clock() - (rebinding.startTime or 0)
        if elapsed >= rebinding.countdown then
            if Input.IsKeyDown(Input.VK.ESCAPE) then -- If you change your mind and don't need to bind the key just click escape Very easy
                Notification.Warning("Key binding cancelled. Restored original binding for "..label, 3)
                State.bindingKey = false
                rebinding.action, rebinding.heldKeys, rebinding.heldBtns, rebinding.startTime, rebinding.wasAnyDown = nil, {}, {}, nil, false
                return false
            end

            for _,vk in pairs(Input.VK) do
                if Input.IsKeyDown(vk) then rebinding.heldKeys[vk] = true end
            end
            for _,gp in pairs(Input.GP) do
                if Input.IsButtonDown(gp) then rebinding.heldBtns[gp] = true end
            end

            local anyDown=false
            for vk in pairs(rebinding.heldKeys) do if Input.IsKeyDown(vk) then anyDown=true break end end
            for gp in pairs(rebinding.heldBtns) do if Input.IsButtonDown(gp) then anyDown=true break end end

            -- Release = confirm bind
            if rebinding.wasAnyDown and not anyDown then
                if next(rebinding.heldKeys) then
                    local combo = {}
                    for vk in pairs(rebinding.heldKeys) do table.insert(combo,vk) end
                    table.sort(combo)
                    Bindings.Rebind(action,{ keys=combo })
                    Notification.Success("Bound "..label.." to "..formatBinding({keys=combo}),3)
                end
                if next(rebinding.heldBtns) then
                    local combo = {}
                    for gp in pairs(rebinding.heldBtns) do table.insert(combo,gp) end
                    table.sort(combo)
                    Bindings.Rebind(action,{ btns=combo })
                    Notification.Success("Bound "..label.." to "..formatBinding({btns=combo}),3)
                end

                BindingsConfig.Save()
                State.bindingKey = false
                rebinding.action, rebinding.heldKeys, rebinding.heldBtns, rebinding.startTime, rebinding.wasAnyDown = nil, {}, {}, nil, false
            end
            rebinding.wasAnyDown = anyDown
        end
    end

    return clicked
end

return BindButton
