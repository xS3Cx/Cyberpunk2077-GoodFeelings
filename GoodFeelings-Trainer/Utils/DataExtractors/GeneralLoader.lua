local Logger = require("Core/Logger")
local utils = require("Utils/DataExtractors/DataUtils")
local JsonHelper = require("Core/JsonHelper")

local GeneralLoader = {
    items = {},
    indexById = {}
}

local function GetTags(rec)
    local tags = {}
    local count = utils.SafeCall(function() return rec:GetTagsCount() end) or 0
    for i = 0, count - 1 do
        local tag = utils.SafeCall(function() return rec:GetTagsItem(i).value end)
        if tag then table.insert(tags, tag) end
    end
    return tags
end

local PARENT_CATEGORIES = { -- All of this so it's much easier to navigate; Loading too many items at once makes the game lag.

    WeaponMods = {
        "ChimeraMod",
        "ThrowMod",
        "BluntMod",
        "BladeMod",
        "MeleeMod",
        "RangedMod",
        "GenericRangedMod",
        "WeaponMod",
    },
    Consumables = {
        "PermanentFood",
        "PermanentHealthFood",
        "IllegalFood",
        "Injector",
        "Inhaler",
        "Drug",
        "Medical",
        "Alcohol",
        "Drink",
        "Food",
        "Edible",
        "InjectorPlus",
        "InhalerPlus",
    },
    CraftingMaterials = {
        "CraftingPart",
        "QuickhackCraftingMaterials",
        "FabricEnhancer",
        "DeprecatedFabricEnhancer",
        "LegendaryAttachment",
    },
    SkillShards = {
        "MoneyShard",
        "PerkSkillbook",
        "LargeSkillbook",
        "skillbook",
        "SkillbookReward_Tech",
        "SkillbookReward_Int",
        "SkillbookReward_Body",
        "SkillbookReward_Cool",
        "SkillbookReward_Ref",
    },
    CyberdeckShards = {
        "Tier6Shard",
        -- "Tier5Shard", not real
        "Tier4Shard",
        "Tier3Shard",
        "Tier2Shard",
        "Tier1Shard",
        "Tier0Shard",
        "pShard",
        "SoftwareShard",
    },
    Readables = {
        "Shard",
        "Readable",
        "Fragment",
    },
    Miscellaneous = {
        "Jewellery",
        "SexToy",
        "Junk",
        "Prop"
    },
    Reward = {
        "CourierReward",
        "AirDropReward",
        "MoneyShard",
        "Currency",
        "CasinoChip"
    },
    Quest = {
        "Quest"
    },
    Cyberware = { -- This was a lot more complicated than I thought I honestly didn't think there was so much cyberware half of them can't even be looted
        "OperatingSystem",
        "Skeleton",
        "Circulatory",
        "Integumentary",
        "NervousSystem",
        "Ocular",
        "Boosters",
        "Tattoos",
        "Misc",
    },
}

-- Small helper
local function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

function GeneralLoader:LoadAll()
    local records = utils.TableMerge(
        TweakDB:GetRecords("gamedataItem_Record"),
        TweakDB:GetRecords("gamedataConsumableItem_Record")
    )

    if not records or #records == 0 then
        Logger.Log("GeneralLoader: No item records found.")
        return
    end

    local obsStr = "!OBSOLETE"
    local idExcludeList = { -- From SimpleMenu
        "Left_Hand", "FunctionalTests", "TEST.", "CPO", "KERS", "Tutorial",
        "Items.Inhaler", "Items.Injector", "Items.LongLasting",
        "_Arasaka", "_Oda_S", "BaseDeck", "NPC", "Test", "Silenced",
        "SemiAuto", "_V_", "Generic", "Items.Silverhand_Malorian",
        "Items.SimpleWeaponMod10", "IntrinsicFabricEnhancer",
        "Items.Dummy", "Items.PowerWeaponMod", "Items.TechWeaponMod",
        "Items.SmartWeaponMod", "knuckledusters", "Items.Preset_Knuckles",
        "Smasher_HMG", "HMG_Sasquatch", "HMG_turret", "Minotaur_HMG",
        "HMG_Invisible", "Items.Panzer_", "Items.Panam_Vehicle",
        "Items.Vehicle_", "Items.RareMaterial2",
        "Items.EpicMaterial2", "Items.LegendaryMaterial2"
    }

    for _, rec in ipairs(records) do
        local id   = utils.SafeCall(function() return rec:GetID().value end)
        if not (id and id:find("^Items%.")) then goto continue end
        if id:find("<.+>") then goto continue end -- skip default/broken IDs
        for _, excl in ipairs(idExcludeList) do
            if id:find(excl) then goto continue end
        end

        local name = utils.GetDisplayName(rec) or "Unknown"
        if name == "Unknown" then goto continue end

        -- check obsolete marker
        local dname = rec:DisplayName()
        if dname ~= nil then
            local lname = Game.GetLocalizedTextByKey(CName.new(tonumber(dname.hash_lo)))
            if lname and lname:upper() == obsStr then
                goto continue
            end
        end

        local data = { id = id, name = name }
        data.quality = utils.SafeCall(function() return rec:Quality():GetID().value end)
        data.canDrop = utils.SafeCall(function() return rec:CanDrop() end) or false
        data.isGarment = utils.SafeCall(function() return rec:IsGarment() end) or false
        data.isCoreCW = utils.SafeCall(function() return rec:IsCoreCW() end) or false
        data.isCustomizable = utils.SafeCall(function() return rec:IsCustomizable() end) or false
        data.tags = GetTags(rec)

        local lowerName = name:lower()
        local lowerId = id:lower()
        if lowerName:find("craftable") or lowerId:find("craftable") then
            data.isCraftable = true
        else
            data.isCraftable = false
        end

        table.insert(self.items, data)
        self.indexById[id] = data

        ::continue::
    end


    local catCount, subcatCount = 0, 0
    for parent, subcats in pairs(PARENT_CATEGORIES) do
        catCount = catCount + 1
        subcatCount = subcatCount + #subcats
    end

    Logger.Log(string.format(
        "GeneralLoader: Loaded %d items across %d categories and %d subcategories.",
        #self.items, catCount, subcatCount
    ))
end



local function shallowCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = v
    end
    return copy
end

local function AssignToCategory(item, categorized)
    for parent, subcats in pairs(PARENT_CATEGORIES) do
        local primarySub, additional = nil, {}

        for _, sub in ipairs(subcats) do
            if tableContains(item.tags, sub) then
                if not primarySub then
                    primarySub = sub
                else
                    table.insert(additional, sub)
                end
            end
        end

        if primarySub then
            local entry = shallowCopy(item)
            if #additional > 0 then
                entry.AdditionalTags = additional
            end
            table.insert(categorized[parent][primarySub], entry)
            return true
        end
    end
    return false
end

local function AssignToUncategorized(item, categorized)
    local parentTag = item.tags[1] or "Unknown"
    categorized["Uncategorized"][parentTag] = categorized["Uncategorized"][parentTag] or {}
    local entry = shallowCopy(item)
    if #item.tags > 1 then
        entry.AdditionalTags = { table.unpack(item.tags, 2) }
    end
    table.insert(categorized["Uncategorized"][parentTag], entry)
end

local function CategorizeCyberware(items)
    local categories = {
        OperatingSystem = {}, Skeleton = {}, Circulatory = {}, Integumentary = {},
        NervousSystem = {}, Ocular = {}, Boosters = {}, Tattoos = {}, Misc = {}
    }

    for _, item in ipairs(items) do
        local entry = shallowCopy(item)
        local n = (item.id or ""):lower()

        local bucket =
            (n:find("deck") or n:find("sandevistan") or n:find("berserk") or n:find("mk")) and "OperatingSystem"
            or (n:find("muscle") or n:find("marrow") or n:find("bone") or n:find("joint") or n:find("tissue")) and "Skeleton"
            or (n:find("heart") or n:find("lung") or n:find("blood")) and "Circulatory"
            or (n:find("skin") or n:find("armor") or n:find("plating")) and "Integumentary"
            or (n:find("reflex") or n:find("perception") or n:find("synaptic") or n:find("cogito") or n:find("neofiber") or n:find("kerenzikov")) and "NervousSystem"
            or (n:find("optics") or n:find("kiroshi")) and "Ocular"
            or (n:find("booster") or n:find("injector") or n:find("memory") or n:find("resistance") or n:find("capacity")) and "Boosters"
            or (n:find("tattoo")) and "Tattoos"
            or "Misc"

        table.insert(categories[bucket], entry)
    end

    return categories
end

function GeneralLoader:Categorize()
    local categorized = {}

    -- init buckets
    for parent, subcats in pairs(PARENT_CATEGORIES) do
        categorized[parent] = {}
        for _, sub in ipairs(subcats) do
            categorized[parent][sub] = {}
        end
    end
    categorized["Uncategorized"] = {}

    local cyberwareItems = {}

    for _, item in ipairs(self.items) do
        if item.tags and #item.tags > 0 then
            if tableContains(item.tags, "Cyberware") then
                table.insert(cyberwareItems, item)
            elseif not AssignToCategory(item, categorized) then
                AssignToUncategorized(item, categorized)
            end
        end
    end

    categorized["Cyberware"] = CategorizeCyberware(cyberwareItems)
    return categorized
end

return GeneralLoader
