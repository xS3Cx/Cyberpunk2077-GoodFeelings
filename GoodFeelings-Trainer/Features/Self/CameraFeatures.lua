local CameraFeatures = {
    fovRef = { value = 80, min = 65, max = 115, step = 5 }
}
local UI = require("UI")
local Notification = UI.Notification

function CameraFeatures.ApplyFOV()
    local player = Game.GetPlayer()
    if not player then return end

    local cam = player:GetFPPCameraComponent()
    if not cam then return end

    cam:SetZoom(0.0)
    cam:SetFOV(CameraFeatures.fovRef.value)
    
    Notification.Info(string.gsub(L("modifiers.camera.fovset.msg"), "{fov}", math.floor(CameraFeatures.fovRef.value)))
end

function CameraFeatures.CycleFOV()
    -- Kept for backward compatibility or if needed, but ApplyFOV is preferred for Int buttons
    local currentFOV = CameraFeatures.fovRef.value
    local newFOV = currentFOV + 5
    if newFOV > 115 then newFOV = 65 end
    CameraFeatures.fovRef.value = newFOV
    CameraFeatures.ApplyFOV()
end

return CameraFeatures
