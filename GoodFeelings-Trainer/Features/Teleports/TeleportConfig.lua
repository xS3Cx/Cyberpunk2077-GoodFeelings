local ConfigManager = require("Config/OptionConfig")
local AutoTeleport = require("Features/Teleports/AutoTeleport")
local Settings = require("Features/Teleports/TeleportViewStates")


local function RegisterAllTelportOptions()

    ConfigManager.Register("toggle.teleport.autowaypoint", AutoTeleport.toggleAutoWaypoint, false)
    ConfigManager.Register("toggle.teleport.autoquest", AutoTeleport.toggleAutoQuest, false)

    ConfigManager.Register("view.teleport.showforward", Settings.showForward, true)
    ConfigManager.Register("view.teleport.showquick", Settings.showQuick, true)
    ConfigManager.Register("view.teleport.showquickdistance", Settings.showQuickDistance, true)
    ConfigManager.Register("view.teleport.showcategorydistance", Settings.showCategoryDistance, true)
    ConfigManager.Register("view.teleport.showcreatorfilter", Settings.showCreatorFilter, false)
    ConfigManager.Register("view.teleport.showdistrictfilter", Settings.showDistrictFilter, true)
end

return RegisterAllTelportOptions
