local WorldInteractions = {}
local UI = require("UI")
local Notification = UI.Notification
local Input = require("Core/Input")
local Bindings = require("Controls/Bindings")

local state = {
    firstAppName = nil,
    entHash = nil
}

WorldInteractions.toggleInstantKill = { value = false }
WorldInteractions.toggleClickDoor = { value = false }
WorldInteractions.toggleClickRemoveFakeDoor = { value = false }
WorldInteractions.toggleClickDevice = { value = false }
WorldInteractions.toggleClickRandomizeAppearance = { value = false }
WorldInteractions.toggleClickRemoteLaunch = { value = false }
WorldInteractions.toggleDebugObject = { value = false }
WorldInteractions.wasInteractDown = false

function WorldInteractions.InstantKillTarget()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if not target then
        return
    end

    local targetStr = target:ToString()
    if string.find(targetStr, "NPCPuppet") or string.find(targetStr, "Puppet") then
        Game.GetStatusEffectSystem():ApplyStatusEffect(target:GetEntityID(), "BaseStatusEffect.ForceKill")
    end
end

function WorldInteractions.Tick()
    if not WorldInteractions.toggleInstantKill.value and 
       not WorldInteractions.toggleClickDoor.value and 
       not WorldInteractions.toggleClickRemoveFakeDoor.value and
       not WorldInteractions.toggleClickDevice.value and
       not WorldInteractions.toggleClickRandomizeAppearance.value and
       not WorldInteractions.toggleClickRemoteLaunch.value then 
        return 
    end

    local isDown = Bindings.IsActionDown("WORLD_INTERACT")

    if isDown and not WorldInteractions.wasInteractDown then
        local player = Game.GetPlayer()
        local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
        
        if target then
            local targetStr = target:ToString()
            
            -- NPC Kill
            if WorldInteractions.toggleInstantKill.value and (string.find(targetStr, "NPCPuppet") or string.find(targetStr, "Puppet")) then
                WorldInteractions.InstantKillTarget()
            -- Door Interaction (Toggle/Unlock)
            elseif WorldInteractions.toggleClickDoor.value and (targetStr == "Door" or targetStr == "FakeDoor") then
                WorldInteractions.ToggleDoor()
            -- Open Fake Doors (Remove)
            elseif WorldInteractions.toggleClickRemoveFakeDoor.value and (targetStr == "Door" or targetStr == "FakeDoor") then
                WorldInteractions.RemoveFakeDoor()
            -- Device Interaction
            elseif WorldInteractions.toggleClickDevice.value and target:IsDevice() and targetStr ~= "Door" and targetStr ~= "FakeDoor" then
                WorldInteractions.ToggleDevices()
            -- Remote Launch Vehicle
            elseif WorldInteractions.toggleClickRemoteLaunch.value then
                if string.find(string.lower(targetStr), "vehicle") then
                    WorldInteractions.LaunchVehicle()
                end
            -- Random Appearance On Click
            elseif WorldInteractions.toggleClickRandomizeAppearance.value then
                WorldInteractions.RandomizeAppearance()
            end
        end
    end

    WorldInteractions.wasInteractDown = isDown
end

function WorldInteractions.ToggleDoor()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if not target then
        Notification.Info(L("worldinteractions.notarget.msg"))
        return
    end

    local targetStr = target:ToString()
    if targetStr == "Door" then
        local doorPS = target:GetDevicePS()
        local doorProps = doorPS.doorProperties
        local isVisuallyOpened = target.isVisuallyOpened

        if tostring(doorProps.doorType.value) == "AUTOMATIC" then
            doorPS:SetCloseItself(true)
        end

        if isVisuallyOpened then
            Notification.Info(L("worldinteractions.door.closing.msg"))
            target:CloseDoor()
        else
            Notification.Info(L("worldinteractions.door.opening.msg"))
            target:OpenDoor()
            doorPS:ExecuteForceOpen(player)
        end
    elseif targetStr == "FakeDoor" then
        Notification.Info(L("worldinteractions.fakedoor.msg"))
    else
        Notification.Info(L("worldinteractions.notdoor.msg"))
    end
end

function WorldInteractions.DestroyDoor()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if not target then
        Notification.Info(L("worldinteractions.notarget.msg"))
        return
    end

    local targetStr = target:ToString()
    if targetStr == "Door" or targetStr == "FakeDoor" then
        target:Dispose()
        Notification.Info(L("worldinteractions.door.destroyed.msg"))
    else
        Notification.Info(L("worldinteractions.notdoor.msg"))
    end
end

function WorldInteractions.RemoveFakeDoor()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if not target then
        Notification.Info(L("worldinteractions.notarget.msg"))
        return
    end

    local targetStr = target:ToString()
    if targetStr == "Door" or targetStr == "FakeDoor" then
        target:Dispose()
        Notification.Info(L("worldinteractions.fakedoor.removed.msg"))
    else
        Notification.Info(L("worldinteractions.notdoor.msg"))
    end
end

function WorldInteractions.LaunchVehicle()
    local VehicleJump = require("Features/Vehicles/VehicleJump")
    VehicleJump.LaunchTargeted()
end

function WorldInteractions.RandomizeAppearance()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if not target then
        Notification.Info(L("worldinteractions.notarget.msg"))
        return
    end

    local entity = Game.FindEntityByID(target:GetEntityID())
    local targetType = target:ToString()

    if targetType == "NPCPuppet" then
        local displayName = Game.GetLocalizedTextByKey(TDB.GetLocKey(target:GetRecordID() .. ".displayName"))
        if displayName == "" then displayName = "Generic NPC" end

        local currentHash = tostring(target:GetEntityID():GetHash())

        if state.entHash ~= currentHash then
            state.firstAppName = tostring(entity:GetCurrentAppearanceName().value)
            state.entHash = currentHash
            entity:ScheduleAppearanceChange("")
            Notification.Info(string.gsub(L("worldinteractions.npc.randomized.msg"), "{name}", displayName))
        else
            if tostring(entity:GetCurrentAppearanceName().value) == "" then
                entity:ScheduleAppearanceChange(state.firstAppName)
            else
                entity:ScheduleAppearanceChange("")
            end
            Notification.Info(string.gsub(L("worldinteractions.npc.randomized.msg"), "{name}", displayName))
        end
    elseif entity then
        local name = "Object"
        local targetType = target:ToString()
        
        -- Try to get a better name if possible
        if target:IsDevice() then
            name = target:ToString()
        elseif string.find(targetType, "Vehicle") then
            name = "Vehicle"
        end

        entity:ScheduleAppearanceChange("")
        local msg = L("worldinteractions.entity.randomizing.msg")
        msg = string.gsub(msg, "{name}", name)
        msg = string.gsub(msg, "{type}", targetType)
        Notification.Info(msg)
    else
        Notification.Info(L("worldinteractions.notarget.msg"))
    end
end

function WorldInteractions.LaunchVehicle()
    local VehicleJump = require("Features/Vehicles/VehicleJump")
    VehicleJump.LaunchTargeted()
end

function WorldInteractions.ToggleDevices()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if not target then
        Notification.Info(L("worldinteractions.notarget.msg"))
        return
    end

    local targetStr = target:ToString()
    if target:IsDevice() then
        if targetStr == 'Door' or targetStr == 'FakeDoor' then
            Notification.Info(L("worldinteractions.device.isdoor.msg"))
        elseif targetStr ~= 'gameObject' then
            local ps = target:GetDevicePS()
            local toggle = ps:ActionToggleON()
            Game.GetPersistencySystem():QueuePSDeviceEvent(toggle)
            Notification.Info(string.gsub(L("worldinteractions.device.toggled.msg"), "{name}", targetStr))
        else
            Notification.Info(L("worldinteractions.device.canttoggle.msg"))
        end
    else
        Notification.Info(L("worldinteractions.device.notdevice.msg"))
    end
end

function WorldInteractions.DrawDebug()
    if not WorldInteractions or not WorldInteractions.toggleDebugObject or not WorldInteractions.toggleDebugObject.value then return end

    local screenW, screenH = GetDisplayResolution()
    if not screenW or screenW <= 0 then
        screenW = ImGui.GetIO().DisplaySize.x
        screenH = ImGui.GetIO().DisplaySize.y
    end
    if not screenW or screenW <= 0 then return end
    
    local centerX, centerY = screenW / 2, screenH / 2
    local dl = ImGui.GetForegroundDrawList()
    
    -- Colors (ABGR)
    local cyan = 0xFFFFFF00
    local red = 0xFF0000FF
    local white = 0xFFFFFFFF
    local bg = 0xE0040404
    local border = 0x80FFFFFF

    -- Crosshair
    local len = 20
    local thick = 2.0
    ImGui.ImDrawListAddLine(dl, centerX - len, centerY, centerX + len, centerY, cyan, thick)
    ImGui.ImDrawListAddLine(dl, centerX, centerY - len, centerX, centerY + len, cyan, thick)

    -- Object Info
    local player = Game.GetPlayer()
    if not player then return end
    
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
    local infoText = ""
    local headerText = "NO TARGET"
    local headerColor = red
    local hasTarget = false

    if target then
        hasTarget = true
        headerText = "DEBUG OBJECT"
        headerColor = cyan
        
        local targetType = "Unknown"
        local properName = "Unknown"
        pcall(function() targetType = target:ToString() end)
        
        -- Try to get a proper localized name (for NPCs and some objects)
        pcall(function()
            if target.GetRecordID then
                local recordID = target:GetRecordID()
                if recordID then
                    properName = Game.GetLocalizedTextByKey(TDB.GetLocKey(recordID .. ".displayName"))
                    if properName == "" then properName = "No Localized Name" end
                end
            end
        end)
        
        local entityID = target:GetEntityID()
        local hashId = "Unknown"
        if entityID then
            pcall(function() hashId = tostring(entityID:GetHash()) end)
        end
        
        infoText = string.format("Name: %s\nType: %s\nHash: %s", properName, targetType, hashId)
        
        local isDevice = false
        pcall(function() isDevice = target:IsDevice() end)
        if isDevice then
            infoText = infoText .. "\nDevice: Yes"
        end
    end

    -- Draw Info Box manually (Direct rendering, no ImGui window)
    local pad = 10
    local fontSize = ImGui.GetFontSize() or 18
    local headerW, headerH = ImGui.CalcTextSize(headerText)
    local bodyW, bodyH = ImGui.CalcTextSize(infoText)
    
    local boxW = math.max(headerW, bodyW) + pad * 2
    local boxH = (hasTarget and (headerH + 10 + bodyH) or headerH) + pad * 2
    
    local boxX = centerX + 30
    local boxY = centerY + 30
    
    -- Background & Border
    ImGui.ImDrawListAddRectFilled(dl, boxX, boxY, boxX + boxW, boxY + boxH, bg, 5.0)
    ImGui.ImDrawListAddRect(dl, boxX, boxY, boxX + boxW, boxY + boxH, headerColor, 5.0, 0, 1.5)
    
    -- Text Rendering
    ImGui.ImDrawListAddText(dl, fontSize, boxX + pad, boxY + pad, headerColor, headerText)
    if hasTarget then
        -- Separator line
        local sepY = boxY + pad + headerH + 4
        ImGui.ImDrawListAddLine(dl, boxX + pad, sepY, boxX + boxW - pad, sepY, 0x40FFFFFF, 1.0)
        -- Body details
        ImGui.ImDrawListAddText(dl, fontSize, boxX + pad, boxY + pad + headerH + 10, white, infoText)
    end
end

return WorldInteractions
