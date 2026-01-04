-- ==============================
-- Services
-- ==============================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")


local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local plr = Players.LocalPlayer

local KillBossEnabled = false
local SelectedBoss = nil


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "[Farm Boss Pity 25] Rogue Piece",
    SubTitle = "Made by BenJaMinZ",
    TabWidth = 200,
    Size = UDim2.fromOffset(580,400),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local function initCharacter(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
end

local TabMain = Window:AddTab({ Title = "Main", Icon = "hammer" })
local TabAutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "bot" })
local TabLand = Window:AddTab({ Title = "Buy Summon", Icon = "globe" })
local Setting = Window:AddTab({ Title = "Setting", Icon = "settings" })

local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

StarterGui:SetCore("SendNotification", {
    Title = "BenJaMinZ Hub",
    Text = "AntiAFK Active",
    Duration = 5
})

local AutoHakiEnabled = false

local function fireHaki()
    local Character = player.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or Humanoid.Health <= 0 or not HumanoidRootPart then return end

    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not Remotes then return end
    local remote = Remotes:FindFirstChild("Serverside")
    if not remote then return end

    local hakiValue = AutoHakiEnabled and 1 or 2
    local args = {"Server", "Misc", "Haki", hakiValue}

    pcall(function()
        remote:FireServer(unpack(args))
    end)
end

LocalPlayer.CharacterAdded:Connect(function(Character)
    if AutoHakiEnabled then
        Character:WaitForChild("Humanoid")
        task.wait(0.01)
        fireHaki()
    end
end)

TabMain:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Default = false,
    Callback = function(state)
        AutoHakiEnabled = state
        fireHaki()
    end
})

local defaultSpeed = 16
local boostedSpeed = 250
local speedActive = false

TabMain:AddToggle("SpeedNoClipToggle", {
    Title = "Speed Hack",
    Default = false,
    Callback = function(state)
        speedActive = state
        local humanoidRef = character:FindFirstChild("Humanoid")
        if humanoidRef then
            humanoidRef.WalkSpeed = state and boostedSpeed or defaultSpeed
        end
    end
})

RunService.RenderStepped:Connect(function()
    if speedActive then
        local char = player.Character
        if char then
            local humanoidRef = char:FindFirstChild("Humanoid")
            local hrpRef = char:FindFirstChild("HumanoidRootPart")
            if humanoidRef and hrpRef then
                local moveDir = humanoidRef.MoveDirection
                hrpRef.Velocity = Vector3.new(moveDir.X * boostedSpeed, hrpRef.Velocity.Y, moveDir.Z * boostedSpeed)
            end
        end
    end
end)

_G.InfiniteJumpMisc = false
TabMain:AddToggle("InfinityJumpMisc", {
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state) _G.InfiniteJumpMisc = state end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJumpMisc then
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local WhiteScreenEnabled = false

local RunService = game:GetService("RunService")

local function updateWhiteScreen()
    if WhiteScreenEnabled then
        pcall(function()
            RunService:Set3dRenderingEnabled(false)
        end)
    else
        pcall(function()
            RunService:Set3dRenderingEnabled(true)
        end)
    end
end

TabMain:AddToggle("WhiteScreenToggle", {
    Title = "White Screen (FPS Boost)",
    Default = false,
    Callback = function(state)
        WhiteScreenEnabled = state
        updateWhiteScreen()
    end
})


local Section = TabMain:AddSection("Select Farm Haki")

local Players = game:WaitForChild("Players")
local ReplicatedStorage = game:WaitForChild("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local AutoHakiEnabled = false
local SelectedHakiType = "Haki"

local function fireHaki()
    local Character = LocalPlayer.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or Humanoid.Health <= 0 or not HumanoidRootPart then return end

    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not Remotes then return end

    local remote = Remotes:FindFirstChild("Serverside")
    if not remote then return end

    local args = {
        [1] = "Server",
        [2] = "Misc",
        [3] = SelectedHakiType,
        [4] = AutoHakiEnabled and 1 or 2
    }

    pcall(function()
        remote:FireServer(unpack(args))
    end)
end

LocalPlayer.CharacterAdded:Connect(function(Character)
    Character:WaitForChild("Humanoid")
    task.wait()
    if AutoHakiEnabled then
        task.spawn(function()
            while AutoHakiEnabled do
                fireHaki()
                task.wait()
            end
        end)
    end
end)

local HakiDropdown = TabMain:AddDropdown("HakiTypeDropdown", {
    Title = "Select Haki",
    Values = {"Haki", "Observation"},
    Default = "Haki",
})

HakiDropdown:OnChanged(function(value)
    SelectedHakiType = value
end)

local AutoHakiToggle = TabMain:AddToggle("AutoHakiToggle", {
    Title = "Auto Farm Haki / Observation",
    Default = false,
})

AutoHakiToggle:OnChanged(function(state)
    AutoHakiEnabled = state

    if AutoHakiEnabled then
        task.spawn(function()
            while AutoHakiEnabled do
                fireHaki()
                task.wait()
            end
        end)
    end
end)

TabMain:AddButton({
    Title = "Buy Haki",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(15.541900634765625, -0.6488094925880432, 127.20834350585938)
    end
})

TabMain:AddButton({
    Title = "Buy Observation",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-604.7462768554688, 0.15616437792778015, -277.2145080566406)
    end
})

local SelectedWeapon = "Zangetsu"
local SelectedType = "Combat"
local EquipEnabled = false

local WeaponTypes = {
    ["Kafka's Katana"] = "Sword",
    ["Jin Mori"] = 'Combat',
    ["Anti-Magic Sword"] = "Sword",
    ["Herta's Hammer"] = "Sword",
    ["Yuta's Katana"] = "Sword",
    ["Divine Bident"] = "Sword",
    ["Kaneki"] = "Combat",
    ["Todoroki"] = "Combat",
    ["Todoroki"] = "Combat",
    ["Qin Shi"] = "Combat",
    ["Shadow"] = "Combat",
    ["Abyssbreaker"] = "Sword",
    ["Venuzdonoa"] = "Sword",
    ["Solemn Lament"] = "Sword",
    ["Tensa Zangetsu"] = "Sword",
    ["Zangetsu"] = "Sword",
    ["Hellsing Dual Pistol"] = "Sword",
    ["Dark Blade"] = "Sword",
    ["Dual Dagger"] = "Sword",
    ["Spiritual Katana"] = "Sword",
    ["Tanjiro's Nichirin"] = "Sword",
    ["Metal Bat"] = "Sword",
    ["OFA"] = "Combat",
    ["Aizen"] = "Combat",
    ["Gojo"] = "Combat",
    ["One For All"] = "Combat",
    ["Shigaraki"] = "Combat",
    ["Sukuna"] = "Combat",
    ["Akaza"] = "Combat",
    ["Sandevistan"] = "Combat",
    ["Combat"] = "Combat",
    ["Garou"] = "Combat",
    ["Suiryu"] = "Combat",
    ["Wando"] = "Sword",
    ["Katana"] = "Sword",
    ["Dual Katana"] = "Sword"
}

local function holdWeaponByType(weaponType)
    task.spawn(function()
        while EquipEnabled do
            local Character = LocalPlayer.Character
            local Backpack = LocalPlayer:FindFirstChild("Backpack")
            if Character and Backpack then
                for weaponName, wType in pairs(WeaponTypes) do
                    if wType == weaponType then
                        local weapon = Backpack:FindFirstChild(weaponName) or Character:FindFirstChild(weaponName)
                        if weapon and weapon.Parent ~= Character then
                            weapon.Parent = Character
                            SelectedWeapon = weaponName
                            break
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

TabAutoFarm:AddDropdown("WeaponTypeSelect", {
    Title = "Equip Weapon Type",
    Values = {"Combat","Sword"},
    Default = "Combat",
    Callback = function(value)
        SelectedType = value
    end
})

TabAutoFarm:AddToggle("EquipWeaponToggle", {
    Title = "Equip Weapon",
    Default = false,
    Callback = function(state)
        EquipEnabled = state
        if state then
            holdWeaponByType(SelectedType)
        end
    end
})

-----------------------------------------------------------------------------------
local Section = TabAutoFarm:AddSection("Select Boss Type Pity 25")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

local SingleBoss_Selected = nil
local SingleBoss_Enabled = false
local AbyssalScriptRan = false

local AkazaBoss = "Akaza"
local AutoKillAkaza = true

local BossPositions = {
    Zangetsu = Vector3.new(-551.933, 24.840, -802.254),
    Aizen = Vector3.new(-466.279, 4.840, -875.021),
    Tanjiro = Vector3.new(-603.887, 10.964, 594.560),
    ["Abyssal Beast"] = Vector3.new(20.92774772644043, 103.84904479980469, -1343.6639404296875),
    ["Kaneki"] = Vector3.new(138.07069396972656, 352.7678527832031, -1347.8748779296875),
    ["Shigaraki"] = Vector3.new(562.9945068359375, 89.82760620117188, 489.7559814453125)
}

local originalGUIPos = nil

local function PressKey(key)
    VirtualInput:SendKeyEvent(true, key, false, game)
    task.wait()
    VirtualInput:SendKeyEvent(false, key, false, game)
end

local function PressEnter() PressKey(Enum.KeyCode.Return) end
local function PressE() PressKey(Enum.KeyCode.E) end
local function PressBackslash() PressKey(Enum.KeyCode.BackSlash) end

local function SingleBoss_Find(name)
    if name == "Yuta" then
        return workspace.Main.Characters["Jujutsu Highschool"].Boss:FindFirstChild("Yuta")
    elseif name == "Zangetsu" then
        local folder = workspace.Main.Characters.Innerworld:FindFirstChild("Boss")
        if folder then
            for _, npc in ipairs(folder:GetChildren()) do
                if npc.Name:match("Zangetsu") then return npc end
            end
        end
    elseif name == "Aizen" then
        return workspace.Main.Characters.Huecomundo.Boss:FindFirstChild("Aizen")
    elseif name == "Tanjiro" then
        for _, npc in ipairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc.Name == "Tanjiro" and npc:FindFirstChild("Humanoid") then
                if npc.Humanoid.Health > 0 then return npc end
            end
        end
    elseif name == "Sung Jin Woo" then
        local folder = workspace.Main.Characters["Rogue Town [Backside]"]:FindFirstChild("Boss")
        if folder then
            local npc = folder:FindFirstChild("Sung Jin Woo")
            if npc and npc:FindFirstChild("Humanoid").Health > 0 then return npc end
        end
    elseif name == "Kafka" then
        local folder = workspace.Main.Characters["Abyss Hill [Upper]"]:FindFirstChild("Boss")
        if folder then
            local npc = folder:FindFirstChild("Kafka")
            if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                return npc
            end
        end
    elseif name == "Herta" then
        local folder = workspace.Main.Characters["Xmas Island"]:FindFirstChild("Boss")
        if folder then
            local npc = folder:FindFirstChild("Herta")
            if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                return npc
            end
        end
    elseif name == "Silver Fang" then
        local folder = workspace.Main.Characters["Rogue Town [Backside]"]:FindFirstChild("Boss")
        if folder then
            local npc = folder:FindFirstChild("Silver Fang")
            if npc and npc:FindFirstChild("Humanoid").Health > 0 then return npc end
        end
    elseif name == "Abyssal Beast" then
        local folder = workspace.Main.Characters["Abyss Hill"]:FindFirstChild("Boss")
        if folder then
            local npc = folder:FindFirstChild("Abyssal Beast")
            if npc and npc:FindFirstChild("Humanoid").Health > 0 then return npc end
        end
    elseif name == "Shigaraki" then
        local folder = workspace.Main.Characters["Rogue Town"]:FindFirstChild("Boss")
        if folder then
            local npc = folder:FindFirstChild("Shigaraki")
            if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                return npc
            end
        end
    elseif name == AkazaBoss then
        local throne = workspace:FindFirstChild("Main") and workspace.Main.Characters:FindFirstChild("Throne Isle")
        if throne and throne:FindFirstChild("Boss") then
            return throne.Boss:FindFirstChild(AkazaBoss)
        end
    end
    return nil
end

local function checkPity()
    local success, pityValue = pcall(function()
        return plr:FindFirstChild("Pity") and plr.Pity:FindFirstChild("Boss") and plr.Pity.Boss.Value or 0
    end)
    if success then return pityValue end
    return 0
end

local function Akaza_Spawn()
    if not SingleBoss_Enabled then return end

    local bossUI = plr:WaitForChild("PlayerGui"):WaitForChild("Button"):WaitForChild("Boss Spawn")
    bossUI.Visible = true

    if not originalGUIPos then originalGUIPos = bossUI.Position end
    bossUI.Position = UDim2.new(0.8, 0, 0.1, 0)

    local selectBtn = pcall(function()
        return bossUI.Frame[AkazaBoss].Button
    end) and bossUI.Frame[AkazaBoss].Button or nil

    if selectBtn then
        GuiService.SelectedObject = selectBtn
        PressEnter()
        task.wait()
    end

    local spawnBtn = bossUI:FindFirstChild("Spawn") and bossUI.Spawn:FindFirstChild("Button")
    if spawnBtn then
        GuiService.SelectedObject = spawnBtn
        PressEnter()
    end

    task.wait()
    PressBackslash()
end

local function Akaza_AttackLoop(HRP)
    while AutoKillAkaza and SingleBoss_Enabled do
        if checkPity() >= 25 then break end
        local npc = SingleBoss_Find(AkazaBoss)
        if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local humanoid = npc.Humanoid
            while humanoid.Health > 0 and checkPity() < 25 and SingleBoss_Enabled do
                local backPos = npc.HumanoidRootPart.Position - npc.HumanoidRootPart.CFrame.LookVector * 11.5
                TweenService:Create(HRP, TweenInfo.new(0.08), {CFrame = CFrame.new(backPos, npc.HumanoidRootPart.Position)}):Play()
                ReplicatedStorage.Remotes.Serverside:FireServer("Server", SelectedType, "M1s", SelectedWeapon, AttackValue)
                task.wait(0.01)
            end
        else
            Akaza_Spawn()
        end
        task.wait(0.5)
    end
end

local function SingleBoss_AttackBoss(npc, HRP)
    local humanoid = npc:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end

    local function attack()
        ReplicatedStorage.Remotes.Serverside:FireServer(
            "Server",
            SelectedType,
            "M1s",
            SelectedWeapon,
            AttackValue
        )
    end

    local function stayBehind(npc)
        local nh = npc:FindFirstChild("HumanoidRootPart")
        if not nh then return end
        local pos = nh.Position - nh.CFrame.LookVector * 11.5
        TweenService:Create(HRP, TweenInfo.new(0.08), {CFrame = CFrame.new(pos, nh.Position)}):Play()
    end

    while SingleBoss_Enabled and humanoid.Health > 0 do
        stayBehind(npc)
        attack()
        task.wait(0.01)
    end

    return humanoid.Health <= 0
end

local Event = {}
Event.__index = Event

function Event:fireclickbutton(button)
    if not button then return end
    xpcall(function()
        local VisibleGui = plr.PlayerGui:FindFirstChild("") or Instance.new("Frame")
        VisibleGui.Name = "_"
        VisibleGui.BackgroundTransparency = 0
        VisibleGui.Parent = plr.PlayerGui
        plr.PlayerGui.SelectionImageObject = VisibleGui
        GuiService.SelectedObject = button
        for i = 1, 15 do
            if not button or not SingleBoss_Enabled then break end
            VirtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end
    end, warn)
end

function Event:findDarknessSpirit()
    local AllItems = {}
    local MaterialFrame = plr.PlayerGui.Button["Storage_Frame"]["Material_Frame"]
    for _, v in pairs(MaterialFrame:GetChildren()) do
        if v:IsA("Frame") and v.Name == "Darkness Spirit" then
            table.insert(AllItems, v)
        end
    end
    return AllItems
end

function Event:findCore()
    local AllCores = {}
    local MaterialFrame = plr.PlayerGui.Button["Storage_Frame"]["Material_Frame"]
    for _, v in pairs(MaterialFrame:GetChildren()) do
        if v:IsA("Frame") and string.find(v.Name, "Core of Abyssal") then
            table.insert(AllCores, v)
        end
    end
    return AllCores
end

-- Loop ฟาร์ม Boss
local function SingleBoss_Loop(HRP)
    while SingleBoss_Enabled do
        while checkPity() < 25 and SingleBoss_Enabled do
            Akaza_AttackLoop(HRP)
            task.wait(0.2)
        end

        if SingleBoss_Selected and SingleBoss_Selected ~= "Select Boss" then
            local npc = SingleBoss_Find(SingleBoss_Selected)
            local pos = BossPositions[SingleBoss_Selected]

            if npc then
                SingleBoss_AttackBoss(npc, HRP)
            elseif pos then
                HRP.CFrame = CFrame.new(pos)
                task.wait(0.1)

                if SingleBoss_Selected == "Abyssal Beast" or SingleBoss_Selected == "Shigaraki" then
                    local AutoGetItem = true
                    while not SingleBoss_Find(SingleBoss_Selected) and AutoGetItem and SingleBoss_Enabled do
                        task.wait(0.1)
                        local success, err = pcall(function()
                            local StorageGUI = plr.PlayerGui['Button']
                            if StorageGUI and not StorageGUI:FindFirstChild('Confirm') then
                                if SingleBoss_Selected == "Shigaraki" then
                                    for _, item in pairs(Event:findDarknessSpirit()) do
                                        if StorageGUI["Storage_Frame"]["Material_Frame"]:FindFirstChild(item.Name) then
                                            Event:fireclickbutton(StorageGUI["Storage_Frame"]["Material_Frame"][item.Name]["Button"])
                                        end
                                    end
                                elseif SingleBoss_Selected == "Abyssal Beast" then
                                    for _, item in pairs(Event:findCore()) do
                                        if StorageGUI["Storage_Frame"]["Material_Frame"]:FindFirstChild(item.Name) then
                                            Event:fireclickbutton(StorageGUI["Storage_Frame"]["Material_Frame"][item.Name]["Button"])
                                        end
                                    end
                                end
                            end

                            if StorageGUI and StorageGUI:FindFirstChild('Confirm') then
                                local Confirm = StorageGUI['Confirm']
                                if Confirm:FindFirstChild('Accept') then
                                    Event:fireclickbutton(Confirm['Accept']['Button'])
                                end
                            end
                        end)
                        if err then warn("Error in Auto Open Item: ", err) end
                    end

                    local npcSpawned = SingleBoss_Find(SingleBoss_Selected)
                    if npcSpawned then
                        SingleBoss_AttackBoss(npcSpawned, HRP)
                    end
                elseif SingleBoss_Selected == "Aizen" or SingleBoss_Selected == "Tanjiro" or SingleBoss_Selected == "Kaneki" then
                    PressE()
                end
            end
        end

        task.wait(0.2)
    end
end

local SingleBoss_Task
local function SingleBoss_Start()
    if SingleBoss_Task then return end
    SingleBoss_Task = task.spawn(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local HRP = char:WaitForChild("HumanoidRootPart")

        while SingleBoss_Enabled do
            SingleBoss_Loop(HRP)
            task.wait(0.2)
        end

        SingleBoss_Task = nil
    end)
end

plr.CharacterAdded:Connect(function(char)
    if SingleBoss_Enabled then
        task.wait(0.8)
        local HRP = char:WaitForChild("HumanoidRootPart")
        while SingleBoss_Enabled do
            SingleBoss_Loop(HRP)
            task.wait(0.2)
        end
    end
end)

TabAutoFarm:AddDropdown("SingleBoss_Dropdown", {
    Title = "Select Single Boss",
    Values = {
        "Select Boss",
        "Yuta",
        "Zangetsu",
        "Aizen",
        "Tanjiro",
        "Sung Jin Woo",
        "Silver Fang",
        "Abyssal Beast",
        "Shigaraki",
        "Herta",
        "Kafka"
    },
    Default = "Select Boss",
    Callback = function(v) SingleBoss_Selected = v end
})

TabAutoFarm:AddToggle("SingleBoss_Toggle", {
    Title = "Start Single Boss Farm",
    Default = false,
    Callback = function(state)
        SingleBoss_Enabled = state

        local bossUI = plr:WaitForChild("PlayerGui"):WaitForChild("Button"):WaitForChild("Boss Spawn")
        if state then
            if not originalGUIPos then originalGUIPos = bossUI.Position end
            bossUI.Position = UDim2.new(0.8, 0, 0.1, 0)
            bossUI.Visible = true
            SingleBoss_Start()
        else
            if originalGUIPos then
                bossUI.Position = originalGUIPos
            end
            bossUI.Visible = false
        end
    end
})

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer

local AutoFarm = false
local AkazaBoss = "Akaza"

local function FindBoss(name)
    if name == "Yuta" then
        return workspace.Main.Characters["Jujutsu Highschool"].Boss:FindFirstChild("Yuta")

    elseif name == "Sung Jin Woo" then
        local folder = workspace.Main.Characters["Rogue Town [Backside]"]:FindFirstChild("Boss")
        return folder and folder:FindFirstChild("Sung Jin Woo")

    elseif name == "Silver Fang" then
        local folder = workspace.Main.Characters["Rogue Town [Backside]"]:FindFirstChild("Boss")
        return folder and folder:FindFirstChild("Silver Fang")

    elseif name == "Anos" then
        local folder = workspace.Main.Characters["Abyss Hill [Upper]"]:FindFirstChild("Boss")
        return folder and folder:FindFirstChild("Anos")

    elseif name == AkazaBoss then
        local throne = workspace.Main.Characters:FindFirstChild("Throne Isle")
        return throne and throne.Boss:FindFirstChild(AkazaBoss)
    end
    return nil
end

local function Press(key)
    VirtualInput:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInput:SendKeyEvent(false, key, false, game)
end

local function GetPity()
    return (plr:FindFirstChild("Pity") and plr.Pity.Boss.Value) or 0
end

local function AttackBoss(npc, hrp)
    local hum = npc:FindFirstChild("Humanoid")
    if not hum then return end

    while hum.Health > 0 and AutoFarm do
        local root = npc:FindFirstChild("HumanoidRootPart")
        if not root then break end

        local pos = root.Position - root.CFrame.LookVector * 11.5

        TweenService:Create(hrp, TweenInfo.new(0.08), {
            CFrame = CFrame.new(pos, root.Position)
        }):Play()

        ReplicatedStorage.Remotes.Serverside:FireServer(
            "Server",
            SelectedType,
            "M1s",
            SelectedWeapon,
            AttackValue
        )

        task.wait(0.01)
    end
end

local function SpawnAkaza()
    if not AutoFarm then return end
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = CFrame.new(481.75, 2.65, -626.47)
    Press(Enum.KeyCode.E)
    task.wait(0.2)

    local btn = plr.PlayerGui.Button["Boss Spawn"].Frame[AkazaBoss].Button
    if btn then
        GuiService.SelectedObject = btn
        Press(Enum.KeyCode.Return)
        task.wait(0.1)
    end

    local spawnBtn = plr.PlayerGui.Button["Boss Spawn"].Spawn.Button
    if spawnBtn then
        GuiService.SelectedObject = spawnBtn
        Press(Enum.KeyCode.Return)
    end
end

local function PityLoop(hrp)
    while AutoFarm and GetPity() < 25 do
        local npc = FindBoss(AkazaBoss)
        if npc then
            AttackBoss(npc, hrp)
        else
            SpawnAkaza()
        end
        task.wait(0.1)
    end
end

local BossList = {
    "Yuta",
    "Anos",
    "Sung Jin Woo",
    "Silver Fang"
}

local function FarmBosses(hrp)

    local yuta = FindBoss("Yuta")
    if yuta then
        if yuta:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = yuta.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.15)
        end

        AttackBoss(yuta, hrp)

        -- 🎯 หลังจากฆ่า Yuta → กลับไปฟาร์ม pity
        return "YUTA_DONE"
    end

    for _, name in ipairs(BossList) do
        if name ~= "Yuta" then
            local npc = FindBoss(name)
            if npc then
                if npc:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.15)
                end

                AttackBoss(npc, hrp)
                return "KILLED_OTHER"
            end
        end
    end

    return "NONE"
end

local function StartAuto()
    task.spawn(function()
        local hrp = plr.Character:WaitForChild("HumanoidRootPart")

        while AutoFarm do

            PityLoop(hrp)

            local result = FarmBosses(hrp)

            if result == "YUTA_DONE" then
                PityLoop(hrp)
            end

            task.wait(0.1)
        end
    end)
end

TabAutoFarm:AddToggle("AutoFarmBossAll", {
    Title = "Auto Farm Yuta,Anos,SJW,Silver Fang",
    Default = false,
    Callback = function(state)
        AutoFarm = state
        if state then StartAuto() end
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Count = 1200

local function pressEnterAllAtOnce(totalPresses)
    for i = 1, totalPresses do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end
end

local function buySummonOrb()
    local shopGui = playerGui:WaitForChild("Button"):WaitForChild("Shop Item")
    local itemBuy = shopGui.Gems["Summon Orb"].Buy

    shopGui.Visible = true
    task.wait(0.1)

    GuiService.SelectedObject = itemBuy
    task.wait(0.05)

    pressEnterAllAtOnce(Count)

    task.wait(0.2)
    shopGui.Visible = false
    GuiService.SelectedObject = nil
end

task.spawn(function()
    while true do
        local currentSummonOrb = player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild("Summon Orb")
        if not currentSummonOrb or currentSummonOrb.Value < 100 then
            buySummonOrb()
        end
        task.wait(1)
    end
end)


TabAutoFarm:AddButton({
    Title = "Remove the blue frame./เอากรอบฟ้าๆออก",
    Callback = function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        
        -- กดปุ่ม Backslash (\) 1 ครั้ง
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)  -- กดลง
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game) -- ปล่อย
    end
})

local HideQuestCancel_Enabled = false

local function UpdateQuestCancel_Toggle(state)
    task.spawn(function()
        while HideQuestCancel_Enabled do
            if not plr.PlayerGui:FindFirstChild("HUD") then
                task.wait(0.2)
                continue
            end

            local cancelGui = plr.PlayerGui.HUD.Bar.List.Quest.Bar:FindFirstChild("Cancel")
            if cancelGui then
                cancelGui.Visible = false   -- เปิด toggle = ปิด GUI
            end

            task.wait(0.2)
        end

        -- ถ้า toggle ปิด → เปิด GUI กลับ
        local hud = plr.PlayerGui:FindFirstChild("HUD")
        if hud then
            local cancelGui = hud.Bar.List.Quest.Bar:FindFirstChild("Cancel")
            if cancelGui then
                cancelGui.Visible = true
            end
        end
    end)
end

TabAutoFarm:AddToggle("HideQuestCancel_Toggle", {
    Title = "Hide Quest Cancel Button",
    Default = false,
    Callback = function(state)
        HideQuestCancel_Enabled = state
        UpdateQuestCancel_Toggle(state)
    end
})



local Section = TabAutoFarm:AddSection("Select Auto Skill")

local SkillKeyMap = {
    Skill1 = Enum.KeyCode.Z,
    Skill2 = Enum.KeyCode.X,
    Skill3 = Enum.KeyCode.C,
    Skill4 = Enum.KeyCode.V
}

local AllSkills = { "Skill1", "Skill2", "Skill3", "Skill4" }
local AutoSkillEnabled = false

local function useAllSkills()
    while AutoSkillEnabled do
        for _, skillName in ipairs(AllSkills) do
            local skillNumber = tonumber(skillName:match("%d"))
            
            local args = {
                [1] = "Server",
                [2] = SelectedType,
                [3] = "Skill"..skillNumber,
                [4] = SelectedWeapon,
                [5] = AttackValue
            }
            ReplicatedStorage.Remotes.Serverside:FireServer(unpack(args))
            
            VirtualInputManager:SendKeyEvent(true, SkillKeyMap["Skill"..skillNumber], false, game)
            VirtualInputManager:SendKeyEvent(false, SkillKeyMap["Skill"..skillNumber], false, game)
        end
        task.wait(0)
    end
end

TabAutoFarm:AddToggle("AutoSkillToggle", {
    Title = "Auto Skill (All)",
    Default = false,
    Callback = function(state)
        AutoSkillEnabled = state
        if state then
            task.spawn(useAllSkills)
        end
    end
})

local Section = TabLand:AddSection("Select Buy Item")
local Count = 1
local SelectedAction = "Summon Orb"

local ActionDropdown = TabLand:AddDropdown("ActionDropdown", {
    Title = "Select item",
    Values = {"Summon Orb", "Core of Abyssal", "Darkness Spirit", "Kaneki's Blood"},
    Multi = false,
    Default = "Summon Orb",
})

ActionDropdown:OnChanged(function(Value)
    SelectedAction = Value
end)

local OneInput = TabLand:AddInput("OneInput", {
    Title = "Amount to buy",
    Default = "1",
    Numeric = true,
    Callback = function(Value)
        Count = tonumber(Value) or 1
    end
})

TabLand:AddButton({
    Title = "Click to Buy",
    Callback = function()

        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local GuiService = game:GetService("GuiService")

        local function pressEnterBatch()
            local totalPresses = Count
            local batchSize = Count
            local delayTime = 0.01

            local pressed = 0
            while pressed < totalPresses do
                local thisBatch = math.min(batchSize, totalPresses - pressed)
                for i = 1, thisBatch do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                end
                pressed = pressed + thisBatch
                task.wait(delayTime)
            end
        end

        if SelectedAction == "Summon Orb" then
            local shopGui = playerGui.Button:WaitForChild("Shop Item")
            local itemBuy = shopGui.Gems["Summon Orb"].Buy

            shopGui.Visible = true
            task.wait(0.1)

            GuiService.SelectedObject = itemBuy
            task.wait(0.05)

            pressEnterBatch()

            task.wait(0.2)

            shopGui.Visible = false
            GuiService.SelectedObject = nil
            return
        end

        local craftGui = playerGui.Button:WaitForChild("Craft")
        craftGui.Visible = true
        task.wait(0.1)

        local scroll = craftGui.Craft_Frame.Scroll
        local coreButton = scroll[SelectedAction].Craft  -- ตรงนี้จะใช้ SelectedAction โดยตรง

        GuiService.SelectedObject = coreButton
        task.wait(0.05)

        pressEnterBatch()

        task.wait(0.2)

        craftGui.Visible = false
        GuiService.SelectedObject = nil
    end
})
----------------------------------------------------------------------------------------------------------------
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local allNPCs = {
	workspace.Main.NPCs.Combat.Aizen,
	workspace.Main.NPCs.Combat.Akaza,
	workspace.Main.NPCs.Combat.David,
	workspace.Main.NPCs.Combat.Gojo,
	workspace.Main.NPCs.Combat.Sukuna,
	workspace.Main.NPCs.Quests,
	workspace.Main.NPCs.Quests["{}"],
	workspace.Main.NPCs.Quests["1"],
	workspace.Main.NPCs.Quests["10"],
	workspace.Main.NPCs.Quests["2"],
	workspace.Main.NPCs.Quests["3"],
	workspace.Main.NPCs.Quests["4"],
	workspace.Main.NPCs.Quests["5"],
    workspace.Main.NPCs.Sword["Solemn Lament"],
	workspace.Main.NPCs.Quests["6"],
    workspace.Main.NPCs.Craft,
    workspace.Main.NPCs["Heritage Chest Exchange"],
	workspace.Main.NPCs.Quests["7"],
	workspace.Main.NPCs.Quests["8"],
	workspace.Main.NPCs.Quests["9"],
	workspace.Main.NPCs["Set Spawn"],
	workspace.Main.NPCs.Sword,
	workspace.Main.NPCs.Sword["Dark Blade Seller"],
	workspace.Main.NPCs.Sword["Dual Dagger"],
	workspace.Main.NPCs.Sword["Dual Katana Seller"],
	workspace.Main.NPCs.Sword["Gryphon Seller"],
	workspace.Main.NPCs.Sword["Katana Seller"],
	workspace.Main.NPCs.Sword["Tanjiro's Nichirin"],
	workspace.Main.NPCs.Sword["Tensa Zangetsu"],
	workspace.Main.NPCs.Sword["Yuta's Katana"],
	workspace.Main.NPCs.Sword.Zangetsu,
	workspace.Main.NPCs.Blacksmith,
	workspace.Main.NPCs["Boss Spawn1"],
	workspace.Main.NPCs["Boss Spawn2"],
	workspace.Main.NPCs["Boss Spawn3"],
	workspace.Main.NPCs.Capsule,
	workspace.Main.NPCs.Exchange,
	workspace.Main.NPCs["Fishing Rod"],
	workspace.Main.NPCs["Fruit Reroll Gem"],
	workspace.Main.NPCs["Fruit Reroll Money"],
	workspace.Main.NPCs["Group Reward"],
	workspace.Main.NPCs.Guarantee,
	workspace.Main.NPCs["Haki Trainer"],
	workspace.Main.NPCs.Mission,
	workspace.Main.NPCs["Observation Trainer"],
	workspace.Main.NPCs["Rank Up"],
	workspace.Main.NPCs["Sell Fish"],
	workspace.Main.NPCs.Shop,
	workspace.Main.NPCs["Stats Reroll"],
	workspace.Main.NPCs.Title,
	workspace.Main.NPCs["Trait Reroll"],
}

local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end
RunService.Heartbeat:Connect(function()
    for _, npcFolder in pairs(allNPCs) do
        if npcFolder then
            for _, descendant in pairs(npcFolder:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    descendant.HoldDuration = 0
                end
            end
        end
    end
end)
---------------------------------------------------
SaveManager:LoadAutoloadConfig()
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Setting)
SaveManager:BuildConfigSection(Setting)
Window:SelectTab(1)
---------------------------------------------------

