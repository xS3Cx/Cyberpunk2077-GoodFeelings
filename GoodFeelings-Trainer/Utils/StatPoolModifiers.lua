local Logger = require("Core/Logger")

local StatPoolModifiers = {}

function StatPoolModifiers.Get(poolType)
    local player = Game.GetPlayer()
    local poolSystem = Game.GetStatPoolsSystem()
    if not player or not poolSystem then
        Logger.Log("StatPoolModifiers: Get failed (no player or pool system)")
        return nil
    end

    local entityID = player:GetEntityID()
    local value = poolSystem:GetStatPoolValue(entityID, poolType, true)
    return value
end

function StatPoolModifiers.Set(poolType, value)
    local player = Game.GetPlayer()
    local poolSystem = Game.GetStatPoolsSystem()
    if not player or not poolSystem then
        Logger.Log("StatPoolModifiers: Set failed (no player or pool system)")
        return false
    end

    local entityID = player:GetEntityID()
    poolSystem:RequestSettingStatPoolValue(entityID, poolType, value, player, true, true)

    Logger.Log(string.format("StatPoolModifiers: set pool %s to %.2f", tostring(poolType), value))
    return true
end

return StatPoolModifiers
