local Language = require("Core/Language")
local Logger = require("Core/Logger")
local Event = require("Core/Event")
local JsonHelper = require("Core/JsonHelper")
local Session = require("Core/cp2077-cet-kit/GameSession")
local Cron = require("Core/cp2077-cet-kit/Cron")
local OptionConfig = require("Config/OptionConfig")
local Input = require("Core/Input")
-- Config
local BindingsConfig = require("Config/BindingsConfig")
local UIConfig = require("Config/UIConfig")
local NavigationConfig = require("Config/NavigationConfig")

local State = require("Controls/State")
local Handler = require("Controls/Handler")
local Restrictions = require("Controls/Restrictions")
local FPSTracker = require("Utility/FPSTracker")

local Notification = require("UI/Elements/Notification")
local InfoBox = require("UI/Elements/InfoBox")
local UI = require("UI")

local VehicleLoader = require("Utils/DataExtractors/VehicleLoader")
local WeaponLoader = require("Utils/DataExtractors/WeaponLoader")
local PerkLoader = require("Utils/DataExtractors/PerkLoader")
local GeneralLoader = require("Utils/DataExtractors/GeneralLoader")

local TeleportLocations = require("Features/Teleports/TeleportLocations")

local WelcomeWindow = require("View/Welcome")
local Utils
local Weapon
local SelfFeature
local SelfTick
local MainMenu
local Vehicle
local AutoTeleport
local WorldWeather
local WorldTime
registerForEvent("onOverlayOpen", function() State.overlayOpen = true end)
registerForEvent("onOverlayClose", function() State.overlayOpen = false end)

local modulesLoaded = false
GameState = {}

local function GetStartingState()
    GameState = Session.GetState()
end

local lastState = {
    isLoaded = nil,
    isPaused = nil,
    isDead = nil,
}

local function UpdateSessionStateTick()
    local loaded = Session.IsLoaded()
    local paused = Session.IsPaused()
    local dead = Session.IsDead()
    GameState.isLoaded = loaded
    GameState.isPaused = paused
    GameState.isDead = dead
end

local function TryLoadModules()
    if Session.IsLoaded() and not modulesLoaded then
        local ok = true

        Utils = require("Utils")
        SelfFeature = require("Features/Self")
        SelfTick = require("Features/Self/Tick")
        Weapon = require("Features/Weapons/Tick")
        Vehicle = require("Features/Vehicles")
        AutoTeleport = require("Features/Teleports/AutoTeleport")
        WorldWeather = require("Features/World/WorldWeather")
        WorldTime = require("Features/World/WorldTime")
        MainMenu = require("View/MainMenu")
        -- this is a very cancer statement but I guess it works?
        if not (Utils and SelfFeature and AutoTeleport and WorldWeather and WorldTime and SelfTick and Weapon and Vehicle and MainMenu) then
            ok = false
        end

        if ok then
            modulesLoaded = true
            Logger.Log("Game modules initialized.")
        end
    end
end

local function OnSessionUpdate(state)
    GameState = state
    if GameState.event == "Start" and not GameState.wasLoaded then
        TryLoadModules()
    end
end


Event.RegisterInit(function()
    Logger.Initialize()
    Logger.Log("Initialization")

    Input.Initialize()

    Cron.After(0.1, GetStartingState)

    Session.Listen(OnSessionUpdate)

    Cron.Every(1.0, UpdateSessionStateTick)
    Cron.Every(0.5, TryLoadModules)

    Logger.Log("Cron Started")


    local config = JsonHelper.Read("Config/JSON/Settings.json")
    local lang = (config and config.Lang) or "en"
    if not Language.Load(lang) then
        Logger.Log("Language failed to load, fallback to English")
        Language.Load("en")
    else
        Logger.Log("Language loaded: " .. lang)
    end


    TeleportLocations.LoadAll()


    PerkLoader:LoadAll()
    WeaponLoader:LoadAll()
    VehicleLoader:LoadAll()
    GeneralLoader:LoadAll()
    Logger.Log("DataLoaded")


    BindingsConfig.Load()
    Logger.Log("Bindings loaded")

    UIConfig.Load()
    Logger.Log("UI config loaded")

    NavigationConfig.Load()
    Logger.Log("Navigation config loaded")

    OptionConfig.Load()
    Logger.Log("Option config loaded")


    Event.Observe("PlayerPuppet", "OnAction", function(_, action)
        if modulesLoaded then
            SelfFeature.NoClip.HandleMouseLook(action)
            if Utils then
                Utils.Weapon.HandleInputAction(action)
            end
        end
    end)

    Event.Observe("BaseProjectile", "ProjectileHit", function(self, eventData)
        if modulesLoaded then
            Weapon.HandleProjectileHit(self, eventData)
        end
    end)

    Event.ObserveAfter("LocomotionAirEvents", "OnEnter", function(_, context, _)
        if modulesLoaded then
            SelfFeature.GodMode.DisableFallFX(_, context, _)
        end
    end)

    Event.ObserveAfter("MinimapContainerController", "OnCountdownTimerActiveUpdated", function(_, _)
        if modulesLoaded then
            Vehicle.FreezeQuestTimer.HandleCountdownTimer(_, _)
        end
    end)

    Event.Override("LocomotionTransition", "WantsToDodge", function(transition, stateContext, scriptInterface, wrappedFunc)
        if modulesLoaded then
            return SelfFeature.InfiniteAirDash.HandleAirDash(transition, stateContext, scriptInterface, wrappedFunc)
        end
    end)


    Event.Override("scannerDetailsGameController", "ShouldDisplayTwintoneTab", function(this, wrappedMethod)
        return VehicleLoader:HandleTwinToneScan(this, wrappedMethod)
    end)

    Logger.Log("Initialized")

end)
Event.RegisterUpdate(function(dt)
    Cron.Update(dt)

    if not modulesLoaded then return end
    Utils.StatModifiers.UpdateSessionWatcher()
    
    FPSTracker.Update(dt)
    
    if not GameState.isLoaded or GameState.isPaused or GameState.isDead then
        return
    end

    SelfTick.TickHandler()
    Weapon.TickHandler(dt)
    AutoTeleport.Tick(dt)

    Vehicle.VehicleLightFade.TickFade(dt)
    Vehicle.VehiclePreview.Update(dt)
    Vehicle.VehicleSpawning.HandlePending()
    Vehicle.VehicleNitro.Tick(dt)
    WorldWeather.Update()
    WorldTime.Update(dt)
end)

Event.RegisterDraw(function()
    UI.Notification.Render()
    WelcomeWindow.Render()
    UI.Overlay.Render()
    
    if not modulesLoaded then return end
    MainMenu.Initialize()
    Handler.Update()
    
    if State.menuOpen then
        local UIStyle = require("UI/Core/Style")

        
        local targetH
        local SubmenuManager = require("UI/Core/SubmenuManager")
        local currentTitle = SubmenuManager.GetBreadcrumbTitle()
        
        if UIStyle.Layout.DynamicHeight then
            local baseH = (UIStyle.Header.Height or 65) + (UIStyle.SecondHeader.Height or 30) + (UIStyle.Footer.Height or 35) + (UIStyle.Layout.OptionPaddingY or 0) * 2
            local count = State.menuCounts[currentTitle] or State.optionCount or 1
            local limit = UIStyle.Layout.MaxVisibleOptions or 16
            
            local displayCount = math.min(count, limit)
            
            local spacing = (UIStyle.Layout.ItemSpacing and UIStyle.Layout.ItemSpacing.y) or 2.0
            
            -- Explicitly use floats and add slight padding
            local contentHeight = (displayCount * UIStyle.Layout.OptionHeight) + (displayCount * spacing)
            targetH = baseH + contentHeight + 4.0 
        else
            targetH = UIStyle.Layout.WindowHeight or 500.0
        end
        State.targetHeight = targetH

        -- Handle menu change or initialization
        if State.lastMenuTitle ~= currentTitle or (not State.currentHeight) or State.currentHeight == 0 then
            State.currentHeight = targetH
            State.lastMenuTitle = currentTitle
        else
            local speed = UIStyle.Layout.SmoothHeightSpeed or 0.15
            State.currentHeight = State.currentHeight + (targetH - State.currentHeight) * speed
            
            -- Snap if very close
            if math.abs(targetH - State.currentHeight) < 0.1 then
                State.currentHeight = targetH
            end
        end

        local width = UIStyle.Layout.WindowWidth or 500.0

        local menuX, menuY, menuW, menuH
        ImGui.SetNextWindowSize(width, State.currentHeight, ImGuiCond.Always)

        ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, UIStyle.Header.Rounding or 15.0)
        ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, { 0.0, 0.0 })
        ImGui.PushStyleColor(ImGuiCol.Border, 0)
        ImGui.PushStyleColor(ImGuiCol.WindowBg, UIStyle.Colors.Background or 0)
        if ImGui.Begin("GoodFeelings", ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoScrollWithMouse + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoResize) then
            if UIStyle.Layout.Scale and UIStyle.Layout.Scale ~= 1.0 then
                ImGui.SetWindowFontScale(UIStyle.Layout.Scale)
            else
                ImGui.SetWindowFontScale(1.0)
            end

            menuX, menuY = ImGui.GetWindowPos()
            menuW, menuH = ImGui.GetWindowSize()
            MainMenu.Render(menuX, menuY, menuW, menuH)
            ImGui.End()
        end
        ImGui.PopStyleColor(2)
        ImGui.PopStyleVar(3)

        InfoBox.Render(menuX, menuY, menuW, menuH)
    end
end)

Event.RegisterShutdown(function()
    if modulesLoaded then
        Restrictions.Clear()
        BindingsConfig.Save()
        OptionConfig.Save()
        Utils.StatModifiers.Cleanup()
    end
    Logger.Log("Clean up")
end)
