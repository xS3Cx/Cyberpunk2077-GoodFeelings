local AdvancedMobility = {}

AdvancedMobility.toggleDoubleJump = { value = false }
AdvancedMobility.toggleAirHover   = { value = false }
AdvancedMobility.toggleChargeJump = { value = false }

local state = {
    doubleJumpApplied = false,
    airHoverApplied = false,
    chargeJumpApplied = false
}


local function HandleStatToggle(toggle, statName, appliedFlag, label)
    local stats = Game.GetStatsSystem()
    local player = Game.GetPlayer()
    local entityID = player:GetEntityID()

    local function modify(value)
        stats:AddModifier(entityID, RPGManager.CreateStatModifier(statName, gameStatModifierType.Additive, value))
    end

    if toggle.value and not state[appliedFlag] then
        modify(1.0)
        state[appliedFlag] = true
    elseif not toggle.value and state[appliedFlag] then
        modify(-1.0)
        state[appliedFlag] = false
    end
end

function AdvancedMobility.Tick()
    HandleStatToggle(AdvancedMobility.toggleDoubleJump, "HasDoubleJump", "doubleJumpApplied", "Double Jump")
    HandleStatToggle(AdvancedMobility.toggleAirHover,   "HasAirHover",   "airHoverApplied",   "Air Hover")
    HandleStatToggle(AdvancedMobility.toggleChargeJump, "HasChargeJump", "chargeJumpApplied", "Charge Jump")
end

return AdvancedMobility
