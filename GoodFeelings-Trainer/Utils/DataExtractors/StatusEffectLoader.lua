local Logger = require("Core/Logger")

local StatusEffectLoader = {
    effects = {},
    categories = {},
    quickSets = {},
    indexById = {}
}

-- Category definitions with pattern matching
local categoryPatterns = {
    Combat = {
        "Berserk", "Sandevistan", "Kerenzikov", "Deadeye", "Maniac", "ColdBlood",
        "Combat", "Attack", "Damage", "Weapon", "Melee", "Finisher"
    },
    Cyberware = {
        "OpticalCamo", "Kerenzikov", "Sandevistan", "Berserk", "DetectorRush",
        "ReflexRecorder", "SynapticAccelerator", "BloodPump", "SecondHeart",
        "Cyberware", "Implant", "NanoTech", "Microgenerator"
    },
    Quickhacks = {
        "Overheat", "Contagion", "SystemCollapse", "Ping", "BrainMelt", "Madness",
        "Suicide", "MemoryWipe", "WeaponMalfunction", "LocomotionMalfunction",
        "CyberwareMalfunction", "Blind", "Jam", "Reboot", "Blackwall", "QuickHack"
    },
    Debuffs = {
        "Burning", "Poisoned", "Bleeding", "Electrocuted", "EMP", "Stun", "Knockdown",
        "Blind", "Crippled", "Dismembered", "Weak", "Vulnerable", "Exhausted",
        "HearingImpaired", "Pain", "Defeated", "Grappled"
    },
    Buffs = {
        "Buff", "Boost", "Regen", "Health", "Armor", "Resistance", "Speed",
        "Accuracy", "Crit", "Damage", "Stealth", "Detection", "Food", "Inhaler"
    },
    Status = {
        "Drunk", "Drugged", "Sated", "Exhausted", "Invisible", "Cloaked",
        "Masked", "Invulnerable", "GodMode"
    },
    Special = {
        "Johnny", "Relic", "Myers", "Takemura", "Kerry", "Panam", "River",
        "Judy", "Viktor", "Oda", "Smasher", "Blackwall", "Netwatch",
        "MaxTac", "Trauma", "Quest", "Tutorial", "Boss", "Iconic"
    }
}

-- Quick Sets - most popular/useful effects
local quickSetDefinitions = {
    {
        name = "Combat Enhancements",
        effects = {
            "BaseStatusEffect.Berserk",
            "BaseStatusEffect.Sandevistan",
            "BaseStatusEffect.KerenzikovPlayerBuff",
            "BaseStatusEffect.DeadeyeSE",
            "BaseStatusEffect.ColdBlood"
        }
    },
    {
        name = "Stealth & Infiltration",
        effects = {
            "BaseStatusEffect.OpticalCamoPlayerBuffLegendary",
            "BaseStatusEffect.Cloaked",
            "BaseStatusEffect.ReducedDetection",
            "BaseStatusEffect.ReducedVisibility"
        }
    },
    {
        name = "Survival & Defense",
        effects = {
            "BaseStatusEffect.Invulnerable",
            "BaseStatusEffect.SecondHeartCooldown",
            "BaseStatusEffect.HealthMonitor",
            "BaseStatusEffect.PainInhibitors"
        }
    },
    {
        name = "Offensive Quickhacks",
        effects = {
            "BaseStatusEffect.OverheatLevel4PlusPlus",
            "BaseStatusEffect.ContagionPoisonLvl4PlusPlus",
            "BaseStatusEffect.SystemCollapse",
            "BaseStatusEffect.BrainMeltLevel4PlusPlus",
            "BaseStatusEffect.SuicideWithWeapon"
        }
    },
    {
        name = "Control Quickhacks",
        effects = {
            "BaseStatusEffect.MandessLevel4PlusPlus",
            "BaseStatusEffect.WeaponMalfunctionLvl4PlusPlus",
            "BaseStatusEffect.CyberwareMalfunctionLvl4PlusPlus",
            "BaseStatusEffect.LocomotionMalfunctionLevel4"
        }
    },
    {
        name = "Fun & Experimental",
        effects = {
            "BaseStatusEffect.Drunk",
            "BaseStatusEffect.DruggedSevere",
            "BaseStatusEffect.GlowingTattoos",
            "BaseStatusEffect.BlackLaceV1",
            "BaseStatusEffect.BonesMcCoy70V2"
        }
    }
}

local function MatchesCategory(effectId, categoryName)
    local patterns = categoryPatterns[categoryName]
    if not patterns then return false end
    
    -- Search in the full effect ID (e.g., "BaseStatusEffect.Berserk")
    for _, pattern in ipairs(patterns) do
        if effectId:find(pattern) then
            return true
        end
    end
    return false
end

local function CategorizeEffect(effectId)
    local cats = {}
    
    for categoryName, _ in pairs(categoryPatterns) do
        if MatchesCategory(effectId, categoryName) then
            table.insert(cats, categoryName)
        end
    end
    
    -- If no category matched, put in Special
    if #cats == 0 then
        table.insert(cats, "Special")
    end
    
    return cats
end

function StatusEffectLoader:LoadAll()
    -- Load status effects from TweakDB instead of JSON
    local records = TweakDB:GetRecords("gamedataStatusEffect_Record")
    
    if not records or #records == 0 then
        Logger.Log("StatusEffectLoader: No status effect records found in TweakDB")
        return
    end
    
    Logger.Log("StatusEffectLoader: Found " .. #records .. " status effect records in TweakDB")
    
    -- Initialize categories
    for categoryName, _ in pairs(categoryPatterns) do
        self.categories[categoryName] = {}
    end
    self.categories["All"] = {}
    
    -- Process each effect
    for _, rec in ipairs(records) do
        local effectId = rec:GetID().value
        
        if effectId and effectId:find("^BaseStatusEffect%.") then
            local effectName = effectId:gsub("BaseStatusEffect%.", "")
            
            local effectData = {
                id = effectId,
                name = effectName,
                displayName = effectName:gsub("([A-Z])", " %1"):gsub("^%s+", ""), -- Add spaces before capitals
                categories = CategorizeEffect(effectId)
            }
            
            table.insert(self.effects, effectData)
            self.indexById[effectId] = effectData
            
            -- Add to categories
            for _, cat in ipairs(effectData.categories) do
                if self.categories[cat] then
                    table.insert(self.categories[cat], effectData)
                end
            end
            
            -- Add to All category
            table.insert(self.categories["All"], effectData)
        end
    end
    
    -- Sort all categories alphabetically
    for _, categoryEffects in pairs(self.categories) do
        table.sort(categoryEffects, function(a, b)
            return a.displayName < b.displayName
        end)
    end
    
    -- Build quick sets
    for _, setDef in ipairs(quickSetDefinitions) do
        local set = {
            name = setDef.name,
            effects = {}
        }
        
        for _, effectId in ipairs(setDef.effects) do
            local effectData = self.indexById[effectId]
            if effectData then
                table.insert(set.effects, effectData)
            end
        end
        
        table.insert(self.quickSets, set)
    end
    
    Logger.Log(string.format("StatusEffectLoader: Loaded %d status effects", #self.effects))
    Logger.Log(string.format("StatusEffectLoader: Combat=%d, Cyberware=%d, Quickhacks=%d, Buffs=%d, Debuffs=%d, All=%d", 
        #(self.categories["Combat"] or {}),
        #(self.categories["Cyberware"] or {}),
        #(self.categories["Quickhacks"] or {}),
        #(self.categories["Buffs"] or {}),
        #(self.categories["Debuffs"] or {}),
        #(self.categories["All"] or {})
    ))
end

function StatusEffectLoader:GetAll()
    return self.effects
end

function StatusEffectLoader:GetById(id)
    return self.indexById[id]
end

function StatusEffectLoader:GetCategory(categoryName)
    return self.categories[categoryName] or {}
end

function StatusEffectLoader:GetCategories()
    local cats = {}
    for name, _ in pairs(self.categories) do
        if name ~= "All" then
            table.insert(cats, name)
        end
    end
    table.sort(cats)
    table.insert(cats, "All") -- All at the end
    return cats
end

function StatusEffectLoader:GetQuickSets()
    return self.quickSets
end

function StatusEffectLoader:Search(query)
    if not query or query == "" then
        return self.effects
    end
    
    local results = {}
    local lowerQuery = query:lower()
    
    for _, effect in ipairs(self.effects) do
        if effect.displayName:lower():find(lowerQuery) or effect.name:lower():find(lowerQuery) then
            table.insert(results, effect)
        end
    end
    
    return results
end

return StatusEffectLoader
