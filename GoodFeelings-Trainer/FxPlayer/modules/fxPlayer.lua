FxPlayer = {}

local fxLibrary = require('FxPlayer/modules/fxLibrary')

function FxPlayer.GetAllEffectFromLibrary()
    if not fxLibrary then
        local UI = require("UI")
        UI.Notification.Error("FxPlayer: No fxLibrary found")
        return {}
    end

    return fxLibrary.effects
end


function FxPlayer.FilterAllEffectToMenu()
    local returnTable = {}
    local effects = FxPlayer.GetAllEffectFromLibrary()

    for _, effect in pairs(effects) do
        local effectName = string.match(effect, "([^\\]+)$")
        table.insert(returnTable, { effect = effect, name = effectName })
    end

    return returnTable
end

--- @param coords vector4
function FxPlayer.PlayEffectOnCoords(transform, effect)
    if not transform then
        local UI = require("UI")
        UI.Notification.Error('FxPlayer: Transform is nil')
        return
    end

    local fxSystem = Game.GetFxSystem()
    local fxParticle = gameFxResource.new({ effect = effect })
    local fxHandle = fxSystem:SpawnEffect(fxParticle, transform)

    if not IsDefined(fxHandle) then
        fxSystem:SpawnEffectOnGround(fxParticle, transform, true)
    end
end

local effects = FxPlayer.FilterAllEffectToMenu()
local text = ""

function FxPlayer.DrawEffectsMenuOnFrame()
    ImGui.SetNextWindowPos(100, 500, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(410, 600, ImGuiCond.Appearing)

    if ImGui.Begin("Fx Player") then
        text, _ = ImGui.InputText("Search Effect", text, 100)

        for _, effect in pairs(effects) do
            if text == "" or string.find(effect.name, text) then
                if ImGui.Button(effect.name, 400, 0) then

                    local playerEntity = Game.GetPlayer()
                    local playerCoords = playerEntity:GetWorldPosition()
                    local playerForward = playerEntity:GetWorldForward()

                    local transform = WorldTransform.new()
                    transform:SetOrientation(playerEntity:GetWorldOrientation())
                    transform:SetPosition(Vector4.new(playerCoords.x + playerForward.x * 2, playerCoords.y + playerForward.y * 2, playerCoords.z, 0))

                    FxPlayer.PlayEffectOnCoords(transform, effect.effect)
                end
            end
        end
    end

    ImGui.End()
end

return FxPlayer