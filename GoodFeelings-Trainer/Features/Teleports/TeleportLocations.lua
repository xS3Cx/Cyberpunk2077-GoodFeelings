local Logger = require("Core/Logger")
local JsonHelper = require("Core/JsonHelper")

local TeleportLocations = {}

local apartments = { -- Hard coded apartments for quick tp
    { name = "Corpo Plaza", category = "V's Apartment", position = { x = -1598.990723, y = 359.183655, z = 48.620003 } },
    { name = "Dogtown", category = "V's Apartment", position = { x = -2232.448486, y = -2560.21875, z = 80.270355 } },
    { name = "The Glen", category = "V's Apartment", position = { x = -1524.231445, y = -985.826355, z = 86.940002 } },
    { name = "H10 Megabuilding", category = "V's Apartment", position = { x = -1378.424927, y = 1273.94043, z = 123.033356 } },
    { name = "Japantown", category = "V's Apartment", position = { x = -785.826416, y = 987.398376, z = 28.209541 } },
    { name = "Northside", category = "V's Apartment", position = { x = -1507.223022, y = 2232.709229, z = 22.2108 } },
}

local cache = {
    all = {},
    vendors = {},
    apartments = apartments,
    categories = {},
    districts = {},
    priority = {}
}

local TeleportFile = "Config/JSON/Teleports.json"

local function isVendor(entry)
    return entry.category and entry.category:lower():find("vendor")
end

function TeleportLocations.LoadAll()
    local data, err = JsonHelper.Read(TeleportFile)
    if not data then
        Logger.Log(string.format("teleportlocations: failed to load '%s': %s", TeleportFile, tostring(err)))
        cache.all, cache.vendors, cache.categories, cache.districts, cache.priority = {}, {}, {}, {}, {}
        return
    end

    -- Handle new structure: { priority = {...}, teleports = {...} }
    local teleports = data.teleports or {}
    cache.priority = data.priority or {}

    cache.all = teleports
    cache.vendors = {}
    cache.categories = {}
    cache.districts = {}

    for _, entry in ipairs(teleports) do
        -- Vendors
        if isVendor(entry) then
            local cat = entry.category
            cache.vendors[cat] = cache.vendors[cat] or {}
            table.insert(cache.vendors[cat], entry)
        end

        -- Categories
        local category = entry.category or "Uncategorized"
        cache.categories[category] = cache.categories[category] or {}
        table.insert(cache.categories[category], entry)

        -- Districts
        local parent = entry.parentDistrict or "Unknown District"
        local child = entry.childDistrict or "Unknown District"
        local key = parent .. " / " .. child
        cache.districts[key] = cache.districts[key] or {}
        table.insert(cache.districts[key], entry)
    end

    Logger.Log(string.format(
        "teleportlocations: loaded %d teleports across %d categories and %d districts. Added %d categories to Priority list.",
        #cache.all,
        (function() local n=0 for _ in pairs(cache.categories) do n=n+1 end return n end)(),
        (function() local n=0 for _ in pairs(cache.districts) do n=n+1 end return n end)(),
        #cache.priority
    ))
end

function TeleportLocations.GetAll()
    return cache.all
end

function TeleportLocations.GetVendors()
    return cache.vendors
end

function TeleportLocations.GetApartments()
    return cache.apartments
end

function TeleportLocations.GetCategories()
    return cache.categories
end

function TeleportLocations.GetDistricts()
    return cache.districts
end

function TeleportLocations.GetPriority()
    return cache.priority
end

function TeleportLocations.Reload()
    Logger.Log("teleportlocations: reloading teleport locations...")
    TeleportLocations.LoadAll()
end

return TeleportLocations
