local GameHUD = require("Core/cp2077-cet-kit/GameHUD")

local WelcomeLanding = {}

function WelcomeLanding.Show()
    local message = "Welcome to GoodFeelings Trainer!\n" ..
                    "Enjoy your stay in Night City!"
    
    -- Show as warning for 6 seconds
    GameHUD.ShowWarning(message, 6.0)
end

return WelcomeLanding
