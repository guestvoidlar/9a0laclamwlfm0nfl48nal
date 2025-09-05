--// SpyderVoidlar Steal Helper GUI
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SpyderVoidStealGUI"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 180)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(200, 0, 0)
Frame.Active = true
Frame.Parent = ScreenGui

-- Sürüklenebilir sistem
local dragging = false
local dragInput, mousePos, framePos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        Frame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "SpyderVoidlar's Sexy Steal"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

-- Buton
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.8, 0, 0, 40)
Button.Position = UDim2.new(0.1, 0, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "Steal Başlat"
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 18
Button.Parent = Frame

-- Ekran foto
local ScreenOverlay = Instance.new("ImageLabel")
ScreenOverlay.Size = UDim2.new(1,0,1,0)
ScreenOverlay.Position = UDim2.new(0,0,0,0)
ScreenOverlay.BackgroundTransparency = 1
ScreenOverlay.Visible = false
ScreenOverlay.Image = "https://resmim.net/cdn/2025/09/05/jfRcqW.png"
ScreenOverlay.ZIndex = 10
ScreenOverlay.Parent = ScreenGui

-- Base'i otomatik bul (spydervoidlar)
local function GetPlayerBase()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:find("spydervoidlar") then
            if obj:FindFirstChild("HumanoidRootPart") then
                return obj.HumanoidRootPart.CFrame
            end
        end
    end
    return CFrame.new(0,10,0)
end

-- Çalma işlemi
local function StartSteal()
    ScreenOverlay.Visible = true
    local baseCFrame = GetPlayerBase()
    local Character = Player.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = baseCFrame + Vector3.new(0,5,0)
    end
    task.wait(3)
    ScreenOverlay.Visible = false
end

-- Butona tıklayınca başlat
Button.MouseButton1Click:Connect(function()
    StartSteal()
end)
