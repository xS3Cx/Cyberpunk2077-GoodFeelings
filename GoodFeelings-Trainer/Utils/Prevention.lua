local Logger = require("Core/Logger")

local Prevention = {}

function Prevention.SetWantedLevel(level)
    local player = Game.GetPlayer()
    if not player then
        return false
    end

    local ps = player:GetPreventionSystem()
    if not ps or not ps:IsSystemEnabled() then
        return false
    end

    local clamped = math.max(0, math.min(level, 5))
    local request = SetWantedLevel.new()
    request.wantedLevel = clamped
    ps:QueueRequest(request)

    return true
end

function Prevention.SetPoliceDisabled(disabled)
    local player = Game.GetPlayer()
    if not player then
        return false
    end

    local ps = player:GetPreventionSystem()
    if not ps then
        return false
    end

    local request = TogglePreventionSystem.new()
    request.sourceName = CName.new("GoodFeelings")
    request.isActive = not disabled
    ps:QueueRequest(request)
    ps:TogglePreventionSystem(not disabled)

    return true
end

return Prevention
