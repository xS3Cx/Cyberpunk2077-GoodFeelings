local World = {}

---@return string parentDistrictName, string childDistrictName
function World.GetCurrentDistrictName()
    local player = Game.GetPlayer()
    local districtManager = player:GetPreventionSystem().districtManager
    local currentDistrict = districtManager and districtManager:GetCurrentDistrict()
    if not currentDistrict then
        return "Out of Bounds", "Out of Bounds"
    end

    local districtRecord = TweakDBInterface.GetDistrictRecord(currentDistrict:GetDistrictID())
    if not districtRecord then
        return "Out of Bounds", "Out of Bounds"
    end

    local childDistrictName = Game.GetLocalizedText(districtRecord:LocalizedName()) or "Unknown District"

    local parentDistrictName = "Unknown District"
    local parentRecord = districtRecord:ParentDistrict()
    if parentRecord then
        parentDistrictName = Game.GetLocalizedText(parentRecord:LocalizedName()) or "Unknown District"
    end

    return parentDistrictName, childDistrictName
end

return World
