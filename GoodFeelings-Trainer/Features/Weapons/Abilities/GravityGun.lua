
local GravityGun = {}

local heldObject = nil
local grabDistance = 7.0

GravityGun.enabled = { value = false }

function GravityGun.Tick()
    if not GravityGun.enabled.value then
        return
    end

    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    local teleportSystem = Game.GetTeleportationFacility()
    if not player or not targetingSystem or not teleportSystem then return end

    local isAiming = player.isAiming
    if isAiming and not heldObject then
        local obj = targetingSystem:GetLookAtObject(player, true, false)
        if obj then
            heldObject = obj
        end
    end

    if heldObject then
        if isAiming then
            local camOrigin = player:GetWorldPosition()
            local lookAt = targetingSystem:GetLookAtPosition(player, true, false)

            local dir = {
                x = lookAt.x - camOrigin.x,
                y = lookAt.y - camOrigin.y,
                z = lookAt.z - camOrigin.z
            }
            local mag = math.sqrt(dir.x^2 + dir.y^2 + dir.z^2)
            dir.x, dir.y, dir.z = dir.x / mag, dir.y / mag, dir.z / mag

            local targetPos = Vector4.new(
                camOrigin.x + dir.x * grabDistance,
                camOrigin.y + dir.y * grabDistance,
                camOrigin.z + dir.z * grabDistance,
                1.0
            )
            
            teleportSystem:Teleport(heldObject, targetPos, EulerAngles.new(0, 0, 0)) 
            -- Not able to apply force to the vehicle or any entity that is above a certain limit of height for some reason they just freeze
        else
            heldObject = nil
        end
    end
end



return GravityGun
