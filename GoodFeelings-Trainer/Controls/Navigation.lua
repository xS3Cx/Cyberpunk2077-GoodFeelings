local State = require("Controls/State")

local Navigation = {}

function Navigation.ApplyNavigation()
    if State.upPressed then
        State.currentOption = (State.currentOption > 1)
            and (State.currentOption - 1)
            or State.optionIndex
    elseif State.downPressed then
        State.currentOption = (State.currentOption < State.optionIndex)
            and (State.currentOption + 1)
            or 1 
    end

    if State.pageUpPressed then
        local jump = State.maxVisible or 5
        State.currentOption = math.max(1, State.currentOption - jump)
    elseif State.pageDownPressed then
        local jump = State.maxVisible or 5
        State.currentOption = math.min(State.optionIndex, State.currentOption + jump)
    end
end

return Navigation
