
-- UI Variables
local fishingActive = false
local rodName = nil
local statusLabel, rodLabel, startButton, stopButton

-- UI Setup
local function createUI()
    local player = game.Players.LocalPlayer
    if player.PlayerGui:FindFirstChild("Fish1UI") then
        player.PlayerGui.Fish1UI:Destroy()
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "Fish1UI"
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 120)
    frame.Position = UDim2.new(0, 20, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 10)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Idle"
    statusLabel.TextColor3 = Color3.fromRGB(200,255,200)
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.TextSize = 18
    statusLabel.Parent = frame

    rodLabel = Instance.new("TextLabel")
    rodLabel.Size = UDim2.new(1, -20, 0, 24)
    rodLabel.Position = UDim2.new(0, 10, 0, 44)
    rodLabel.BackgroundTransparency = 1
    rodLabel.Text = "Rod: -"
    rodLabel.TextColor3 = Color3.fromRGB(200,200,255)
    rodLabel.Font = Enum.Font.SourceSans
    rodLabel.TextSize = 16
    rodLabel.Parent = frame

    startButton = Instance.new("TextButton")
    startButton.Size = UDim2.new(0, 80, 0, 28)
    startButton.Position = UDim2.new(0, 10, 0, 80)
    startButton.Text = "Mulai"
    startButton.BackgroundColor3 = Color3.fromRGB(60,180,80)
    startButton.TextColor3 = Color3.new(1,1,1)
    startButton.Font = Enum.Font.SourceSansBold
    startButton.TextSize = 16
    startButton.Parent = frame

    stopButton = Instance.new("TextButton")
    stopButton.Size = UDim2.new(0, 80, 0, 28)
    stopButton.Position = UDim2.new(0, 110, 0, 80)
    stopButton.Text = "Stop"
    stopButton.BackgroundColor3 = Color3.fromRGB(200,60,60)
    stopButton.TextColor3 = Color3.new(1,1,1)
    stopButton.Font = Enum.Font.SourceSansBold
    stopButton.TextSize = 16
    stopButton.Parent = frame
end

-- Cari nama rod otomatis dari Backpack/Inventory
local function getRodName()
    local backpack = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item.Name:lower():find("rod") then
                return item.Name
            end
        end
    end
    return "Starter Rod" -- fallback
end

-- Main fishing logic
local function FrequencyExploit_HIGH_RISK()
    -- Cari remote equip rod (jika ada)
    local equipRemote = game.ReplicatedStorage:FindFirstChild("EquipRod")
        or game.ReplicatedStorage:FindFirstChild("EquipFishingRod")
    local rodRemote = game.ReplicatedStorage:FindFirstChild("ChargeFishingRod")
        or game.ReplicatedStorage:FindFirstChild("RF/ChargeFishingRod")
        or game.ReplicatedStorage:FindFirstChild("FishingRodRemote")
    local finishRemote = game.ReplicatedStorage:FindFirstChild("FishingCompleted")
        or game.ReplicatedStorage:FindFirstChild("RE/FishingCompleted")
        or game.ReplicatedStorage:FindFirstChild("FinishFishing")



    rodName = getRodName()
    if rodLabel then rodLabel.Text = "Rod: "..rodName end


    -- Proses awal: equip rod (jika remote ada)
    if equipRemote then
        if statusLabel then statusLabel.Text = "Status: Equip rod... ("..rodName..")" end
        if equipRemote:IsA("RemoteFunction") then
            equipRemote:InvokeServer(rodName)
        else
            equipRemote:FireServer(rodName)
        end
        wait(1)
    else
        if statusLabel then statusLabel.Text = "Status: Equip remote not found!" end
        print("Equip remote not found, lanjut tanpa equip.")
    end


    if rodRemote and finishRemote then
        for i = 1, 10 do
            if not fishingActive then break end
            if statusLabel then statusLabel.Text = "Status: Fishing ("..i.."/10)" end
            if rodRemote:IsA("RemoteFunction") then
                rodRemote:InvokeServer()
            else
                rodRemote:FireServer()
            end
            wait(0.1)
            finishRemote:FireServer("Perfect")
            wait(0.1)
        end
        if statusLabel then statusLabel.Text = "Status: Selesai!" end
    else
        if statusLabel then statusLabel.Text = "Status: Remotes not found!" end
        print("Remotes not found!")
    end

    print("❌ Method 3: Unnatural frequency - Bot pattern detection")
    print("🚨 Detection: Statistical analysis + human behavior modeling")
    if statusLabel then statusLabel.Text = "Status: Idle" end
end


-- UI Button logic
local function onStart()
    if fishingActive then return end
    fishingActive = true
    if statusLabel then statusLabel.Text = "Status: Mulai..." end
    FrequencyExploit_HIGH_RISK()
    fishingActive = false
end

local function onStop()
    fishingActive = false
    if statusLabel then statusLabel.Text = "Status: Dihentikan" end
end

createUI()
if startButton then startButton.MouseButton1Click:Connect(onStart) end
if stopButton then stopButton.MouseButton1Click:Connect(onStop) end
