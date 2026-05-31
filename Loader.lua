-- Inside your GitHub repository's Loader.lua file
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidiploits/Uilib/refs/heads/main/Loader.lua"))()
end)

if not success then
    warn("JojoHub Core Engine failed to load: " .. tostring(result))
    return nil
else
    return result
end
