loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/6872274481.lua"))()
local GuiLibrary = shared.GuiLibrary
local lplr = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local cam = game:GetService("Workspace").CurrentCamera

local networkownerfunc = isnetworkowner or (gethiddenproperty and function(part)
    if gethiddenproperty(part, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then 
        return false
    end
    return true
end) or function() return true end

local function runcode(func)
    func()
end
local function isalive(plr, checkhp)
    plr = plr or lplr
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("Head") then return false end
    if not plr.Character:FindFirstChild("Humanoid") then return false end
    if checkhp ~= nil then
        if plr.Character.Humanoid.Health < 0.11 then return false end
    end
    return true
end
local function createwarning(title, text, delay)
	local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
	frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
end

local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local getremote = function(tab)
    for i,v in pairs(tab) do
        if v == "Client" then
            return tab[i + 1]
        end
    end
    return ""
end
local bedwars = {
    ["ClientStoreHandler"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
    ["ProjectileRemote"] = getremote(debug.getconstants(debug.getupvalues(getmetatable(KnitClient.Controllers.ProjectileController)["launchProjectileWithValues"])[2]))
}
local function getmatchstate()
    return bedwars["ClientStoreHandler"]:getState().Game.matchState
end
local function getmatchtype()
    return bedwars["ClientStoreHandler"]:getState().Game.queueType or "bedwars_test"
end
local function getbeds()
    local beds = {}
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if string.lower(v.Name) == "bed" and v:FindFirstChild("Covers") ~= nil and v:FindFirstChild("Covers").BrickColor ~= lplr.Team.TeamColor then
            table.insert(beds, v)
        end
    end
    return beds
end
local function getplayers()
    local players = {}
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Team ~= lplr.Team and isalive(v) then
            table.insert(players, v)
        end
    end
    return players
end
local function getitem(itm)
    if isalive(lplr) and lplr.Character.InventoryFolder.Value:FindFirstChild(itm) ~= nil then
        return true
    end
    return false
end
local function getnearestplayerchar(maxdist)
    local character = nil
    local charactermindistance = math.huge
    for i,v in pairs(getplayers()) do
        local Distance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
        if (Distance < maxdist) and (Distance < charactermindistance) then
            character = v.Character
            charactermindistance = Distance
        end
    end
    return character
end

runcode(function()
    local velo
    local FlyV2 = {["Enabled"] = false}
    local FlyV2Vertical = {["Enabled"] = false}
    local FlyV2VerticalVal = {["Value"] = 50}
    FlyV2 = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "FlyV2",
        ["Function"] = function(callback)
            if callback then
                velo = Instance.new("BodyVelocity")
                velo.MaxForce = Vector3.new(0, 9e9, 0)
                velo.Velocity = Vector3.new(0, -0.5, 0)
                velo.Parent = lplr.Character.HumanoidRootPart
                spawn(function()
                    repeat
                        task.wait()
                        if not networkownerfunc(lplr.Character.HumanoidRootPart) then
                            createwarning("FlyV2", "Lagback detected, Stopped FlyV2", 3)
                            FlyV2["ToggleButton"](true)
                            return
                        end
                        if FlyV2Vertical["Enabled"] then
                            if uis:IsKeyDown(Enum.KeyCode.Space) then
                                lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, FlyV2VerticalVal["Value"] / 100, 0)
                            end
                            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                                lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, -FlyV2VerticalVal["Value"] / 100, 0)
                            end
                        else
                            task.wait(0.1)
                        end
                    until not FlyV2["Enabled"]
                end)
                spawn(function()
                    repeat
                        task.wait()
                        game:GetService("Workspace").Gravity = 0
                        if (lplr.Character:GetAttribute("InflatedBalloons") ~= nil and lplr.Character:GetAttribute("InflatedBalloons") > 0) then
                            for i = 1,15 do
                                task.wait()
                                if not FlyV2["Enabled"] then return end
                                velo.Velocity = Vector3.new(0, i, 0)
                            end
                            for i = 1,15 do
                                task.wait()
                                if not FlyV2["Enabled"] then return end
                                velo.Velocity = Vector3.new(0, -i, 0)
                            end
                        else
                            velo.Velocity = Vector3.new(0, -1, 0)
                            task.wait(0.1)
                            velo.Velocity = Vector3.new(0, 1, 0)
                            task.wait(0.1)
                        end
                    until not FlyV2["Enabled"]
                    game:GetService("Workspace").Gravity = 196.2
                end)
            else
                velo:Destroy()
                game:GetService("Workspace").Gravity = 196.2
            end
        end,
        ["HoverText"] = "Yea a fly lol"
    })
    FlyV2Vertical = FlyV2.CreateToggle({
        ["Name"] = "Vertical",
        ["HoverText"] = "Allows you to fly Up and Down",
        ["Function"] = function() end,
        ["Default"] = true
    })
    FlyV2VerticalVal = FlyV2.CreateSlider({
        ["Name"] = "VerticalSpeed",
        ["Min"] = 0,
        ["Max"] = 100,
        ["Function"] = function() end,
        ["HoverText"] = "Vertical speed Value",
        ["Default"] = 50
    })
end)

runcode(function()
    local AddConnection
    local PopperExploit = {["Enabled"] = false}
    local PopperExploitHide = {["Enabled"] = false}
    PopperExploit = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "PopperExploit",
        ["Function"] = function(callback)
            if callback then
                if PopperExploitHide["Enabled"] then
                    AddConnection = game:GetService("Workspace").ChildAdded:Connect(function(newchild)
                        if newchild.Name == "NewYearsConfetti" and newchild:IsA("Part") then
                            newchild:Destroy()
                        end
                    end)
                end
                spawn(function()
                    repeat
                        task.wait(1.1)
                        game:GetService("ReplicatedStorage"):FindFirstChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events").useAbility:FireServer("PARTY_POPPER")
                    until not PopperExploit["Enabled"]
                end)
            else
                if AddConnection then
                    AddConnection:Disconnect()
                    AddConnection = nil
                end
            end
        end,
        ["HoverText"] = "Plays annoying sound and effect"
    })
    PopperExploitHide = PopperExploit.CreateToggle({
        ["Name"] = "HideEffect",
        ["HoverText"] = "Hides the effect (for You only)",
        ["Function"] = function()
            if PopperExploit["Enabled"] and not AddConnection then
                PopperExploit["ToggleButton"](true)
                PopperExploit["ToggleButton"](true)
            end
        end
    })
end)
runcode(function()
    local DaoExploit = {["Enabled"] = false}
    DaoExploit = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "DaoExploit",
        ["Function"] = function(callback)
            if callback then
                spawn(function()
                    repeat
                        task.wait(2)
                        game:GetService("ReplicatedStorage"):FindFirstChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events").useAbility:FireServer("dash")
                    until not DaoExploit["Enabled"]
                end)
            end
        end,
        ["HoverText"] = "Plays dao Sound effect (No item Required)"
    })
end)
runcode(function()
    local TPHighJump = {["Enabled"] = false}
    local TPHighJumpStuds = {["Value"] = 100}
    TPHighJump = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "TPHighJump",
        ["Function"] = function(callback)
            if callback then
                game:GetService("TweenService"):Create(lplr.Character.HumanoidRootPart, TweenInfo.new(0.4), {CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, TPHighJumpStuds["Value"], 0)}):Play()
                TPHighJump["ToggleButton"](true)
            end
        end,
        ["HoverText"] = "TPs you up (Real Highjump)"
    })
    TPHighJumpStuds = TPHighJump.CreateSlider({
        ["Name"] = "Studs",
        ["Min"] = 1,
        ["Max"] = 300,
        ["Function"] = function() end,
        ["HoverText"] = "Studs to TP up",
        ["Default"] = 100
    })
end)
runcode(function()
    local FastFly = {["Enabled"] = false}
    FastFly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "FastFly",
        ["Function"] = function(callback)
            if callback then
                local char = lplr.Character
                local hrp = char.HumanoidRootPart
                local fhrp = hrp:Clone()
                char.Parent = game
                fhrp.Parent = char
                char.PrimaryPart = fhrp
                hrp.Parent = cam
                char.Parent = game:GetService("Workspace")
                spawn(function()
                    repeat
                        task.wait(0.1)
                        hrp.CFrame = fhrp.CFrame
                    until not FastFly["Enabled"]
                end)
                spawn(function()
                    repeat
                        task.wait()
                        fhrp.Velocity = Vector3.new(fhrp.Velocity.X, 0 + (uis:IsKeyDown(Enum.KeyCode.Space) and 50 or 0) + (uis:IsKeyDown(Enum.KeyCode.LeftShift) and -50 or 0), fhrp.Velocity.Z)
                        hrp.Velocity = Vector3.new(0, 0, 0)
                    until not FastFly["Enabled"]
                end)
                spawn(function()
                    repeat
                        task.wait()
                        char:TranslateBy(char.Humanoid.MoveDirection * (FastFlyNormal["Value"] / 100))
                    until not FastFly["Enabled"]
                end)
            else
                local char = lplr.Character
                local hrp = cam.HumanoidRootPart
                local fhrp = char.HumanoidRootPart
                char.Parent = game
                hrp.Parent = char
                char.PrimaryPart = hrp
                hrp.CFrame = fhrp.CFrame
                fhrp:Destroy()
                char.Parent = game:GetService("Workspace")
            end
        end,
        ["HoverText"] = "A funny fastfly (with bypasses)"
    })
    FastFlyNormal = FastFly.CreateSlider({
        ["Name"] = "NormalSpeed",
        ["Min"] = 20,
        ["Max"] = 100,
        ["Function"] = function() end,
        ["HoverText"] = "The speed to fly having no other bypass",
        ["Default"] = 40
    })
end)
runcode(function()
    local BlockBreaker = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"]["out"]["client"]["break"]["block-breaker"]).BlockBreaker
    local FastBreak = {["Enabled"] = false}
    FastBreak = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "FastBreak",
        ["Function"] = function(callback)
            if callback then
                spawn(function()
                    repeat
                        task.wait(1)
                        BlockBreaker.COOLDOWN = 0.23
                    until not FastBreak["Enabled"]
                end)
            end
        end
    })
end)
runcode(function()
    local LongJumpV2 = {["Enabled"] = false}
    local LongJumpV2Gravity = {["Value"] = 15}
    LongJumpV2 = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "LongJumpV2",
        ["Function"] = function(callback)
            if callback then
                game:GetService("Workspace").Gravity = LongJumpV2Gravity["Value"]
                lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            else
                game:GetService("Workspace").Gravity = 196.2
            end
        end,
        ["HoverText"] = "A LongJump that doesnt need fireballs"
    })
    LongJumpV2Gravity = LongJumpV2.CreateSlider({
        ["Name"] = "Gravity",
        ["Min"] = 1,
        ["Max"] = 197,
        ["Function"] = function() end,
        ["HoverText"] = "Gravity to Use when Using LongJumpV2",
        ["Default"] = 15
    })
end)
runcode(function()
    local FastHighJump = {["Enabled"] = false}
    local FastHighJumpKillVelo = {["Enabled"] = false}
    local FastHighJumpOffDelay = {["Value"] = 0.5}
    FastHighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "FastHighJump",
        ["Function"] = function(callback)
            if callback then
                delay(FastHighJumpOffDelay["Value"] / 100, function()
                    createwarning("FastHighJump", "Disabled FastHighJump to prevent Flagging", 3)
                    FastHighJump["ToggleButton"](true)
                end)
                spawn(function()
                    repeat
                        task.wait()
                        for i = 1,10 do
                            task.wait(0.1)
                            if not FastHighJump["Enabled"] then return end
                            lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, (i * 100), lplr.Character.HumanoidRootPart.Velocity.Z)
                        end
                    until not FastHighJump["Enabled"]
                end)
            else
                if FastHighJumpKillVelo["Enabled"] and isalive(lplr) then
                    lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 0, lplr.Character.HumanoidRootPart.Velocity.Z)
                end
            end
        end,
        ["HoverText"] = "A faster HighJump (Using too long will result in a Lagback)"
    })
    FastHighJumpKillVelo = FastHighJump.CreateToggle({
        ["Name"] = "KillVelo",
        ["HoverText"] = "Makes you instandly Fall-down when Disabling",
        ["Function"] = function() end,
        ["Default"] = false
    })
    FastHighJumpOffDelay = FastHighJump.CreateSlider({
        ["Name"] = "OffDelay",
        ["Min"] = 0,
        ["Max"] = 200,
        ["Function"] = function() end,
        ["HoverText"] = "Time before disabling (to prevent flagging), format: value / 100",
        ["Default"] = 50
    })
end)
runcode(function()
    local TPLongJump = {["Enabled"] = false}
    TPLongJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "TPFastJump",
        ["Function"] = function(callback)
            if callback then
                spawn(function()
                    local hrp = lplr.Character.HumanoidRootPart
                    local tpcf = hrp.CFrame
                    spawn(function()
                        repeat
                            task.wait()
                            hrp.CFrame = tpcf
                            hrp.Velocity = Vector3.new(0, 5, 0)
                        until not TPLongJump["Enabled"]
                    end)
                    spawn(function()
                        repeat
                            task.wait(0.4)
                            tpcf = hrp.CFrame + (hrp.CFrame.LookVector * 10)
                        until not TPLongJump["Enabled"]
                    end)
                end)
            end
        end,
        ["HoverText"] = "A longjump thats fast and stops"
    })
end)
runcode(function()
    local function ShootFunc(ItemName, ProjectileName, Part)
        Client:Get(bedwars["ProjectileRemote"]):CallServerAsync(
            lplr.Character.InventoryFolder.Value[ItemName],
            ProjectileName,
            ProjectileName,
            Part.Position,
            Part.Position,
            Vector3.new(0, -20, 0),
            game:GetService("HttpService"):GenerateGUID(false),
            {
                ["drawDurationSeconds"] = 1
            },
            game:GetService("Workspace"):GetServerTimeNow()
        )
    end
    local TPAura = {["Enabled"] = false}
    TPAura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "TPAura",
        ["Function"] = function(callback)
            if callback then
                spawn(function()
                    repeat
                        task.wait(0.2)
                        if isalive(lplr) then
                            local Nearest = getnearestplayerchar(10000)
                            if Nearest then
                                local lhrp = lplr.Character.HumanoidRootPart
                                local nhrp = Nearest.HumanoidRootPart
                                if getitem("fireball") then
                                    ShootFunc("fireball", "fireball", nhrp)
                                elseif getitem("arrow") and (getitem("wood_bow") or getitem("wood_crossbow") or getitem("tactical_crossbow")) then
                                    ShootFunc("crossbow", "arrow", nhrp)
                                elseif getitem("snowball") then
                                    ShootFunc("snowball", "snowball", nhrp)
                                end
                            end
                        end
                    until not TPAura["Enabled"]
                end)
            end
        end,
        ["HoverText"] = "A TPAura that uses Projectiles found in SW chests"
    })
end)

spawn(function()
    if game:HttpGet("https://raw.githubusercontent.com/yCyhVm2bbn38ORd8Bv1Ql06uxssD7MHIUOhQazN/OhioWare/main/Announcement.json") ~= "" then
        spawn(function()
            local announcement = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/yCyhVm2bbn38ORd8Bv1Ql06uxssD7MHIUOhQazN/OhioWare/main/Announcement.json"))
            if announcement.Enabled == true then
                local vapeannouncement = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/bedwarsdata")).Announcement
                if vapeannouncement.ExpireTime > tick() then
                    createwarning("OhioWare Announcement", "Waiting for Vape's Announcement to end before showing OhioWare's Announcement.", 5)
                    task.wait(vapeannouncement.Time)
                end
                if typeof(announcement.KickUsers) == "table" then
                    if table.find(announcement.KickUsers, tonumber(lplr.UserId)) then
                        local reason = ((announcement.KickReason and (announcement.KickReason:gsub(" ", "") ~= "")) and announcement.KickReason) or "This account has've been Blacklisted from OhioWare (Temporary)."
                        lplr:Kick(reason)
                    end
                end
                if announcement.Notify == true then
                    createwarning("OhioWare Announcement", announcement.Header, announcement.Time or 30)
                else
                    local ts = game:GetService("TweenService")
                    local waittime = announcement.Time or 30
                    local main = Instance.new("Frame")
                    main.AnchorPoint = Vector2.new(0.5, 0.5)
                    main.Size = UDim2.new(0, 720, 0, 100)
                    main.Position = UDim2.new(0.4997, 0, 0.05, 0)
                    main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    main.BorderSizePixel = 0
                    main.Parent = GuiLibrary["MainGui"]
                    local title = Instance.new("TextLabel")
                    title.Size = UDim2.new(0, 720, 0, 35)
                    title.BackgroundTransparency = 1
                    title.BorderSizePixel = 0
                    title.Text = "OhioWare announcement"
                    title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title.TextScaled = true
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.Parent = main
                    local content = title:Clone()
                    content.Size = UDim2.new(0, 720, 0, 60)
                    content.Position = UDim2.new(0, 0, 0.31, 0)
                    content.Text = announcement.Header
                    content.TextXAlignment = Enum.TextXAlignment.Center
                    content.Parent = main
                    local bar = Instance.new("Frame")
                    bar.Size = UDim2.new(0, 720, 0, 9)
                    bar.Position = UDim2.new(0, 0, 0.91, 0)
                    bar.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
                    bar.BorderSizePixel = 0
                    bar.Parent = main
                    ts:Create(bar, TweenInfo.new(waittime), {Size = UDim2.new(0, 0, 0, 9)}):Play()
                    task.wait(waittime)
                    bar:Destroy()
                    ts:Create(main, TweenInfo.new(1), {Position = (main.Position - UDim2.new(0, 0, 0.5, 0))}):Play()
                    task.wait(1)
                    main:Destroy()
                end
            end
        end)
    end
end)
