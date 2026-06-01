-- [[ BUTTON STRUCTURAL COMPONENT ]]
-- TabReference:CreateButton({ config })
TargetTab:CreateButton({
   Name = "Execute Script Payload",
   Callback = function()
      -- [[ INJECT LOGIC HERE ]]
      -- This execution field triggers instantly upon user physical click input
      print("Button interaction triggered successfully.")
      
      -- Example: Running network string fetching inside client thread
      -- loadstring(game:HttpGet("YOUR_EXTERNAL_LINK_HERE"))()
   end
})
