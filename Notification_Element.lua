-- [[ GLOBAL NOTIFICATION POPUP ]]
-- LibraryName:Notify({ config })
-- Uses 'JojoHub' base assignment instance directly from the workspace thread
JojoHub:Notify({
   Title = "System Operational Alert",
   Content = "Initialization pipeline completed without throwing runtime constraints.",
   Duration = 5.0,    -- Visible floating delay tracking window before fading away
   Image = 0,         -- Image assets configuration index placeholder (0 = Hidden)
   Actions = {        -- Context action interaction payload options
      Confirm = {
         Name = "Acknowledge",
         Callback = function()
            print("System confirmation dialogue accepted by client input.")
         end
      }
   }
})
