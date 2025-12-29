-- View/World/NPCFXView.lua
local UI = require("UI")
local Buttons = UI.Buttons

local npcEffects = {
    "Burning",
    "EMP",
    "Poisoned",
    "Bleeding",
    "Stunned",
    "Blinded",
    "System Collapse",
    "Overheat",
    "Cyberware Malfunction",
    "Weapon Malfunction"
}

local selectedEffect = { index = 1, expanded = false }
local effectDuration = { value = 10, min = 1, max = 60 }
local autoApplyMode = { value = false }

-- Track last applied NPC to prevent spam
local lastAppliedNPC = nil
local lastAppliedTime = 0
local applyCooldown = 1.0 -- seconds

-- Real game status effects
local effectBuffs = {
    "BaseStatusEffect.Burning",
    "BaseStatusEffect.EMPJammed",
    "BaseStatusEffect.Poisoned",
    "BaseStatusEffect.Bleeding",
    "BaseStatusEffect.Stunned",
    "BaseStatusEffect.Blind",
    "BaseStatusEffect.SystemCollapse",
    "BaseStatusEffect.Overheat",
    "BaseStatusEffect.CyberwareMalfunction",
    "BaseStatusEffect.WeaponMalfunction"
}

local function GetTargetNPC()
    local targetingSystem = Game.GetTargetingSystem()
    local player = Game.GetPlayer()
    
    if not player then return nil end
    
    local target = targetingSystem:GetLookAtObject(player, false, false)
    
    if target and target:IsNPC() then
        return target
    end
    
    return nil
end

local function ApplyEffectToNPC(npc, effectIndex)
    if not IsDefined(npc) then return false end
    
    local npcEntity = npc:GetEntityID()
    local SEE = Game.GetStatusEffectSystem()
    local buffName = effectBuffs[effectIndex]
    
    -- Apply the status effect
    SEE:ApplyStatusEffect(npcEntity, buffName, npc:GetEntityID(), effectDuration.value)
    return true
end

local function RemoveEffectFromNPC(npc, effectIndex)
    if not IsDefined(npc) then return false end
    
    local npcEntity = npc:GetEntityID()
    local SEE = Game.GetStatusEffectSystem()
    local buffName = effectBuffs[effectIndex]
    
    if SEE:HasStatusEffect(npcEntity, buffName) then
        SEE:RemoveStatusEffect(npcEntity, buffName)
        return true
    end
    
    return false
end

local function RemoveAllEffects(npc)
    if not IsDefined(npc) then return false end
    
    local npcEntity = npc:GetEntityID()
    local SEE = Game.GetStatusEffectSystem()
    local count = 0
    
    for _, buffName in ipairs(effectBuffs) do
        if SEE:HasStatusEffect(npcEntity, buffName) then
            SEE:RemoveStatusEffect(npcEntity, buffName)
            count = count + 1
        end
    end
    
    return count > 0, count
end

-- Auto-apply logic
local function UpdateAutoApply()
    if not autoApplyMode.value then return end
    
    local target = GetTargetNPC()
    if not target then 
        lastAppliedNPC = nil
        return 
    end
    
    local currentTime = os.clock()
    local targetID = target:GetEntityID()
    
    -- Check if this is a new NPC or enough time has passed
    if lastAppliedNPC ~= targetID or (currentTime - lastAppliedTime) > applyCooldown then
        if ApplyEffectToNPC(target, selectedEffect.index) then
            lastAppliedNPC = targetID
            lastAppliedTime = currentTime
        end
    end
end

local function NPCFXViewFunction()
    -- Update auto-apply if enabled
    UpdateAutoApply()
    
    Buttons.Break("NPC Status Effects")
    
    Buttons.Dropdown("Effect Type", selectedEffect, npcEffects, "Select status effect to apply")
    
    Buttons.Int("Duration (seconds)", effectDuration, "How long the effect lasts")
    
    Buttons.Break("Actions")
    
    if Buttons.Option("Apply to Target NPC", "Apply selected effect to NPC in crosshair") then
        local target = GetTargetNPC()
        if target then
            if ApplyEffectToNPC(target, selectedEffect.index) then
                UI.Notification.Success("Applied " .. npcEffects[selectedEffect.index] .. " to NPC")
            else
                UI.Notification.Error("Failed to apply effect")
            end
        else
            UI.Notification.Error("No NPC in crosshair")
        end
    end
    
    if Buttons.Option("Remove Selected Effect", "Remove selected effect from NPC in crosshair") then
        local target = GetTargetNPC()
        if target then
            if RemoveEffectFromNPC(target, selectedEffect.index) then
                UI.Notification.Info("Removed " .. npcEffects[selectedEffect.index])
            else
                UI.Notification.Warning("NPC doesn't have this effect")
            end
        else
            UI.Notification.Error("No NPC in crosshair")
        end
    end
    
    if Buttons.Option("Remove All Effects", "Remove all status effects from target NPC") then
        local target = GetTargetNPC()
        if target then
            local removed, count = RemoveAllEffects(target)
            if removed then
                UI.Notification.Info("Removed " .. count .. " effects")
            else
                UI.Notification.Warning("NPC has no effects")
            end
        else
            UI.Notification.Error("No NPC in crosshair")
        end
    end
    
    Buttons.Break("Auto Mode")
    
    Buttons.Toggle(
        "Auto-Apply on Look",
        autoApplyMode,
        "Automatically apply selected effect to any NPC you look at"
    )
    
    Buttons.Break("Info")
    Buttons.OptionExtended("Selected Effect", nil, npcEffects[selectedEffect.index])
    Buttons.OptionExtended("Duration", nil, effectDuration.value .. "s")
    
    local target = GetTargetNPC()
    if target then
        local npcName = target:GetDisplayName()
        if npcName and npcName ~= "" then
            Buttons.OptionExtended("Target NPC", nil, npcName)
        else
            Buttons.OptionExtended("Target NPC", nil, "Unknown NPC")
        end
    else
        Buttons.OptionExtended("Target NPC", nil, "No NPC")
    end
end

return {
    title = "NPC FX",
    view = NPCFXViewFunction
}
