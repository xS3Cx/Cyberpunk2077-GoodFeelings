local Welcome = {}
local Input = require("Core/Input")
local windowW, windowH = 600, 815 -- Don't want it to be scrollable so just got to get it the right size
local JsonHelper = require("Core/JsonHelper")
local configPath = "Config/JSON/Settings.json"

local showWelcome = false
local countdown = 60
local startTime = nil

do
    local data = JsonHelper.Read(configPath)
    if not data or not data.shown then
        showWelcome = true
        startTime = os.clock()
    end
end

local info = {
    "Welcome to EasyTrainer (Beta)",
    "",
    "Controls:",
    "- Keyboard: Arrow Keys = Navigate | Enter = Confirm | Backspace = Back | X = Cursor Mode",
    "- Controller: D-Pad = Navigate | A = Confirm | B = Back (configurable in Navigation view)",
    "- CET Overlay: Drag to move, resize from window edges",
    "- Default Toggle Key: F4 (can be rebound in Settings > Navigation)",
    "- Controller Open Shortcut: Right Bumper + A (can be rebound in Settings > Navigation)",
    "",
    "Notes:",
    "- Cursor Mode (X) allows using the mouse even with CET overlay closed.",
    "- Input restrictions apply for keyboard, mouse, and controller depending on what you're using.",
    "- Some gameplay inputs (e.g., driving) may be blocked while navigating with trainer controls.",
    "",
    "Menu Tips:",
    "- Integer/Float Inputs: Use Left and Right Arrow keys to adjust values (auto-applies)",
    "- Toggles: Press Enter/A to toggle ON or OFF",
    "- Dropdowns: Press Enter to expand and browse options",
    "- RGB Buttons: Adjust four channels (R, G, B, A) using Left/Right keys for each value",
    "",
    "About EasyTrainer:",
    "An easy and flexible trainer for Cyberpunk 2077.",
    "Supports both controller and keyboard navigation.",
    "Designed to feel familiar to anyone who's used GTA-style trainers.",
    "Currently in Beta - expect some issues while things are being improved.",
    "",
    "Open Source Info:",
    "This project is open-source. Feel free to explore, tweak, or extend it.",
    "Bug reports, ideas, or contributions are welcome.",
    "GitHub: https://github.com/AviWind02/EasyTrainers",
    "",
    "Credits:",
    "- Created by: Avi",
    "- Inspired by: SimpleMenu (Dank Rafft, capncoolio2)",
    "- Special Thanks: LocationKingGRP (Teleport data from Nexus)",
    "",
    "Thank You:",
    "Huge thanks to everyone who has tried EasyTrainer.",
    "I honestly didn't think people would actually use it. Your support means a lot!"
}

function Welcome.Render()
    if not showWelcome then return end

    local elapsed = os.clock() - (startTime or os.clock())
    local remaining = math.max(0, countdown - math.floor(elapsed))

    if remaining == 0 then
        Welcome.Dismiss()
        return
    end

    local resX, resY = GetDisplayResolution()
    local winX, winY = (resX - windowW) / 2, (resY - windowH) / 2

    ImGui.SetNextWindowPos(winX, winY, ImGuiCond.Always)
    ImGui.SetNextWindowSize(windowW, windowH, ImGuiCond.Always)

    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 12.0)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, 0.1, 0.1, 0.1, 0.95)
    ImGui.PushStyleColor(ImGuiCol.Border, 1, 0.75, 0.25, 0.2)

    if ImGui.Begin("EasyTrainerWelcome", ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar) then
        local centerX = ImGui.GetWindowWidth() / 2

        ImGui.SetCursorPosX(centerX - 100)
        ImGui.TextColored(1, 0.85, 0.35, 1, "Welcome to EasyTrainer")
        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        for _, line in ipairs(info) do
            if line == "" then
                ImGui.Spacing()
            elseif line:match("^https?://") then
                ImGui.TextColored(0.3, 0.7, 1, 1, line)
            else
                ImGui.TextWrapped(line)
            end
        end

        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        ImGui.SetCursorPosX(centerX - 100)
        ImGui.TextColored(0.6, 1, 0.6, 1,
            string.format("Press Enter or A to continue (%d)", remaining)
        )

        if Input.IsButtonDown(Input.GP.A) or Input.IsKeyDown(Input.VK.ENTER) then
            Welcome.Dismiss()
        end
    end

    ImGui.End()
    ImGui.PopStyleColor(2)
    ImGui.PopStyleVar()
end

function Welcome.Dismiss()
    showWelcome = false
    JsonHelper.Update(configPath, { shown = true })
end

return Welcome
