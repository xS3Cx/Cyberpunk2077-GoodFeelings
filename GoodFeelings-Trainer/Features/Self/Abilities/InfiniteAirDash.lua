-- Contributed by barhxr, refactored for GoodFeelings.
-- Allows unlimited mid-air dashes if perk & stamina conditions are met.

local InfiniteAirDash = {}
InfiniteAirDash.enabled = { value = false }

local Notification = require("UI").Notification

---@enum Direction
local Direction = {
    Back = -180.0,
    Right = -90.0,
    Forward =  0.0,
    Left =  90.0
}


local function setDodgeDirection(stateContext, scriptInterface, direction)
    stateContext:SetConditionFloatParameter("DodgeDirection", direction, true)
    scriptInterface.localBlackboard:SetFloat(
        GetAllBlackboardDefs().PlayerStateMachine.DodgeTimeStamp,
        EngineTime.ToFloat(GameInstance.GetSimTime())
    )
end

local function checkDirectionalDodge(stateContext, scriptInterface)
    if scriptInterface:IsActionJustPressed("DodgeForward") then
        setDodgeDirection(stateContext, scriptInterface, Direction.Forward)
        return true, Direction.Forward
    elseif scriptInterface:IsActionJustPressed("DodgeRight") then
        setDodgeDirection(stateContext, scriptInterface, Direction.Right)
        return true, Direction.Right
    elseif scriptInterface:IsActionJustPressed("DodgeLeft") then
        setDodgeDirection(stateContext, scriptInterface, Direction.Left)
        return true, Direction.Left
    elseif scriptInterface:IsActionJustPressed("DodgeBack") then
        setDodgeDirection(stateContext, scriptInterface, Direction.Back)
        return true, Direction.Back
    end
    return false, nil
end

local function checkTappedDodge(transition, stateContext, scriptInterface)
    local pressed = scriptInterface:IsActionJustTapped("Dodge") or scriptInterface:IsActionJustReleased("Dodge")
    if pressed then
        if transition:GetStaticBoolParameterDefault("dodgeWithNoMovementInput", false) then
            setDodgeDirection(stateContext, scriptInterface, Direction.Back)
            return true, Direction.Back
        else
            local dir = scriptInterface:GetInputHeading()
            setDodgeDirection(stateContext, scriptInterface, dir)
            return true, dir
        end
    end
    return false, nil
end

local function hasValidRequirements(scriptInterface)
    local hasAirDashPerk = PlayerDevelopmentSystem.GetInstance(scriptInterface.executionOwner)
        :IsNewPerkBought(scriptInterface.executionOwner, gamedataNewPerkType.Reflexes_Central_Milestone_3) == 3

    local stamina = GameInstance.GetStatPoolsSystem():GetStatPoolValue(
        scriptInterface.executionOwner:GetEntityID(),
        gamedataStatPoolType.Stamina,
        true
    )

    if not hasAirDashPerk then
        Notification.Error("Air Dash Perk (Level 3) is required for Infinite Air Dash.")
        return false
    end

    if stamina <= 0.0 then
        Notification.Error("Not enough stamina to air dash. (Tip: enable Infinite Stamina)")
        return false
    end

    return true
end

function InfiniteAirDash.HandleAirDash(transition, stateContext, scriptInterface, wrappedFunc)
    local tapped, tappedDir = checkTappedDodge(transition, stateContext, scriptInterface)
    local directional, dirDir = checkDirectionalDodge(stateContext, scriptInterface)

    local result = wrappedFunc(stateContext, scriptInterface)

    if not InfiniteAirDash.enabled.value then
        return result
    end

    local tooFast = transition:IsCurrentFallSpeedTooFastToEnter(stateContext, scriptInterface)

    local preconditionMet = (not result) and (tapped or directional)

    if preconditionMet then
        if not hasValidRequirements(scriptInterface) then
            return result
        end

        local disableParam = stateContext:GetPermanentBoolParameter("disableAirDash")
        local airDashDisabled = disableParam.valid and disableParam.value
        local dodgeEnabled = GameplaySettingsSystem.GetMovementDodgeEnabled(scriptInterface.executionOwner)
        local touchingGround = transition:IsTouchingGround(scriptInterface)

        local conditionsMet = (not touchingGround and not tooFast and not airDashDisabled and dodgeEnabled)

        if conditionsMet then
            result = true
        end
    end

    return result
end


return InfiniteAirDash
