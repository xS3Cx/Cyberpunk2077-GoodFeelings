local WorldTime = {}
local Logger = require("Core/Logger")
local Notification = require("UI").Notification

local timeSystem = Game.GetTimeSystem()

WorldTime.daySpeedMultiplier = { value = 2.0, min = 1.0, max = 10.0, step = 0.5, enabled = false }
WorldTime.nightSpeedMultiplier = { value = 2.0, min = 1.0, max = 10.0, step = 0.5, enabled = false }

WorldTime.toggleFreezeTime = { value = false }
WorldTime.toggleTimeLapse = { value = false }
WorldTime.toggleSyncToSystemClock = { value = false }

WorldTime.timeLapseMultiplier = { value = 2, min = 1, max = 64, step = 1.0 }

local skipState = {
    enabled = false,
    totalStart = 0,
    totalTarget = 0,
    step = 500,
    currentTime = 0,
    days = 0,
    logged = false
}



function WorldTime.GetTime()
    local gameTime = timeSystem:GetGameTime()

    return {
        hours = gameTime:Hours(),
        minutes = gameTime:Minutes(),
        seconds = gameTime:Seconds(),
        -- day = gameTime:Day(), -- Not working idk why
        raw = gameTime
    }
end

function WorldTime.SetGameTime(hours, minutes, seconds)
    timeSystem:SetGameTimeByHMS(hours, minutes, seconds, "EasyTrainerWorldTime")
    -- Logger.Log(string.format("[EasyTrainerWorldTime] Set game time to %02d:%02d:%02d", hours, minutes, seconds))
end


local function ApplyTimeWithState(hours, minutes, seconds, label)
    local refroze = false
    local resynced = false

    if WorldTime.toggleFreezeTime.value then
        WorldTime.toggleFreezeTime.value = false
        refroze = true
    end

    if WorldTime.toggleSyncToSystemClock.value then
        WorldTime.toggleSyncToSystemClock.value = false
        resynced = true
    end

    WorldTime.SetGameTime(hours, minutes, seconds)

    if refroze then
        -- WorldTime.toggleFreezeTime.value = true
        Notification.Info(string.format("Time set to %s and disabled Freeze Time", label or "custom time"))
    end

    if resynced then
        Notification.Info("System clock sync disabled to apply custom time")
    end
end

function WorldTime.SetTimeMorning()   ApplyTimeWithState(6, 0, 0, "Morning (6:00)") end
function WorldTime.SetTimeNoon()      ApplyTimeWithState(12, 0, 0, "Noon (12:00)") end
function WorldTime.SetTimeAfternoon() ApplyTimeWithState(15, 0, 0, "Afternoon (15:00)") end
function WorldTime.SetTimeEvening()   ApplyTimeWithState(18, 0, 0, "Evening (18:00)") end
function WorldTime.SetTimeNight()     ApplyTimeWithState(22, 0, 0, "Night (22:00)") end

function WorldTime.SkipDays(days, step)
    if not days or days < 1 then days = 1 end
    local current = timeSystem:GetGameTime()
    skipState.totalStart = current:Seconds()
    skipState.totalTarget = skipState.totalStart + (days * 86400)
    skipState.currentTime = 0
    skipState.step = step or 500
    skipState.enabled = true
    skipState.days = days
    skipState.logged = false
end

local function HandleFreezeTime()
    if WorldTime.toggleFreezeTime.value then
        if not WorldTime.frozenTime then
            local current = timeSystem:GetGameTime()
            WorldTime.frozenTime = {
                h = current:Hours(),
                m = current:Minutes(),
                s = current:Seconds()
            }
        end
        timeSystem:SetGameTimeByHMS(WorldTime.frozenTime.h, WorldTime.frozenTime.m, WorldTime.frozenTime.s, "EasyTrainerFreezeTime"
        )
        return true
    else
        WorldTime.frozenTime = nil
    end
end

local function HandleTimeLapse()
    if not WorldTime.toggleTimeLapse.value then return end
    
    local now = timeSystem:GetGameTime()
    local hour = now:Hours()
    local minute = now:Minutes()
    local second = now:Seconds()

    local totalSeconds = hour * 3600 + minute * 60 + second
    totalSeconds = totalSeconds + (10 * WorldTime.timeLapseMultiplier.value)

    local h = math.floor((totalSeconds / 3600) % 24)
    local m = math.floor((totalSeconds % 3600) / 60)
    local s = math.floor(totalSeconds % 60)

    timeSystem:SetGameTimeByHMS(h, m, s, "EasyTrainerTimeLapse")
end


local function HandleSyncToSystemClock()
    if WorldTime.toggleSyncToSystemClock.value then
        local now = os.date("*t")
        WorldTime.SetGameTime(now.hour, now.min, now.sec)
    end
end

local function HandleSkipDays(delta)
    if not skipState.enabled then return end

    skipState.currentTime = skipState.currentTime + (delta * 1000)
    if skipState.currentTime >= 50 then
        skipState.currentTime = 0
        skipState.totalStart = skipState.totalStart + skipState.step

        if skipState.totalStart >= skipState.totalTarget then
            skipState.enabled = false
            if not skipState.logged then
                Logger.Log(string.format("[EasyTrainerWorldTime] Skipped %d day(s)", skipState.days))
                Notification.Info(string.format("Skipped %d day(s)", skipState.days))
                skipState.logged = true
            end
            return
        end

        local h = math.floor((skipState.totalStart / 3600) % 24)
        local m = math.floor((skipState.totalStart % 3600) / 60)
        local s = math.floor(skipState.totalStart % 60)
        timeSystem:SetGameTimeByHMS(h, m, s, "EasyTrainerWorldTime")
    end
end

local function HandleFasterTime(delta)
    WorldTime.fasterTimeTick = (WorldTime.fasterTimeTick or 0) + (delta * 1000)
    if WorldTime.fasterTimeTick >= 100 then
        WorldTime.fasterTimeTick = 0

        local now = timeSystem:GetGameTime()
        local hour = now:Hours()
        local minute = now:Minutes()
        local second = now:Seconds()

        local isDay = hour >= 6 and hour < 18
        local isNight = not isDay

        local applyDay = isDay and WorldTime.daySpeedMultiplier.enabled
        local applyNight = isNight and WorldTime.nightSpeedMultiplier.enabled

        if applyDay or applyNight then
            local multiplier = applyDay and WorldTime.daySpeedMultiplier.value or WorldTime.nightSpeedMultiplier.value
            local totalSeconds = hour * 3600 + minute * 60 + second
            totalSeconds = totalSeconds + (10 * multiplier)

            local h = math.floor((totalSeconds / 3600) % 24)
            local m = math.floor((totalSeconds % 3600) / 60)
            local s = math.floor(totalSeconds % 60)

            timeSystem:SetGameTimeByHMS(h, m, s, "EasyTrainerFasterTime")
        end
    end
end




function WorldTime.Update(delta)
    HandleSyncToSystemClock()

    if HandleFreezeTime() then return end

    HandleSkipDays(delta)
    HandleFasterTime(delta)
    HandleTimeLapse()
end


return WorldTime
