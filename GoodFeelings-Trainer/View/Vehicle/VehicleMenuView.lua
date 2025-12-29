local Buttons = require("UI").Buttons
local VehicleFeaures = require("Features/Vehicles")

local VehicleListView = require("View/Vehicle/VehicleListView")
local VehicleLightView = require("View/Vehicle/VehicleLightView")

local VehicleLights = VehicleFeaures.VehicleLightFade
local VehiclePreview = VehicleFeaures.VehiclePreview
local VehicleRepair = VehicleFeaures.VehicleRepair
local VehicleMount = VehicleFeaures.VehicleMountOnRoof
local VehicleMapTimer = VehicleFeaures.FreezeQuestTimer
local VehicleNitro = VehicleFeaures.VehicleNitro
local VehicleUnlocking = VehicleFeaures.VehicleUnlocking
local VehicleAppearance = require("Features/Vehicles/VehicleAppearance")
local VehicleSiren = VehicleFeaures.VehicleSiren
local VehicleJump = VehicleFeaures.VehicleJump
local VehicleFlip = VehicleFeaures.VehicleFlip

local VehicleLoader = require("Utils/DataExtractors/VehicleLoader")


local function GetAllFactions()
    local seen, list = {}, {}

    for _, v in ipairs(VehicleLoader:GetAll()) do
        if v.faction and not seen[v.faction] then
            seen[v.faction] = true
            table.insert(list, v.faction)
        end
    end

    table.sort(list)
    return list
end

local factionCycler = { index = 1 }
local factionList = nil

local function VehicleViewFunction()
    
    if not factionList then
        factionList = GetAllFactions()
    end

    VehiclePreview.SetActive(false)
    if Buttons.Submenu(L("vehiclemenu.vehiclelist.label"), VehicleListView, L("vehiclemenu.vehiclelist.tip")) then VehicleFeaures.VehicleListStates.enableVehicleSpawnerMode = false end
    if Buttons.Submenu(L("vehiclemenu.vehiclespawner.label"), VehicleListView, L("vehiclemenu.vehiclespawner.tip")) then VehicleFeaures.VehicleListStates.enableVehicleSpawnerMode = true end
    Buttons.Submenu(L("vehiclemenu.vehicleheadlights.label"), VehicleLightView, L("vehiclemenu.vehicleheadlights.tip"))
    Buttons.Option(L("vehiclemenu.repairvehicle.label"), L("vehiclemenu.repairvehicle.tip"), VehicleRepair.RepairMounted)
    Buttons.Option(L("vehiclemenu.randomize.label"), L("vehiclemenu.randomize.tip"), VehicleAppearance.RandomizeMounted)
    Buttons.Option(L("vehiclemenu.mountonroof.label"), L("vehiclemenu.mountonroof.tip"), VehicleMount.MountOnRoof)
    Buttons.Toggle(L("vehiclelights.rgbfade.label"), VehicleLights.toggleRGBFade, L("vehiclelights.rgbfade.tip"))
    Buttons.Toggle(L("vehiclemenu.policesiren.label"), VehicleSiren.enabled, L("vehiclemenu.policesiren.tip"))
    Buttons.Option(L("vehiclemenu.vehiclelaunch.label"), L("vehiclemenu.vehiclelaunch.tip"), VehicleJump.LaunchMounted)
    Buttons.Option(L("vehiclemenu.instaflip.label"), L("vehiclemenu.instaflip.tip"), VehicleFlip.FlipCurrent)
    Buttons.Toggle(L("vehiclemenu.freezequesttimer.label"), VehicleMapTimer.toggleFreezeQuestTimer, L("vehiclemenu.freezequesttimer.tip"))
    Buttons.Float(L("vehiclemenu.nitrous.label"), VehicleNitro.multiplier, L("vehiclemenu.nitrous.tip"))

    Buttons.Break(L("vehiclemenu.quickoptions.label"))

    Buttons.Option(L("vehiclemenu.unlockplayer.label"), L("vehiclemenu.unlockplayer.tip"), VehicleUnlocking.UnlockAllPlayerVehicles)
    Buttons.Option(L("vehiclemenu.disableplayer.label"), L("vehiclemenu.disableplayer.tip"), VehicleUnlocking.DisableAllPlayerVehicles)

    Buttons.Option(L("vehiclemenu.unlockmodded.label"), L("vehiclemenu.unlockmodded.tip"), VehicleUnlocking.UnlockAllModded)
    Buttons.Option(L("vehiclemenu.disablemodded.label"), L("vehiclemenu.disablemodded.tip"), VehicleUnlocking.DisableAllModded)

    if Buttons.StringCyclerClick(L("vehiclemenu.unlockfaction.label"), factionCycler, factionList, L("vehiclemenu.unlockfaction.tip")) then 
        VehicleUnlocking.UnlockFaction(factionList[factionCycler.index])  
    end
    if Buttons.StringCyclerClick(L("vehiclemenu.lockfaction.label"), factionCycler, factionList, L("vehiclemenu.lockfaction.tip")) then 
        VehicleUnlocking.DisableFaction(factionList[factionCycler.index])  
    end

end

local VehicleView = { title = L("vehiclemenu.title"), view = VehicleViewFunction }

return VehicleView
