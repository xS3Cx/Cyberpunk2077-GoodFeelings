local UI = require("UI")
local Buttons = UI.Buttons
local Notification = UI.Notification

local Teleport = require("Utils/Teleport")
local TeleportLocations = require("Features/Teleports/TeleportLocations")
local AutoTeleport = require("Features/Teleports/AutoTeleport")
local Settings = require("Features/Teleports/TeleportViewStates")

local CustomTeleportView = require("View/Teleports/CustomTeleportView")

local selectedCreator = { index = 1 }
local currentTeleportCategory = ""
local creatorList = {}

local quickTeleport = { index = 1 }
local quickOptions = {}

local selectedParentDistrict = { index = 1 }
local selectedChildDistrict = { index = 1 }
local parentOptions, childOptions = { "teleport.district_all" }, { "teleport.area_all" }


local function FormatDistance(dist)
    if not dist then return "" end
    return dist >= 1000 and string.format("%.2f km", dist / 1000) or string.format("%d m", math.floor(dist))
end

local quickOptions = {}

local function BuildQuickOptions()
    quickOptions = {}

    local vendorPrefix = L("teleport.quick_closest_vendor")
    for cat in pairs(TeleportLocations.GetVendors()) do
        table.insert(quickOptions, {
            type = "vendor",
            key = cat,
            label = vendorPrefix .. " " .. cat
        })
    end

    local aptPrefix = L("teleport.quick_apartment")
    for _, apt in ipairs(TeleportLocations.GetApartments()) do
        table.insert(quickOptions, {
            type = "apartment",
            key = apt.name,
            label = aptPrefix .. ": " .. apt.name
        })
    end

    table.sort(quickOptions, function(a, b) return a.label < b.label end)
end


local function BuildCreatorList()
    creatorList = { L("teleport.creator_all") }
    local seen = { [L("teleport.creator_all")] = true }
    for _, loc in ipairs(TeleportLocations.GetAll()) do
        if not seen[loc.creator] then
            table.insert(creatorList, loc.creator)
            seen[loc.creator] = true
        end
    end
    table.sort(creatorList, function(a, b)
        if a == L("teleport.creator_all") then return true end
        if b == L("teleport.creator_all") then return false end
        return a < b
    end)
end

local function BuildParentOptions()
    parentOptions = { L("teleport.district_all") }
    local seen = { [L("teleport.district_all")] = true }
    for _, loc in ipairs(TeleportLocations.GetAll()) do
        local parent = loc.parentDistrict or L("teleport.district_unknown")
        if not seen[parent] then
            table.insert(parentOptions, parent)
            seen[parent] = true
        end
    end
    selectedParentDistrict.index = 1
end

local function BuildChildOptionsForParent(parentFilter)
    childOptions = { L("teleport.area_all") }
    local seen = { [L("teleport.area_all")] = true }
    for _, loc in ipairs(TeleportLocations.GetAll()) do
        local parent = loc.parentDistrict or L("teleport.district_unknown")
        local child = loc.childDistrict or L("teleport.area_unknown")
        if parentFilter == L("teleport.district_all") or parent == parentFilter then
            if not seen[child] then
                table.insert(childOptions, child)
                seen[child] = true
            end
        end
    end
    selectedChildDistrict.index = 1
end

local function PassesDistrictFilter(loc)
    local parentFilter = parentOptions[selectedParentDistrict.index] or L("teleport.district_all")
    local childFilter = childOptions[selectedChildDistrict.index] or L("teleport.area_all")
    if parentFilter ~= L("teleport.district_all") and loc.parentDistrict ~= parentFilter then return false end
    if childFilter ~= L("teleport.area_all") and loc.childDistrict ~= childFilter then return false end
    return true
end

local function FilteredCategoryView()
    local creator = creatorList[selectedCreator.index or 1]
    local playerPos = Game.GetPlayer() and Game.GetPlayer():GetWorldPosition()

    for _, loc in ipairs(TeleportLocations.GetAll()) do
        if loc.category == currentTeleportCategory
            and (creator == L("teleport.creator_all") or loc.creator == creator)
            and PassesDistrictFilter(loc) then
            local dist = playerPos and Teleport.DistanceBetween(playerPos, loc.position) or nil
            local distLabel = (Settings.showCategoryDistance.value and FormatDistance(dist)) or ""

            if Buttons.OptionExtended(
                    loc.name,
                    "",
                    distLabel ~= "" and distLabel or IconGlyphs.MapMarker,
                    tip("teleport.teleportoption.tip", {
                        creator = loc.creator,
                        category = loc.category,
                        district_parent = loc.parentDistrict or "?",
                        district_child = loc.childDistrict or "?",
                        location_name = loc.name
                    })
                ) then
                Teleport.TeleportEntity(Game.GetPlayer(), loc.position)
            end
        end
    end
end

local filteredCategorySubmenu = { title = L("teleport.selectedteleports.label"), view = FilteredCategoryView }

local function GetFilteredCategories()
    local seen, filtered = {}, {}
    local creator = creatorList[selectedCreator.index or 1]

    for _, loc in ipairs(TeleportLocations.GetAll()) do
        if (creator == L("teleport.creator_all") or loc.creator == creator)
            and PassesDistrictFilter(loc) then
            if not seen[loc.category] then
                table.insert(filtered, loc.category)
                seen[loc.category] = true
            end
        end
    end

    -- Split into priority then normal
    -- (teleport's listed in the priority array That I believe people will use most can be adjusted in the file)
    local prioritySet, priority, normal = {}, {}, {}
    for _, cat in ipairs(TeleportLocations.GetPriority()) do
        prioritySet[cat] = true
    end

    for _, cat in ipairs(filtered) do
        if prioritySet[cat] then
            table.insert(priority, cat)
        else
            table.insert(normal, cat)
        end
    end

    table.sort(priority)
    table.sort(normal)

    local final = {}
    for _, cat in ipairs(priority) do table.insert(final, cat) end
    for _, cat in ipairs(normal) do table.insert(final, cat) end

    return final
end

local function GetQuickOptionDistance(option)
    if not option then return nil end

    local player = Game.GetPlayer()
    if not player then return nil end
    local playerPos = player:GetWorldPosition()
    if not playerPos then return nil end

    if option.type == "vendor" then
        local vendors = TeleportLocations.GetVendors()[option.key]
        if vendors then
            local nearestDist = math.huge
            for _, v in ipairs(vendors) do
                local dist = Teleport.DistanceBetween(playerPos, v.position)
                if dist < nearestDist then
                    nearestDist = dist
                end
            end
            return nearestDist ~= math.huge and nearestDist or nil
        end
    elseif option.type == "apartment" then
        for _, apt in ipairs(TeleportLocations.GetApartments()) do
            if apt.name == option.key then
                return Teleport.DistanceFromPlayer(apt.position)
            end
        end
    end

    return nil
end

local function DoQuickTeleport(option)
    if not option then return end
    local player = Game.GetPlayer()
    if not player then return end

    if option.type == "vendor" then
        local vendors = TeleportLocations.GetVendors()[option.key]
        if vendors then
            local nearest, nearestDist = nil, math.huge
            local playerPos = player:GetWorldPosition()
            for _, v in ipairs(vendors) do
                local dist = Teleport.DistanceBetween(playerPos, v.position)
                if dist < nearestDist then nearest, nearestDist = v, dist end
            end
            if nearest then
                Teleport.TeleportEntity(player, nearest.position)

                local msg = L("teleport.quick_closest_vendor_notify")
                    .. " " .. option.key
                    .. " (" .. nearest.name .. ")"

                Notification.Info(msg)
            end
        end

    elseif option.type == "apartment" then
        for _, apt in ipairs(TeleportLocations.GetApartments()) do
            if apt.name == option.key then
                Teleport.TeleportEntity(player, apt.position)

                local msg = L("teleport.quick_apartment_notify")
                    .. ": " .. apt.name

                Notification.Info(msg)
                break
            end
        end
    end
end


local onInit = false
local forwardRef = { value = 2, min = 1, max = 25 }

local function TeleportSettingsView()
    Buttons.Option(L("teleport.reloadteleports.label"), L("teleport.reloadteleports.tip"), TeleportLocations.Reload)
    Buttons.Break("", L("teleport.customteleports.label"))
    CustomTeleportView.view()
    Buttons.Break("", L("teleport.autoteleports.label"))

    Buttons.Toggle(L("teleport.autowaypoint.label"), AutoTeleport.toggleAutoWaypoint, L("teleport.autowaypoint.tip"))
    Buttons.Toggle(L("teleport.autoquest.label"), AutoTeleport.toggleAutoQuest, L("teleport.autoquest.tip"))
    Buttons.Break("", L("teleport.Settings.label"))
    Buttons.Toggle(L("teleport.showforward.label"), Settings.showForward, L("teleport.showforward.tip"))
    Buttons.Toggle(L("teleport.showquick.label"), Settings.showQuick, L("teleport.showquick.tip"))
    Buttons.Toggle(L("teleport.showquickdistance.label"), Settings.showQuickDistance, L("teleport.showquickdistance.tip"))
    Buttons.Toggle(L("teleport.showcategorydistance.label"), Settings.showCategoryDistance,
        L("teleport.showcategorydistance.tip"))
    Buttons.Toggle(L("teleport.showdistrictfilter.label"), Settings.showDistrictFilter,
        L("teleport.showdistrictfilter.tip"))
    Buttons.Toggle(L("teleport.showcreatorfilter.label"), Settings.showCreatorFilter, L("teleport.showcreatorfilter.tip"))
end

local settingsSubmenu = { title = L("teleport.settingssubmenu.label"), view = TeleportSettingsView }

function TeleportMenuView()
    if not onInit then
        BuildCreatorList()
        BuildQuickOptions()
        BuildParentOptions()
        BuildChildOptionsForParent(L("teleport.district_all"))
        onInit = true
    end
    Buttons.Submenu(L("teleport.miscsubmenu.label"), settingsSubmenu, L("teleport.miscsubmenu.tip"))
    if Settings.showForward.value then
        Buttons.Int(L("teleport.forwarddistance.label"), forwardRef, L("teleport.forwarddistance.tip"))
        if Buttons.Option(L("teleport.teleportforward.label"), L("teleport.teleportforward.tip")) then
            local pos = Teleport.GetForwardOffset(forwardRef.value)
            Teleport.TeleportEntity(Game.GetPlayer(), pos)
        end
    end
    if Settings.showQuick.value then
        Buttons.Break("", L("teleport.quickteleports.label"))
        Buttons.Option(L("teleport.questmarker.label"), L("teleport.questmarker.tip"), function()
            Teleport.ToQuestMarker()
        end)
        Buttons.Option(L("teleport.waypointmarker.label"), L("teleport.waypointmarker.tip"), function()
            Teleport.ToWaypoint()
        end)

        local option = quickOptions[quickTeleport.index]
        local label = L("teleport.quickcycler.label")
        if Settings.showQuickDistance.value and option then
            local distText = GetQuickOptionDistance(option)
            label = label .. " (" .. FormatDistance(distText) .. ")"
        end

        local quickLabels = {}
        for _, o in ipairs(quickOptions) do
            table.insert(quickLabels, o.label)
        end

        if Buttons.StringCyclerClick(label, quickTeleport, quickLabels, L("teleport.quickcycler.tip")) then
            if option then DoQuickTeleport(option) end
        end
    end


    if Settings.showCreatorFilter.value or Settings.showDistrictFilter.value then
        Buttons.Break("", L("teleport.filters.label"))

        if Settings.showDistrictFilter.value then
            if Buttons.StringCycler(L("teleport.district.label"), selectedParentDistrict, parentOptions, L("teleport.district.tip")) then
                BuildChildOptionsForParent(parentOptions[selectedParentDistrict.index])
                selectedChildDistrict.index = 1
            end
            Buttons.StringCycler(L("teleport.area.label"), selectedChildDistrict, childOptions, L("teleport.area.tip"))
        end

        if Settings.showCreatorFilter.value then
            Buttons.Dropdown(L("teleport.creator.label"), selectedCreator, creatorList, L("teleport.creator.tip"))
        end
    end

    Buttons.Break("", L("teleport.categoriesbreak.label"))
    for _, category in ipairs(GetFilteredCategories()) do
        Buttons.Submenu(
            category,
            filteredCategorySubmenu,
            tip("teleport.categorysubmenu.tip", { category = category }),
            function() currentTeleportCategory = category end
        )
    end
end

return { 
    title = "teleport.title", 
    view = TeleportMenuView,
    Settings = Settings
}
