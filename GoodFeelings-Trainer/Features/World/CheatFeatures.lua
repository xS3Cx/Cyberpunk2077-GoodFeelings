local CheatFeatures = {}
local UI = require("UI")
local Notification = UI.Notification

function CheatFeatures.CycleDifficulty()
    local SDS = Game.GetStatsDataSystem()
    if not SDS then return end

    local curDiff = SDS:GetDifficulty().value
    local nextDiff
    local nextDiffLabel

    if curDiff == "Story" then
        nextDiff = gameDifficulty.Easy
        nextDiffLabel = "Easy"
    elseif curDiff == "Easy" then
        nextDiff = gameDifficulty.Hard
        nextDiffLabel = "Hard"
    elseif curDiff == "Hard" then
        nextDiff = gameDifficulty.VeryHard
        nextDiffLabel = "Very Hard"
    elseif curDiff == "VeryHard" then
        nextDiff = gameDifficulty.Story
        nextDiffLabel = "Story"
    else
        -- Fallback if current is unknown
        nextDiff = gameDifficulty.Easy
        nextDiffLabel = "Easy"
    end

    SDS:SetDifficulty(nextDiff)
    
    Notification.Info(string.gsub(L("debug.cheats.difficulty.msg"), "{difficulty}", nextDiffLabel))
end

return CheatFeatures
