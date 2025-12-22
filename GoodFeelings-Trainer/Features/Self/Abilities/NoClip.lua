local Input = require("Core/Input")
local Utils = require("Utils")
local StatusEffect = Utils.StatusEffect
local Teleport = Utils.Teleport
local logger = require("Core/Logger")
local Noclip = {}
Noclip.toggleNoClip = { value = false }

local yaw = 0
local moveSpeed = 1.5
local boostMult = 2.5
local slowMult = 0.7
local deadzone = 7849

local noclipRestrictions = {
    "GameplayRestriction.NoZooming",
    "GameplayRestriction.NoMovement",
    "GameplayRestriction.NoCombat",
    "GameplayRestriction.InDaClub",
    "GameplayRestriction.NoJump",
    "GameplayRestriction.NoFallDamage",
}

local noclipWasOn = false

local function ApplyNoclipRestrictions(enable)
    for _, eff in ipairs(noclipRestrictions) do
        StatusEffect.Set(eff, enable)
    end
end

local function RemoveRestriction()
    if not Noclip.toggleNoClip.value and noclipWasOn then
        ApplyNoclipRestrictions(false)
        noclipWasOn = false
    end
end

function Noclip.HandleMouseLook(action)
    local actionName = Game.NameToString(action:GetName(action))
    if actionName ~= "CameraMouseX" then return end

    local x = action:GetValue(action)
    local sens = Game.GetSettingsSystem():GetVar("/controls/fppcameramouse", "FPP_MouseX"):GetValue() / 2.9
    yaw = yaw - (x / 35) * sens
end

function Noclip.Tick()
    RemoveRestriction()
    if not Noclip.toggleNoClip.value then return end

    local player = Game.GetPlayer()
    if not player then return end

    -- initialize yaw once when toggling on
    if not noclipWasOn then
        local rot = player:GetWorldOrientation():ToEulerAngles()
        yaw = rot.yaw
    end

    ApplyNoclipRestrictions(true)
    noclipWasOn = true

    -- input axes
    local lx = Input.GetGamepadAxis(Input.GP_AXIS.LEFT_X)
    local ly = -Input.GetGamepadAxis(Input.GP_AXIS.LEFT_Y)
    local rx = Input.GetGamepadAxis(Input.GP_AXIS.RIGHT_X)

    if math.abs(lx) < deadzone then lx = 0 end
    if math.abs(ly) < deadzone then ly = 0 end

    if math.abs(rx) > deadzone then
        local sens = Game.GetSettingsSystem():GetVar("/controls/fppcamerapad", "FPP_PadX"):GetValue() / 10
        yaw = yaw - (rx / 32768) * 1.7 * sens
    end

    -- button inputs
    local goUp = Input.IsKeyDown(Input.VK.SPACE) or Input.IsButtonDown(Input.GP.RIGHT_BUMPER)
    local goDown = Input.IsKeyDown(Input.VK.CTRL)  or Input.IsButtonDown(Input.GP.LEFT_BUMPER)
    local speedBoost = Input.IsKeyDown(Input.VK.SHIFT) or Input.IsButtonDown(Input.GP.LEFT_STICK)

    local forward = Input.IsKeyDown(Input.VK.W) or ly < 0
    local backward = Input.IsKeyDown(Input.VK.S) or ly > 0
    local strafeL = Input.IsKeyDown(Input.VK.A) or lx < 0
    local strafeR = Input.IsKeyDown(Input.VK.D) or lx > 0

    local frameSpeed = moveSpeed * (speedBoost and boostMult or slowMult)

    local pos = player:GetWorldPosition()
    if forward then
        local fwd = Teleport.GetForwardOffset(frameSpeed, yaw)
        logger.Log("fwd: " .. tostring(fwd))
        pos.x, pos.y = fwd.x, fwd.y
    end
    if backward then
        local back = Teleport.GetForwardOffset(-frameSpeed, yaw)
        pos.x, pos.y = back.x, back.y
    end
    if strafeR then
        local right = Teleport.GetRightOffset(-frameSpeed, yaw)
        pos.x, pos.y = right.x, right.y
    end
    if strafeL then
        local left = Teleport.GetRightOffset(frameSpeed, yaw)
        pos.x, pos.y = left.x, left.y
    end

    if goUp then pos.z = pos.z + frameSpeed end
    if goDown then pos.z = pos.z - frameSpeed end

    if yaw < 0 then yaw = yaw + 360 end
    if yaw > 360 then yaw = yaw - 360 end

    local rot = player:GetWorldOrientation():ToEulerAngles()
    rot.yaw = yaw
    Teleport.TeleportEntity(player, Vector4.new(pos.x, pos.y, pos.z, 1.0), rot)
end

return Noclip
