-- Controls/Restrictions.lua
local Logger = require("Core/Logger")
local Input = require("Core/Input")
local State = require("Controls/State")

local StatusEffect = require("Utils/StatusEffect")

local Restrictions = {}

local controllerRestrictions = {
    "GameplayRestriction.NoPhone",
    "GameplayRestriction.VehicleNoSummoning",
    "GameplayRestriction.PhoneCall",
    "GameplayRestriction.NoHealing",
    "GameplayRestriction.NoJump",
    "GameplayRestriction.InDaClub" -- Go shorty, it’s your birthday. | blocks cyberware dash
}

-- we don't need to block much when the player is using a keyboard the arrow keys drive
-- This is of course assuming they use default controls
local keyboardOnlyRestriction = "GameplayRestriction.NoDriving"

local mouseRestrictions = {
    "GameplayRestriction.NoZooming",
    "GameplayRestriction.NoWeapons",
    "GameplayRestriction.NoCameraControl",
    "GameplayRestriction.NoCombat",
    "GameplayRestriction.NoHealing",
    "GameplayRestriction.BinocularView"
}

local typingRestrictions = {
    "GameplayRestriction.BlockAllHubMenu",
    "GameplayRestriction.NoDriving",
    "GameplayRestriction.Melee",
    "GameplayRestriction.NoPhone",
    "GameplayRestriction.VehicleNoSummoning",
    "GameplayRestriction.PhoneCall",
    "GameplayRestriction.NoHealing",
    "GameplayRestriction.NoJump",
    "GameplayRestriction.NoMovement",
    "GameplayRestriction.NoPhotoMode",
    "GameplayRestriction.NoQuickMelee",
    "GameplayRestriction.NoScanning",
    "GameplayRestriction.NoSprint",
}

local lastMenuOpen = false
local lastWasController = false
local lastMouseEnabled = false
local lastTypingEnabled = false

function Restrictions.Update()
    local menuOpen = State.IsMenuOpen()
    Input.UpdateDevice()

    local usingController = Input.IsController()
    local mouseEnabled = State.mouseEnabled
    local typingEnabled = State.typingEnabled

    if not menuOpen and lastMenuOpen then
        Restrictions.Clear()
        lastMenuOpen, lastWasController, lastMouseEnabled, lastTypingEnabled = false, false, false, false
        return
    end

    if not menuOpen then return end

    -- if input mode changed, reapply restrictions once
    if usingController ~= lastWasController
        or mouseEnabled ~= lastMouseEnabled
        or typingEnabled ~= lastTypingEnabled
        or not lastMenuOpen then
        Restrictions.Clear()

        if usingController then
            Logger.Log("Controller restrictions applied")
            for _, effect in ipairs(controllerRestrictions) do
                StatusEffect.Set(effect, true)
            end
        elseif typingEnabled then
            Logger.Log("Typing restrictions applied")
            for _, effect in ipairs(typingRestrictions) do
                StatusEffect.Set(effect, true)
            end
        elseif mouseEnabled then
            Logger.Log("Mouse restrictions applied")
            for _, effect in ipairs(mouseRestrictions) do
                StatusEffect.Set(effect, true)
            end
        else
            Logger.Log("Keyboard restrictions applied")
            StatusEffect.Set(keyboardOnlyRestriction, true)
        end
    end

    lastMenuOpen = menuOpen
    lastWasController = usingController
    lastMouseEnabled = mouseEnabled
    lastTypingEnabled = typingEnabled
end

function Restrictions.Clear()
    StatusEffect.Set(keyboardOnlyRestriction, false)
    for _, effect in ipairs(controllerRestrictions) do
        StatusEffect.Set(effect, false)
    end
    for _, effect in ipairs(mouseRestrictions) do
        StatusEffect.Set(effect, false)
    end
    for _, effect in ipairs(typingRestrictions) do
        StatusEffect.Set(effect, false)
    end
end

return Restrictions
