local Logger = require("Core/Logger")
local Vehicle = require("Utils/Vehicle")

local VehicleSpawning = {}

local activeSpawns, pendingMounts, pendingDeletes = {}, {}, {}

local function DespawnEntity(des, entityID, tag)
    if des and entityID then
        des:DeleteEntity(entityID)
        Logger.Log("VehicleSpawning: despawned " .. (tag or "entity") .. " " .. tostring(entityID))
    end
end

function VehicleSpawning.RequestVehicle(tweakDBIDStr, spawnDist)
    local player = Game.GetPlayer()
    if not player then return false end

    local transform, spawnPos = Vehicle.GetSpawnTransform(player, spawnDist)
    local vehicleID = TweakDBID.new(tweakDBIDStr)

    Game.GetPreventionSpawnSystem():RequestUnitSpawn(vehicleID, transform)
    Logger.Log(string.format("VehicleSpawning: requested '%s' at (%.2f, %.2f, %.2f)",
        tweakDBIDStr, spawnPos.x, spawnPos.y, spawnPos.z))
    return true
end

local function CreateDynamicSpec(tweakDBIDStr, spawnPos) -- Probably should go into some utility tbh
    local spec = NewObject("DynamicEntitySpec")
    spec.recordID = TweakDBID.new(tweakDBIDStr)
    spec.position = spawnPos
    spec.orientation = Quaternion.new(0, 0, 0, 1)
    spec.persistState = false
    spec.persistSpawn = false
    spec.spawnInView = true
    spec.active = true
    spec.tags = { CName.new("GoodFeelings") }
    return spec
end

function VehicleSpawning.SpawnVehicle(tweakDBIDStr, spawnDist, mount, deleteLast)
    local player, des = Game.GetPlayer(), Game.GetDynamicEntitySystem()
    if not player or not des then return nil end

    if deleteLast then
        local currentVehicle = Vehicle.GetMountedVehicleSafe()
        if currentVehicle then
            table.insert(pendingDeletes, currentVehicle:GetEntityID())
            Logger.Log("VehicleSpawning: queued current vehicle for deletion " .. tostring(currentVehicle:GetEntityID()))
        end
    end

    local transform, spawnPos = Vehicle.GetSpawnTransform(player, spawnDist)
    local spec = CreateDynamicSpec(tweakDBIDStr, spawnPos)
    local entityID = des:CreateEntity(spec)

    if not entityID then
        Logger.Log("VehicleSpawning: failed to spawn " .. tostring(tweakDBIDStr))
        return nil
    end

    table.insert(activeSpawns, entityID)
    -- Logger.Log(string.format("VehicleSpawning: spawned '%s' at (%.2f, %.2f, %.2f)", tweakDBIDStr, spawnPos.x, spawnPos.y, spawnPos.z))

    if mount then
        pendingMounts[entityID] = { seat = "seat_front_left" }
        Logger.Log("VehicleSpawning: queued auto-mount for " .. tostring(entityID))
    end

    return entityID
end

function VehicleSpawning.HandlePending()
    if next(pendingMounts) == nil then return end

    local des, ws, player = Game.GetDynamicEntitySystem(), Game.GetWorkspotSystem(), Game.GetPlayer()
    if not (des and ws and player) then return end

    for entityID, opts in pairs(pendingMounts) do
        if des:IsSpawned(entityID) then
            pendingMounts[entityID] = nil
            local ent = des:GetEntity(entityID)
            if not Vehicle.IsValidVehicle(ent) then return end

            Vehicle.UnmountPlayer(true)
            Vehicle.MountPlayer(ent)
            Logger.Log("VehicleSpawning: mounted player into Vehicle" )

            for _, oldID in ipairs(pendingDeletes) do
                if oldID and oldID ~= entityID then
                    DespawnEntity(des, oldID, "previous vehicle")
                end
            end
            pendingDeletes = {}
        end
    end
end

function VehicleSpawning.DespawnLast()
    local des = Game.GetDynamicEntitySystem()
    local lastID = table.remove(activeSpawns)
    if lastID then
        DespawnEntity(des, lastID, "last vehicle")
        return true
    end
    Logger.Log("VehicleSpawning: no vehicle to despawn")
    return false
end

function VehicleSpawning.DespawnPrevious(currentID)
    local des = Game.GetDynamicEntitySystem()
    if not des or #activeSpawns < 2 then return end

    local prevID = activeSpawns[#activeSpawns - 1]
    if prevID and prevID ~= currentID then
        DespawnEntity(des, prevID, "previous vehicle")
    end
end

return VehicleSpawning
