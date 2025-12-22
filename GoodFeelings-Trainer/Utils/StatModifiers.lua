local Logger = require("Core/Logger")
local Weapon = require("Utils/Weapon")
local Notification = require("UI").Notification
local Session = require("Core/cp2077-cet-kit/GameSession")

local StatModifiers = {}

local cache = {}   -- id { mod, target, statType, modifierType, value }
local nextID = 1


local function getTargetID(entry)
    if entry.target == "player" then
        local player = Game.GetPlayer()
        return player and player:GetEntityID()
    elseif entry.target == "vehicle" then
        local player = Game.GetPlayer()
        local vehicle = player and Game.GetMountedVehicle(player)
        return vehicle and vehicle:GetEntityID()
    elseif entry.target == "weapon" then
        local _, itemData = Weapon.GetEquippedRightHand()
        return itemData and itemData:GetStatsObjectID()
    elseif type(entry.target) == "userdata" then
        return entry.target
    end
    return nil
end

local function setActiveByMod(mod, isActive)
    for _, entry in pairs(cache) do
        if entry.mod == mod then
            entry.active = isActive
            return
        end
    end
end

local function applyToTarget(mod, targetID, remove)
    local stats = Game.GetStatsSystem()
    if not stats or not targetID then return false end

    if remove then
        stats:RemoveModifier(targetID, mod)
        setActiveByMod(mod, false)
    else
        stats:AddModifier(targetID, mod)
        setActiveByMod(mod, true)
    end
    return true
end


function StatModifiers.Create(statType, modifierType, value, target)
    local mod = RPGManager.CreateStatModifier(statType, modifierType, value)
    if not mod then
        Logger.Log(string.format(
            "StatModifiers: failed to create (%s, %.2f, %s)",
            tostring(statType), value, tostring(modifierType)
        ))
        return nil
    end

    local id = nextID
    nextID = nextID + 1

    cache[id] = {
        mod = mod,
        target = target or "player",
        statType = statType,
        modifierType = modifierType,
        value = value,
        active = true 
    }

    Logger.Log(string.format(
        "StatModifiers: created ID %d (%s %s %.2f > %s)",
        id, tostring(statType), tostring(modifierType), value, tostring(target or "player")
    ))
    return id, mod
end

function StatModifiers.CreateForWeapon(statType, modifierType, value, weaponItemID)
    local mod = RPGManager.CreateStatModifier(statType, modifierType, value)
    if not mod then
        Logger.Log(string.format(
            "StatModifiers: failed to create (%s, %.2f, %s)",
            tostring(statType), value, tostring(modifierType)
        ))
        return nil
    end

    local id = nextID
    nextID = nextID + 1

    cache[id] = {
        mod = mod,
        target = weaponItemID,
        statType = statType,
        modifierType = modifierType,
        value = value
    }

    Logger.Log(string.format(
        "StatModifiers: created ID %d (%s %s %.2f > weapon %s)",
        id, tostring(statType), tostring(modifierType), value, tostring(weaponItemID)
    ))
    return id, mod
end

-- Apply a cached modifier
function StatModifiers.Apply(id)
    local entry = cache[id]
    if not entry then return false end

    local targetID = getTargetID(entry)
    if not targetID then return false end

    if applyToTarget(entry.mod, targetID, false) then
        Logger.Log(string.format("StatModifiers: applied ID %d", id))
        return true
    end
    return false
end

-- Remove a cached modifier
function StatModifiers.Remove(id)
    local entry = cache[id]
    if not entry then return false end

    local targetID = getTargetID(entry)
    if not targetID then return false end

    if applyToTarget(entry.mod, targetID, true) then
        Logger.Log(string.format("StatModifiers: removed ID %d", id))
        cache[id] = nil
        return true
    end
    return false
end


function StatModifiers.RemoveAllButKeepCache()
    local count = 0
    for id, entry in pairs(cache) do
        local targetID = getTargetID(entry)
        if targetID then
            applyToTarget(entry.mod, targetID, true)
            count = count + 1
        end
    end
    Logger.Log(string.format("StatModifiers: removed and cached %d modifiers", count))
end


function StatModifiers.ReapplyAll()
    local ss = Game.GetStatsSystem()
    local player = Game.GetPlayer()
    if not ss or not player then return end

    local pid = player:GetEntityID()
    local count = 0

    for id, entry in pairs(cache) do
        if entry.active then
            local targetID = getTargetID(entry)
            if targetID then
                applyToTarget(entry.mod, targetID, false)
                count = count + 1
            end
        end
    end

    Logger.Log(string.format("StatModifiers: Reapplied %d active modifiers", count))
    Notification.Success(string.format("Reapplied %d modifiers", count), 3)
end



local lastLoadedState = false
local firstLoad = true

function StatModifiers.UpdateSessionWatcher()
    local loaded = Session.IsLoaded()

    -- only need to check when the game is loading or unloaded
    if not loaded and lastLoadedState then
        Logger.Log("Game unloading: Clearing modifiers")
        StatModifiers.RemoveAllButKeepCache()
        lastLoadedState = false
        return
    end

    if loaded and not lastLoadedState then
        if firstLoad then
            Logger.Log("Initial game load detected: skipping modifier reapply")
            firstLoad = false
        else
            Logger.Log("Game fully loaded: Reapplying modifiers")
            StatModifiers.ReapplyAll()
        end
        lastLoadedState = true
    end
end

local appliedStates = setmetatable({}, { __mode = "k" })

function StatModifiers.HandleToggle(ref, applyFunc)
    local wasApplied = appliedStates[ref] or false

    if ref.value then
        if not wasApplied then
            applyFunc(false) -- apply
            appliedStates[ref] = true
        end
    elseif wasApplied then
        applyFunc(true) -- remove
        appliedStates[ref] = false
    end
end

local dynamicStates = setmetatable({}, { __mode = "k" })

function StatModifiers.HandleDynamicToggle(ref, applyFunc)
    local state = dynamicStates[ref]
    if not state then
        state = { applied = false, lastValue = nil }
        dynamicStates[ref] = state
    end

    if ref.enabled then
        if not state.applied then
            applyFunc(false, ref.value)
            state.applied = true
            state.lastValue = ref.value
        elseif ref.value ~= state.lastValue then
            applyFunc(true, state.lastValue)
            applyFunc(false, ref.value) 
            state.lastValue = ref.value
        end
    elseif state.applied then
        applyFunc(true, state.lastValue)
        state.applied = false
    end
end

function StatModifiers.Cleanup()
    local count = 0
    for id, entry in pairs(cache) do
        local targetID = getTargetID(entry)
        if targetID then
            applyToTarget(entry.mod, targetID, true)
            count = count + 1
        end
        cache[id] = nil
    end
    Logger.Log(string.format("StatModifiers: cleanup removed %d modifiers", count))
end


return StatModifiers
