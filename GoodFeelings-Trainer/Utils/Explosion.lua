local Logger = require("Core/Logger")

local Explosion = {}

function Explosion.SpawnVFX(pos, orientation, effectPath)
    if not pos or not effectPath then return false end

    local t = WorldTransform.new()
    t:SetPosition(Vector4.new(pos.x, pos.y, pos.z, 1.0))
    t:SetOrientation(orientation or Game.GetPlayer():GetWorldOrientation())

    local fxRes = gameFxResource.new({ effect = effectPath })
    local fxSystem = Game.GetFxSystem()
    if fxSystem then
        fxSystem:SpawnEffect(fxRes, t, false)
        return true
    end
    Logger.Log("Explosion: FxSystem not available")
    return false
end

function Explosion.SpawnAtPos(pos, attackName, instigator, source, weapon, duration)
    if not pos then return false end

    local attackSystem = GetSingleton("gameAttack_GameEffect")
    if not attackSystem then
        Logger.Log("Explosion: gameAttack_GameEffect system not available")
        return false
    end

    local record = TweakDB:GetRecord(attackName or "Attacks.LegendaryFragGrenade")
    if not record then
        Logger.Log("Explosion: Invalid attack record " .. tostring(attackName))
        return false
    end

    local player = Game.GetPlayer()
    local inst = instigator or player
    local src  = source or player
    local weap = weapon or (player and player:GetActiveWeapon() or nil)

    attackSystem:SpawnExplosionAttack(record, weap, inst, src, pos, duration or 3.0)

   -- Logger.Log(string.format("Explosion: Spawned %s at (%.2f, %.2f, %.2f)", attackName or "Attacks.LegendaryFragGrenade", pos.x, pos.y, pos.z))
    return true
end

function Explosion.AtLookAt(attackName, duration)
    local player = Game.GetPlayer()
    local targeting = Game.GetTargetingSystem()
    if not (player and targeting) then return false end

    local pos = targeting:GetLookAtPosition(player, true, false)
    return Explosion.SpawnAtPos(pos, attackName, player, player, nil, duration)
end

return Explosion
