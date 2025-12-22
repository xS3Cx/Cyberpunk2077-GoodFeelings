local SmartBlade = {}

SmartBlade.enabled = { value = false }


-- I'm not sure why no one has ever made this or I couldn't just find a mod
function SmartBlade.Tick(self)
    if not SmartBlade.enabled.value then
        return
    end
    local player = Game.GetPlayer()
    if not player then return end

    local playerPos = player:GetWorldPosition()
    local rot = player:GetWorldOrientation():ToEulerAngles()

    local returnPos = Vector4.new(playerPos.x, playerPos.y, playerPos.z - 0.5, 1.0)
    Game.GetTeleportationFacility():Teleport(self, returnPos, rot)
end

return SmartBlade
