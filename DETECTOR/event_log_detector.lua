-- Event Log Detector v1.0
-- Mendeteksi dan menampilkan event-event yang sedang terjadi secara real-time

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Buat UI log sederhana
local screen = Instance.new("ScreenGui")
screen.Name = "EventLogDetector"
screen.Parent = CoreGui
screen.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screen
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "📝 Event Log Detector"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

local logBox = Instance.new("TextBox")
logBox.Parent = mainFrame
logBox.Size = UDim2.new(1, -20, 1, -50)
logBox.Position = UDim2.new(0, 10, 0, 40)
logBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
logBox.TextColor3 = Color3.fromRGB(200, 255, 200)
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.TextWrapped = true
logBox.TextEditable = false
logBox.ClearTextOnFocus = false
logBox.MultiLine = true
logBox.Text = ""

-- Fungsi logging
local allLogs = {}
local function logEvent(text)
    logBox.Text = logBox.Text .. text .. "\n"
    table.insert(allLogs, text)
    logBox.CursorPosition = #logBox.Text + 1
end

-- Mendeteksi event RemoteEvent dan RemoteFunction
local function hookRemotes()
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            remote.OnClientEvent:Connect(function(...)
                logEvent("[RemoteEvent] " .. remote.Name .. " | Args: " .. tostring(...) .. " | Time: " .. os.date("%H:%M:%S"))
            end)
        elseif remote:IsA("RemoteFunction") then
            remote.OnClientInvoke = function(...)
                logEvent("[RemoteFunction] " .. remote.Name .. " | Args: " .. tostring(...) .. " | Time: " .. os.date("%H:%M:%S"))
            end
        end
    end
end

hookRemotes()

logEvent("Event Log Detector started at " .. os.date("%H:%M:%S"))
logEvent("Menunggu event terjadi...")

-- Auto refresh/hook jika ada remote baru
task.spawn(function()
    while true do
        task.wait(10)
        hookRemotes()
    end
end)

-- Floating button untuk show/hide UI
local floatingBtn = Instance.new("TextButton")
floatingBtn.Parent = screen
floatingBtn.Size = UDim2.new(0, 50, 0, 50)
floatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
floatingBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
floatingBtn.BorderSizePixel = 0
floatingBtn.Text = "📝"
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.TextScaled = true
floatingBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", floatingBtn).CornerRadius = UDim.new(0.5, 0)

local isUIVisible = true
floatingBtn.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    mainFrame.Visible = isUIVisible
    floatingBtn.BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
    floatingBtn.Text = isUIVisible and "📝" or "👁"
end)
mainFrame.Visible = true

-- Tombol export/copy semua log ke clipboard
local exportBtn = Instance.new("TextButton")
exportBtn.Parent = mainFrame
exportBtn.Size = UDim2.new(0, 120, 0, 30)
exportBtn.Position = UDim2.new(1, -130, 1, -35)
exportBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
exportBtn.BorderSizePixel = 0
exportBtn.Text = "📋 Export Log"
exportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportBtn.TextScaled = true
exportBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", exportBtn).CornerRadius = UDim.new(0, 6)

exportBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(table.concat(allLogs, "\n"))
        logEvent("[Export] Semua log telah dicopy ke clipboard!")
    else
        logEvent("[Export] setclipboard tidak tersedia di executor ini.")
    end
end)
