local Teleport = require("Utils/Teleport")
local Notification = require("UI").Notification
local AutoTeleport = {}

AutoTeleport.toggleAutoWaypoint = { value = false }
AutoTeleport.toggleAutoQuest = { value = false }

local tickTimer = 0
function AutoTeleport.Tick(delta)
    tickTimer = tickTimer + delta
    if tickTimer < 1.0 then return end  
    tickTimer = 0

    if AutoTeleport.toggleAutoWaypoint.value then
        local success = Teleport.ToWaypoint()
        if success then Notification.Info("Auto-teleported to waypoint.") end
    end

    if AutoTeleport.toggleAutoQuest.value then
        local success = Teleport.ToQuestMarker()
        if success then Notification.Info("Auto-teleported to quest objective.") end
    end
end

return AutoTeleport
