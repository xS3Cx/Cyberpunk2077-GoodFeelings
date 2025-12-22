local InfiniteJumps = {}

InfiniteJumps.enabled = { value = false }

local wasApplied = false
local Notification = require("UI").Notification

-- All multi-jump flats we want to patch
local multiJumpFlats = {
    { flat = "playerStateMachineBaseLocomotion.locomotionAir.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineBaseLocomotionTakedown.grappleAir.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineBaseLocomotionTier3.locomotionAirTier3.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineBaseLocomotionTier4.locomotionAirTier4.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineBaseLocomotionTier5.locomotionAirTier5.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.airHover.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.airThrusters.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.bodySlamJump.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.chargeJump.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.coolExitJump.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.dodgeAir.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.fall.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.hoverJump.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.doubleJump.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.jump.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.ladderCrouch.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.ladderJump.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.slideFall.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.superheroFall.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotion.unsecureFootingFall.numberOfMultiJumps", def = 1 },
    { flat = "playerStateMachineLocomotionTakedown.grappleFall.numberOfMultiJumps", def = 1 }
}

local newMultiJumps = 5000

local function hasReinforcedTendons()
    local player = Game.GetPlayer()
    if not player then return false end

    local ssc = Game.GetScriptableSystemsContainer()
    local ts = Game.GetTransactionSystem()
    local es = ssc:Get("EquipmentSystem")
    local pd = es:GetPlayerData(player)

    local id = pd:GetItemInEquipSlot(gamedataEquipmentArea["LegsCW"], 0)
    if id.tdbid.hash == 0 then
        Notification.Warning("No cyberware in Legs slot.\nEquip Reinforced Tendons first.")
        return false
    end

    local itemData = ts:GetItemData(player, id)
    local twid = TDBID.ToStringDEBUG(itemData:GetID().id)
    if twid and string.find(twid, "BoostedTendons") then
        return true
    end

    Notification.Error("Reinforced Tendons not detected.\nEquip them before enabling Infinite Jumps.")
    return false
end

function InfiniteJumps.Tick()
    if InfiniteJumps.enabled.value then
        if not wasApplied then
            if hasReinforcedTendons() then
                for _, entry in ipairs(multiJumpFlats) do
                    TweakDB:SetFlat(entry.flat, newMultiJumps)
                end
                Notification.Success("Infinite Jumps Enabled.\nSave & reload to apply.", 6.0)
                wasApplied = true
            else
                InfiniteJumps.enabled.value = false -- auto-disable toggle if requirements not met
            end
        end
    elseif wasApplied then
        for _, entry in ipairs(multiJumpFlats) do
            TweakDB:SetFlat(entry.flat, entry.def)
        end
         Notification.Info("Infinite Jumps Disabled.\nSave & reload to restore defaults.", 6.0)
        wasApplied = false
    end
end

return InfiniteJumps
