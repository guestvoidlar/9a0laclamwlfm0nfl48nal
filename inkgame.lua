local GlobalEnv = getgenv()
local FunctionEnv = getfenv()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
end)

local infJump = false
UserInputService.JumpRequest:Connect(function()
    if infJump and Character and Character:FindFirstChild("HumanoidRootPart") and Humanoid then
        Character.HumanoidRootPart.Velocity = Vector3.new(
            Character.HumanoidRootPart.Velocity.X, 
            Humanoid.JumpPower, 
            Character.HumanoidRootPart.Velocity.Z
        )
    end
end)

-- GÜNCELLENMİŞ GÜVENLİ COORD RLGL GOD MODE
GlobalEnv.RLGL_GodMode = false
local function ToggleGodMode(state)
    GlobalEnv.RLGL_GodMode = state
    if Character then
        local currentPivot = Character:GetPivot()
        if state then
            -- Yukarı güvenli mesafeye ışınlanma
            Character:PivotTo(currentPivot * CFrame.new(0, 180, 0))
        else
            -- Haritanın altına düşmemek için -150 blok geri iniş
            Character:PivotTo(currentPivot * CFrame.new(0, -150, 0))
        end
    end
end

-- PLATFORM DESTEKLİ GELİŞMİŞ INVISIBLE YAPISI (Anti-Cheat Korumalı)
local offsetConnection = nil
local LocalAntiCheatPlate = nil

local function ToggleInvisibility(state)
    if state then
        if offsetConnection then offsetConnection:Disconnect() end
        
        -- Anti-Cheat'i kandırmak için görünmez yerel taban platformu oluşturuyoruz
        if not LocalAntiCheatPlate then
            LocalAntiCheatPlate = Instance.new("Part")
            LocalAntiCheatPlate.Name = "VoidHub_AntiCheatSafety"
            LocalAntiCheatPlate.Size = Vector3.new(200, 2, 200) -- Geniş platform
            LocalAntiCheatPlate.Anchored = true
            LocalAntiCheatPlate.CanCollide = true
            LocalAntiCheatPlate.Transparency = 1 -- Tamamen görünmez
            LocalAntiCheatPlate.Material = Enum.Material.SmoothPlastic
            LocalAntiCheatPlate.Parent = workspace
        end
        
        offsetConnection = RunService.RenderStepped:Connect(function()
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                local rootCFrame = Character.HumanoidRootPart.CFrame
                
                -- Koruma platformunu her karede karakterimizin tam 26 blok altına sabitliyoruz
                if LocalAntiCheatPlate then
                    LocalAntiCheatPlate.CFrame = rootCFrame * CFrame.new(0, -26, 0)
                end
                
                -- Uzuvları platformun üstüne (-25 blok) kaydırıyoruz
                for _, part in ipairs(Character:GetChildren()) do
                    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                    local isToolPart = part:IsDescendantOf(Character:FindFirstChildOfClass("Tool") or workspace) 
                        or (Backpack and part:IsDescendantOf(Backpack))
                    
                    -- RootPart'a ve elimizdeki/çantamızdaki eşyalara dokunmuyoruz
                    if not isToolPart and part.Name ~= "HumanoidRootPart" then
                        if part:IsA("BasePart") then
                            part.CFrame = rootCFrame * CFrame.new(0, -25, 0)
                        elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                            part.Handle.CFrame = rootCFrame * CFrame.new(0, -25, 0)
                        end
                    end
                end
            end
        end)
        
        if Humanoid then
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    else
        -- Kapatıldığında her şeyi temizle ve eski haline getir
        if offsetConnection then
            offsetConnection:Disconnect()
            offsetConnection = nil
        end
        
        if LocalAntiCheatPlate then
            LocalAntiCheatPlate:Destroy()
            LocalAntiCheatPlate = nil
        end
        
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    AutoShow = true,
    Title = "Void Hub",
    Footer = "@alexandriuslang on discord",
    Icon = 97167002328360,
    NotifySide = "Right",
    ShowCustomCursor = false
})

local MainTab = Window:AddTab("Main", "lightbulb")
local RedLightTab = Window:AddTab("Red Light Green Light", "lightbulb")
local DalgonaTab = Window:AddTab("Dalgona", "cookie")
local jrgbTab = Window:AddTab("Jump Rope, Glass Bridge", "rope")
local hnsTab = Window:AddTab("Hide and Seek", "sword")
local mingleTab = Window:AddTab("Mingle", "number")
local UISettingsTab = Window:AddTab("UI Settings", "settings") 

local powersGroupBox = MainTab:AddLeftGroupbox("Powers", "wrench")
local chGroupBox = MainTab:AddRightGroupbox("Character Features", "user")

local lighterGroupBox = DalgonaTab:AddLeftGroupbox("Free Lighter", "fire")
local dalgonaUtilities = DalgonaTab:AddRightGroupbox("Utilities", "shield")

local seekerGroupBox = hnsTab:AddLeftGroupbox("Seeker Features", "sword")
local hiderGroupBox = hnsTab:AddRightGroupbox("Hider Features", "eye")

local gbGroupBox = jrgbTab:AddLeftGroupbox("Glass Bridge", "bridge")
local jrGroupBox = jrgbTab:AddRightGroupbox("Jump Rope", "rope")

local mingGroupBox = mingleTab:AddLeftGroupbox("Noclip", "shield")

powersGroupBox:AddButton("Parkour Artist", function()
    LocalPlayer:SetAttribute("_EquippedPower", "PARKOUR ARTIST")
end)

local WalkSpeedConnection
chGroupBox:AddToggle("WalkSpeedIncrease", {
    Text = "WalkSpeed Increase (CHOOSE BELOW)",
    Default = false,
    Callback = function(State)
        if not State then return end
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Hum then Hum.WalkSpeed = Library.Options.WalkSpeedAmount.Value or 16 end
        WalkSpeedConnection = LocalPlayer.CharacterAdded:Connect(function(Char)
            local NewHum = Char:WaitForChild("Humanoid")
            if NewHum and Library.Toggles.WalkSpeedIncrease.Value then
                NewHum.WalkSpeed = Library.Options.WalkSpeedAmount.Value or 16
            end
        end)
        task.spawn(function()
            while Library.Toggles.WalkSpeedIncrease.Value do
                local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if Hum then Hum.WalkSpeed = Library.Options.WalkSpeedAmount.Value or 16 end
                task.wait(0.4)
            end
        end)
    end
})

chGroupBox:AddSlider("WalkSpeedAmount", {
    Min = 1, Default = 16, Max = 100,
    Text = "WalkSpeed Amount",
    Callback = function(Value)
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Hum then Hum.WalkSpeed = Value end
    end
})

chGroupBox:AddButton("Reset WalkSpeed to Normal", function()
    local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if Hum then Hum.WalkSpeed = 16 end
    if WalkSpeedConnection then WalkSpeedConnection:Disconnect() end
end)

local noclip_on = false
local function runNoclip()
    local char = Players.LocalPlayer.Character
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            if obj.Transparency and obj.Transparency >= 0.99 then continue end
            local name = obj.Name:lower()
            if name:find("wall") then
                obj.CanCollide = not noclip_on
            elseif name:find("floor") or name:find("ground") or name:find("plate") then
                obj.CanCollide = true
            else
                if obj.Size.Y < obj.Size.X and obj.Size.Y < obj.Size.Z then
                    obj.CanCollide = true
                elseif obj.Size.Y > obj.Size.X or obj.Size.Y > obj.Size.Z then
                    obj.CanCollide = not noclip_on
                end
            end
        end
    end
end

local noclipEzToggle = chGroupBox:AddToggle("noclipez", {
    Text = "Noclip",
    Default = false,
    Callback = function(val)
        noclip_on = val
        runNoclip()
    end
})

noclipEzToggle:AddKeyPicker("Noclip", {
    Default = "X", Mode = "Toggle", Text = "Noclip",
    Callback = function(v) noclipEzToggle:SetValue(v) end
})

chGroupBox:AddToggle("InfiniteJumpToggle", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(v) infJump = v end
})

-- Anti-Cheat Korumalı ve Eşya İzinli Görünmezlik
chGroupBox:AddToggle("InvisibleToggle", {
    Text = "Invisibility (BETA)",
    Default = false,
    Callback = function(State)
        ToggleInvisibility(State)
    end
})

local RedLightMainBox = RedLightTab:AddLeftGroupbox("Main Features")
local RedLightUtilitiesBox = RedLightTab:AddRightGroupbox("Utilities")

RedLightMainBox:AddToggle("RLGLGodModeToggle", {
    Text = "God Mode (Dikey Işınlanma)",
    Default = false,
    Callback = function(State)
        ToggleGodMode(State)
    end
})

RedLightMainBox:AddButton("Finish RDGL", function()
    if Character then Character:PivotTo(CFrame.new(Vector3.new(-215.82, 1023.05, 145.96))) end
end)

RedLightMainBox:AddButton("Remove Injury", function()
    local Player = LocalPlayer
    local Char = Player.Character
    local Hum = Char:FindFirstChild("Humanoid")
    local RootPart = Char:FindFirstChild("HumanoidRootPart")
    
    Hum.PlatformStand = false
    Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    Hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    Hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    Hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    Hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    Hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
    Hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    for _, con in pairs(RootPart:GetChildren()) do
        if con:IsA("BallSocketConstraint") then con:Destroy() end
    end
    for _, p in pairs(Char:GetChildren()) do
        if p:IsA("BasePart") and p:FindFirstChild("BoneCustom") then p.BoneCustom:Destroy() end
    end
    
    if Char:FindFirstChild("Ragdoll") then Char.Ragdoll:Destroy() end
    if Char:FindFirstChild("Stun") then Char.Stun:Destroy() end
    if Char:FindFirstChild("RotateDisabled") then Char.RotateDisabled:Destroy() end
    if Char:FindFirstChild("RagdollWakeupImmunity") then Char.RagdollWakeupImmunity:Destroy() end
    
    local fx = workspace:FindFirstChild("Effects")
    if fx and fx:FindFirstChild("LocalRagdolls") and fx.LocalRagdolls:FindFirstChild(Player.Name) then
        fx.LocalRagdolls[Player.Name]:Destroy()
    end
end)

RedLightUtilitiesBox:AddToggle("AutoCollectBandage", {
    Text = "Auto Collect Bandage",
    Default = false,
    Callback = function(State) if not State then return end end
})

lighterGroupBox:AddButton("Free Lighter", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ergergq2/erge.github.io/refs/heads/main/free.lua"))()
end)

local comingLabel = dalgonaUtilities:AddLabel("Coming Soon!", false)

seekerGroupBox:AddToggle("SmartKillHidersToggle", {
    Text = "Kill Hiders (BETA)",
    Default = false,
    Callback = function(State)
        if not State then return end
        task.spawn(function()
            while Library.Toggles.SmartKillHidersToggle.Value do
                local KillingParts = workspace:FindFirstChild("HideAndSeekMap"):FindFirstChild("KillingParts")
                if KillingParts then KillingParts:Destroy() end
                task.wait(2)
            end
        end)
    end
})

seekerGroupBox:AddButton("Delete the spikes", function()
    local map = workspace:FindFirstChild("HideAndSeekMap")
    if map then
        local killing = map:FindFirstChild("KillingParts")
        if killing then killing:Destroy() end
    end
end)

seekerGroupBox:AddButton("Teleport to Random Hider", function()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player:FindFirstChild("Backpack") then
            if Player.Backpack:FindFirstChild("DODGE!") then
                local Live = Workspace:FindFirstChild("Live")
                if Live then
                    local TargetChar = Live:FindFirstChild(Player.Name)
                    if TargetChar then
                        local TargetRoot = TargetChar:FindFirstChild("HumanoidRootPart")
                        if TargetRoot and Character then
                            Character:PivotTo(TargetRoot.CFrame + Vector3.new(0, 2, 0))
                            break
                        end
                    end
                end
            end
        end
    end
end)

seekerGroupBox:AddToggle("KillAuraSafe", {
    Text = "Kill Aura (BETA)",
    Default = false,
    Callback = function(State) if not State then return end end
})

hiderGroupBox:AddButton("Teleport 100 Blocks Up", function()
    if Character then Character:PivotTo(Character:GetPivot() + Vector3.new(0, 100, 0)) end
end)

hiderGroupBox:AddButton("Teleport 40 Blocks Down", function()
    if Character then Character:PivotTo(Character:GetPivot() + Vector3.new(0, -40, 0)) end
end)

local SeekerColor = Color3.new(1, 0, 0)
local HiderColor = Color3.new(0, 0.5, 1)

local function CreatePlayerESP(TargetPlayer, IsSeeker)
    if TargetPlayer == LocalPlayer then return end
    if not TargetPlayer.Character then return end
    
    local Char = TargetPlayer.Character
    local Head = Char:FindFirstChild("Head")
    if not Head then return end
    
    local ExistingESP = Head:FindFirstChild("RoleESP")
    if ExistingESP then ExistingESP:Destroy() end
    
    for _, Part in ipairs(Char:GetChildren()) do
        if Part:IsA("BasePart") and Part:FindFirstChild("ESPBox") then Part.ESPBox:Destroy() end
    end
    
    local Color = IsSeeker and SeekerColor or HiderColor
    local RoleText = IsSeeker and "Seeker" or "Hider"
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "RoleESP"
    Billboard.Adornee = Head
    Billboard.Size = UDim2.new(0, 60, 0, 20)
    Billboard.StudsOffset = Vector3.new(0, 1, 0)
    Billboard.AlwaysOnTop = true
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.Parent = Billboard
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = RoleText
    Label.TextColor3 = Color
    Label.TextStrokeTransparency = 0.5
    Label.Font = Enum.Font.SourceSansBold
    Label.TextScaled = true
    Label.Parent = Billboard
    
    Billboard.Parent = Head
    
    for _, Part in ipairs(Char:GetChildren()) do
        if Part:IsA("BasePart") then
            local Box = Instance.new("BoxHandleAdornment")
            Box.Name = "ESPBox"
            Box.Size = Part.Size
            Box.Adornee = Part
            Box.AlwaysOnTop = true
            Box.ZIndex = 10
            Box.Transparency = 0.5
            Box.Color3 = Color
            Box.Parent = Part
        end
    end
end

hiderGroupBox:AddToggle("EspHiderSeeker", {
    Text = "ESP Hider & Seeker",
    Default = false,
    Callback = function(State)
        if not State then return end
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local HasKnife = (Player.Backpack:FindFirstChild("Knife") or Player.Character:FindFirstChild("Knife"))
                CreatePlayerESP(Player, HasKnife)
            end
            Player.CharacterAdded:Connect(function()
                task.wait(0.1)
                if Library.Toggles.EspHiderSeeker.Value then
                    local HasKnife = (Player.Backpack:FindFirstChild("Knife") or Player.Character:FindFirstChild("Knife"))
                    CreatePlayerESP(Player, HasKnife)
                end
            end)
        end
        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function()
                task.wait(0.1)
                if Library.Toggles.EspHiderSeeker.Value then
                    local HasKnife = (Player.Backpack:FindFirstChild("Knife") or Player.Character:FindFirstChild("Knife"))
                    CreatePlayerESP(Player, HasKnife)
                end
            end)
        end)
    end
})

local ExitDoorFillColor = Color3.fromRGB(21, 150, 0)
local ExitDoorOutlineColor = Color3.fromRGB(12, 150, 0)

local function CreateExitDoorESP()
    local HideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
    if not HideAndSeekMap then return end
    local FixedDoors = HideAndSeekMap:FindFirstChild("NEWFIXEDDOORS")
    if not FixedDoors then return end
    for _, Floor in ipairs(FixedDoors:GetChildren()) do
        if string.find(string.lower(Floor.Name), "floor") then
            local ExitDoors = Floor:FindFirstChild("EXITDOORS")
            if ExitDoors then
                for _, Door in ipairs(ExitDoors:GetChildren()) do
                    if string.find(string.lower(Door.Name), "exitdoor") then
                        local BasePart = Door:FindFirstChildOfClass("BasePart")
                        if BasePart then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Parent = BasePart
                            Highlight.FillColor = ExitDoorFillColor
                            Highlight.OutlineColor = ExitDoorOutlineColor
                            Highlight.FillTransparency = 0.3
                            Highlight.OutlineTransparency = 0
                            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            
                            local Billboard = Instance.new("BillboardGui")
                            Billboard.Adornee = BasePart
                            Billboard.AlwaysOnTop = true
                            Billboard.Size = UDim2.new(0, 100, 0, 25)
                            Billboard.StudsOffset = Vector3.new(0, 2, 0)
                            Billboard.Parent = BasePart
                            
                            local Label = Instance.new("TextLabel")
                            Label.BackgroundTransparency = 1
                            Label.Font = Enum.Font.Oswald
                            Label.Size = UDim2.new(1, 0, 1, 0)
                            Label.Text = "Exit Door"
                            Label.TextColor3 = ExitDoorFillColor
                            Label.TextSize = 22
                            Label.Parent = Billboard
                        end
                    end
                end
            end
        end
    end
end

hiderGroupBox:AddToggle("ExitDoorESP", {
    Text = "ESP Exit Doors",
    Default = false,
    Callback = function(State)
        if not State then return end
        CreateExitDoorESP()
        GlobalEnv.exitDoorESPConnectionAdded = workspace.DescendantAdded:Connect(function(Descendant)
            if Descendant:IsA("Model") and string.find(string.lower(Descendant.Name), "exitdoor") then
                task.wait(0.5)
                CreateExitDoorESP()
            end
        end)
        GlobalEnv.exitDoorESPConnectionRemoved = workspace.DescendantRemoving:Connect(function(Descendant)
            if Descendant:IsA("Model") and string.find(string.lower(Descendant.Name), "exitdoor") then
                CreateExitDoorESP()
            end
        end)
    end
})

hiderGroupBox:AddToggle("ESPKeys", {
    Text = "ESP Keys",
    Default = false,
    Callback = function(State)
        if not State then return end
        local Effects = Workspace:FindFirstChild("Effects")
        if not Effects then return end
        for _, Object in pairs(Effects:GetChildren()) do
            if Object:IsA("Model") and Object.PrimaryPart and Object.Name:find("DroppedKey") then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "KeyESP"
                Highlight.Adornee = Object
                Highlight.FillColor = Color3.fromRGB(255, 255, 0)
                Highlight.OutlineColor = Color3.fromRGB(255, 187, 0)
                Highlight.FillTransparency = 0.3
                Highlight.OutlineTransparency = 0
                Highlight.Parent = Object
                
                local Billboard = Instance.new("BillboardGui")
                Billboard.Adornee = Object.PrimaryPart
                Billboard.Size = UDim2.new(0, 60, 0, 20)
                Billboard.StudsOffset = Vector3.new(0, 2, 0)
                Billboard.AlwaysOnTop = true
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "Key"
                Label.TextColor3 = Color3.fromRGB(255, 255, 0)
                Label.TextStrokeTransparency = 0.5
                Label.Font = Enum.Font.GothamSemibold
                Label.TextSize = 16
                Label.Parent = Billboard
                
                Billboard.Parent = Object
            end
        end
    end
})

-- Glass Bridge
local createdPlatforms = {}
local originalColors = {}

gbGroupBox:AddToggle("GlassBridgeESP", {
    Text = "Glass ESP", 
    Default = false, 
    Callback = function(State)
        if not State then
            for part, color in pairs(originalColors) do if part and part.Parent then part.Color = color end end
            table.clear(originalColors)
            return
        end
        task.spawn(function()
            while Library.Toggles.GlassBridgeESP.Value do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:lower() == "glasspart" then
                        if not originalColors[v] then originalColors[v] = v.Color end
                        local isFake = v:GetAttribute("exploitingisevil") or v:GetAttribute("DelayedBreaking") or v:GetAttribute("ActuallyKilling")
                        v.Color = isFake and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

gbGroupBox:AddToggle("GlassBridgeAntiFall", {
    Text = "Anti Break", 
    Default = false, 
    Callback = function(State)
        if not State then
            for _, obj in pairs(createdPlatforms) do if obj then obj:Destroy() end end
            table.clear(createdPlatforms)
            return
        end
        task.spawn(function()
            while Library.Toggles.GlassBridgeAntiFall.Value do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:lower() == "glasspart" then
                        local isFake = v:GetAttribute("exploitingisevil") or v:GetAttribute("DelayedBreaking") or v:GetAttribute("ActuallyKilling")
                        if isFake and not v:FindFirstChild("AntiFallPlatform") then
                            local plate = Instance.new("Part")
                            plate.Name = "AntiFallPlatform"
                            plate.Size = v.Size
                            plate.CFrame = v.CFrame + Vector3.new(0, 1, 0)
                            plate.Color = Color3.fromRGB(0, 0, 0)
                            plate.Material = Enum.Material.SmoothPlastic
                            plate.Anchored = true
                            plate.CanCollide = true
                            plate.Transparency = 0
                            plate.Parent = v
                            table.insert(createdPlatforms, plate)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
})

-- Jump Rope
jrGroupBox:AddButton("TP to End", function()
    if Character then Character:PivotTo(CFrame.new(Vector3.new(720.83, 202.7, 921.26))) end
end)

jrGroupBox:AddButton("Delete The Rope (OP)", function()
    local Effects = Workspace:FindFirstChild("Effects")
    if Effects and Effects:FindFirstChild("rope") then Effects.rope:Destroy() end
    local SafePlatform = Instance.new("Part")
    SafePlatform.Size = Vector3.new(100, 1, 100)
    SafePlatform.Anchored = true
    SafePlatform.CanCollide = true
    SafePlatform.Position = Vector3.new(672.41, 190.24, 920.59)
    SafePlatform.Material = Enum.Material.SmoothPlastic
    SafePlatform.Color = Color3.fromRGB(89, 159, 0)
    
    local LogoTexture = Instance.new("Texture")
    LogoTexture.Texture = "rbxassetid://97167002328360"
    LogoTexture.Face = Enum.NormalId.Top
    LogoTexture.StudsPerTileU = 100
    LogoTexture.StudsPerTileV = 100
    LogoTexture.Parent = SafePlatform

    SafePlatform.Parent = Workspace
end)

-- Mingle
local noclipmingToggle = mingGroupBox:AddToggle("noclipez", {
    Text = "Mingle Noclip",
    Default = false,
    Callback = function(val)
        noclip_on = val
        runNoclip()
    end
})

noclipmingToggle:AddKeyPicker("Noclipm", {
    Default = "M", Mode = "Toggle", Text = "Mingle Noclip",
    Callback = function(v) noclipmingToggle:SetValue(v) end
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("void")
SaveManager:SetFolder("void/EUT")
SaveManager:BuildConfigSection(UISettingsTab)
ThemeManager:ApplyToTab(UISettingsTab)
SaveManager:LoadAutoloadConfig()