local Logger = require("Core/Logger")
local utils = require("Utils/DataExtractors/DataUtils")

local rarityOrder = {
    iconic = 9,
    legendaryplusplus = 8,
    legendaryplus = 7,
    legendary = 6,
    epic = 5,
    rare = 4,
    uncommon = 3,
    common = 2,
    base = 1
}

local WeaponLoader = {
    weapons = {},
    indexById = {},
    typeMap = {
        handgun = "Handgun",
        revolver = "Revolver",
        smg = "SMG",
        sniper = "Sniper",
        shotgun = "Shotgun",
        lmg = "LMG",
        hmg = "Heavy Machine Gun",
        ["rifle assault"] = "Assault Rifle",
        ["rifle precision"] = "Precision Rifle",
        katana = "Katana",
        blade = "Blade",
        blunt = "Blunt",
        machete = "Machete",
        chainsword = "Chainsword",
        knife = "Knife",
        cyberware = "Cyberware Melee",
        meleeweapon = "Melee"
    },
    rarityMap = {
        legendaryplusplus = "Legendary++",
        legendaryplus = "Legendary+",
        legendary = "Legendary",
        epic = "Epic",
        rare = "Rare",
        uncommon = "Uncommon",
        common = "Common",
        base = "Base"
    },
    wallWeaponIds = {
        ["Items.Preset_Grad_Panam"] = true,
        ["Items.Preset_Carnage_Mox"] = true,
        ["Items.Preset_Nue_Jackie"] = true,
        ["Items.Preset_Katana_Saburo"] = true,
        ["Items.Preset_Katana_Takemura"] = true,
        ["Items.Preset_Overture_Kerry"] = true,
        ["Items.Preset_Liberty_Dex"] = true,
        ["Items.Preset_Ajax_Moron"] = true,
        ["Items.Preset_Copperhead_Genesis"] = true,
        ["Items.Preset_Tactician_Headsman"] = true,
        ["Items.Preset_Pulsar_Buzzsaw"] = true,
        ["Items.Preset_Igla_Sovereign"] = true,
        ["Items.Preset_Dian_Yinglong"] = true,
        ["Items.Preset_Nekomata_Breakthrough"] = true,
        ["Items.Preset_Burya_Comrade"] = true,
        ["Items.Preset_Zhuo_Eight_Star"] = true,
        ["Items.mq007_skippy"] = true,
        ["Items.Preset_Silverhand_3516"] = true,
        ["Items.sq029_rivers_gun"] = true
    }
}

local function GetType(tags)
    local lowerTags = {}
    for _, t in ipairs(tags) do
        lowerTags[t:lower()] = true
    end
    for key, label in pairs(WeaponLoader.typeMap) do
        for tag in pairs(lowerTags) do
            if tag:find(key) then
                return label
            end
        end
    end
    return lowerTags.rangedweapon and "Ranged" or "Miscellaneous"
end

local function GetRarity(recordId, record)
    local quality = utils.SafeCall(function() return record:Quality() end)
    local val = utils.SafeCall(function() return quality:Type().value end) or ""
    val = val:lower()

    for key, label in pairs(WeaponLoader.rarityMap) do
        if val:find(key) then
            return label
        end
    end
    for key, label in pairs(WeaponLoader.rarityMap) do
        if recordId:lower():find(key) then
            return label
        end
    end

    return val ~= "" and val or "Standard"
end

function WeaponLoader:LoadAll()
    local records = TweakDB:GetRecords("gamedataWeaponItem_Record")
    if not records or #records == 0 then
        Logger.Log("WeaponLoader: No weapon records found.")
        return
    end

    for _, rec in ipairs(records) do
        local id = utils.SafeCall(function() return rec:GetID().value end)
        if id and id:find("^Items%.") then
            local tags = utils.GetTags(rec)

            local data = {
                id = id,
                displayName = utils.EscapeString(
                    utils.SafeCall(function()
                        return Game.GetLocalizedTextByKey(rec:DisplayName())
                    end) or "Unknown"
                ),
                type = GetType(tags),
                rarity = GetRarity(id, rec),
                manufacturer = utils.EscapeString(
                    utils.SafeCall(function()
                        return rec:Manufacturer():Name()
                    end) or "Unlisted"
                ),
                iconic = utils.HasTag(tags, "iconicweapon"),
                isTech = utils.HasTag(tags, "techweapon"),
                isSmart = utils.HasTag(tags, "smartweapon"),
                isPower = utils.HasTag(tags, "powerweapon"),
                onWall = WeaponLoader.wallWeaponIds[id] == true,
                tags = tags
            }

            table.insert(self.weapons, data)
            self.indexById[id] = data
        end
    end

    Logger.Log(string.format("WeaponLoader: Loaded %d weapons.", #self.weapons))
end

function WeaponLoader:GetAll()
    return self.weapons
end

function WeaponLoader:GetById(id)
    return self.indexById[id]
end

function WeaponLoader:GetByCategory(category, opts)
    opts = opts or {}
    return self:Filter(function(w)
        if w.type ~= category then return false end
        if opts.tech == false and w.isTech then return false end
        if opts.smart == false and w.isSmart then return false end
        if opts.power == false and w.isPower then return false end
        return true
    end)
end

function WeaponLoader:GetByRarity(rarity)
    local r = (rarity or ""):lower()
    return self:Filter(function(w) return (w.rarity or ""):lower() == r end)
end

function WeaponLoader:GetAllRarities()
    local seen, rarities = {}, {}
    for _, w in ipairs(self.weapons) do
        local r = (w.rarity or ""):lower()
        if not seen[r] then
            seen[r] = true
            table.insert(rarities, w.rarity)
        end
    end
    table.sort(rarities)
    return rarities
end

function WeaponLoader:GetTypes()
    local seen, types = {}, {}
    for _, w in ipairs(self.weapons) do
        if not seen[w.type] then
            seen[w.type] = true
            table.insert(types, w.type)
        end
    end
    table.sort(types)
    return types
end


function WeaponLoader:GetRarityWeight(w)
    if w.iconic then return rarityOrder["iconic"] end
    return rarityOrder[(w.rarity or ""):lower()] or 0
end

function WeaponLoader:GetWall()
    return self:Filter(function(w) return w.onWall end)
end

function WeaponLoader:GetIconic()
    return self:Filter(function(w) return w.iconic end)
end

function WeaponLoader:Filter(fn)
    local out = {}
    for _, w in ipairs(self.weapons) do
        if fn(w) then
            table.insert(out, w)
        end
    end
    return out
end

return WeaponLoader
