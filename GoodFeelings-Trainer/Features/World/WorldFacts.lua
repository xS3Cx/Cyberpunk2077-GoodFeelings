local Facts = {}
local logger = require("Core/Logger")


function Facts.Get(factName)
    local QS = Game.GetQuestsSystem()
    local result = QS:GetFactStr(factName)
    logger.Log(string.format("[Facts] %s = %s", factName, tostring(result)))
    return result
end

function Facts.Set(factName, value)
    local QS = Game.GetQuestsSystem()
    QS:SetFactStr(factName, value)
    logger.Log(string.format("[Facts] %s set to %s", factName, tostring(value)))
end

function Facts.IsTrue(factName)
    return tostring(Facts.Get(factName)) == "1"
end

function Facts.SetBool(factName, state)
    Facts.Set(factName, state and 1 or 0)
end

function Facts.Print(factList)
    for _, fact in ipairs(factList) do
        logger.Log(fact .. ": " .. tostring(Facts.Get(fact)))
    end
end

function Facts.MakeToggle(factName)
    return {
        value = Facts.IsTrue(factName),
        _fact = factName
    }
end

function Facts.Tick(toggleRef)
    local current = Facts.IsTrue(toggleRef._fact)
    if toggleRef.value ~= current then
        Facts.SetBool(toggleRef._fact, toggleRef.value)
    end
end

return Facts
