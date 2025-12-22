local FPSTracker = {
    currentFPS = 0,
    displayFPS = 0,
    smoothingAlpha = 0.05, -- Stronger smoothing for stability
    refreshTimer = 0,
    refreshInterval = 0.5 -- Update display every 0.5 seconds
}

function FPSTracker.Update(deltaTime)
    if deltaTime > 0 then
        local rawFPS = 1 / deltaTime
        -- Exponential Moving Average (EMA) for stability
        FPSTracker.currentFPS = (FPSTracker.smoothingAlpha * rawFPS) + (1 - FPSTracker.smoothingAlpha) * FPSTracker.currentFPS
        
        -- Refresh timer for the displayed value
        FPSTracker.refreshTimer = FPSTracker.refreshTimer + deltaTime
        if FPSTracker.refreshTimer >= FPSTracker.refreshInterval then
            FPSTracker.displayFPS = FPSTracker.currentFPS
            FPSTracker.refreshTimer = 0
        end
    end
end

function FPSTracker.GetFPS()
    return FPSTracker.displayFPS
end

return FPSTracker
