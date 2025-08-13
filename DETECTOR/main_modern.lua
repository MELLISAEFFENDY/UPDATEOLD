--[[
    XSAN's Fish It Pro - Ultimate Edition v2.0 MODERN UI
    
    Premium Fish It script with ULTIMATE features:
    • Modern Tab-based Interface (NEW!)
    • Quick Start Presets & Advanced Analytics
    • Smart Inventory Management & AI Features  
    • Enhanced Fishing & Quality of Life
    • Smart Notifications & Safety Systems
    • Advanced Automation & Much More
    • Ultimate Teleportation System
    
    Developer: XSAN
    Instagram: @_bangicoo
    GitHub: github.com/codeico
    
    Premium Quality • Modern Design • Ultimate Edition
--]]

print("XSAN: Starting Fish It Pro Ultimate v2.0 Modern...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

-- Enhanced notification system with proper Z-Index
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        -- Create custom notification that appears in front
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "XSAN_Notification"
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.ResetOnSpawn = false
        
        -- Try CoreGui first for better visibility
        local success = pcall(function()
            ScreenGui.Parent = CoreGui
        end)
        if not success then
            ScreenGui.Parent = LocalPlayer.PlayerGui
        end
        
        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
        NotificationFrame.Position = UDim2.new(1, -320, 0, 20)
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.ZIndex = 1000 -- Very high Z-Index
        NotificationFrame.Parent = ScreenGui
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = NotificationFrame
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(70, 130, 200)
        Stroke.Thickness = 2
        Stroke.Parent = NotificationFrame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -10, 0.5, 0)
        TitleLabel.Position = UDim2.new(0, 5, 0, 5)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title or "XSAN Fish It Pro"
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextScaled = true
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.ZIndex = 1001
        TitleLabel.Parent = NotificationFrame
        
        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Size = UDim2.new(1, -10, 0.5, -5)
        ContentLabel.Position = UDim2.new(0, 5, 0.5, 0)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Text = text or "Notification"
        ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ContentLabel.TextScaled = true
        ContentLabel.Font = Enum.Font.SourceSans
        ContentLabel.ZIndex = 1001
        ContentLabel.Parent = NotificationFrame
        
        -- Animate in
        TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(1, -320, 0, 20)
        }):Play()
        
        -- Auto dismiss
        task.spawn(function()
            task.wait(duration)
            TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, 50, 0, 20),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.3)
            ScreenGui:Destroy()
        end)
        
        -- Also try default notification as backup
        StarterGui:SetCore("SendNotification", {
            Title = title or "XSAN Fish It Pro",
            Text = text or "Notification", 
            Duration = duration,
            Icon = "rbxassetid://6023426923"
        })
    end)
    print("XSAN:", title, "-", text)
end

-- Check basic requirements
if not LocalPlayer then
    warn("XSAN ERROR: LocalPlayer not found")
    return
end

if not ReplicatedStorage then
    warn("XSAN ERROR: ReplicatedStorage not found")
    return
end

print("XSAN: Basic services OK")

-- Mobile/Android detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize

print("XSAN: Platform Detection - Mobile:", isMobile, "Screen Size:", screenSize.X .. "x" .. screenSize.Y)

-- Create main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XSAN_ModernUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to parent to CoreGui first, then fallback to PlayerGui
local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- Responsive main frame optimized for mobile landscape
local isLandscape = screenSize.X > screenSize.Y
local frameWidth = isLandscape and 650 or 500  -- Mobile friendly
local frameHeight = isLandscape and 400 or 450  -- Mobile friendly

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
mainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(70, 130, 200)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🐟 XSAN Fish It Pro Ultimate v2.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 35)
tabContainer.Position = UDim2.new(0, 0, 0, 45)
tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0, 2)
tabLayout.Parent = tabContainer

-- Content area
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -85)
contentFrame.Position = UDim2.new(0, 0, 0, 85)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 8
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 5)
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingBottom = UDim.new(0, 10)
contentPadding.PaddingLeft = UDim.new(0, 10)
contentPadding.PaddingRight = UDim.new(0, 10)
contentPadding.Parent = contentFrame

-- === GAME VARIABLES ===
local fishing = false
local autoFishing = false
local autoShaking = false
local autoReeling = false
local autoSelling = false
local autoCasting = false
local autoUpgrading = false
local useGamepass = false
local shakeDetection = false
local sellMethod = "Auto"
local equipBestRod = false
local sellInterval = 30
local fishingDelay = 1
local castPower = 100
local selectedPreset = "Balanced"
local teleportCooldown = false

-- Advanced features
local autoEquipBait = false
local smartCasting = false
local fishingAnalytics = {
    fishCaught = 0,
    totalValue = 0,
    sessionStart = tick(),
    bestFish = {name = "None", value = 0},
    efficiency = 0
}

-- Game detection and RemoteEvents
local remotes = {}
local player = LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Find RemoteEvents with better error handling
local function findRemotes()
    local foundRemotes = {}
    local attempts = 0
    local maxAttempts = 10
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        
        pcall(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    foundRemotes[remote.Name] = remote
                end
            end
        end)
        
        if next(foundRemotes) then
            break
        end
        
        wait(1)
    end
    
    return foundRemotes
end

-- Load remotes
task.spawn(function()
    print("XSAN: Finding game RemoteEvents...")
    remotes = findRemotes()
    
    if next(remotes) then
        print("XSAN: Found", #remotes, "RemoteEvents")
        Notify("Game Detected", "Found " .. #remotes .. " RemoteEvents")
    else
        warn("XSAN: No RemoteEvents found")
        Notify("Warning", "No RemoteEvents detected")
    end
end)

-- UI Creation Helper Functions
local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 11
    button.Parent = contentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    if callback then
        button.MouseButton1Click:Connect(callback)
    end

    return button
end

local function createToggle(name, currentValue, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    container.BorderSizePixel = 0
    container.Parent = contentFrame

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    toggleButton.BackgroundColor3 = currentValue and Color3.fromRGB(60, 120, 180) or Color3.fromRGB(80, 80, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = container

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0)
    toggleCorner.Parent = toggleButton

    local isToggled = currentValue

    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(60, 120, 180) or Color3.fromRGB(80, 80, 80)
        if callback then
            callback(isToggled)
        end
    end)

    return container
end

local function createParagraph(title, content)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = contentFrame

    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 20)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = container
    end

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, 0, 0, 0)
    contentLabel.Position = title and UDim2.new(0, 0, 0, 25) or UDim2.new(0, 0, 0, 0)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content or ""
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.Font = Enum.Font.SourceSans
    contentLabel.TextSize = 10
    contentLabel.TextWrapped = true
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.AutomaticSize = Enum.AutomaticSize.Y
    contentLabel.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = container

    return container
end

-- Tab System
local tabs = {}
local currentTab = nil

local function createTab(name, emoji)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tabButton.BorderSizePixel = 0
    tabButton.Text = emoji .. " " .. name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.SourceSans
    tabButton.Parent = tabContainer

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton

    local tab = {
        button = tabButton,
        content = {},
        isActive = false
    }

    tabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, t in pairs(tabs) do
            t.button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            for _, element in pairs(t.content) do
                element.Visible = false
            end
            t.isActive = false
        end
        
        -- Show this tab
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
        for _, element in pairs(tab.content) do
            element.Visible = true
        end
        tab.isActive = true
        currentTab = tab
    end)

    tabs[name] = tab
    return tab
end

local function addToTab(tabName, element)
    if tabs[tabName] then
        table.insert(tabs[tabName].content, element)
        element.Visible = tabs[tabName].isActive
        element.Parent = contentFrame
    end
end

-- Create all tabs
local infoTab = createTab("INFO", "📋")
local autoFishTab = createTab("AUTO FISH", "🎣")
local teleportTab = createTab("TELEPORT", "🌍")
local inventoryTab = createTab("INVENTORY", "🎒")
local buySystemTab = createTab("BUY", "🛒")
local settingsTab = createTab("SETTINGS", "⚙️")

-- Activate first tab
if infoTab then
    infoTab.button.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    infoTab.isActive = true
    currentTab = infoTab
end

-- === TAB CONTENT ===

-- INFO TAB
local infoContent1 = createParagraph("🌟 XSAN Fish It Pro Ultimate v2.0", "Selamat datang di XSAN Fish It Pro Ultimate Edition dengan Modern Tab Interface! Script premium dengan fitur terlengkap untuk Fish It!")
addToTab("INFO", infoContent1)

local infoContent2 = createParagraph("✨ What's New in v2.0", "• Modern Tab-based Interface (NEW!)\n• Mobile Landscape Optimized\n• Enhanced Performance\n• Better Error Handling\n• Improved Analytics\n• Smart Notifications")
addToTab("INFO", infoContent2)

local infoContent3 = createParagraph("📖 How to Use", "1. Gunakan tab AUTO FISH untuk fishing automation\n2. Tab TELEPORT untuk berpindah lokasi\n3. Tab INVENTORY untuk item management\n4. Tab BUY untuk purchase automation\n5. Tab SETTINGS untuk konfigurasi")
addToTab("INFO", infoContent3)

local infoContent4 = createParagraph("👨‍💻 Developer Info", "Created by XSAN\nInstagram: @_bangicoo\nGitHub: github.com/codeico\n\nTrusted by thousands of players worldwide!")
addToTab("INFO", infoContent4)

-- AUTO FISH TAB
local autoFishContent1 = createParagraph("🎣 Automated Fishing System", "Ultimate fishing automation with smart features and customizable settings.")
addToTab("AUTO FISH", autoFishContent1)

local mainFishingToggle = createToggle("🎣 Enable Auto Fishing", autoFishing, function(value)
    autoFishing = value
    fishing = value
    
    if value then
        Notify("🎣 Auto Fishing", "Started!")
        task.spawn(function()
            while autoFishing do
                pcall(function()
                    if remotes.Cast then
                        remotes.Cast:FireServer(castPower)
                    end
                    
                    if autoShaking and remotes.Shake then
                        wait(math.random(1, 3))
                        remotes.Shake:FireServer()
                    end
                    
                    if autoReeling and remotes.Reel then
                        wait(math.random(2, 4))
                        remotes.Reel:FireServer()
                    end
                    
                    fishingAnalytics.fishCaught = fishingAnalytics.fishCaught + 1
                end)
                
                wait(fishingDelay)
            end
        end)
    else
        Notify("🎣 Auto Fishing", "Stopped!")
    end
end)
addToTab("AUTO FISH", mainFishingToggle)

local autoShakeToggle = createToggle("🌊 Auto Shaking", autoShaking, function(value)
    autoShaking = value
    Notify("🌊 Auto Shaking", value and "Enabled" or "Disabled")
end)
addToTab("AUTO FISH", autoShakeToggle)

local autoReelToggle = createToggle("🎯 Auto Reeling", autoReeling, function(value)
    autoReeling = value
    Notify("🎯 Auto Reeling", value and "Enabled" or "Disabled")
end)
addToTab("AUTO FISH", autoReelToggle)

local smartCastToggle = createToggle("🧠 Smart Casting", smartCasting, function(value)
    smartCasting = value
    Notify("🧠 Smart Casting", value and "Enabled" or "Disabled")
end)
addToTab("AUTO FISH", smartCastToggle)

-- TELEPORT TAB
local teleportContent1 = createParagraph("🌍 Ultimate Teleportation System", "Teleport instantly to any fishing location or shop. Updated coordinates for all areas!")
addToTab("TELEPORT", teleportContent1)

-- Fish It accurate teleport locations
local teleportLocations = {
    {"🏠 Spawn", {x = 1, y = 18, z = 134}},
    {"🏪 Shop (Alex)", {x = -28.43, y = 4.50, z = 2891.28}},
    {"🏪 Shop (Joe)", {x = 112.01, y = 4.75, z = 2877.32}},
    {"🎣 Rod Shop (Marc)", {x = 454, y = 150, z = 229}},
    {"🌊 Ocean (Starter)", {x = 0, y = 20, z = 200}},
    {"🏔️ Mountain Lake", {x = -1800, y = 150, z = 900}},
    {"🏝️ Coral Reef", {x = 500, y = 130, z = -200}},
    {"🌅 Deep Ocean", {x = 1000, y = 130, z = 1000}},
    {"❄️ Ice Lake", {x = -1200, y = 140, z = -800}},
    {"🌟 Isonade Event", {x = -1442, y = 135, z = 1006}},
}

local function teleportTo(position)
    if teleportCooldown then
        Notify("⏰ Cooldown", "Please wait before teleporting again")
        return
    end
    
    teleportCooldown = true
    
    pcall(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(position.x, position.y, position.z)
            Notify("✅ Teleported", "Arrived at destination!")
        end
    end)
    
    task.wait(2)
    teleportCooldown = false
end

for _, location in pairs(teleportLocations) do
    local locationName = location[1]
    local position = location[2]
    
    local teleportButton = createButton(locationName, function()
        teleportTo(position)
    end)
    addToTab("TELEPORT", teleportButton)
end

-- INVENTORY TAB
local inventoryContent1 = createParagraph("🎒 Smart Inventory Management", "Automated selling, upgrading, and inventory optimization tools.")
addToTab("INVENTORY", inventoryContent1)

local autoSellToggle = createToggle("💰 Auto Sell Fish", autoSelling, function(value)
    autoSelling = value
    
    if value then
        Notify("💰 Auto Sell", "Started!")
        task.spawn(function()
            while autoSelling do
                pcall(function()
                    if remotes.SellFish then
                        remotes.SellFish:FireServer()
                        fishingAnalytics.totalValue = fishingAnalytics.totalValue + 100
                    end
                end)
                wait(sellInterval)
            end
        end)
    else
        Notify("💰 Auto Sell", "Stopped!")
    end
end)
addToTab("INVENTORY", autoSellToggle)

local equipRodToggle = createToggle("🎣 Auto Equip Best Rod", equipBestRod, function(value)
    equipBestRod = value
    
    if value then
        task.spawn(function()
            pcall(function()
                if remotes.EquipRod then
                    remotes.EquipRod:FireServer("BestRod")
                end
            end)
        end)
    end
    
    Notify("🎣 Auto Equip Rod", value and "Enabled" or "Disabled")
end)
addToTab("INVENTORY", equipRodToggle)

local sellAllButton = createButton("💎 Sell All Fish Now", function()
    pcall(function()
        if remotes.SellFish then
            remotes.SellFish:FireServer()
            Notify("💎 Sold!", "All fish sold successfully")
            fishingAnalytics.totalValue = fishingAnalytics.totalValue + 500
        end
    end)
end)
addToTab("INVENTORY", sellAllButton)

-- BUY SYSTEM TAB
local buyContent1 = createParagraph("🛒 Smart Buy System Automation", "Automated purchasing, selling, and shop management with intelligent detection of all game purchase events.")
addToTab("BUY", buyContent1)

-- Buy System Variables
local autoBuyEnabled = false
local autoSellItemsEnabled = false
local autoEquipmentBuy = false

local function executeRemoteFunction(remoteName, ...)
    pcall(function()
        if remotes[remoteName] then
            if remotes[remoteName]:IsA("RemoteFunction") then
                remotes[remoteName]:InvokeServer(...)
            else
                remotes[remoteName]:FireServer(...)
            end
        end
    end)
end

local autoSellItemsToggle = createToggle("💰 Auto Sell Items", autoSellItemsEnabled, function(value)
    autoSellItemsEnabled = value
    
    if value then
        Notify("💰 Auto Sell", "Started selling items automatically!")
        task.spawn(function()
            while autoSellItemsEnabled do
                pcall(function()
                    executeRemoteFunction("SellItem")
                    wait(1)
                    executeRemoteFunction("SellAllItems")
                end)
                wait(30)
            end
        end)
    else
        Notify("💰 Auto Sell", "Stopped!")
    end
end)
addToTab("BUY", autoSellItemsToggle)

local autoEquipmentToggle = createToggle("🎣 Auto Buy Equipment", autoEquipmentBuy, function(value)
    autoEquipmentBuy = value
    
    if value then
        Notify("🎣 Auto Equipment", "Smart equipment purchasing enabled!")
        task.spawn(function()
            while autoEquipmentBuy do
                pcall(function()
                    executeRemoteFunction("PurchaseFishingRod", "BestRod")
                    wait(5)
                    executeRemoteFunction("PurchaseBait", "BestBait")
                    wait(5)
                    executeRemoteFunction("PurchaseGear", "BestGear")
                    wait(5)
                    executeRemoteFunction("PurchaseBoat", "BestBoat")
                end)
                wait(120)
            end
        end)
    else
        Notify("🎣 Auto Equipment", "Disabled!")
    end
end)
addToTab("BUY", autoEquipmentToggle)

local buyRodButton = createButton("🎣 Buy Best Fishing Rod", function()
    executeRemoteFunction("PurchaseFishingRod", "BestRod")
    Notify("🎣 Purchase", "Attempting to buy best fishing rod!")
end)
addToTab("BUY", buyRodButton)

local buyBaitButton = createButton("🪱 Buy Best Bait", function()
    executeRemoteFunction("PurchaseBait", "BestBait")
    Notify("🪱 Purchase", "Attempting to buy best bait!")
end)
addToTab("BUY", buyBaitButton)

local buyBoatButton = createButton("⚓ Buy Best Boat", function()
    executeRemoteFunction("PurchaseBoat", "BestBoat")
    Notify("⚓ Purchase", "Attempting to buy best boat!")
end)
addToTab("BUY", buyBoatButton)

local buyCrateButton = createButton("🎁 Buy Skin Crate", function()
    executeRemoteFunction("PurchaseSkinCrate")
    Notify("🎁 Purchase", "Attempting to buy skin crate!")
end)
addToTab("BUY", buyCrateButton)

-- SETTINGS TAB
local settingsContent1 = createParagraph("⚙️ Advanced Settings & Configuration", "Customize your XSAN Fish It Pro experience with advanced options.")
addToTab("SETTINGS", settingsContent1)

local gamepassToggle = createToggle("🎮 Use Gamepass Features", useGamepass, function(value)
    useGamepass = value
    Notify("🎮 Gamepass", value and "Enabled" or "Disabled")
end)
addToTab("SETTINGS", gamepassToggle)

local shakeDetectionToggle = createToggle("🔍 Enhanced Shake Detection", shakeDetection, function(value)
    shakeDetection = value
    Notify("🔍 Shake Detection", value and "Enhanced" or "Normal")
end)
addToTab("SETTINGS", shakeDetectionToggle)

local mobileTipsButton = createButton("📱 Show Mobile Tips", function()
    Notify("📱 Mobile Tips", "• Use landscape mode for best experience\n• Tap and hold to drag the interface\n• Swipe to navigate tabs\n• Pinch to zoom if needed")
end)
addToTab("SETTINGS", mobileTipsButton)

local buyDetectorButton = createButton("🛒 Enhanced Buy System Detector", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/donitono/part2/main/buy_system_detector_enhanced.lua"))()
    Notify("🛒 Buy Detector", "Enhanced buy system detector loaded!")
end)
addToTab("SETTINGS", buyDetectorButton)

local toolsInterfaceButton = createButton("🔧 Advanced Tools Interface", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/donitono/part2/main/unified_enhanced_detectors.lua"))()
    Notify("🔧 Tools Loaded", "Advanced tools interface loaded!")
end)
addToTab("SETTINGS", toolsInterfaceButton)

local emergencyStopButton = createButton("🆘 Emergency Stop All", function()
    autoFishing = false
    fishing = false
    autoShaking = false
    autoReeling = false
    autoSelling = false
    autoCasting = false
    autoUpgrading = false
    autoBuyEnabled = false
    autoSellItemsEnabled = false
    autoEquipmentBuy = false
    
    Notify("🆘 Emergency Stop", "All automation stopped!")
end)
addToTab("SETTINGS", emergencyStopButton)

local destroyButton = createButton("🗑️ Destroy Interface", function()
    ScreenGui:Destroy()
end)
addToTab("SETTINGS", destroyButton)

-- Final setup
print("XSAN: Modern UI setup complete!")
Notify("✅ Ready!", "XSAN Fish It Pro Ultimate v2.0 loaded successfully! Use the tab navigation for best experience.")

-- Auto-detection and smart features
task.spawn(function()
    task.wait(3)
    
    -- Auto-detect game mode
    pcall(function()
        local gameMode = "Fish It Detected"
        Notify("🎮 Game Detected", "Mode: " .. gameMode)
    end)
    
    -- Show mobile optimization status
    if isMobile then
        local isLandscape = screenSize.X > screenSize.Y
        Notify("📱 Mobile Optimized", isLandscape and "Landscape mode detected - UI optimized!" or "Portrait mode - consider rotating for better experience")
    end
end)
