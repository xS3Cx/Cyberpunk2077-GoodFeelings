local Input = require("Core/Input")
local State = require("Controls/State")

local Cursor = {}
local cursorActive = false 

function Cursor.Update()
    local shouldBeVisible = State.menuOpen and State.mouseEnabled

    if shouldBeVisible and not cursorActive then
        Input.ShowCursor(true)
        cursorActive = true
    elseif not shouldBeVisible and cursorActive then
        Input.ShowCursor(false)
        cursorActive = false
    end
end

return Cursor
