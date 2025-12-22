-- Seems useless to have but I'm trying to keep it as clean as possible and learn how to code properly
local Logger = require("Core/Logger")

local Event = {}
Event._subs = {}

---Subscribe a function to a custom topic  
---Any number of functions can subscribe to the same topic  
---@param topic string Name of the event topic  
---@param fn fun(...) Function to call when the topic is emitted  
function Event.subscribe(topic, fn)
    Event._subs[topic] = Event._subs[topic] or {}
    table.insert(Event._subs[topic], fn)
end

---Emit a custom topic, calling all subscribed functions  
---@param topic string Name of the event topic  
---@param ... any Arguments passed to subscribers  
function Event.emit(topic, ...)
    local list = Event._subs[topic]
    if not list then return end
    for _, fn in ipairs(list) do
        local ok, err = pcall(fn, ...)
        if not ok then
            Logger.Log("Event: Error in subscriber for "..topic..": "..tostring(err))
        end
    end
end

---Register a callback for CET onInit  
---@param fn fun() Function to run on init  
function Event.RegisterInit(fn)
    registerForEvent("onInit", fn)
    Logger.Log("Event: Registered onInit")
end

---Register a callback for CET onUpdate  
---@param fn fun(deltaTime:number) Function to run every frame  
function Event.RegisterUpdate(fn)
    registerForEvent("onUpdate", fn)
    Logger.Log("Event: Registered onUpdate")
end

---Register a callback for CET onDraw  
---@param fn fun() Function to run during ImGui draw cycle  
function Event.RegisterDraw(fn)
    registerForEvent("onDraw", fn)
    Logger.Log("Event: Registered onDraw")
end

---Register a callback for CET onShutdown  
---@param fn fun() Function to run during shutdown  
function Event.RegisterShutdown(fn)
    registerForEvent("onShutdown", fn)
    Logger.Log("Event: Registered onShutdown")
end

---Observe a game class method (non-destructive hook)  
---@param class string Game class name  
---@param method string Method name to observe  
---@param fn fun(...) Callback invoked after the method  
function Event.Observe(class, method, fn)
    Observe(class, method, fn)
    Logger.Log(string.format("Event: Observing %s.%s", tostring(class), tostring(method)))
end

---Observe a game class method after execution (non-destructive hook)
---@param class string Game class name
---@param method string Method name to observe
---@param fn fun(...) Callback invoked after the method has finished
function Event.ObserveAfter(class, method, fn)
    ObserveAfter(class, method, fn)
    Logger.Log(string.format("Event: ObservingAfter %s.%s", tostring(class), tostring(method)))
end

---Override a game class method (replaces implementation)  
---@param class string Game class name  
---@param method string Method name to override  
---@param fn fun(...) Replacement function  
function Event.Override(class, method, fn)
    Override(class, method, fn)
    Logger.Log(string.format("Event: Overriding %s.%s", tostring(class), tostring(method)))
end

return Event
