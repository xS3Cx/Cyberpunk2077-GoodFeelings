local Logger = require("Core/Logger")
local utils = require("Utils/DataExtractors/DataUtils")

local PerkLoader = {
    attribute = {},
    indexById = {},
    categoryNames = {}
}

local perkCatKeys = {
    { key = "Body", value = "Body" },
    { key = "Cool", value = "Cool" },
    { key = "Intelligence", value = "Intelligence" },
    { key = "Reflexes", value = "Reflexes" },
    { key = "Tech", value = "Technical Ability" },
    { key = "Espionage", value = "Relic" },
}

local function GuessAttributeFromId(id)
    if not id then return "Unknown" end
    for _, entry in ipairs(perkCatKeys) do
        if id:find(entry.key, 1, true) then
            return entry.value
        end
    end
    return "Unknown"
end

local function GetRequirements(rec)
    local requirements = { perks = {}, prereqId = nil }

    if not rec then return requirements end

    local count = rec:GetRequiresPerksCount()
    for i = 0, count - 1 do
        local reqRec = rec:GetRequiresPerksItem(i)
        if reqRec then
            local reqId   = reqRec:GetID().value
            local reqName = utils.GetLocalizedText(reqRec:Loc_name_key())
            local reqType = reqRec:Type()

            table.insert(requirements.perks, {
                id = reqId,  
                name = reqName,
                type = reqType 
            })
        end
    end

    local prereqRec = rec:Requirement()
    if prereqRec then
        requirements.prereqId = prereqRec:GetID().value
    end

    return requirements
end


function PerkLoader:LoadAll()
    local perkRecords = TweakDB:GetRecords("gamedataNewPerk_Record")
    if not perkRecords or #perkRecords == 0 then
        Logger.Log("PerkLoader: No perk records found.")
        return
    end

    for _, rec in ipairs(perkRecords) do
        local id = utils.SafeCall(function() return rec:GetID().value end)
        if id then
            local catRecord = rec:Category()
            local catId = catRecord and catRecord:GetID().value or "Unknown"
            local catName = self.categoryNames[catId]

            if not catName and catRecord then
                catName = catRecord:EnumComment() or tostring(catRecord:EnumName())
                self.categoryNames[catId] = catName
            end

            local attribute = GuessAttributeFromId(id)
            local data = {
                id = id,
                name = utils.GetLocalizedText(rec:Loc_name_key()),
                description = utils.StripRichText(utils.GetLocalizedText(rec:Loc_desc_key())),
                category = catName or "Uncategorized",
                attribute = attribute,
                type = rec:Type(),
                requirements = GetRequirements(rec)
            }

            

            self.attribute[attribute] = self.attribute[attribute] or {}
            self.attribute[attribute][id] = data
            self.indexById[id] = data
        end
    end

    Logger.Log(string.format(
        "PerkLoader: Loaded %d perks across %d attributes.",
        utils.Count(self.indexById),
        utils.Count(self.attribute)
    ))
end

function PerkLoader:GetAll()
    return self.indexById
end

function PerkLoader:GetById(id)
    return self.indexById[id]
end

return PerkLoader
