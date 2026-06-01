-- [[ TOGGLE STRUCTURAL COMPONENT ]]
-- TabReference:CreateToggle({ config })
TargetTab:CreateToggle({
   Name = "Automation Feature Toggle",
   CurrentValue = false, -- Default baseline setting on launch
   Flag = "UniqueToggleID_1", -- Key index used inside saved data JSON files
   Callback = function(Value)
      -- 'Value' returns true when activated, false when deactivated
      _G.FeatureActiveState = Value
      
      -- [[ PARALLEL THREAD HANDLING ]]
      if _G.FeatureActiveState then
          task.spawn(function()
              while _G.FeatureActiveState do
                  -- Insert repeating execution sequences safely here
                  print("Executing asynchronous process step...")
                  
                  -- Critical safeguard: absolute delay timing to prevent execution lockup
                  task.wait(1.0) 
              end
          end)
      else
          print("Automation feature systematically powered down.")
      end
   end
})
