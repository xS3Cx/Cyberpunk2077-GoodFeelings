local Logger = require("Core/Logger")
local Draw   = require("UI")

local PlayerDevelopment = {}

local function GetPlayerData()
    local player = Game.GetPlayer()
    if not player then
        Logger.Log("PlayerDevelopment: No player found")
        return nil
    end

    local data = PlayerDevelopmentSystem.GetData(player)
    if not data then
        Logger.Log("PlayerDevelopment: No PlayerDevelopmentData found")
    end
    return data
end

function PlayerDevelopment.GetLevel(profType)
    local data = GetPlayerData()
    return data and data:GetProficiencyLevel(profType) or nil
end

function PlayerDevelopment.SetLevel(profType, level)
    local data = GetPlayerData()
    if not data then return false end
    data:SetLevel(profType, level, telemetryLevelGainReason.Gameplay, true)
    Logger.Log(string.format("PlayerDevelopment: Set level %s = %d", tostring(profType), level))
    return true
end

function PlayerDevelopment.GetMaxLevel(profType)
    local data = GetPlayerData()
    return data and data:GetProficiencyAbsoluteMaxLevel(profType) or 60
end

function PlayerDevelopment.AddXP(profType, amount)
    local data = GetPlayerData()
    if not data then return false end
    data:AddExperience(amount, profType, telemetryLevelGainReason.Gameplay, false)
    Logger.Log(string.format("PlayerDevelopment: Added %d XP to %s", amount, tostring(profType)))
    return true
end

function PlayerDevelopment.GetAttribute(statType)
    local data = GetPlayerData()
    return data and data:GetAttributeValue(statType) or nil
end

function PlayerDevelopment.SetAttribute(statType, value)
    local data = GetPlayerData()
    if not data then return false end
    data:SetAttribute(statType, value)
    Logger.Log(string.format("PlayerDevelopment: Set attribute %s = %.2f", tostring(statType), value))
    return true
end

function PlayerDevelopment.AddDevPoints(pointType, amount)
    local data = GetPlayerData()
    if not data then return false end
    data:AddDevelopmentPoints(amount, pointType)
    Logger.Log(string.format("PlayerDevelopment: Added %d %s points", amount, tostring(pointType)))
    return true
end

function PlayerDevelopment.GetDevPoints(pointType)
    local data = GetPlayerData()
    return data and data:GetDevPoints(pointType) or 0
end


function PlayerDevelopment.HasPerk(perkType)
    local data = GetPlayerData()
    return data and (data:IsNewPerkBought(perkType) > 0) or false
end

function PlayerDevelopment.IsPerkUnlocked(perkType)
    local data = GetPlayerData()
    return data and data:IsNewPerkUnlocked(perkType) or false
end

function PlayerDevelopment.BuyPerk(perkType, force)
    local data = GetPlayerData()
    if not data then return false end
    return data:BuyNewPerk(perkType, force or false)
end

function PlayerDevelopment.GetPerkMaxLevel(perkType)
    local data = GetPlayerData()
    return data and data:GetNewPerkMaxLevel(perkType) or 1
end

function PlayerDevelopment.AddPerk(perkType, force)
    local data = GetPlayerData()
    if not data then return false end
    return data:BuyNewPerk(perkType, force or true)
end

function PlayerDevelopment.RemovePerk(perkType)
    local data = GetPlayerData()
    if not data then return false end
    local sold, level = data:ForceSellNewPerk(perkType)
    return sold, level
end

function PlayerDevelopment.GetPerkLevel(perkType)
    local data = GetPlayerData()
    if not data then return 0 end
    return data:IsNewPerkBought(perkType) or 0
end


function PlayerDevelopment.UnlockPerksForAttribute(attributeType)
    local data = GetPlayerData()
    if not data then return false end
    data:UnlockFreeNewPerks(attributeType)
    Logger.Log("PlayerDevelopment: Unlocked perks for attribute " .. tostring(attributeType))
    return true
end

return PlayerDevelopment
