-- Auto Event & Location Detector v1.0
-- Mendeteksi event spesial (misal: Admin Event) dan lokasi event secara otomatis

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Buat UI sederhana
local screen = Instance.new("ScreenGui")
screen.Name = "AutoEventLocationDetector"
screen.Parent = CoreGui
screen.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screen
mainFrame.Size = UDim2.new(0, 400, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0, 60)
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
title.Text = "✨ Auto Event & Location Detector"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

local infoBox = Instance.new("TextLabel")
infoBox.Parent = mainFrame
infoBox.Size = UDim2.new(1, -20, 1, -50)
infoBox.Position = UDim2.new(0, 10, 0, 40)
infoBox.BackgroundTransparency = 1
infoBox.TextColor3 = Color3.fromRGB(200, 255, 200)
infoBox.Font = Enum.Font.Code
infoBox.TextSize = 16
infoBox.TextXAlignment = Enum.TextXAlignment.Left
infoBox.TextYAlignment = Enum.TextYAlignment.Top
infoBox.TextWrapped = true
infoBox.Text = "Menunggu event..."

-- Floating button
local floatingBtn = Instance.new("TextButton")
floatingBtn.Parent = screen
floatingBtn.Size = UDim2.new(0, 45, 0, 45)
floatingBtn.Position = UDim2.new(0, 20, 0, 10)
floatingBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
floatingBtn.BorderSizePixel = 0
floatingBtn.Text = "✨"
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.TextScaled = true
floatingBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", floatingBtn).CornerRadius = UDim.new(0.5, 0)

local isUIVisible = true
floatingBtn.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    mainFrame.Visible = isUIVisible
    floatingBtn.BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
    floatingBtn.Text = isUIVisible and "✨" or "👁"
end)
mainFrame.Visible = true

-- Tombol export/copy info event
local exportBtn = Instance.new("TextButton")
exportBtn.Parent = mainFrame
exportBtn.Size = UDim2.new(0, 120, 0, 30)
exportBtn.Position = UDim2.new(1, -130, 1, -35)
exportBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
exportBtn.BorderSizePixel = 0
exportBtn.Text = "📋 Export Info"
exportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportBtn.TextScaled = true
exportBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", exportBtn).CornerRadius = UDim.new(0, 6)

local lastInfo = ""
exportBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(lastInfo)
        infoBox.Text = infoBox.Text .. "\n[Export] Info event dicopy ke clipboard!"
    else
        infoBox.Text = infoBox.Text .. "\n[Export] setclipboard tidak tersedia di executor ini."
    end
end)

-- Fungsi utama: scan event dan lokasi
local function scanEvent()
    local eventName, eventDesc, eventLocation = nil, nil, nil
    local debugLabels, debugParts = {}, {}
    local eventKeywords = {"black hole", "galaxy", "corrupt", "admin", "event", "mutation", "limited"}
    -- Fungsi rekursif untuk scan semua label di semua level
    local function scanLabels(obj)
        -- Cek property Text
        if obj:IsA("TextLabel") or obj:IsA("ImageLabel") or obj:IsA("Frame") or obj:IsA("TextButton") then
            if obj.Text then
                local txt = tostring(obj.Text):lower()
                for _, keyword in ipairs(eventKeywords) do
                    if txt:find(keyword) then
                        table.insert(debugLabels, obj.Text)
                        if not eventName and (keyword ~= "event" and keyword ~= "admin") then
                            eventName = obj.Text
                        end
                        if txt:find("black hole") then eventDesc = obj.Text end
                    end
                end
            end
        end
        -- Cek property Name
        if obj.Name then
            local n = tostring(obj.Name):lower()
            for _, keyword in ipairs(eventKeywords) do
                if n:find(keyword) then
                    table.insert(debugLabels, obj.Name)
                    if not eventName and (keyword ~= "event" and keyword ~= "admin") then
                        eventName = obj.Name
                    end
                end
            end
        end
        -- Scan children
        for _, child in ipairs(obj:GetChildren()) do
            scanLabels(child)
        end
    end
    scanLabels(CoreGui)
    -- Scan lokasi event di Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("black") or n:find("hole") or n:find("event") or n:find("admin") then
            if obj:IsA("BasePart") then
                table.insert(debugParts, obj.Name .. " @ " .. tostring(obj.Position))
                eventLocation = obj.Position
            end
        end
    end
    -- Tampilkan info
    if eventName then
        local info = "✨ EVENT DETECTED!\n" .. eventName .. "\n" .. (eventDesc or "")
        if eventLocation then
            info = info .. "\nLokasi: " .. tostring(eventLocation)
        end
        if #debugLabels > 0 then
            info = info .. "\n[Debug Labels]: " .. table.concat(debugLabels, ", ")
        end
        if #debugParts > 0 then
            info = info .. "\n[Debug Parts]: " .. table.concat(debugParts, ", ")
        end
        infoBox.Text = info
        lastInfo = info
    else
        infoBox.Text = "Menunggu event...\n[Debug Labels]: " .. table.concat(debugLabels, ", ")
        lastInfo = infoBox.Text
    end
end

-- Scan setiap 5 detik
while true do
    scanEvent()
    wait(5)
end
