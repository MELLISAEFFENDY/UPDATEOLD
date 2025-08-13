--[[
    XSAN Admin Event Monitor & Auto Teleporter
    
    Real-time monitoring untuk Admin Events seperti Ghost Worm
    dengan auto-detection dan teleportation system.
    
    Features:
    • Auto-detect Admin Events (Ghost Worm, Kraken, dll)
    • Real-time location tracking
    • Auto-teleport ke event location
    • Event timer dan status monitoring
    • UI dashboard untuk easy access
    
    Usage:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/UPDATE/main/Detector/admin_event_monitor.lua"))()
--]]

print("🚨 XSAN Admin Event Monitor v1.0 Loading...")

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Load Admin Event Detector
local detector = loadstring(game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/UPDATE/main/Detector/admin_event_detector.lua"))()

-- UI Creation
local function CreateEventMonitorUI()
    -- Destroy existing UI
    if LocalPlayer.PlayerGui:FindFirstChild("XSANEventMonitor") then
        LocalPlayer.PlayerGui.XSANEventMonitor:Destroy()
    end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XSANEventMonitor"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer.PlayerGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 350, 0, 450)
    MainFrame.Position = UDim2.new(1, -370, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Add corner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    -- Add stroke
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 150, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    -- Fix corner for title bar
    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 10)
    TitleFix.Position = UDim2.new(0, 0, 1, -10)
    TitleFix.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -90, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "🚨 ADMIN EVENT MONITOR"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextScaled = true
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextScaled = true
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 5)
    CloseCorner.Parent = CloseButton
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextScaled = true
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 5)
    MinimizeCorner.Parent = MinimizeButton
    
    -- Status Frame
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Name = "StatusFrame"
    StatusFrame.Size = UDim2.new(1, -20, 0, 60)
    StatusFrame.Position = UDim2.new(0, 10, 0, 50)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    StatusFrame.BorderSizePixel = 0
    StatusFrame.Parent = MainFrame
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = StatusFrame
    
    -- Status Text
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, -20, 1, -20)
    StatusText.Position = UDim2.new(0, 10, 0, 10)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "🔍 Scanning for Admin Events..."
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.TextScaled = true
    StatusText.Font = Enum.Font.SourceSans
    StatusText.TextWrapped = true
    StatusText.Parent = StatusFrame
    
    -- Events List Frame
    local EventsListFrame = Instance.new("ScrollingFrame")
    EventsListFrame.Name = "EventsListFrame"
    EventsListFrame.Size = UDim2.new(1, -20, 1, -230)
    EventsListFrame.Position = UDim2.new(0, 10, 0, 120)
    EventsListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    EventsListFrame.BorderSizePixel = 0
    EventsListFrame.ScrollBarThickness = 6
    EventsListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    EventsListFrame.Parent = MainFrame
    
    local EventsCorner = Instance.new("UICorner")
    EventsCorner.CornerRadius = UDim.new(0, 8)
    EventsCorner.Parent = EventsListFrame
    
    -- Events List Layout
    local EventsLayout = Instance.new("UIListLayout")
    EventsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    EventsLayout.Padding = UDim.new(0, 5)
    EventsLayout.Parent = EventsListFrame
    
    -- Control Buttons Frame
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Name = "ControlsFrame"
    ControlsFrame.Size = UDim2.new(1, -20, 0, 100)
    ControlsFrame.Position = UDim2.new(0, 10, 1, -110)
    ControlsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ControlsFrame.BorderSizePixel = 0
    ControlsFrame.Parent = MainFrame
    
    local ControlsCorner = Instance.new("UICorner")
    ControlsCorner.CornerRadius = UDim.new(0, 8)
    ControlsCorner.Parent = ControlsFrame
    
    -- Scan Button
    local ScanButton = Instance.new("TextButton")
    ScanButton.Name = "ScanButton"
    ScanButton.Size = UDim2.new(1, -10, 0, 25)
    ScanButton.Position = UDim2.new(0, 5, 0, 5)
    ScanButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    ScanButton.Text = "🔍 Force Scan Events"
    ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScanButton.TextScaled = true
    ScanButton.Font = Enum.Font.SourceSansBold
    ScanButton.BorderSizePixel = 0
    ScanButton.Parent = ControlsFrame
    
    local ScanCorner = Instance.new("UICorner")
    ScanCorner.CornerRadius = UDim.new(0, 5)
    ScanCorner.Parent = ScanButton
    
    -- Auto Teleport Toggle
    local AutoTeleportToggle = Instance.new("TextButton")
    AutoTeleportToggle.Name = "AutoTeleportToggle"
    AutoTeleportToggle.Size = UDim2.new(1, -10, 0, 25)
    AutoTeleportToggle.Position = UDim2.new(0, 5, 0, 35)
    AutoTeleportToggle.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    AutoTeleportToggle.Text = "⚡ Auto Teleport: OFF"
    AutoTeleportToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoTeleportToggle.TextScaled = true
    AutoTeleportToggle.Font = Enum.Font.SourceSansBold
    AutoTeleportToggle.BorderSizePixel = 0
    AutoTeleportToggle.Parent = ControlsFrame
    
    local AutoTeleportCorner = Instance.new("UICorner")
    AutoTeleportCorner.CornerRadius = UDim.new(0, 5)
    AutoTeleportCorner.Parent = AutoTeleportToggle
    
    -- Clear Events Button
    local ClearButton = Instance.new("TextButton")
    ClearButton.Name = "ClearButton"
    ClearButton.Size = UDim2.new(1, -10, 0, 25)
    ClearButton.Position = UDim2.new(0, 5, 0, 65)
    ClearButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    ClearButton.Text = "🗑️ Clear Events"
    ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearButton.TextScaled = true
    ClearButton.Font = Enum.Font.SourceSansBold
    ClearButton.BorderSizePixel = 0
    ClearButton.Parent = ControlsFrame
    
    local ClearCorner = Instance.new("UICorner")
    ClearCorner.CornerRadius = UDim.new(0, 5)
    ClearCorner.Parent = ClearButton
    
    return ScreenGui, {
        MainFrame = MainFrame,
        StatusText = StatusText,
        EventsListFrame = EventsListFrame,
        ScanButton = ScanButton,
        AutoTeleportToggle = AutoTeleportToggle,
        ClearButton = ClearButton,
        CloseButton = CloseButton,
        MinimizeButton = MinimizeButton
    }
end

-- Event Item Creation
local function CreateEventItem(eventData, parent)
    local EventItem = Instance.new("Frame")
    EventItem.Size = UDim2.new(1, -10, 0, 80)
    EventItem.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    EventItem.BorderSizePixel = 0
    EventItem.Parent = parent
    
    local ItemCorner = Instance.new("UICorner")
    ItemCorner.CornerRadius = UDim.new(0, 6)
    ItemCorner.Parent = EventItem
    
    -- Event Icon & Name
    local EventName = Instance.new("TextLabel")
    EventName.Size = UDim2.new(0.7, 0, 0, 25)
    EventName.Position = UDim2.new(0, 10, 0, 5)
    EventName.BackgroundTransparency = 1
    EventName.Text = eventData.icon .. " " .. eventData.name
    EventName.TextColor3 = Color3.fromRGB(255, 255, 255)
    EventName.TextScaled = true
    EventName.Font = Enum.Font.SourceSansBold
    EventName.TextXAlignment = Enum.TextXAlignment.Left
    EventName.Parent = EventItem
    
    -- Rarity Badge
    local RarityBadge = Instance.new("TextLabel")
    RarityBadge.Size = UDim2.new(0.25, 0, 0, 20)
    RarityBadge.Position = UDim2.new(0.72, 0, 0, 7)
    RarityBadge.BackgroundColor3 = eventData.rarity == "LEGENDARY" and Color3.fromRGB(255, 215, 0) or
                                   eventData.rarity == "MYTHIC" and Color3.fromRGB(200, 0, 255) or
                                   eventData.rarity == "EPIC" and Color3.fromRGB(150, 0, 255) or
                                   Color3.fromRGB(0, 150, 255)
    RarityBadge.Text = eventData.rarity
    RarityBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
    RarityBadge.TextScaled = true
    RarityBadge.Font = Enum.Font.SourceSansBold
    RarityBadge.BorderSizePixel = 0
    RarityBadge.Parent = EventItem
    
    local RarityCorner = Instance.new("UICorner")
    RarityCorner.CornerRadius = UDim.new(0, 3)
    RarityCorner.Parent = RarityBadge
    
    -- Duration & Status
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 20)
    StatusLabel.Position = UDim2.new(0, 10, 0, 30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⏱️ Duration: " .. eventData.duration .. " min | 📍 " .. eventData.location
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = EventItem
    
    -- Teleport Button
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Size = UDim2.new(1, -20, 0, 22)
    TeleportButton.Position = UDim2.new(0, 10, 0, 53)
    TeleportButton.BackgroundColor3 = eventData.position and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(100, 100, 100)
    TeleportButton.Text = eventData.position and ("🚀 Teleport to " .. eventData.name) or ("📍 Location Unknown")
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextScaled = true
    TeleportButton.Font = Enum.Font.SourceSansBold
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Active = eventData.position ~= nil
    TeleportButton.Parent = EventItem
    
    local TeleportCorner = Instance.new("UICorner")
    TeleportCorner.CornerRadius = UDim.new(0, 4)
    TeleportCorner.Parent = TeleportButton
    
    -- Teleport Button Click
    TeleportButton.MouseButton1Click:Connect(function()
        if eventData.position then
            detector.TeleportToEvent(eventData.name)
        else
            detector.Notify("Event Teleport", "⚠️ " .. eventData.name .. " location not found yet!")
        end
    end)
    
    return EventItem
end

-- UI Update Function
local function UpdateEventsList(ui)
    -- Clear existing events
    for _, child in pairs(ui.EventsListFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Get detected events
    local activeEvents, eventCount = detector.GetDetectedEvents()
    
    -- Update status
    if eventCount > 0 then
        ui.StatusText.Text = "🚨 " .. eventCount .. " ADMIN EVENT(S) DETECTED!"
        ui.StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        ui.StatusText.Text = "🔍 Scanning for Admin Events..."
        ui.StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    -- Create event items
    for _, eventData in pairs(activeEvents) do
        CreateEventItem(eventData, ui.EventsListFrame)
    end
    
    -- Update canvas size
    ui.EventsListFrame.CanvasSize = UDim2.new(0, 0, 0, eventCount * 85)
end

-- Main Execution
local function StartEventMonitor()
    detector.Notify("Event Monitor", "🚨 XSAN Admin Event Monitor Started!\n\n🔍 Scanning for admin events...\n📍 Auto-detection active")
    
    -- Start auto-scan
    detector.StartAutoScan()
    
    -- Create UI
    local screenGui, ui = CreateEventMonitorUI()
    
    -- Variables for functionality
    local autoTeleport = false
    local isMinimized = false
    local lastEventCount = 0
    
    -- Auto Teleport Toggle
    ui.AutoTeleportToggle.MouseButton1Click:Connect(function()
        autoTeleport = not autoTeleport
        ui.AutoTeleportToggle.Text = autoTeleport and "⚡ Auto Teleport: ON" or "⚡ Auto Teleport: OFF"
        ui.AutoTeleportToggle.BackgroundColor3 = autoTeleport and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 100, 0)
        
        detector.Notify("Auto Teleport", autoTeleport and "✅ Auto teleport to new events ENABLED" or "❌ Auto teleport DISABLED")
    end)
    
    -- Force Scan Button
    ui.ScanButton.MouseButton1Click:Connect(function()
        detector.ScanForAdminEvents()
        detector.ScanEventLocations()
        UpdateEventsList(ui)
        detector.Notify("Force Scan", "🔍 Manual event scan completed!")
    end)
    
    -- Clear Events Button
    ui.ClearButton.MouseButton1Click:Connect(function()
        for eventName in pairs(detector.detectedEvents) do
            detector.detectedEvents[eventName] = nil
        end
        for eventName in pairs(detector.eventLocations) do
            detector.eventLocations[eventName] = nil
        end
        UpdateEventsList(ui)
        detector.Notify("Clear Events", "🗑️ All events cleared!")
    end)
    
    -- Close Button
    ui.CloseButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        detector.Notify("Event Monitor", "📴 Admin Event Monitor closed")
    end)
    
    -- Minimize Button
    ui.MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        ui.MainFrame:TweenSize(
            isMinimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 450),
            "Out", "Quad", 0.3, true
        )
        ui.MinimizeButton.Text = isMinimized and "□" or "−"
    end)
    
    -- Make draggable
    local dragToggle = nil
    local dragSpeed = 0.25
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(ui.MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end
    
    ui.MainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = ui.MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
    
    -- Auto-update and auto-teleport system
    spawn(function()
        while screenGui.Parent do
            UpdateEventsList(ui)
            
            -- Auto teleport logic
            if autoTeleport then
                local activeEvents, eventCount = detector.GetDetectedEvents()
                
                -- If new event detected and has location
                if eventCount > lastEventCount then
                    for _, eventData in pairs(activeEvents) do
                        if eventData.position then
                            detector.Notify("Auto Teleport", "🚀 Auto teleporting to " .. eventData.name .. "!")
                            wait(1)
                            detector.TeleportToEvent(eventData.name)
                            break
                        end
                    end
                end
                
                lastEventCount = eventCount
            end
            
            wait(3)
        end
    end)
    
    print("XSAN: Admin Event Monitor UI created and running!")
end

-- Start the monitor
StartEventMonitor()

detector.Notify("XSAN Event Monitor", "✅ Admin Event Monitor v1.0 Loaded!\n\n🚨 Real-time event detection active\n🎯 Ghost Worm & other admin events\n📍 Auto location finding\n⚡ Optional auto-teleport")
