local Logger = require("Core/Logger")

local Teleport = {}

function Teleport.TeleportEntity(entity, pos, facing)
    if not entity or not pos then return false end

    local targetPos = Vector4.new(pos.x, pos.y, pos.z, pos.w or 1.0)
    local rot = facing or entity:GetWorldOrientation():ToEulerAngles()

    Game.GetTeleportationFacility():Teleport(entity, targetPos, rot)
    --Logger.Log(string.format("Teleport: moved entity to (%.2f, %.2f, %.2f)", targetPos.x, targetPos.y, targetPos.z))
    return true
end

function Teleport.TeleportPlayerTo(x, y, z)
    local player = Game.GetPlayer()
    if not player then return false end

    local facing = player:GetWorldOrientation():ToEulerAngles()
    local pos = Vector4.new(x, y, z, 1.0)
    Teleport.TeleportEntity(player, pos, facing)
    -- Logger.Log(string.format("Teleport: player to (%.2f, %.2f, %.2f)", x, y, z))
    return true
end

function Teleport.DistanceBetween(posA, posB)
    if not posA or not posB then return math.huge end
    local dx, dy, dz = posA.x - posB.x, posA.y - posB.y, (posA.z or 0) - (posB.z or 0)
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function Teleport.DistanceFromPlayer(pos)
    local player = Game.GetPlayer()
    if not player or not pos then return math.huge end
    return Teleport.DistanceBetween(player:GetWorldPosition(), pos)
end

function Teleport.GetClosestPosition(list)
    local player = Game.GetPlayer()
    if not player or not list or #list == 0 then return nil end

    local playerPos = player:GetWorldPosition()
    local nearest, nearestDist = nil, math.huge

    for _, pos in ipairs(list) do
        local dist = Teleport.DistanceBetween(playerPos, pos)
        if dist < nearestDist then
            nearest, nearestDist = pos, dist
        end
    end
    return nearest, nearestDist
end

function Teleport.ToWaypoint()
    local ms = Game.GetMappinSystem()
    if not ms then return false end

    local id = ms:GetManuallyTrackedMappinID()
    if not id then return false end

    local m = ms:GetMappin(id)
    if not m or not m:IsPlayerTracked() then return false end

    return Teleport.TeleportEntity(Game.GetPlayer(), m:GetWorldPosition())
end

function Teleport.ToQuestMarker()
    local player = Game.GetPlayer()
    if not player then return false end

    local journal = Game.GetJournalManager()
    local tracked = journal and journal:GetTrackedEntry()
    if not tracked then return false end

    local mappinSys = Game.GetMappinSystem()
    if not mappinSys then return false end

    local hash = journal:GetEntryHash(tracked)
    local ok, positions = mappinSys:GetQuestMappinPositionsByObjective(hash)
    if not ok or not positions or #positions == 0 then return false end

    return Teleport.TeleportEntity(player, positions[1])
end

function Teleport.GetPlayerPosition()
    local player = Game.GetPlayer()
    return player and player:GetWorldPosition() or nil
end

function Teleport.GetForwardOffset(distance, yawOverride)
    local player = Game.GetPlayer()
    if not player then return nil end

    local pos = player:GetWorldPosition()
    local rot = player:GetWorldOrientation():ToEulerAngles()
    local yaw = yawOverride or rot.yaw

    local yawRad = math.rad(yaw)
    local xOffset = distance * -math.sin(yawRad)
    local yOffset = distance *  math.cos(yawRad)

    return Vector4.new(pos.x + xOffset, pos.y + yOffset, pos.z, 1.0)
end

function Teleport.GetRightOffset(distance, yawOverride)
    local player = Game.GetPlayer()
    if not player then return nil end

    local pos = player:GetWorldPosition()
    local rot = player:GetWorldOrientation():ToEulerAngles()
    local yaw = yawOverride or rot.yaw

    local yawRad = math.rad(yaw + 90)
    local xOffset = distance * -math.sin(yawRad)
    local yOffset = distance *  math.cos(yawRad)

    return Vector4.new(pos.x + xOffset, pos.y + yOffset, pos.z, 1.0)
end

-- Was messing with trying to get the nearest vendor and kind of just gave up and just used hard coded variables 
-- but I found a way to get the nearest drop point! :)
function Teleport.GetNearestDropPoint()
    local player = Game.GetPlayer()
    if not player then return nil end

    local playerPos = player:GetWorldPosition()
    local dropPointSystem = Game.GetScriptableSystemsContainer():Get("DropPointSystem")
    if not dropPointSystem then
        Logger.Log("Teleport: DropPointSystem not found")
        return nil
    end

    local mappins = dropPointSystem.mappins or {}
    local nearest, nearestDist = nil, math.huge

    for _, dp in ipairs(mappins) do
        if dp and dp:GetPosition() then
            local pos = dp:GetPosition()
            local dist = Teleport.DistanceBetween(playerPos, pos)
            if dist < nearestDist then
                nearest, nearestDist = dp, dist
            end
        end
    end

    if nearest then
        Logger.Log(string.format("Teleport: nearest drop point %.2f units away", nearestDist))
        return nearest, nearestDist
    end
    return nil
end

return Teleport
