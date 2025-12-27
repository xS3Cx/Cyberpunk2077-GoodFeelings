local PerkLoader = require("Utils/DataExtractors/PerkLoader")
local PlayerDevelopment = require("Utils").PlayerDevelopment
local Inventory = require("Utils").Inventory
local Buttons = require("UI").Buttons
local Logger = require("Core/Logger")
local Notification = require("UI").Notification


local selectedAttribute = { index = 1, expanded = false }
local attributeOptions = {
    "playerdev.attributes.body",
    "playerdev.attributes.cool",
    "playerdev.attributes.intelligence",
    "playerdev.attributes.reflexes",
    "playerdev.attributes.technical",
    "playerdev.attributes.relic"
}

local perkFilter = { index = 1 }
local perkFilterOptions = {
    "playerdev.perks.filter.all",
    "playerdev.perks.filter.active",
    "playerdev.perks.filter.inactive"
}

local attributeIdMap = {
    ["playerdev.attributes.body"] = "Body",
    ["playerdev.attributes.cool"] = "Cool",
    ["playerdev.attributes.intelligence"] = "Intelligence",
    ["playerdev.attributes.reflexes"] = "Reflexes",
    ["playerdev.attributes.technical"] = "Technical Ability",
    ["playerdev.attributes.relic"] = "Relic"
}

local attributeLevel = { value = 5, min = 1, max = 20 }
local showActiveOnly = { value = false }
local showInactiveOnly = { value = false }
local lastSelectedIndex = -1

local statTypeMap = {
    ["Body"] = gamedataStatType.Strength,
    ["Cool"] = gamedataStatType.Cool,
    ["Intelligence"] = gamedataStatType.Intelligence,
    ["Reflexes"] = gamedataStatType.Reflexes,
    ["Technical Ability"] = gamedataStatType.TechnicalAbility,
    ["Relic"] = gamedataStatType.Espionage
}

local initializedLevels = false
local profLevels = {}

local Proficiencies = {
    { name = "playerdev.proficiencies.playerlevel", type = gamedataProficiencyType.Level },
    { name = "playerdev.proficiencies.streetcred", type = gamedataProficiencyType.StreetCred },
    { name = "playerdev.proficiencies.assault", type = gamedataProficiencyType.Assault },
    { name = "playerdev.proficiencies.athletics", type = gamedataProficiencyType.Athletics },
    { name = "playerdev.proficiencies.brawling", type = gamedataProficiencyType.Brawling },
    { name = "playerdev.proficiencies.coldblood", type = gamedataProficiencyType.ColdBlood },
    { name = "playerdev.proficiencies.combathacking", type = gamedataProficiencyType.CombatHacking },
    { name = "playerdev.proficiencies.cool", type = gamedataProficiencyType.CoolSkill },
    { name = "playerdev.proficiencies.crafting", type = gamedataProficiencyType.Crafting },
    { name = "playerdev.proficiencies.demolition", type = gamedataProficiencyType.Demolition },
    { name = "playerdev.proficiencies.engineering", type = gamedataProficiencyType.Engineering },
    { name = "playerdev.proficiencies.espionage", type = gamedataProficiencyType.Espionage },
    { name = "playerdev.proficiencies.gunslinger", type = gamedataProficiencyType.Gunslinger },
    { name = "playerdev.proficiencies.hacking", type = gamedataProficiencyType.Hacking },
    { name = "playerdev.proficiencies.intelligence", type = gamedataProficiencyType.IntelligenceSkill },
    { name = "playerdev.proficiencies.kenjutsu", type = gamedataProficiencyType.Kenjutsu },
    { name = "playerdev.proficiencies.reflexes", type = gamedataProficiencyType.ReflexesSkill },
    { name = "playerdev.proficiencies.stealth", type = gamedataProficiencyType.Stealth },
    { name = "playerdev.proficiencies.strength", type = gamedataProficiencyType.StrengthSkill },
    { name = "playerdev.proficiencies.technical", type = gamedataProficiencyType.TechnicalAbilitySkill }
}

local function InitProficiencies()
    if initializedLevels then return end
    initializedLevels = true
    for _, prof in ipairs(Proficiencies) do
        local value = PlayerDevelopment.GetLevel(prof.type) or 1
        local max = PlayerDevelopment.GetMaxLevel(prof.type)
        profLevels[prof.name] = { ref = { value = value, min = 0, max = max, step = 1 }, type = prof.type }
    end
end

local function ProficiencyView()
    InitProficiencies()
    for _, prof in ipairs(Proficiencies) do
        local entry = profLevels[prof.name]
        Buttons.Int(L(prof.name), entry.ref, tip("playerdev.proficiencies.tip", { name = L(prof.name) }), function()
            PlayerDevelopment.SetLevel(entry.type, entry.ref.value)
        end)
    end
end

local ProficiencyMenu = {
    title = "playerdev.submenus.proficiencies.label",
    view = ProficiencyView
}

local eddieInput = { value = 1000, min = 1, max = 1000000, step = 100 }
local perkInput = { value = 1, min = 1, max = 100, step = 1 }
local attrInput = { value = 1, min = 1, max = 100, step = 1 }

local function AddMoney(amount) Inventory.GiveItem("Items.money", amount) end

local function ResourceView()
    local perkPoints = PlayerDevelopment.GetDevPoints(gamedataDevelopmentPointType.Primary) or 0
    local attrPoints = PlayerDevelopment.GetDevPoints(gamedataDevelopmentPointType.Attribute) or 0
    local relicPoints = PlayerDevelopment.GetDevPoints(gamedataDevelopmentPointType.Espionage) or 0

    Buttons.OptionExtended(L("playerdev.perkpoints.available.label"), "", tostring(perkPoints),
        tip("playerdev.perkpoints.available.tip"))
    Buttons.OptionExtended(L("playerdev.attributepoints.available.label"), "", tostring(attrPoints),
        tip("playerdev.attributepoints.available.tip"))
    Buttons.OptionExtended(L("playerdev.relicpoints.available.label"), "", tostring(relicPoints),
        tip("playerdev.relicpoints.available.tip"))

    Buttons.Break(L("playerdev.eddies.label"))
    Buttons.Option(L("playerdev.eddies.add1k.label"), tip("playerdev.eddies.add1k.tip"), function() AddMoney(1000) end)
    Buttons.Option(L("playerdev.eddies.add10k.label"), tip("playerdev.eddies.add10k.tip"), function() AddMoney(10000) end)
    Buttons.Option(L("playerdev.eddies.add100k.label"), tip("playerdev.eddies.add100k.tip"),
        function() AddMoney(100000) end)
    Buttons.Int(L("playerdev.eddies.custom.label"), eddieInput, tip("playerdev.eddies.custom.tip"))
    Buttons.Option(L("playerdev.eddies.addcustom.label"), tip("playerdev.eddies.addcustom.tip"),
        function() AddMoney(eddieInput.value) end)
    Buttons.Option(L("playerdev.eddies.removecustom.label"), tip("playerdev.eddies.removecustom.tip"),
        function() Inventory.RemoveItem("Items.money", eddieInput.value) end)

    Buttons.Break(L("playerdev.perkpoints.label"))
    Buttons.Option(L("playerdev.perkpoints.add1"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Primary, 1) end)
    Buttons.Option(L("playerdev.perkpoints.remove1"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Primary, -1) end)
    Buttons.Int(L("playerdev.perkpoints.custom"), perkInput)
    Buttons.Option(L("playerdev.perkpoints.addcustom"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Primary, perkInput.value) end)
    Buttons.Option(L("playerdev.perkpoints.removecustom"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Primary, -perkInput.value) end)

    Buttons.Break(L("playerdev.attributepoints.label"))
    Buttons.Option(L("playerdev.attributepoints.add1"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Attribute, 1) end)
    Buttons.Option(L("playerdev.attributepoints.remove1"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Attribute, -1) end)
    Buttons.Int(L("playerdev.attributepoints.custom"), attrInput)
    Buttons.Option(L("playerdev.attributepoints.addcustom"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Attribute, attrInput.value) end)
    Buttons.Option(L("playerdev.attributepoints.removecustom"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Attribute, -attrInput.value) end)

    Buttons.Break(L("playerdev.relicpoints.label"))
    Buttons.Option(L("playerdev.relicpoints.add1"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Espionage, 1) end)
    Buttons.Option(L("playerdev.relicpoints.remove1"), "",
        function() PlayerDevelopment.AddDevPoints(gamedataDevelopmentPointType.Espionage, -1) end)
end

local ResourceMenu = {
    title = "playerdev.submenus.resources.label",
    view = ResourceView
}


local requirementLogCache = {}

local function DebugRequirementLog(perk, hasReqs, missing, current, maxLevel)
    if requirementLogCache[perk.id] then return end -- already logged once

    local status = hasReqs and "OK" or "MISSING"
    Logger.Log(string.format(
        "[PerkCheck] %s | Current: %d / %d | Status: %s",
        perk.name, current, maxLevel, status
    ))

    if not hasReqs and #missing > 0 then
        Logger.Log("   Missing -> " .. table.concat(missing, ", "))
    end

    requirementLogCache[perk.id] = true
end

local function HasRequirements(perk)
    if not perk.requirements or not perk.requirements.perks then return true, {} end

    local missing = {}
    for _, req in ipairs(perk.requirements.perks) do
        local hasIt = PlayerDevelopment.HasPerk(req.type)
        if not hasIt then
            table.insert(missing, req.name)
        end
    end

    return (#missing == 0), missing
end

local function FormatPerkDisplay(perk, current, maxLevel)
    local hasReqs, missing = HasRequirements(perk)
    if not hasReqs and current == 0 then
        return L("playerdev.perks.locked")
    elseif current == 0 then
        return L("playerdev.perks.unequipped")
    elseif maxLevel > 1 then
        return L("playerdev.perks.equipped") .. string.format(" %d / %d", current, maxLevel)
    else
        return L("playerdev.perks.equipped") .. " 1 / 1"
    end
end

local function BuildPerkTip(perk, maxLevel)
    local tipKey = (maxLevel > 1) and "playerdev.perks.tipmulti" or "playerdev.perks.tipsingle"
    local baseTip = tip(tipKey, { category = perk.category, levels = maxLevel })

    local hasReqs, missing = HasRequirements(perk)
    if not hasReqs and #missing > 0 then
        return baseTip .. "\n\nRequires: " .. table.concat(missing, ", ")
    end

    return baseTip
end

local function HandleSingleRank(perk, current)
    if current == 0 then
        local hasReqs, missing = HasRequirements(perk)
        if not hasReqs then
            Notification.Error(tip("playerdev.perks.notifications.requirement_failed", {
                perk = perk.name,
                requirements = table.concat(missing, ", ")
            }))
            return
        end

        if PlayerDevelopment.AddPerk(perk.type, true) then
            Notification.Success(tip("playerdev.perks.notifications.equipped", { perk = perk.name }))
        else
            Notification.Error(tip("playerdev.perks.notifications.equip_failed", { perk = perk.name }))
        end
    else
        if PlayerDevelopment.RemovePerk(perk.type) then
            Notification.Info(tip("playerdev.perks.notifications.unequipped", { perk = perk.name }))
        else
            Notification.Error(tip("playerdev.perks.notifications.unequip_failed", { perk = perk.name }))
        end
    end
end

local function HandleMultiRank(perk, current, maxLevel)
    if current < maxLevel then
        local hasReqs, missing = HasRequirements(perk)
        if not hasReqs then
            Notification.Error(tip("playerdev.perks.notifications.requirement_failed", {
                perk = perk.name,
                requirements = table.concat(missing, ", ")
            }))
            return
        end

        if PlayerDevelopment.AddPerk(perk.type, true) then
            Notification.Success(tip("playerdev.perks.notifications.level_increased",
                { perk = perk.name, level = tostring(current + 1) }))
        else
            Notification.Error(tip("playerdev.perks.notifications.level_failed", { perk = perk.name }))
        end
    else
        local removed = 0
        for i = 1, current do
            if PlayerDevelopment.RemovePerk(perk.type) then
                removed = removed + 1
            end
        end
        if removed > 0 then
            Notification.Info(tip("playerdev.perks.notifications.reset",
                { perk = perk.name, count = tostring(removed) }))
        else
            Notification.Error(tip("playerdev.perks.notifications.reset_failed", { perk = perk.name }))
        end
    end
end


local function DrawPerkEntry(id, perk)
    local maxLevel = PlayerDevelopment.GetPerkMaxLevel(perk.type) or 1
    local current  = PlayerDevelopment.GetPerkLevel(perk.type)

    local hasReqs, missing = HasRequirements(perk)
    -- DebugRequirementLog(perk, hasReqs, missing, current, maxLevel)

    local display = FormatPerkDisplay(perk, current, maxLevel)
    local tipText = BuildPerkTip(perk, maxLevel)

    Buttons.OptionExtended(
        perk.name, "", display, tipText,
        function()
            if not hasReqs and current == 0 then
                Notification.Error(tip("playerdev.perks.notifications.requirement_failed", {
                    perk = perk.name,
                    requirements = table.concat(missing, ", ")
                }))
                return
            end

            if maxLevel == 1 then
                HandleSingleRank(perk, current)
            else
                HandleMultiRank(perk, current, maxLevel)
            end
        end
    )
end


local function DrawPerksForAttribute(attrKey)
    local attr  = attributeIdMap[attrKey]
    local perks = PerkLoader.attribute[attr] or {}

    for id, perk in pairs(perks) do
        local current = PlayerDevelopment.GetPerkLevel(perk.type)
        local isActive = current > 0

        if (perkFilter.index == 2 and not isActive)
        or (perkFilter.index == 3 and isActive) then
            goto continue
        end

        DrawPerkEntry(id, perk)

        ::continue::
    end
end





local function PlayerDevView()
    if selectedAttribute.index ~= lastSelectedIndex then
        lastSelectedIndex = selectedAttribute.index
        local selectedAttr = attributeIdMap[attributeOptions[selectedAttribute.index]]
        local stat = statTypeMap[selectedAttr]
        if stat then
            attributeLevel.value = PlayerDevelopment.GetAttribute(stat)
        end
    end

    Buttons.Submenu(L("playerdev.submenus.proficiencies.label"), ProficiencyMenu,
        tip("playerdev.submenus.proficiencies.tip"))
    Buttons.Submenu(L("playerdev.submenus.resources.label"), ResourceMenu, tip("playerdev.submenus.resources.tip"))

    Buttons.Break(L("playerdev.perkattributes"))
    Buttons.Dropdown(L("playerdev.attributes.label"), selectedAttribute, attributeOptions,
        tip("Select attribute to manage"))
    Buttons.Int(L("playerdev.attributes.setlevel.label"), attributeLevel, tip("playerdev.attributes.setlevel.tip"),
        function()
            local stat = statTypeMap[attributeIdMap[attributeOptions[selectedAttribute.index]]]
            if stat then
                PlayerDevelopment.SetAttribute(stat, attributeLevel.value)
            end
        end)

    Buttons.StringCycler(L("playerdev.perks.filter.label"), perkFilter, perkFilterOptions,
        tip("playerdev.perks.filter.tip"))

    Buttons.Break(L("playerdev.perks.header"))
    DrawPerksForAttribute(attributeOptions[selectedAttribute.index])
end

return {
    title = "playerdev.title",
    view = PlayerDevView
}
