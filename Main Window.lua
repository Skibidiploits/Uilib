-- [[ 1. FETCH & INITIALIZE LIBRARY ]]
local JojoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidiploits/Uilib/refs/heads/main/Loader.lua"))()

-- [[ 2. APPLICATION CONTAINER SETUP ]]
local Window = JojoHub:CreateWindow({
   Name = "Project Identity | Suite v1.0",
   LoadingTitle = "Booting Framework Core...",
   LoadingSubtitle = "by Developer Name",
   ToggleUIKeybind = "K", -- Default keybind to toggle visibility
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ProjectSaveData", -- Folder created in workspace folder
      FileName = "Preferences"       -- Name of JSON configuration profile
   }
})

-- [[ 3. GLOBAL CONFIGURATION SAFEGUARD ]]
-- Declaring a shared environment flag system to control looping tasks globally
getgenv().ExecutionState = {
    RunningLoops = {},
    ActiveToggles = {}
}

-- Return window reference for module expansion templates
return Window
