local Logger = {
    logCount = 6,
    logDir = "Logs",
    logWindow = {},
    currentLogFile = "",
    numberedLogFile = "",
    autoScroll = true,
    showTimestamps = true
}

local function GetTimestamp()
    return os.date("[%Y-%m-%d %H:%M:%S]")
end

local function GetNextLogIndex()
    local index = 1
    while true do
        local path = string.format("%s/log_%d.txt", Logger.logDir, index)
        local file = io.open(path, "r")
        if not file then break end
        file:close()
        index = index + 1
    end
    return index
end

local function RotateLogs()
    local files = {}
    for i = 1, 100 do
        local path = string.format("%s/log_%d.txt", Logger.logDir, i)
        local file = io.open(path, "r")
        if file then
            table.insert(files, path)
            file:close()
        else
            break
        end
    end

    if #files >= Logger.logCount then
        for i = Logger.logCount, #files do
            os.remove(files[i])
        end
    end
end

local function WriteToFile(msg)
    local f1 = io.open(Logger.numberedLogFile, "a")
    if f1 then
        f1:write(msg .. "\n")
        f1:close()
    end

    local f2 = io.open(Logger.currentLogFile, "a")
    if f2 then
        f2:write(msg .. "\n")
        f2:close()
    end
end

function Logger.Log(msg)
    local timestamped = GetTimestamp() .. " " .. msg
    table.insert(Logger.logWindow, timestamped)
    WriteToFile(timestamped)
    print("[GoodFeelings] " .. msg)
end

function Logger.Initialize()
    RotateLogs()
    local index = GetNextLogIndex()
    Logger.numberedLogFile = string.format("%s/log_%d.txt", Logger.logDir, index)
    Logger.currentLogFile = string.format("%s/log_current.txt", Logger.logDir)

    local clear = io.open(Logger.currentLogFile, "w")
    if clear then clear:close() end

    Logger.Log("[GoodFeelings] Logger initialized. Writing to log_" .. index .. ".txt and log_current.txt")
end

-- Draws a log window that can stay open without CET overlay blocking controls
function Logger.DrawLogWindow()
    ImGui.Begin("Logger Window")

    if ImGui.Button("Clear") then
        Logger.logWindow = {}
    end
    ImGui.SameLine()
    if ImGui.Button("Copy") then
        local text = table.concat(Logger.logWindow, "\n")
        ImGui.SetClipboardText(text)
    end

    ImGui.Separator()
    ImGui.BeginChild("LogScroll")

    for _, line in ipairs(Logger.logWindow) do
        if Logger.showTimestamps then
            ImGui.TextUnformatted(line)
        else
            local msgOnly = line:gsub("^%[.-%]%s*", "")
            ImGui.TextUnformatted(msgOnly)
        end
    end

    ImGui.SetScrollHereY(1.0)

    ImGui.EndChild()
    ImGui.End()
end

return Logger
