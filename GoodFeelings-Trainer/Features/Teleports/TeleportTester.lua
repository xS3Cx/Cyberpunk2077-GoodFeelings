local JsonHelper = require("Core/JsonHelper")
local Logger = require("Core/Logger")
local World = require("Utils/World")
local Cron = require("Core/cp2077-cet-kit/Cron")

local TeleportTester = {}

local teleports = {}
local index = 1
local attempts = 0
local savePath = nil

-- Apparently the parent district can sometimes become the child district depending on the area you're in
-- This helps normalize that keeping it a bit more organized making sure the parent districts always stay the parent districts 
-- and if it finds a child district as a parent district it fixes up

local DistrictMap = { -- Data based on https://cyberpunk.fandom.com/wiki
    ["City Center"] = { "Corporate Center", "Downtown", "Corporate Plaza" },
    ["Heywood"] = { "The Glen", "Vista Del Rey", "Wellsprings", "Moto Cielo", "Welles' House" },
    ["Pacifica"] = { "Coastview", "West Wind Estate", "Dogtown" },
    ["Santo Domingo"] = { "Arroyo", "Rancho Coronado" },
    ["Watson"] = { "Arasaka Waterfront", "Kabuki", "Little China", "Northside" },
    ["Westbrook"] = { "Charter Hill", "Japantown", "North Oak" },
    ["Badlands"] = {
        "Red Peaks", "Rocky Ridge", "Sierra Sonora", "Vasquez Pass",
        "Biotechnica Flats", "Jackson Plains", "Rattlesnake Creek", "Laguna Bend",
        "Southern Badlands", "Eastern Wastelands"
    }
}

local ChildToParent = {}
for parent, children in pairs(DistrictMap) do
    for _, child in ipairs(children) do
        ChildToParent[child] = parent
    end
end

local function NormalizeDistricts(parent, child)

    if (not DistrictMap[parent]) and (parent == "Unknown District") and ChildToParent[child] then
        local realParent = ChildToParent[child]
        return realParent, child, "Unknown District"
    end

    if DistrictMap[parent] then
        return parent, child, "Unknown District"
    end

    if ChildToParent[parent] then
        local realParent = ChildToParent[parent]
        local realChild = parent
        local misc = (child and child ~= "Unknown District") and child or "Unknown District"
        return realParent, realChild, misc
    end

    if DistrictMap[child] then
        return child, "Unknown District", "Unknown District"
    end

    return parent or "Unknown District", child or "Unknown District", "Unknown District"
end

local function SaveResult(tp)
    if not savePath then return end
    local outPath = savePath:gsub("%.json$", "_results.json")

    local existing = JsonHelper.Read(outPath)
    if type(existing) ~= "table" then
        existing = {}
    end

    table.insert(existing, {
        name = tp.name,
        position = tp.position,
        parentDistrict = tp.parentDistrict,
        childDistrict = tp.childDistrict,
        miscDistrict = tp.miscDistrict,
        category = tp.category,
    })

    JsonHelper.Write(outPath, existing)
    Logger.Log("TeleportTester: saved " .. tp.name .. " to " .. outPath)
end


local function TryCheckDistrict(tp)
    local parent, child = World.GetCurrentDistrictName()

    if parent ~= "Unknown District" or child ~= "Unknown District" then
        local normParent, normChild, misc = NormalizeDistricts(parent, child)
        tp.parentDistrict = normParent
        tp.childDistrict = normChild
        tp.miscDistrict = misc
        SaveResult(tp)
        Logger.Log(string.format("Result: %s -> %s / %s (misc=%s)",
            tp.name, normParent, normChild, misc))
        Cron.After(0.5, TeleportTester.Next)
        return
    end

    attempts = attempts + 1
    if attempts >= 10 then
        tp.parentDistrict = "Unknown District"
        tp.childDistrict = "Unknown District"
        tp.miscDistrict = "Unknown District"
        Logger.Log(string.format("Result: %s -> Unknown District", tp.name))
        Cron.After(0.5, TeleportTester.Next)
    else
        Cron.After(1.0, function() TryCheckDistrict(tp) end)
    end
end

function TeleportTester.Next()
    if index > #teleports then
        Logger.Log("TeleportTester: sweep finished.")
        return
    end

    local tp = teleports[index]
    index = index + 1
    attempts = 0

    if tp and tp.position then
        Logger.Log(string.format("TeleportTester: [%d/%d] Teleporting to %s",
            index - 1, #teleports, tp.name))
        
        Game.GetTeleportationFacility():Teleport(
            Game.GetPlayer(),
            Vector4.new(tp.position.x, tp.position.y, tp.position.z, 1.0),
            EulerAngles.new(0, 0, 0)
        )

        Cron.After(1.0, function() TryCheckDistrict(tp) end)
    else
        TeleportTester.Next()
    end
end

function TeleportTester.RunSweep(path)
    local data, err = JsonHelper.Read(path)
    if not data then
        Logger.Log("TeleportTester: failed to load teleports.json: " .. tostring(err))
        return
    end
    teleports, index, savePath = data, 1, path
    Logger.Log(string.format("TeleportTester: loaded %d teleports", #teleports))
    TeleportTester.Next()
end

return TeleportTester
