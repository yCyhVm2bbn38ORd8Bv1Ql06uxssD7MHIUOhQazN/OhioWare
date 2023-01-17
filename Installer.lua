local function notify(text)
    if messagebox and (typeof(messagebox)) == "function" then
        messagebox(text, "OhioWare Installer", 0)
    end
end
if not writefile or not readfile then
    notify("Unable to Install using Script because 'writefile' or 'readfile' is unsupported.")
    return
end
local function isfile2(path)
    local suc, err = pcall(function()
        readfile(path)
    end)
    return suc
end

if isfile2("vape/CustomModules/6872274481.lua") then
    writefile("vape/CustomModules/Old6872274481.lua", readfile("vape/CustomModules/6872274481.lua"))
    writefile("vape/CustomModules/6872274481.lua", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yCyhVm2bbn38ORd8Bv1Ql06uxssD7MHIUOhQazN/OhioWare/main/Main.lua"))()]])
    notify("OhioWare Installed! Old custom You were Using has been Written to vape/CustomModules/Old6872274481.lua")
else
    writefile("vape/CustomModules/6872274481.lua", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yCyhVm2bbn38ORd8Bv1Ql06uxssD7MHIUOhQazN/OhioWare/main/Main.lua"))()]])
    if shared.GuiLibrary ~= nil and shared.VapeExecuted then
        notify("OhioWare Installed! Please restart vape for Changes to Load/Save.")
    else
        notify("OhioWare Installed!")
    end
end
