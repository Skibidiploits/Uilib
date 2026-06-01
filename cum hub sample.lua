-- [[ 1. FETCH & INITIALIZE LIBRARY ]]
local JojoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidiploits/Uilib/refs/heads/main/Loader.lua"))()

-- [[ 2. APPLICATION CONTAINER SETUP ]]
local Window = JojoHub:CreateWindow({
   Name = "Gooner Hub | Ejaculate v1.0",
   LoadingTitle = "Gooning...",
   LoadingSubtitle = "by Goonmaster69420",
   ToggleUIKeybind = "K", -- Default keybind to toggle visibility
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GooningNghhh", -- Folder created in workspace folder
      FileName = "Configs"       -- Name of JSON configuration profile
   }
})

-- [[ 3. GLOBAL CONFIGURATION SAFEGUARD ]]
-- Declaring a shared environment flag system to control looping tasks globally
getgenv().ExecutionState = {
    RunningLoops = {},
    ActiveToggles = {}
}

-- [[ REQUIRE MAIN CONTEXT ]]
-- Assumes 'Window' variable is active from the window template engine
local Window = _G.ActiveWindowInstance or Window

-- [[ CATEGORY CREATION ]]
-- Format: Window:CreateTab("Tab Display Name")
local MainTab = Window:CreateTab("Main")
local LocalPlayerTab = Window:CreateTab("Local Player")

-- [[ BUTTON STRUCTURAL COMPONENT ]]
-- TabReference:CreateButton({ config })
MainTab:CreateButton({
   Name = "Canhub V2",
   Callback = function()
      -- [[ INJECT LOGIC HERE ]]
      -- This execution field triggers instantly upon user physical click input
      
      print("CanHub V2 succesfully cummed out")
      loadstring(game:HttpGet("https://api.canhub.dev/code"))()
      -- Example: Running network string fetching inside client thread
      -- loadstring(game:HttpGet("YOUR_EXTERNAL_LINK_HERE"))()
   end
})
