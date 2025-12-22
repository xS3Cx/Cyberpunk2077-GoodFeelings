local Utils = {}

function Utils.SafeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok and res or nil
end

function Utils.EscapeString(s)
    if type(s) ~= "string" or s == "" then
        return "Unknown"
    end
    return s:gsub("([\\\"])", "\\%1")
end

function Utils.Count(t)
    local c = 0
    for _ in pairs(t) do c = c + 1 end
    return c
end

function Utils.StripRichText(text)
    if not text then return "" end
    text = text:gsub("{float_%d+}", " ")
    text = text:gsub("{int_%d+}", " ")
    text = text:gsub("<.->", "")
    text = text:gsub("[+%%]+", "")
    text = text:gsub("%s+", " ")
    text = text:gsub("^%s*(.-)%s*$", "%1")
    return text
end

function Utils.GetLocalizedText(locKeyStr)
    if not locKeyStr or locKeyStr == "" then return "Unknown" end
    local numID = tostring(locKeyStr):upper():match("LOCKEY#(%d+)")
    if not numID then return locKeyStr end

    local ok, result = pcall(function()
        return Game.GetLocalizedTextByKey(CName.new(tonumber(numID)))
    end)

    return ok and result or locKeyStr
end

function Utils.GetLocalizedSafe(key)
    local result = Utils.SafeCall(function()
        return Game.GetLocalizedTextByKey(key)
    end)
    if result and result ~= "Label Not Found" then
        return result
    end
    return nil
end

function Utils.GetTags(record)
    local raw = Utils.SafeCall(function() return record:Tags() end)
    if type(raw) ~= "table" then return {} end
    local out = {}
    for _, tag in ipairs(raw) do
        if tag.value then table.insert(out, tag.value) end
    end
    return out
end

function Utils.HasTag(tags, name)
    for _, tag in ipairs(tags) do
        if tag:lower() == name:lower() then
            return true
        end
    end
    return false
end

function Utils.InferQuality(id)
    local patterns = {
        legendaryplusplus = "Legendary++",
        legendaryplus = "Legendary+",
        legendary = "Legendary",
        epicplus = "Epic+",
        epic = "Epic",
        rareplus = "Rare+",
        rare = "Rare",
        uncommon = "Uncommon",
        common = "Common",
        iconic = "Iconic"
    }
    id = id:lower()
    for key, label in pairs(patterns) do
        if id:find(key) then return label end
    end
    return "Unknown"
end

function Utils.GetDisplayName(record, fallbackType)
    local name = nil
    local key = Utils.SafeCall(function() return record:DisplayName() end)
    if key then name = Utils.GetLocalizedSafe(key) end

    if not name and fallbackType then
        name = Utils.GetLocalizedSafe("Items." .. fallbackType)
    end

    return Utils.EscapeString(name or fallbackType or "Unknown")
end

function Utils.GetDescription(record)
    local key = Utils.SafeCall(function() return record:LocalizedDescription() end)
    if key then
        local text = Utils.GetLocalizedSafe(key)
        if text then return Utils.EscapeString(text) end
    end
    return "Unknown"
end

function Utils.TableMerge(...)
    local result = {}
    for i = 1, select("#", ...) do
        local t = select(i, ...)
        if type(t) == "table" then
            for _, v in ipairs(t) do
                table.insert(result, v)
            end
        end
    end
    return result
end


return Utils
