-- [[ KEY SYSTEM INTERFACE INITIALIZATION ]]
-- Passed inside the core JojoHub:CreateWindow({ config }) block
local Window = JojoHub:CreateWindow({
   Name = "Project Identity | Premium Edition",
   LoadingTitle = "Securing Environment...",
   LoadingSubtitle = "Authentication Gate Active",
   
   -- [[ KEY VALVE GATING SETUP ]]
   KeySystem = true, -- Set to true to display the key validation interface on boot
   KeySettings = {
      KeyLink = "https://linkvertise.com/your-key-link-here", -- Link given when user clicks "Get Key Link"
      Keys = {
         "SecretPass2026", 
         "BetaAccess_Jojo", 
         "DeveloperOverrideKey"
      } -- Array of approved text strings that grant execution access
   }
})

-- Note: All subsequent Window:CreateTab() declarations will safely wait 
-- and remain completely hidden until the player inputs a matching key above.
