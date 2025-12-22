local ConfigManager = require("Config/OptionConfig")
local VehicleViewStates = require("Features/Vehicles/VehicleViewStates")
local VehicleLightFade = require("Features/Vehicles/VehicleLightFade")


local function RegisterAllVehicleOptions()

    ConfigManager.Register("toggle.spawner.deletelast", VehicleViewStates.deleteLastVehicle, true)
    ConfigManager.Register("toggle.spawner.mountonspawn", VehicleViewStates.mountOnSpawn, true)
    ConfigManager.Register("toggle.spawner.preview", VehicleViewStates.previewVehicle, true)
    ConfigManager.Register("toggle.vehicle.rgblights", VehicleLightFade.toggleRGBFade, false)

end

return RegisterAllVehicleOptions
