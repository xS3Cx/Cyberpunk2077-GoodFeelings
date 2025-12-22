local UI = require("UI")
local Buttons = UI.Buttons

local WorldTime = require("Features/World").WorldTime

WorldTime.customHour = { value = 12, min = 0, max = 23, step = 1 }
WorldTime.customMinute = { value = 0, min = 0, max = 59, step = 1 }
WorldTime.customSecond = { value = 0, min = 0, max = 59, step = 1 }
WorldTime.customTimeEdited = false

WorldTime.skipDaysAmount = { value = 1, min = 1, max = 100, step = 1 }
WorldTime.skipStepSize = { value = 500, min = 100, max = 5000, step = 100 }

function WorldTime.ApplyCustomGameTime()
    WorldTime.SetGameTime(WorldTime.customHour.value, WorldTime.customMinute.value, WorldTime.customSecond.value)
end

local function OnCustomTimeChanged()
    WorldTime.customTimeEdited = true
    WorldTime.ApplyCustomGameTime()
end

local function FormatTime24(hour, minute, second)
    return string.format("%02d:%02d:%02d", hour, minute, second)
end

local function FormatTime12(hour, minute, second)
    local hour12 = hour % 12
    if hour12 == 0 then hour12 = 12 end
    local ampm = (hour < 12) and "AM" or "PM"
    return string.format("%02d:%02d:%02d %s", hour12, minute, second, ampm)
end

local function WorldTimeViewFunction()
    local time = WorldTime.GetTime()

    if not WorldTime.customTimeEdited then
        WorldTime.customHour.value = time.hours
        WorldTime.customMinute.value = time.minutes
        -- WorldTime.customSecond.value = time.seconds -- Causes conflicts when editing
    end

    local time24 = FormatTime24(time.hours, time.minutes, time.seconds)
    Buttons.OptionExtended(L("worldtime.currenttime24.label"), "", time24, L("worldtime.currenttime24.tip"))

    local time12 = FormatTime12(time.hours, time.minutes, time.seconds)
    Buttons.OptionExtended(L("worldtime.currenttime12.label"), "", time12, L("worldtime.currenttime12.tip"))

    Buttons.Int(
        L("worldtime.hour.label"),
        WorldTime.customHour,
        tip("worldtime.hour.tip", { formatted_time = FormatTime12(WorldTime.customHour.value, 0, 0) }),
        OnCustomTimeChanged
    )
    Buttons.Int(L("worldtime.minute.label"), WorldTime.customMinute, L("worldtime.minute.tip"), OnCustomTimeChanged)
    Buttons.Int(L("worldtime.second.label"), WorldTime.customSecond, L("worldtime.second.tip"), OnCustomTimeChanged)
    WorldTime.customTimeEdited = false
    
    Buttons.Toggle(L("worldtime.synctopc.label"), WorldTime.toggleSyncToSystemClock, L("worldtime.synctopc.tip"))
    
    Buttons.Break(L("worldtime.quickset.label"))
    Buttons.Option(L("worldtime.setmorning.label"), L("worldtime.setmorning.tip"), WorldTime.SetTimeMorning)
    Buttons.Option(L("worldtime.setnoon.label"), L("worldtime.setnoon.tip"), WorldTime.SetTimeNoon)
    Buttons.Option(L("worldtime.setafternoon.label"), L("worldtime.setafternoon.tip"), WorldTime.SetTimeAfternoon)
    Buttons.Option(L("worldtime.setevening.label"), L("worldtime.setevening.tip"), WorldTime.SetTimeEvening)
    Buttons.Option(L("worldtime.setnight.label"), L("worldtime.setnight.tip"), WorldTime.SetTimeNight)

    Buttons.Break(L("worldtime.skipmultiplier.label"))
    Buttons.Int(L("worldtime.skipdays.label"), WorldTime.skipDaysAmount, L("worldtime.skipdays.tip"))
    Buttons.Int(L("worldtime.skipstepspeed.label"), WorldTime.skipStepSize, L("worldtime.skipstepspeed.tip"))
    Buttons.Option(L("worldtime.startskipping.label"), L("worldtime.startskipping.tip"), function()
        WorldTime.SkipDays(WorldTime.skipDaysAmount.value, WorldTime.skipStepSize.value)
    end)

    Buttons.Break(L("worldtime.freezefast.label"))
    Buttons.Toggle(L("worldtime.freezetime.label"), WorldTime.toggleFreezeTime, L("worldtime.freezetime.tip"))
    Buttons.Float(L("worldtime.fasterdayspeed.label"), WorldTime.daySpeedMultiplier, L("worldtime.fasterdayspeed.tip"))
    Buttons.Float(L("worldtime.fasternightspeed.label"), WorldTime.nightSpeedMultiplier, L("worldtime.fasternightspeed.tip"))

    Buttons.Break(L("worldtime.timelapse.label"))
    Buttons.Toggle(L("worldtime.enabletimelapse.label"), WorldTime.toggleTimeLapse, L("worldtime.enabletimelapse.tip"))
    Buttons.Int(L("worldtime.timelapsemultiplier.label"), WorldTime.timeLapseMultiplier, L("worldtime.timelapsemultiplier.tip"))
end

local WorldTimeView = {
    title = "worldtime.title",
    view = WorldTimeViewFunction
}

return WorldTimeView
