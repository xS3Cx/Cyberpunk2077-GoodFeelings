local SuperSpeed = {}

SuperSpeed.enabled = { value = false }

local applied = false

function SuperSpeed.Tick()
    local timeSystem = Game.GetTimeSystem()
    local isActive = timeSystem:IsTimeDilationActive()

    if SuperSpeed.enabled.value and not applied then
        if isActive then
            timeSystem:SetTimeDilation(CName.new(), 1.0)
        end
        timeSystem:SetTimeDilationOnLocalPlayerZero(CName.new(), 3.0, false)
        applied = true

    elseif not SuperSpeed.enabled.value and applied then
        timeSystem:UnsetTimeDilationOnLocalPlayerZero(CName.new())
        applied = false
    end
end

return SuperSpeed
