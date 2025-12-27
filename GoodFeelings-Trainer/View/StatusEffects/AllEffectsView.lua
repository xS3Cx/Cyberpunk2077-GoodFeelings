local Buttons = require("UI").Buttons
local StatusEffectLoader = require("Utils/DataExtractors/StatusEffectLoader")
local StatusEffectBrowser = require("Features/Self/StatusEffectBrowser")
local Notification = require("UI").Notification

local function ApplyEffect(effect)
    if StatusEffectBrowser.ApplyToPlayer(effect.id) then
        Notification.Success("Applied: " .. effect.displayName)
    else
        Notification.Error("Failed to apply: " .. effect.displayName)
    end
end

local function StatusEffectAllView()
    local effects = StatusEffectLoader:GetCategory("All")
    local current = StatusEffectBrowser.GetCurrentEffect()
    
    Buttons.Break("All Status Effects (" .. #effects .. ")")
    
    for _, effect in ipairs(effects) do
        local marker = (current == effect.id) and " [X]" or ""
        Buttons.Option(effect.displayName .. marker, "Apply to player", function()
            ApplyEffect(effect)
        end)
    end
end

return { title = "All Effects", view = StatusEffectAllView }
