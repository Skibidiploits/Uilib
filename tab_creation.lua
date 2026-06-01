-- [[ REQUIRE MAIN CONTEXT ]]
-- Assumes 'Window' variable is active from the window template engine
local Window = _G.ActiveWindowInstance or Window

-- [[ CATEGORY CREATION ]]
-- Format: Window:CreateTab("Tab Display Name")
local FeatureTabOne = Window:CreateTab("Primary Features")
local FeatureTabTwo = Window:CreateTab("Automation Suite")

-- Expose references globally or local variables to inject interactive items
return FeatureTabOne, FeatureTabTwo
