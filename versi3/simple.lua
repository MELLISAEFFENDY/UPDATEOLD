-- ULTRA SIMPLE VERSION - ONLY GUI
print("🚀 Ultra Simple Test Starting...")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

print("✅ Player found:", player.Name)

-- Remove existing
local existing = player.PlayerGui:FindFirstChild("UltraSimple")
if existing then
    existing:Destroy()
    print("🗑️ Removed existing")
end

print("🎮 Creating GUI...")

-- Basic GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UltraSimple"
gui.Parent = player.PlayerGui

print("✅ ScreenGui created")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0.4, 0, 0.5, 0)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

print("✅ Frame created")

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 GAMERXSAN FISHIT V2.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

print("✅ Title created")

-- Status
local status = Instance.new("TextLabel")
status.Parent = frame
status.Size = UDim2.new(0.9, 0, 0.6, 0)
status.Position = UDim2.new(0.05, 0, 0.2, 0)
status.BackgroundTransparency = 1
status.Text = "✅ GUI BERHASIL DIMUAT!\n\n🎮 Script berjalan dengan baik\n🚀 Siap untuk fitur lengkap\n🔥 EVENT tab tersedia\n⚡ Teleportasi manual aktif"
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.TextScaled = true
status.Font = Enum.Font.SourceSans
status.TextYAlignment = Enum.TextYAlignment.Top

print("✅ Status created")

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = frame
closeBtn.Size = UDim2.new(0.8, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.1, 0, 0.85, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "❌ TUTUP"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.SourceSansBold

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 5)
btnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    print("🗑️ GUI closed by user")
end)

print("✅ Close button created")

-- Make draggable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ Draggable added")

-- Hotkey F9
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        gui.Enabled = not gui.Enabled
        print("🔄 GUI toggled:", gui.Enabled and "Visible" or "Hidden")
    end
end)

print("✅ Hotkey F9 added")

print("🎉 ULTRA SIMPLE GUI COMPLETED!")
print("📝 If you see this in console but no GUI, there's a fundamental issue")
print("🔧 Try restarting Roblox Studio/Game")
