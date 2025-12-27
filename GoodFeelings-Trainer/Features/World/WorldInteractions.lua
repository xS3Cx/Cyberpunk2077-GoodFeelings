local WorldInteractions = {}
local UI = require("UI")
local Notification = UI.Notification

local state = {
    firstAppName = nil,
    entHash = nil
}

WorldInteractions.toggleInstantKill = { value = false }
WorldInteractions.toggleClickDoor = { value = false }
WorldInteractions.toggleClickDevice = { value = false }

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

function WorldInteractions.HandleClickInteractions(action)
    if not WorldInteractions.toggleInstantKill.value and 
       not WorldInteractions.toggleClickDoor.value and 
       not WorldInteractions.toggleClickDevice.value then 
        return 
    end

    local name = Game.NameToString(action:GetName())
    local type = action:GetType(action).value

    -- Common LMB-related actions
    local isClick = (name == "RangedAttack" or name == "MeleeAttack" or name == "Attack" or 
                     name == "Choice_Apply" or name == "Use" or name == "LeftMouse" or
                     name == "Attack_Light" or name == "MeleeAttack_Light")

    if isClick and type == "BUTTON_PRESSED" then
        local player = Game.GetPlayer()
        local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
        if not target then return end

        local targetStr = target:ToString()
        
        -- NPC Kill
        if WorldInteractions.toggleInstantKill.value and (string.find(targetStr, "NPCPuppet") or string.find(targetStr, "Puppet")) then
            WorldInteractions.InstantKillTarget()
            return
        end

        -- Door Interaction
        if WorldInteractions.toggleClickDoor.value and (targetStr == "Door" or targetStr == "FakeDoor") then
            WorldInteractions.ToggleDoor()
            return
        end

        -- Device Interaction
        if WorldInteractions.toggleClickDevice.value and target:IsDevice() and targetStr ~= "Door" and targetStr ~= "FakeDoor" then
            WorldInteractions.ToggleDevices()
            return
        end
    end
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
    elseif targetType == "gameObject" then
        entity:ScheduleAppearanceChange("")
        Notification.Info(L("worldinteractions.entity.randomizing.msg"))
    else
        Notification.Info(targetType .. "\n" .. L("worldinteractions.notnpc.msg"))
    end
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

return WorldInteractions
