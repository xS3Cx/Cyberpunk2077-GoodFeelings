local Prevention = require("Utils").Prevention
local Notification = require("UI").Notification

local logger = require("Core/Logger")

local WantedLevel = {}

WantedLevel.tickNeverWanted = { value = false }
WantedLevel.tickClearWanted = { value = false }

WantedLevel.heldWantedLevel = { enabled = false, value = 1, min = 1, max = 5 }

local wasSystemDisabled = false
local wasHeldActive = false

function WantedLevel.Tick()
    if WantedLevel.tickClearWanted.value then
       Prevention.SetPoliceDisabled(true)
        WantedLevel.heldWantedLevel.value = 0
        WantedLevel.heldWantedLevel.enabled = false
        WantedLevel.tickClearWanted.value = false
       Prevention.SetPoliceDisabled(false)
    end

    if WantedLevel.tickNeverWanted.value then
        if not wasSystemDisabled then
           Prevention.SetPoliceDisabled(true)
            wasSystemDisabled = true
        end
        WantedLevel.heldWantedLevel.value = 0
    else
        if wasSystemDisabled then
           Prevention.SetPoliceDisabled(false)
            wasSystemDisabled = false
        end
    end

if WantedLevel.heldWantedLevel.enabled and WantedLevel.heldWantedLevel.value >= 1 then
    if not wasHeldActive then
        wasHeldActive = true
    end

    if WantedLevel.tickNeverWanted.value then
        WantedLevel.tickNeverWanted.value = false
        Notification.Info("Disabled: Never Wanted")
    end

   Prevention.SetWantedLevel(WantedLevel.heldWantedLevel.value)
   Prevention.SetPoliceDisabled(false)
else
    if wasHeldActive then
        wasHeldActive = false
    end
end

end

function WantedLevel.SetNeverWantedLevel(enabled)
    if enabled and  WantedLevel.heldWantedLevel.enabled then
        WantedLevel.heldWantedLevel.enabled = false
        Notification.Info("Disabled: Hold Wanted Level")
    end
    WantedLevel.tickNeverWanted = enabled
end

function WantedLevel.SetHoldWantedLevel(enabled)
    if enabled and WantedLevel.tickNeverWanted then
        WantedLevel.tickNeverWanted = false
        Notification.Info("Disabled: Never Wanted")
    end
    WantedLevel.heldWantedLevel.enabled = enabled
end

return WantedLevel
