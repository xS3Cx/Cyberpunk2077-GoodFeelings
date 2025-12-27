local Buttons = require("UI").Buttons
local StatusEffectLoader = require("Utils/DataExtractors/StatusEffectLoader")
local StatusEffectBrowser = require("Features/Self/StatusEffectBrowser")
local Notification = require("UI").Notification
local Logger = require("Core/Logger")

local function ApplyEffect(effect)
    if StatusEffectBrowser.ApplyToPlayer(effect.id) then
        Notification.Success("Applied: " .. effect.displayName)
    else
        Notification.Error("Failed to apply: " .. effect.displayName)
    end
end

local function StatusEffectCombatView()
    local effects = StatusEffectLoader:GetCategory("Combat")
    local current = StatusEffectBrowser.GetCurrentEffect()
    
    Logger.Log("Combat Effects Count: " .. #effects)
    
    Buttons.Break("Combat Effects (" .. #effects .. ")")
    
    if #effects == 0 then
        Buttons.Option("No effects loaded", "Data may not be initialized")
        return
    end
    
    for _, effect in ipairs(effects) do
        local marker = (current == effect.id) and " [X]" or ""
        Buttons.Option(effect.displayName .. marker, "Apply to player", function()
            ApplyEffect(effect)
        end)
    end
end

return { title = "Combat Effects", view = StatusEffectCombatView }
