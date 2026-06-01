-- [[ DISCORD PROMPT INITIALIZATION ]]
-- Passed inside the core JojoHub:CreateWindow({ config }) block
local Window = JojoHub:CreateWindow({
   Name = "Project Identity | Community Build",
   LoadingTitle = "Connecting Backend...",
   LoadingSubtitle = "Fetching Discord Registry",
   
   -- [[ AUTOMATED COMMUNITY HUB CONNECT ]]
   Discord = {
      Enabled = true, -- Set to true to auto-copy the invite link and trigger the alert banner
      Invite = "skibidi-exploit-server", -- The exact end slug of your invite link (e.g., discord.gg/YOUR_SLUG)
      RememberJoins = true -- Internal logic checkpoint to prevent repetitive prompting on re-execution
   }
})

-- Note: When executed on professional exploitation clients, this will automatically 
-- force a local clipboard string copy action ("setclipboard") and prompt a visual 
-- confirmation banner at the top of the interface frame.
