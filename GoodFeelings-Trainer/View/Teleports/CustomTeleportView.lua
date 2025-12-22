local Buttons = require("UI").Buttons
local TextInput = require("UI/Options/TextInput")
local Notification = require("UI").Notification

local JsonHelper = require("Core/JsonHelper")
local World = require("Utils/World")
local TeleportLocations = require("Features/Teleports/TeleportLocations")

local nameRef = { value = L("teleport.customteleportview.defaults.name"), capturing = false }
local creatorRef = { value = L("teleport.customteleportview.defaults.creator"), capturing = false }
local categoryRef = { index = 1 }
local categories = { L("teleport.customteleportview.defaults.category") }

local offsetX = { value = 0, min = -3000, max = 3000 }
local offsetY = { value = 0, min = -3000, max = 3000 }
local offsetZ = { value = 0, min = -3000, max = 3000 }

local parentDistrict, childDistrict =
    L("teleport.customteleportview.defaults.parentDistrict"), L("teleport.customteleportview.defaults.childDistrict")

local function ValidateTeleport(entry)
    if not entry.name or entry.name == "" then
        Notification.Error("Please enter name for teleport")
        return false
    end
    return true
end

local function BuildCategories()
    categories = { "Custom" }
    local seen = { Custom = true }
    for _, loc in ipairs(TeleportLocations.GetAll()) do
        if not seen[loc.category] then
            table.insert(categories, loc.category)
            seen[loc.category] = true
        end
    end
end

local function SaveCustomTeleport()
    local player = Game.GetPlayer()
    if not player then return end
    local pos = player:GetWorldPosition()
    if not pos then return end

    local finalPos = {
        x = pos.x + offsetX.value,
        y = pos.y + offsetY.value,
        z = pos.z + offsetZ.value
    }

    local parent, child = World.GetCurrentDistrictName()

    local entry = {
        name = nameRef.value ~= "" and nameRef.value,
        position = finalPos,
        parentDistrict = parent or L("teleport.customteleportview.defaults.parentDistrict"),
        childDistrict = child or L("teleport.customteleportview.defaults.childDistrict"),
        category = categories[categoryRef.index] or L("teleport.customteleportview.defaults.category"),
        creator = creatorRef.value or L("teleport.customteleportview.defaults.creator")
    }

    if not ValidateTeleport(entry) then return end

    local path = "Config/JSON/Teleports.json"
    local data, _ = JsonHelper.Read(path)
    if type(data) ~= "table" then
        data = { teleports = {} }
    elseif type(data.teleports) ~= "table" then
        data.teleports = {}
    end

    table.insert(data.teleports, entry)
    JsonHelper.Write(path, data)

    Notification.Success(tip("teleport.customteleportview.notifications.saved", {
        name = entry.name,
        parent = entry.parentDistrict,
        child = entry.childDistrict,
        x = string.format("%.2f", finalPos.x),
        y = string.format("%.2f", finalPos.y),
        z = string.format("%.2f", finalPos.z)
    }))
end


local basePos = nil
local function CaptureBasePosition()
    local player = Game.GetPlayer()
    if not player then return end
    basePos = player:GetWorldPosition()
    parentDistrict, childDistrict = World.GetCurrentDistrictName()
end

local initialized = false
local function CustomTeleportViewFunction()
    if not initialized then
        BuildCategories()
        initialized = true
    end
    -- parentDistrict, childDistrict = World.GetCurrentDistrictName()

    -- CaptureBasePosition()
    Buttons.Text(L("teleport.customteleportview.name.label"), nameRef, L("teleport.customteleportview.name.tip"))
    Buttons.Text(L("teleport.customteleportview.creator.label"), creatorRef,
        L("teleport.customteleportview.creator.tip"))


    Buttons.StringCycler(L("teleport.customteleportview.category.label"), categoryRef, categories,
        L("teleport.customteleportview.category.tip"))



    -- Buttons.Break("Fine Tune Position")
    -- Buttons.Int("Offset X", offsetX, "Adjust X coordinate offset")
    -- Buttons.Int("Offset Y", offsetY, "Adjust Y coordinate offset")
    -- Buttons.Int("Offset Z", offsetZ, "Adjust Z coordinate offset")

    -- Buttons.Break("District Info")
    -- Buttons.OptionExtended("Parent District", "", parentDistrict, "Current parent district")
    -- Buttons.OptionExtended("Child District", "", childDistrict, "Current child district")

    -- Buttons.Break("Debug Info") -- I feel like this would break stuff
    -- local player = Game.GetPlayer()
    -- if player then
    -- local pos = player:GetWorldPosition()
    --  if pos then
    --  Buttons.OptionExtended("X", "", string.format("%.2f", pos.x), "Raw X coordinate")
    --  Buttons.OptionExtended("Y", "", string.format("%.2f", pos.y), "Raw Y coordinate")
    --  Buttons.OptionExtended("Z", "", string.format("%.2f", pos.z), "Raw Z coordinate")
    --   end
    --  end

    if Buttons.Option(L("teleport.customteleportview.save.label"), L("teleport.customteleportview.save.tip")) then
        SaveCustomTeleport()
    end
end

local CustomTeleportView = { title = L("teleport.customteleportview.title"), view = CustomTeleportViewFunction }
return CustomTeleportView
