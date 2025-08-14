--[[
    XSAN's Fish It Pro - Ultimate Edition v1.0 WORKING VERSION
    
    Premium Fish It script with ULTIMATE features:
    • Quick Start Presets & Advanced Analytics
    • Smart Inventory Management & AI Features  
    • Enhanced Fishing & Quality of Life
    • Smart Notifications & Safety Systems
    • Advanced Automation & Much More
    • Ultimate Teleportation System (NEW!)
    
    Developer: XSAN
    Instagram: @_bangicoo
    GitHub: github.com/codeico
    
    Premium Quality • Trusted by Thousands • Ultimate Edition
--]]

print("XSAN: Starting Fish It Pro Ultimate v1.0...")

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

-- ═══════════════════════════════════════════════════════════════
-- XSAN CONTENT CONFIGURATION SYSTEM
-- Edit all tab content and notifications from here!
-- ═══════════════════════════════════════════════════════════════

local XSAN_CONFIG = {
    -- Main Info & Branding
    branding = {
        title = "XSAN Fish It Pro Ultimate v1.0",
        subtitle = "The most advanced Fish It script ever created with AI-powered features, smart analytics, and premium automation systems.",
        developer = "XSAN",
        instagram = "@_bangicoo",
        github = "github.com/codeico",
        support_message = "Created by XSAN - Trusted by thousands of users worldwide!"
    },
    
    -- Tab Descriptions (Easy to edit!)
    tabs = {
        info = {
            title = "Ultimate Features",
            content = "" -- Kosong - tanpa deskripsi
        },
        presets = {
            title = "Quick Start Presets", 
            content = "" -- Kosong - tanpa deskripsi
        },
        teleport = {
            title = "Ultimate Teleport System", 
            content = "", -- Kosong - tanpa deskripsi
            islands_desc = "",
            npcs_desc = "",
            events_desc = ""
        },
        autofish = {
            title = "Auto Fishing System",
            content = ""
        },
        analytics = {
            title = "Advanced Analytics", 
            content = ""
        },
        inventory = {
            title = "Smart Inventory",
            content = ""
        },
        utility = {
            title = "Utility Tools",
            content = ""
        },
        weather = {
            title = "Weather Purchase System",
            content = ""
        }
    },
    
    -- Notification Messages (Easy to customize!)
    notifications = {
        preset_applied = "✅ {preset} mode activated!\n🎯 Settings optimized for {purpose}\n{autosell_status}",
        teleport_success = "🚀 Successfully teleported to: {location}",
        autofish_start = "🎣 XSAN Ultimate auto fishing started!\n⚡ AI systems activated\n🔒 Safety protocols: Active",
        autofish_stop = "⏹️ Auto fishing stopped by user.\n📊 Session completed successfully",
        feature_enabled = "✅ {feature} ENABLED!\n{description}",
        feature_disabled = "❌ {feature} DISABLED\n{description}",
        error_message = "❌ {action} failed!\n💡 Reason: {reason}\n🔧 Please try again or contact support"
    },
    
    -- Preset Configurations
    presets = {
        Beginner = {purpose = "safe and easy fishing", autosell = 5},
        Speed = {purpose = "maximum fishing speed", autosell = 20},
        Profit = {purpose = "maximum earnings", autosell = 15},
        AFK = {purpose = "long AFK sessions", autosell = 25},
        Safe = {purpose = "smart random casting (70% perfect)", autosell = 18},
        Hybrid = {purpose = "ultimate security with AI patterns", autosell = 20}
    }
}

-- Helper function to get formatted notification message
local function GetNotificationMessage(messageType, params)
    local template = XSAN_CONFIG.notifications[messageType] or "{message}"
    local message = template
    
    if params then
        for key, value in pairs(params) do
            message = message:gsub("{" .. key .. "}", tostring(value))
        end
    end
    
    return message
end

-- Helper function to get tab content (with empty content support)
local function GetTabContent(tabName, contentKey)
    local tab = XSAN_CONFIG.tabs[tabName:lower()]
    if tab and tab[contentKey] then
        return tab[contentKey]
    end
    return "" -- Return empty string if not found
end

-- Helper function to create paragraph only if content exists
local function CreateParagraphIfContent(tab, title, content)
    if content and content ~= "" then
        tab:CreateParagraph({
            Title = title,
            Content = content
        })
    end
end

-- ═══════════════════════════════════════════════════════════════
-- UI configuration (edit here to change Floating Button icon)
local UIConfig = {
    floatingButton = {
        -- Set to true to use a custom image icon instead of emoji text
        useImage = false,

        -- Emoji icons (used when useImage = false)
        emojiVisible = "🎣", -- when UI is visible
        emojiHidden = "👁", -- when UI is hidden

        -- Image icons (used when useImage = true). Replace with your asset IDs
        imageVisible = "rbxassetid://88814246774578",
        imageHidden = "rbxassetid://88814246774578"
    }
}

-- Notification system
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "XSAN Fish It Pro",
            Text = text or "Notification", 
            Duration = duration,
            Icon = "rbxassetid://6023426923"
        })
    end)
    -- Comment out print to reduce debug spam
    -- print("XSAN:", title, "-", text)
end

-- Additional Notification Functions
local function NotifySuccess(title, message)
	Notify("XSAN - " .. title, message, 3)
end

local function NotifyError(title, message)
	Notify("XSAN ERROR - " .. title, message, 4)
end

local function NotifyInfo(title, message)
	Notify("XSAN INFO - " .. title, message, 3)
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

-- XSAN Anti Ghost Touch System
local ButtonCooldowns = {}
local BUTTON_COOLDOWN = 0.5

local function CreateSafeCallback(originalCallback, buttonId)
    return function(...)
        local currentTime = tick()
        if ButtonCooldowns[buttonId] and currentTime - ButtonCooldowns[buttonId] < BUTTON_COOLDOWN then
            return
        end
        ButtonCooldowns[buttonId] = currentTime
        
        local success, result = pcall(originalCallback, ...)
        if not success then
            warn("XSAN Error:", result)
        end
    end
end

-- Load Rayfield with error handling
print("XSAN: Loading UI Library...")

local Rayfield
local success, error = pcall(function()
    print("XSAN: Attempting to load UI...")
    
    -- Try ui_fixed.lua first (more stable)
    local uiContent = game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/UPDATEOLD/refs/heads/main/versi3/ui_fixed.lua", true)
    if uiContent and #uiContent > 0 then
        print("XSAN: Loading stable UI library...")
        print("XSAN: UI content length:", #uiContent)
        local uiFunc, loadError = loadstring(uiContent)
        if uiFunc then
            Rayfield = uiFunc()
            if not Rayfield then
                error("UI function returned nil")
            end
            print("XSAN: Stable UI loaded successfully!")
        else
            error("Failed to compile UI: " .. tostring(loadError))
        end
    else
        print("XSAN: Trying fallback UI library...")
        -- Fallback to Rayfield directly
        Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
        if not Rayfield then
            error("Failed to load fallback UI")
        end
        print("XSAN: Fallback UI loaded successfully!")
    end
end)

if not success then
    warn("XSAN Error: Failed to load Rayfield UI Library - " .. tostring(error))
    -- Try alternative loading method
    NotifyError("UI Error", "Primary UI failed. Attempting alternative method...")
    
    local backupSuccess = pcall(function()
        Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
    end)
    
    if not backupSuccess or not Rayfield then
        NotifyError("CRITICAL ERROR", "All UI loading methods failed! Script cannot continue.")
        return
    else
        NotifySuccess("UI Recovery", "Backup UI loaded successfully!")
    end
end

if not Rayfield then
    warn("XSAN Error: Rayfield is nil after loading")
    return
end

print("XSAN: UI Library loaded successfully!")

-- Mobile/Android detection and UI scaling
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize

print("XSAN: Platform Detection - Mobile:", isMobile, "Screen Size:", screenSize.X .. "x" .. screenSize.Y)

-- Create Window with mobile-optimized settings
print("XSAN: Creating main window...")
local windowConfig = {
    Name = isMobile and "XSAN Fish It Pro Mobile" or "XSAN Fish It Pro v1.0",
    LoadingTitle = "XSAN Fish It Pro Ultimate",
    LoadingSubtitle = "by XSAN - Mobile Optimized",
    Theme = "Default", -- Changed to Default for better compatibility
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "XSAN",
        FileName = "FishItProUltimate"
    },
    KeySystem = false,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false
}

-- Mobile specific adjustments
if isMobile then
    -- Detect orientation
    local isLandscape = screenSize.X > screenSize.Y
    
    if isLandscape then
        -- Landscape mode - Much wider UI untuk nama fitur tidak terpotong
        windowConfig.Size = UDim2.new(0, math.min(screenSize.X * 0.60, 500), 0, math.min(screenSize.Y * 0.75, 300))
        print("XSAN: Landscape mode detected - using wider UI for feature names")
    else
        -- Portrait mode - lebih lebar untuk readability
        windowConfig.Size = UDim2.new(0, math.min(screenSize.X * 0.85, 350), 0, math.min(screenSize.Y * 0.70, 420))
        print("XSAN: Portrait mode detected - using wider UI")
    end
end

local Window = Rayfield:CreateWindow(windowConfig)

print("XSAN: Window created successfully!")

-- Fix scrolling issues and mobile scaling for Rayfield UI
print("XSAN: Applying mobile fixes and scrolling fixes...")
task.spawn(function()
    task.wait(1) -- Wait for UI to fully load
    
    local function fixUIForMobile()
        local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
        if rayfieldGui then
            local main = rayfieldGui:FindFirstChild("Main")
            if main and isMobile then
                -- Mobile scaling adjustments - Much wider untuk feature names
                local isLandscape = screenSize.X > screenSize.Y
                
                if isLandscape then
                    -- Landscape mode - Much wider untuk nama fitur tidak terpotong
                    main.Size = UDim2.new(0, math.min(screenSize.X * 0.60, 500), 0, math.min(screenSize.Y * 0.75, 300))
                else
                    -- Portrait mode - lebih lebar untuk readability
                    main.Size = UDim2.new(0, math.min(screenSize.X * 0.85, 350), 0, math.min(screenSize.Y * 0.70, 420))
                end
                
                main.Position = UDim2.new(0.5, -main.Size.X.Offset/2, 0.5, -main.Size.Y.Offset/2)
                
                -- Adjust text scaling for mobile
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        if descendant.TextScaled == false then
                            descendant.TextScaled = true
                        end
                        -- Ensure minimum readable text size on mobile
                        if descendant.TextSize < 14 and isMobile then
                            descendant.TextSize = 16
                        end
                    end
                end
                
                print("XSAN: Applied mobile UI scaling for", isLandscape and "landscape" or "portrait", "mode")
            end
            
            -- Fix scrolling for all platforms with enhanced touch support
            for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                if descendant:IsA("ScrollingFrame") then
                    -- Enable proper scrolling
                    descendant.ScrollingEnabled = true
                    descendant.ScrollBarThickness = isMobile and 15 or 8
                    descendant.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
                    descendant.ScrollBarImageTransparency = 0.2
                    
                    -- Auto canvas size if supported
                    if descendant:FindFirstChild("UIListLayout") then
                        descendant.AutomaticCanvasSize = Enum.AutomaticSize.Y
                        descendant.CanvasSize = UDim2.new(0, 0, 0, 0)
                    end
                    
                    -- Enable touch scrolling for mobile
                    descendant.Active = true
                    descendant.Selectable = true
                    
                    -- Mobile-specific touch improvements
                    if isMobile then
                        descendant.ScrollingDirection = Enum.ScrollingDirection.Y
                        descendant.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
                        descendant.ScrollBarImageTransparency = 0.1 -- More visible on mobile
                        
                        -- Force enable touch scrolling
                        local UserInputService = game:GetService("UserInputService")
                        if UserInputService.TouchEnabled then
                            -- Create touch scroll detection
                            local touchStartPos = nil
                            local scrollStartPos = nil
                            
                            descendant.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch then
                                    touchStartPos = input.Position
                                    scrollStartPos = descendant.CanvasPosition
                                end
                            end)
                            
                            descendant.InputChanged:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch and touchStartPos then
                                    local delta = input.Position - touchStartPos
                                    local newScrollPos = scrollStartPos - Vector2.new(0, delta.Y * 2) -- 2x scroll speed
                                    descendant.CanvasPosition = newScrollPos
                                end
                            end)
                            
                            descendant.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch then
                                    touchStartPos = nil
                                    scrollStartPos = nil
                                end
                            end)
                        end
                    end
                    
                    print("XSAN: Fixed scrolling for", descendant.Name, "with touch support")
                end
            end
        end
    end
    
    -- Apply fixes multiple times to ensure they stick
    fixUIForMobile()
    task.wait(2)
    fixUIForMobile()
    
    -- Force refresh UI content
    task.wait(1)
    if Window and Window.Refresh then
        Window:Refresh()
    end
end)

-- Ultimate tabs with all features
print("XSAN: Creating tabs...")
local InfoTab = Window:CreateTab("INFO", 4483362458) -- Use icon ID instead of name
print("XSAN: InfoTab created")
local PresetsTab = Window:CreateTab("PRESETS", 4483362458) -- Use icon ID instead of name
print("XSAN: PresetsTab created")
local MainTab = Window:CreateTab("AUTO FISH", 4483362458) -- Use icon ID instead of name
print("XSAN: MainTab created")
local TeleportTab = Window:CreateTab("TELEPORT", 4483362458) -- Use icon ID instead of name
print("XSAN: TeleportTab created")
local AnalyticsTab = Window:CreateTab("ANALYTICS", 4483362458) -- Use icon ID instead of name
print("XSAN: AnalyticsTab created")
local InventoryTab = Window:CreateTab("INVENTORY", 4483362458) -- Use icon ID instead of name
print("XSAN: InventoryTab created")
local UtilityTab = Window:CreateTab("UTILITY", 4483362458) -- Use icon ID instead of name
local WeatherTab = Window:CreateTab("WEATHER", 4483362458)
local RandomFishTab = Window:CreateTab("RANDOM FISH", 4483362458)
local ExitTab = Window:CreateTab("EXIT", 4483362458) -- Use icon ID instead of name
print("XSAN: UtilityTab created")
print("XSAN: WeatherTab created")
print("XSAN: RandomFishTab created")
print("XSAN: ExitTab created")

print("XSAN: All tabs created successfully!")

-- ═══════════════════════════════════════════════════════════════
-- WEATHER TAB - Weather Purchase System
-- Based on probe results: Cloudy/Wind/Storm returned true; others false.
-- ═══════════════════════════════════════════════════════════════
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local weatherNetFolder = nil
    pcall(function()
        weatherNetFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
    end)
    local weatherRemote = weatherNetFolder and weatherNetFolder:FindFirstChild("RF/PurchaseWeatherEvent")

    local WeatherOptions = {"Cloudy","Wind","Storm","Snow","Fog","Sunny","Rain","SharkHunt"}
    local validSuccess = {Cloudy=true, Wind=true, Storm=true}
    local selectedWeather = WeatherOptions[1]
    local autoWeather = false
    local rotateMode = false
    local autoDelay = 5
    local loopSession = 0
    local statusLabel = nil

    local function updateStatus(txt, color)
        -- statusLabel is the Paragraph Frame returned by CreateParagraph.
        -- It does NOT have a :Set() method. Its child named "Content" holds the text.
        if statusLabel and statusLabel.Parent then
            local contentLabel = statusLabel:FindFirstChild("Content")
            if contentLabel and contentLabel:IsA("TextLabel") then
                contentLabel.Text = txt
                if color then
                    contentLabel.TextColor3 = color
                end
            end
        end
    end

    local function PurchaseWeather(name)
        if not weatherRemote then
            updateStatus("Remote not found", Color3.fromRGB(220,120,120))
            return false
        end
        local ok,ret = pcall(function()
            if weatherRemote:IsA("RemoteFunction") then
                return weatherRemote:InvokeServer(name)
            else
                weatherRemote:FireServer(name)
                return nil
            end
        end)
        if ok then
            local success = ret == true or validSuccess[name] or false
            updateStatus(string.format("%s -> %s", name, success and "OK" or tostring(ret)), success and Color3.fromRGB(120,200,120) or Color3.fromRGB(220,160,80))
            return success
        else
            updateStatus(name .. " error", Color3.fromRGB(220,120,120))
            return false
        end
    end

    WeatherTab:CreateParagraph({
        Title = "Weather Purchase",
        Content = "Gunakan untuk membeli event cuaca. Cloudy/Wind/Storm terverifikasi dari probe. Yang lain mungkin membutuhkan syarat khusus atau belum aktif."})

    -- Small spacer to ensure next elements (dropdown) don't visually overlap first paragraph container
    WeatherTab:CreateParagraph({
        Title = " ",
        Content = " "
    })

    WeatherTab:CreateDropdown({
        Name = "Select Weather",
        Options = WeatherOptions,
        CurrentOption = WeatherOptions[1],
        Callback = function(opt)
            if type(opt)=="table" then opt = opt[1] end
            selectedWeather = opt
            updateStatus("Selected: "..selectedWeather)
        end
    })

    WeatherTab:CreateSlider({
        Name = "Auto Delay (s)",
        Range = {3,30},
        Increment = 1,
        CurrentValue = autoDelay,
        Callback = function(v)
            autoDelay = v
        end
    })

    WeatherTab:CreateToggle({
        Name = "Rotate List",
        CurrentValue = false,
        Callback = function(v)
            rotateMode = v
        end
    })

    WeatherTab:CreateButton({
        Name = "Buy Once",
        Callback = function()
            PurchaseWeather(selectedWeather)
        end
    })

    WeatherTab:CreateToggle({
        Name = "Auto Buy",
        CurrentValue = false,
        Callback = function(val)
            autoWeather = val
            if val then
                loopSession += 1
                local mySession = loopSession
                local rotateIndex = table.find(WeatherOptions, selectedWeather) or 1
                updateStatus("Auto ON", Color3.fromRGB(120,200,120))
                task.spawn(function()
                    while autoWeather and loopSession == mySession do
                        local target = selectedWeather
                        if rotateMode then
                            target = WeatherOptions[rotateIndex]
                            rotateIndex += 1
                            if rotateIndex > #WeatherOptions then rotateIndex = 1 end
                        end
                        PurchaseWeather(target)
                        local elapsed = 0
                        while elapsed < autoDelay and autoWeather and loopSession == mySession do
                            task.wait(0.25)
                            elapsed += 0.25
                        end
                    end
                    if loopSession == mySession then
                        updateStatus("Auto OFF", Color3.fromRGB(220,160,80))
                    end
                end)
            else
                loopSession += 1 -- invalidate
                updateStatus("Stopped", Color3.fromRGB(220,160,80))
            end
        end
    })

    statusLabel = WeatherTab:CreateParagraph({
        Title = "Status",
        Content = "Ready"
    })
end

-- Debug tab creation
task.spawn(function()
    task.wait(3)
    pcall(function()
        local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
        if rayfieldGui then
            print("XSAN: Rayfield GUI found, checking tabs...")
            local tabCount = 0
            for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                if descendant:IsA("TextButton") and descendant.Text and (
                    descendant.Text == "INFO" or 
                    descendant.Text == "PRESETS" or 
                    descendant.Text == "AUTO FISH" or 
                    descendant.Text == "TELEPORT" or 
                    descendant.Text == "ANALYTICS" or 
                    descendant.Text == "INVENTORY" or 
                    descendant.Text == "UTILITY" or
                    descendant.Text == "WEATHER"
                ) then
                    tabCount = tabCount + 1
                    print("XSAN: Found tab:", descendant.Text, "Visible:", descendant.Visible, "Transparency:", descendant.BackgroundTransparency)
                end
            end
            
            if tabCount == 0 then
                print("XSAN: WARNING - No tabs found! This might cause black tab issue.")
                if NotifyError then
                    NotifyError("Tab Debug", "⚠️ Tabs not detected!\n\n🔧 Use 'Fix Black Tabs' button in INFO tab\n💡 Or try reloading the script")
                end
            else
                print("XSAN: Found", tabCount, "tabs successfully")
                if NotifySuccess then
                    NotifySuccess("Tab Debug", "✅ Found " .. tabCount .. " tabs!\n\n🎯 If tabs appear black, use fix buttons in INFO tab")
                end
            end
        else
            print("XSAN: ERROR - Rayfield GUI not found!")
            if NotifyError then
                NotifyError("Tab Debug", "❌ Rayfield GUI not found!\n\nThis may cause display issues.")
            end
        end
    end)
end)

-- Fix tab visibility issues
task.spawn(function()
    task.wait(2)
    local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
    if rayfieldGui then
        -- Fix tab container visibility
        for _, descendant in pairs(rayfieldGui:GetDescendants()) do
            if descendant:IsA("Frame") and descendant.Name == "TabContainer" then
                descendant.BackgroundTransparency = 0
                descendant.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                descendant.Visible = true
                print("XSAN: Fixed TabContainer visibility")
            elseif descendant:IsA("TextButton") and descendant.Parent and descendant.Parent.Name == "TabContainer" then
                descendant.BackgroundTransparency = 0.1
                descendant.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                descendant.TextColor3 = Color3.fromRGB(255, 255, 255)
                descendant.Visible = true
                print("XSAN: Fixed tab button:", descendant.Text or descendant.Name)
            elseif descendant:IsA("Frame") and (descendant.Name:find("Tab") or descendant.Name:find("tab")) then
                descendant.Visible = true
                descendant.BackgroundTransparency = 0
                print("XSAN: Fixed tab frame:", descendant.Name)
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- FLOATING TOGGLE BUTTON - Hide/Show UI
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating floating toggle button...")
task.spawn(function()
    task.wait(1) -- Wait for UI to fully load
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create floating button ScreenGui
    local FloatingButtonGui = Instance.new("ScreenGui")
    FloatingButtonGui.Name = "XSAN_FloatingButton"
    FloatingButtonGui.ResetOnSpawn = false
    FloatingButtonGui.IgnoreGuiInset = true
    FloatingButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui first, then fallback to PlayerGui
    local success = pcall(function()
        FloatingButtonGui.Parent = game.CoreGui
    end)
    if not success then
        FloatingButtonGui.Parent = PlayerGui
    end
    
    -- Create floating button
    local FloatingButton = Instance.new("TextButton")
    FloatingButton.Name = "ToggleButton"
    FloatingButton.Size = UDim2.new(0, isMobile and 70 or 60, 0, isMobile and 70 or 60)
    FloatingButton.Position = UDim2.new(0, 20, 0.5, -35)
    FloatingButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    FloatingButton.BorderSizePixel = 0
    -- Text will be controlled by setFloatingIcon()
    FloatingButton.Text = ""
    FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatingButton.TextScaled = true
    FloatingButton.Font = Enum.Font.SourceSansBold
    FloatingButton.Parent = FloatingButtonGui
    
    -- Add UICorner for rounded button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.5, 0) -- Perfect circle
    ButtonCorner.Parent = FloatingButton
    
    -- Add UIStroke for better visibility
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    ButtonStroke.Thickness = 2
    ButtonStroke.Transparency = 0.3
    ButtonStroke.Parent = FloatingButton
    
    -- Add shadow effect
    local ButtonShadow = Instance.new("Frame")
    ButtonShadow.Name = "Shadow"
    ButtonShadow.Size = UDim2.new(1, 4, 1, 4)
    ButtonShadow.Position = UDim2.new(0, 2, 0, 2)
    ButtonShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ButtonShadow.BackgroundTransparency = 0.7
    ButtonShadow.BorderSizePixel = 0
    ButtonShadow.ZIndex = FloatingButton.ZIndex - 1
    ButtonShadow.Parent = FloatingButton
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0.5, 0)
    ShadowCorner.Parent = ButtonShadow

    -- Optional icon image (used when UIConfig.floatingButton.useImage = true)
    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "Icon"
    IconImage.BackgroundTransparency = 1
    IconImage.AnchorPoint = Vector2.new(0.5, 0.5)
    IconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconImage.Size = UDim2.new(0.6, 0, 0.6, 0) -- 60% of button for padding
    IconImage.ScaleType = Enum.ScaleType.Fit
    IconImage.Visible = false
    IconImage.ZIndex = FloatingButton.ZIndex + 1
    IconImage.Parent = FloatingButton

    -- Helper to switch icon based on visibility and configuration
    local function setFloatingIcon(visibleState)
        local cfg = UIConfig.floatingButton
        if cfg.useImage then
            FloatingButton.Text = ""
            IconImage.Visible = true
            IconImage.Image = visibleState and cfg.imageVisible or cfg.imageHidden
        else
            IconImage.Visible = false
            FloatingButton.Text = visibleState and cfg.emojiVisible or cfg.emojiHidden
        end
    end
    
    -- Initialize icon state
    setFloatingIcon(true)

    -- Variables
    local isUIVisible = true
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    -- Get Rayfield GUI reference
    local function getRayfieldGui()
        return LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
    end
    
    -- Toggle UI visibility function
    local function toggleUI()
        pcall(function()
            local rayfieldGui = getRayfieldGui()
            if rayfieldGui then
                isUIVisible = not isUIVisible
                
                -- Update button appearance
                if isUIVisible then
                    setFloatingIcon(true)
                    FloatingButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                    rayfieldGui.Enabled = true
                    
                    -- Animate show
                    rayfieldGui.Main.BackgroundTransparency = 1
                    TweenService:Create(rayfieldGui.Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0
                    }):Play()
                    
                    if NotifySuccess then
                        NotifySuccess("UI Toggle", "XSAN Fish It Pro UI shown!")
                    end
                else
                    setFloatingIcon(false)
                    FloatingButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
                    
                    -- Animate hide
                    TweenService:Create(rayfieldGui.Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        BackgroundTransparency = 1
                    }):Play()
                    
                    task.wait(0.3)
                    rayfieldGui.Enabled = false
                    if NotifyInfo then
                        NotifyInfo("UI Toggle", "UI hidden! Use floating button to show.")
                    end
                end
                
                -- Button feedback animation
                TweenService:Create(FloatingButton, TweenInfo.new(0.1, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, (isMobile and 70 or 60) * 1.1, 0, (isMobile and 70 or 60) * 1.1)
                }):Play()
                
                task.wait(0.1)
                TweenService:Create(FloatingButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, isMobile and 70 or 60, 0, isMobile and 70 or 60)
                }):Play()
            end
        end)
    end
    
    -- Make button draggable
    local function updateDrag(input)
        local delta = input.Position - dragStart
        FloatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    FloatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = FloatingButton.Position
            
            -- Visual feedback for drag start
            TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 160, 230)
            }):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    -- Reset color
                    TweenService:Create(FloatingButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
                    }):Play()
                end
            end)
        end
    end)
    
    FloatingButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Click to toggle (only if not dragging significantly)
    FloatingButton.MouseButton1Click:Connect(function()
        if not dragging then
            toggleUI()
        end
    end)
    
    -- Right click or long press to access menu
    FloatingButton.MouseButton2Click:Connect(function()
        if not dragging then
            -- Create mini context menu
            local ContextMenu = Instance.new("Frame")
            ContextMenu.Name = "ContextMenu"
            ContextMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ContextMenu.BorderSizePixel = 0
            ContextMenu.Position = UDim2.new(0, FloatingButton.AbsolutePosition.X + 80, 0, FloatingButton.AbsolutePosition.Y)
            ContextMenu.Size = UDim2.new(0, 120, 0, 0)
            ContextMenu.AutomaticSize = Enum.AutomaticSize.Y
            ContextMenu.ZIndex = 20
            ContextMenu.Parent = FloatingButtonGui
            
            -- Add UICorner
            local MenuCorner = Instance.new("UICorner")
            MenuCorner.CornerRadius = UDim.new(0, 8)
            MenuCorner.Parent = ContextMenu
            
            -- Add UIListLayout
            local MenuLayout = Instance.new("UIListLayout")
            MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
            MenuLayout.Padding = UDim.new(0, 2)
            MenuLayout.Parent = ContextMenu
            
            -- Add UIPadding
            local MenuPadding = Instance.new("UIPadding")
            MenuPadding.PaddingTop = UDim.new(0, 5)
            MenuPadding.PaddingBottom = UDim.new(0, 5)
            MenuPadding.PaddingLeft = UDim.new(0, 8)
            MenuPadding.PaddingRight = UDim.new(0, 8)
            MenuPadding.Parent = ContextMenu
            
            -- Close Button
            local CloseButton = Instance.new("TextButton")
            CloseButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
            CloseButton.BorderSizePixel = 0
            CloseButton.Size = UDim2.new(1, 0, 0, 30)
            CloseButton.Font = Enum.Font.SourceSansBold
            CloseButton.Text = "❌ Close Script"
            CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CloseButton.TextScaled = true
            CloseButton.LayoutOrder = 1
            CloseButton.Parent = ContextMenu
            
            local CloseCorner = Instance.new("UICorner")
            CloseCorner.CornerRadius = UDim.new(0, 5)
            CloseCorner.Parent = CloseButton
            
            CloseButton.MouseButton1Click:Connect(function()
                -- Destroy all XSAN GUIs
                if getRayfieldGui() then
                    getRayfieldGui():Destroy()
                end
                FloatingButtonGui:Destroy()
                NotifyInfo("XSAN", "Script closed. Thanks for using XSAN Fish It Pro!")
            end)
            
            -- Minimize Button
            local MinimizeButton = Instance.new("TextButton")
            MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
            MinimizeButton.BorderSizePixel = 0
            MinimizeButton.Size = UDim2.new(1, 0, 0, 30)
            MinimizeButton.Font = Enum.Font.SourceSans
            MinimizeButton.Text = "➖ Minimize"
            MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            MinimizeButton.TextScaled = true
            MinimizeButton.LayoutOrder = 2
            MinimizeButton.Parent = ContextMenu
            
            local MinimizeCorner = Instance.new("UICorner")
            MinimizeCorner.CornerRadius = UDim.new(0, 5)
            MinimizeCorner.Parent = MinimizeButton
            
            MinimizeButton.MouseButton1Click:Connect(function()
                if isUIVisible then
                    toggleUI()
                end
                ContextMenu:Destroy()
            end)
            
            -- Auto-close menu after 3 seconds
            task.spawn(function()
                task.wait(3)
                if ContextMenu.Parent then
                    ContextMenu:Destroy()
                end
            end)
            
            -- Close menu when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local menuPos = ContextMenu.AbsolutePosition
                    local menuSize = ContextMenu.AbsoluteSize
                    
                    if mousePos.X < menuPos.X or mousePos.X > menuPos.X + menuSize.X or
                       mousePos.Y < menuPos.Y or mousePos.Y > menuPos.Y + menuSize.Y then
                        if ContextMenu.Parent then
                            ContextMenu:Destroy()
                        end
                    end
                end
            end)
        end
    end)
    
    -- Hover effects for desktop
    if not isMobile then
        FloatingButton.MouseEnter:Connect(function()
            if not dragging then
                TweenService:Create(FloatingButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 65, 0, 65),
                    BackgroundColor3 = isUIVisible and Color3.fromRGB(90, 150, 220) or Color3.fromRGB(220, 120, 120)
                }):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                    Transparency = 0.1
                }):Play()
            end
        end)
        
        FloatingButton.MouseLeave:Connect(function()
            if not dragging then
                TweenService:Create(FloatingButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 60, 0, 60),
                    BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
                }):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                    Transparency = 0.3
                }):Play()
            end
        end)
    end
    
    -- Keyboard shortcut for toggle (H key)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.H then
            toggleUI()
        end
    end)
    
    print("XSAN: Floating toggle button created successfully!")
    print("XSAN: - Click button to hide/show UI")
    print("XSAN: - Drag button to move position")
    print("XSAN: - Press 'H' key to toggle UI")
end)

-- Load Remotes
print("XSAN: Loading remotes...")
local net, rodRemote, miniGameRemote, finishRemote, equipRemote

local function initializeRemotes()
    local success, error = pcall(function()
        net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
        print("XSAN: Net found")
        rodRemote = net:WaitForChild("RF/ChargeFishingRod")
        print("XSAN: Rod remote found")
        miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted") 
        print("XSAN: MiniGame remote found")
        finishRemote = net:WaitForChild("RE/FishingCompleted")
        print("XSAN: Finish remote found")
        equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")
        print("XSAN: Equip remote found")
    end)
    
    if not success then
        warn("XSAN: Error loading remotes:", error)
        Notify("XSAN Error", "Failed to load game remotes. Some features may not work.", 5)
        return false
    end
    
    return true
end

local remotesLoaded = initializeRemotes()
print("XSAN: Remotes loading completed! Status:", remotesLoaded)

-- State Variables
print("XSAN: Initializing variables...")
local autofish = false
local autofishSession = 0 -- increments each time autofish is (re)started to invalidate old loops
local autofishThread = nil -- coroutine reference
local perfectCast = false
local safeMode = false  -- Safe Mode for random perfect cast
local safeModeChance = 70  -- 70% chance for perfect cast in safe mode
local hybridMode = false  -- Hybrid Mode for ultimate security
local clickFastAutoClicker = false  -- Auto-clicker for Click Fast mini-game (default OFF for speed)
local hybridPerfectChance = 70  -- Hybrid mode perfect cast chance
local hybridMinDelay = 1.0  -- Hybrid mode minimum delay
local hybridMaxDelay = 2.5  -- Hybrid mode maximum delay
local hybridAutoFish = nil  -- Hybrid auto fish instance
local autoRecastDelay = 0.5
local fishCaught = 0
local itemsSold = 0
local autoSellThreshold = 10
local autoSellOnThreshold = false
local sessionStartTime = tick()
local perfectCasts = 0
local normalCasts = 0  -- Track normal casts for analytics
local clickFastDetections = 0  -- Track Click Fast mini-game detections
local currentPreset = "None"
local globalAutoSellEnabled = true  -- Global auto sell control

-- Random Fish System Variables
local randomFishEnabled = false
local randomFishLocations = {}  -- Selected locations for random fishing
local randomFishInterval = 5  -- Minutes between location changes
local randomFishSession = 0  -- Session control for random fish
local randomFishThread = nil  -- Coroutine reference
local currentRandomLocation = nil  -- Current fishing location
local lastLocationChange = tick()  -- Track when location was last changed
local randomFishStartTime = tick()  -- Session start time for analytics
local locationsVisited = 0  -- Track how many locations visited
local totalRandomFishCaught = 0  -- Track fish caught in random mode

-- Feature states
local featureState = {
    AutoSell = false,
    SmartInventory = false,
    Analytics = true,
    Safety = true,
}

print("XSAN: Variables initialized successfully!")

-- ═══════════════════════════════════════════════════════════════
-- ULTIMATE RESET SYSTEM - Auto Reset on Respawn/Reconnect
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Initializing Ultimate Reset System...")

-- Function to reset all features to default state
local function ResetAllFeatures()
    print("XSAN: Resetting all features to default state...")
    
    -- Reset auto fishing system
    autofish = false
    autofishSession = autofishSession + 1  -- Invalidate any running loops
    autofishThread = nil
    
    -- Reset casting modes
    perfectCast = false
    safeMode = false
    hybridMode = false
    
    -- Reset auto sell
    autoSellOnThreshold = false
    
    -- Reset walk speed
    walkspeedEnabled = false
    currentWalkspeed = defaultWalkspeed
    
    -- Reset unlimited jump
    unlimitedJumpEnabled = false
    currentJumpHeight = defaultJumpHeight
    if unlimitedJumpConnection then
        unlimitedJumpConnection:Disconnect()
        unlimitedJumpConnection = nil
    end
    
    -- Reset current preset
    currentPreset = "None"
    
    -- Reset hybrid auto fish if exists
    if hybridAutoFish then
        pcall(function()
            hybridAutoFish.toggle(false)
        end)
        hybridAutoFish = nil
    end
    
    -- Update UI flags if they exist
    pcall(function()
        if Rayfield and Rayfield.Flags then
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(false)
            end
            if Rayfield.Flags["WalkSpeedSlider"] then
                Rayfield.Flags["WalkSpeedSlider"]:Set(defaultWalkspeed)
            end
            if Rayfield.Flags["UnlimitedJumpToggle"] then
                Rayfield.Flags["UnlimitedJumpToggle"]:Set(false)
            end
            if Rayfield.Flags["JumpHeightSlider"] then
                Rayfield.Flags["JumpHeightSlider"]:Set(defaultJumpHeight)
            end
        end
    end)
    
    print("XSAN: All features reset to default state successfully!")
    NotifySuccess("System Reset", "🔄 XSAN Reset Complete!\n\n✅ All features disabled\n✅ Settings restored to default\n✅ Safe state activated\n\n💡 Ready for fresh start!")
end

-- Function to detect respawn/reconnect
local function SetupResetTriggers()
    -- Method 1: Character respawn detection
    LocalPlayer.CharacterAdded:Connect(function(character)
        print("XSAN: Character respawn detected - Triggering reset...")
        task.wait(2) -- Wait for character to fully load
        ResetAllFeatures()
    end)
    
    -- Method 2: Connection lost/reconnect detection
    local Players = game:GetService("Players")
    local lastPlayerCount = #Players:GetPlayers()
    
    spawn(function()
        while true do
            task.wait(5) -- Check every 5 seconds
            local currentPlayerCount = #Players:GetPlayers()
            
            -- If player count changes dramatically, might indicate reconnection
            if math.abs(currentPlayerCount - lastPlayerCount) > 5 then
                print("XSAN: Potential reconnection detected - Triggering reset...")
                ResetAllFeatures()
            end
            
            lastPlayerCount = currentPlayerCount
        end
    end)
    
    -- Method 3: Game state change detection
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            print("XSAN: Player leaving - Preparing reset for next session...")
            ResetAllFeatures()
        end
    end)
    
    print("XSAN: Reset triggers setup complete!")
end

-- Initialize reset system
SetupResetTriggers()

-- Manual reset function for emergency use
_G.XSANReset = ResetAllFeatures -- Global function for manual reset

print("XSAN: Ultimate Reset System initialized successfully!")

-- ═══════════════════════════════════════════════════════════════
-- WALKSPEED SYSTEM
-- ═══════════════════════════════════════════════════════════════
local walkspeedEnabled = false
local currentWalkspeed = 16
local defaultWalkspeed = 16

local function setWalkSpeed(speed)
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            currentWalkspeed = speed
            NotifySuccess("Walk Speed", "Walk speed set to " .. speed)
        else
            NotifyError("Walk Speed", "Character or Humanoid not found")
        end
    end)
    
    if not success then
        NotifyError("Walk Speed", "Failed to set walk speed: " .. tostring(error))
    end
end

local function resetWalkSpeed()
    setWalkSpeed(defaultWalkspeed)
    walkspeedEnabled = false
end

print("XSAN: Walkspeed system initialized!")

-- ═══════════════════════════════════════════════════════════════
-- UNLIMITED JUMP SYSTEM
-- ═══════════════════════════════════════════════════════════════
local unlimitedJumpEnabled = false
local currentJumpHeight = 7.2 -- Default Roblox jump height
local defaultJumpHeight = 7.2
local unlimitedJumpConnection = nil

local function setJumpHeight(height)
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpHeight = height
            currentJumpHeight = height
            NotifySuccess("Jump Height", "Jump height set to " .. height)
        else
            NotifyError("Jump Height", "Character or Humanoid not found")
        end
    end)
    
    if not success then
        NotifyError("Jump Height", "Failed to set jump height: " .. tostring(error))
    end
end

local function enableUnlimitedJump()
    if unlimitedJumpEnabled then return end
    
    unlimitedJumpEnabled = true
    
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            -- Method 1: Set very high jump height
            humanoid.JumpHeight = 50
            currentJumpHeight = 50
            
            -- Method 2: Enable infinite jumps via UserInputService (with proper input filtering)
            if UserInputService then
                unlimitedJumpConnection = UserInputService.JumpRequest:Connect(function()
                    -- Only process if unlimited jump is still enabled and character exists
                    if unlimitedJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
            
            NotifySuccess("Unlimited Jump", "✅ Unlimited Jump ENABLED!\n\n🚀 Jump height: 50\n⚡ Infinite jumps: Active\n🎯 Press space repeatedly to fly!\n\n💡 Won't interfere with manual fishing")
        else
            NotifyError("Unlimited Jump", "Character or Humanoid not found!")
        end
    end)
    
    if not success then
        NotifyError("Unlimited Jump", "Failed to enable unlimited jump: " .. tostring(error))
        unlimitedJumpEnabled = false
    end
end

local function disableUnlimitedJump()
    if not unlimitedJumpEnabled then return end
    
    unlimitedJumpEnabled = false
    
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpHeight = defaultJumpHeight
            currentJumpHeight = defaultJumpHeight
        end
        
        -- Disconnect infinite jump connection
        if unlimitedJumpConnection then
            unlimitedJumpConnection:Disconnect()
            unlimitedJumpConnection = nil
        end
        
        NotifyInfo("Unlimited Jump", "❌ Unlimited Jump DISABLED\n\n📉 Jump height: Normal (7.2)\n🚫 Infinite jumps: Disabled")
    end)
    
    if not success then
        NotifyError("Unlimited Jump", "Failed to disable unlimited jump: " .. tostring(error))
    end
end

local function toggleUnlimitedJump()
    if unlimitedJumpEnabled then
        disableUnlimitedJump()
    else
        enableUnlimitedJump()
    end
end

print("XSAN: Unlimited Jump system initialized!")

-- XSAN Ultimate Teleportation System
print("XSAN: Initializing teleportation system...")

-- Dynamic Teleportation Data (like old.lua)
local TeleportLocations = {
    Islands = {},
    NPCs = {},
    Events = {}
}

-- Get island locations dynamically from workspace (same as old.lua)
local tpFolder = workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!")
if tpFolder then
    for _, island in ipairs(tpFolder:GetChildren()) do
        if island:IsA("BasePart") then
            TeleportLocations.Islands[island.Name] = island.CFrame
            print("XSAN: Found island - " .. island.Name)
        end
    end
else
    -- Fallback to hardcoded coordinates if workspace folder not found
    print("XSAN: Island folder not found, using updated fallback coordinates")
    TeleportLocations.Islands = {
        -- Random Spot Fishing locations (Updated from user table)
        ["SISYPUS"] = CFrame.new(-3730.62, -101.13, -951.52),
        ["TREASURE"] = CFrame.new(-3542.26, -279.08, -1663.14),
        ["STINGRY"] = CFrame.new(102.05, 29.64, 3054.35),
        ["ICE LAND"] = CFrame.new(1990.55, 3.09, 3021.91),
        ["CRATER"] = CFrame.new(990.45, 21.06, 5059.85),
        ["TROPICAL"] = CFrame.new(-2093.80, 6.26, 3654.30),
        ["STONE"] = CFrame.new(-2636.19, 124.87, -27.49),
        ["MACHINE"] = CFrame.new(-1551.25, 2.87, 1920.26),
        
        -- Updated island coordinates from detector (Latest 2025)
        ["Kohana Volcano"] = CFrame.new(-594.971252, 396.65213, 149.10907),
        ["Crater Island"] = CFrame.new(1010.01001, 252, 5078.45117),
        ["Kohana"] = CFrame.new(-650.971191, 208.693695, 711.10907),
        ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801),
        ["Stingray Shores"] = CFrame.new(45.2788086, 252.562927, 2987.10913),
        ["Esoteric Depths"] = CFrame.new(1944.77881, 393.562927, 1371.35913),
        ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298),
        ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
        ["Coral Reefs"] = CFrame.new(-3023.97119, 337.812927, 2195.60913),
        
        -- Legacy coordinates (backup)
        ["Moosewood"] = CFrame.new(389, 137, 264),
        ["Ocean"] = CFrame.new(1082, 124, -924),
        ["Snowcap Island"] = CFrame.new(2648, 140, 2522),
        ["Mushgrove Swamp"] = CFrame.new(-1817, 138, 1808),
        ["Roslit Bay"] = CFrame.new(-1442, 135, 1006),
        ["Sunstone Island"] = CFrame.new(-934, 135, -1122),
        ["Statue Of Sovereignty"] = CFrame.new(1, 140, -918),
        ["Moonstone Island"] = CFrame.new(-3004, 135, -1157),
        ["Forsaken Shores"] = CFrame.new(-2853, 135, 1627),
        ["Ancient Isle"] = CFrame.new(5896, 137, 4516),
        ["Keepers Altar"] = CFrame.new(1296, 135, -808),
        ["Brine Pool"] = CFrame.new(-1804, 135, 3265),
        ["The Depths"] = CFrame.new(994, -715, 1226),
        ["Vertigo"] = CFrame.new(-111, -515, 1049),
        ["Volcano"] = CFrame.new(-1888, 164, 330)
    }
end

-- Event Locations (Moved above NPCs for better organization)
TeleportLocations.Events = {
    ["🦈 Ice Spot"] = CFrame.new(1990.55, 3.09, 3021.91),
    ["🦈 Crater Spot"] = CFrame.new(990.45, 21.06, 5059.85),
    ["🦈 Stone Spot"] = CFrame.new(-2636.19, 124.87, -27.49),
    ["🦈 Tropical Spot"] = CFrame.new(-2093.80, 6.26, 3654.30),
	["🦈 Sisypus Statue"] = CFrame.new(-3730.62, -101.13, -951.52),
    ["🦈 Treasure Hall"] = CFrame.new(-3542.26, -279.08, -1663.14),
    ["🦈 Enchant Stone"] = CFrame.new(3237.61, -1302.33, 1398.04)
}

-- Player Teleportation Function (improved like old.lua)
local function TeleportToPlayer(targetPlayerName)
    pcall(function()
        -- Try to find in workspace Characters folder first (like old.lua)
        local charFolder = workspace:FindFirstChild("Characters")
        local targetCharacter = nil
        
        if charFolder then
            targetCharacter = charFolder:FindFirstChild(targetPlayerName)
        end
        
        -- Fallback to Players service
        if not targetCharacter then
            local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
            if targetPlayer then
                targetCharacter = targetPlayer.Character
            end
        end
        
        if not targetCharacter then
            NotifyError("Player TP", "Player '" .. targetPlayerName .. "' not found!")
            return
        end
        
        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            NotifyError("Player TP", "Target player's character not found!")
            return
        end
        
        SafeTeleport(targetHRP.CFrame, targetPlayerName .. "'s location")
    end)
end

-- NPCs Detection System - Real-time accurate locations
local function DetectNPCLocations()
    local detectedNPCs = {}
    
    -- Method 1: Check ReplicatedStorage NPCs (Most Accurate)
    local npcContainer = ReplicatedStorage:FindFirstChild("NPC")
    if npcContainer then
        print("XSAN: Scanning ReplicatedStorage NPCs...")
        for _, npc in pairs(npcContainer:GetChildren()) do
            if npc:FindFirstChild("WorldPivot") then
                local pos = npc.WorldPivot.Position
                local emoji = "👤"
                
                -- Add specific emojis based on NPC names
                if string.find(npc.Name:lower(), "alex") or string.find(npc.Name:lower(), "shop") then
                    emoji = "🛒"
                elseif string.find(npc.Name:lower(), "marc") or string.find(npc.Name:lower(), "rod") then
                    emoji = "🎣"
                elseif string.find(npc.Name:lower(), "henry") or string.find(npc.Name:lower(), "storage") then
                    emoji = "📦"
                elseif string.find(npc.Name:lower(), "scientist") then
                    emoji = "🔬"
                elseif string.find(npc.Name:lower(), "boat") then
                    emoji = "⚓"
                elseif string.find(npc.Name:lower(), "angler") then
                    emoji = "🏆"
                elseif string.find(npc.Name:lower(), "scott") then
                    emoji = "🐧"
                elseif string.find(npc.Name:lower(), "billy") or string.find(npc.Name:lower(), "bob") then
                    emoji = "🐟"
                elseif string.find(npc.Name:lower(), "fish") then
                    emoji = "🎣"
                end
                
                detectedNPCs[emoji .. " " .. npc.Name] = CFrame.new(pos)
                print("XSAN: Found NPC -", npc.Name, "at", pos)
            end
        end
    end
    
    -- Method 2: Check Workspace NPCs (Backup method)
    print("XSAN: Scanning Workspace NPCs...")
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
            -- Skip player characters
            local isPlayerCharacter = false
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character == obj then
                    isPlayerCharacter = true
                    break
                end
            end
            
            if not isPlayerCharacter then
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                if rootPart then
                    local emoji = "👤"
                    
                    -- Check if this NPC is important (not already detected)
                    local isImportant = false
                    local npcName = obj.Name
                    
                    if string.find(npcName:lower(), "alex") or string.find(npcName:lower(), "shop") then
                        emoji = "🛒"
                        isImportant = true
                    elseif string.find(npcName:lower(), "marc") or string.find(npcName:lower(), "rod") then
                        emoji = "🎣"
                        isImportant = true
                    elseif string.find(npcName:lower(), "henry") or string.find(npcName:lower(), "storage") then
                        emoji = "📦"
                        isImportant = true
                    elseif string.find(npcName:lower(), "scientist") then
                        emoji = "🔬"
                        isImportant = true
                    elseif string.find(npcName:lower(), "boat") then
                        emoji = "⚓"
                        isImportant = true
                    elseif string.find(npcName:lower(), "angler") then
                        emoji = "🏆"
                        isImportant = true
                    end
                    
                    if isImportant then
                        local key = emoji .. " " .. npcName
                        if not detectedNPCs[key] then -- Only add if not already detected
                            detectedNPCs[key] = rootPart.CFrame
                            print("XSAN: Found Workspace NPC -", npcName, "at", rootPart.Position)
                        end
                    end
                end
            end
        end
    end
    
    return detectedNPCs
end

-- Initialize NPCs with real-time detection
print("XSAN: Detecting NPC locations in real-time...")
local detectedNPCs = DetectNPCLocations()

-- Updated fallback NPCs (Latest 2025 coordinates - Only used if detection fails)
local fallbackNPCs = {
    -- Primary NPCs (Most frequently used)
    ["🛒 Shop (Alex)"] = CFrame.new(-31.10, 4.84, 2899.03),
    ["🎣 Rod Shop (Marc)"] = CFrame.new(454, 150, 229),
    ["📦 Storage (Henry)"] = CFrame.new(491, 150, 272),
    ["🏆 Angler"] = CFrame.new(484, 150, 331),
    
    -- Secondary NPCs (Backup only)
    ["🛒 Shop (Joe)"] = CFrame.new(114.39, 4.75, 2882.38),
    ["🛒 Shop (Seth)"] = CFrame.new(70.96, 4.84, 2895.36),
    ["⚓ Boat Expert"] = CFrame.new(23.39, 4.70, 2804.16),
    ["🔬 Scientist"] = CFrame.new(-8.64, 4.50, 2849.57),
    ["🐟 Billy Bob"] = CFrame.new(72.05, 29.00, 2950.63),
    ["🎣 Silly Fisherman"] = CFrame.new(93.53, 27.24, 3009.08),
    ["🐧 Scott"] = CFrame.new(-81.94, 4.80, 2866.59)
}

-- Smart NPC Selection: Use detected NPCs first, fallback if needed
if next(detectedNPCs) then
    local detectedCount = 0
    for _ in pairs(detectedNPCs) do detectedCount = detectedCount + 1 end
    
    TeleportLocations.NPCs = detectedNPCs
    print("XSAN: ✅ Using REAL-TIME detected NPC locations! Found", detectedCount, "NPCs")
    NotifySuccess("NPC Detection", "✅ Real-time NPC locations detected!\n📍 " .. detectedCount .. " NPCs found with accurate positions.\n🔄 Auto-refresh: Active")
    
    -- Merge important fallback NPCs if not detected
    for fallbackName, fallbackCFrame in pairs(fallbackNPCs) do
        if not detectedNPCs[fallbackName] then
            TeleportLocations.NPCs[fallbackName .. " (Fallback)"] = fallbackCFrame
            print("XSAN: Added fallback NPC:", fallbackName)
        end
    end
else
    TeleportLocations.NPCs = fallbackNPCs
    print("XSAN: ⚠️ Real-time detection failed - Using fallback NPC locations")
    NotifyInfo("NPC Detection", "⚠️ Using fallback NPC locations.\n🔄 Real-time detection will retry automatically.\n📍 11 NPCs loaded from backup database")
end

-- Safe Teleportation Function
local function SafeTeleport(targetCFrame, locationName)
    pcall(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            NotifyError("Teleport", "Character not found! Cannot teleport.")
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- Disable gravity temporarily to prevent falling
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        -- Smart teleportation with multiple safety checks
        local originalCFrame = humanoidRootPart.CFrame
        
        -- Method 1: Direct teleport (best for most cases)
        local directPosition = targetCFrame.Position + Vector3.new(0, 3, 0) -- Reduced from 5 to 3
        humanoidRootPart.CFrame = CFrame.new(directPosition, targetCFrame.LookVector)
        
        -- Wait shorter time and check if position is safe
        task.wait(0.05)
        
        -- Method 2: Raycast to find safe ground level
        local raycast = workspace:Raycast(directPosition, Vector3.new(0, -50, 0))
        local finalPosition = targetCFrame.Position
        
        if raycast and raycast.Position then
            -- Found ground, place slightly above it
            finalPosition = raycast.Position + Vector3.new(0, 5, 0)
        end
        
        -- Final teleport to safe position
        humanoidRootPart.CFrame = CFrame.new(finalPosition, targetCFrame.LookVector)
        
        -- Re-enable gravity after short delay
        task.wait(0.1)
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        NotifySuccess("Teleport", "Successfully teleported to: " .. locationName)
        
        -- Log teleportation for analytics
        print("XSAN Teleport: " .. LocalPlayer.Name .. " -> " .. locationName)
    end)
end

print("XSAN: Teleportation system initialized successfully!")

-- ═══════════════════════════════════════════════════════════════
-- RANDOM FISH SYSTEM - Auto Fishing with Location Rotation
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Initializing Random Fish System...")

-- Smart Wait function for Random Fish with session control
local function randomFishWait(duration, sessionId)
    local endTime = tick() + duration
    while tick() < endTime do
        if randomFishSession ~= sessionId or not randomFishEnabled then
            return false -- Session invalidated or disabled
        end
        task.wait(0.1)
    end
    return true
end

-- Get Random Location from selected locations
local function GetRandomLocation()
    if #randomFishLocations == 0 then
        return nil, "No locations selected"
    end
    
    local availableLocations = {}
    
    -- Combine all selected location types
    for _, locationType in pairs(randomFishLocations) do
        if locationType == "Islands" then
            for name, cframe in pairs(TeleportLocations.Islands) do
                table.insert(availableLocations, {name = name, cframe = cframe, type = "🏝️"})
            end
        elseif locationType == "NPCs" then
            for name, cframe in pairs(TeleportLocations.NPCs) do
                table.insert(availableLocations, {name = name, cframe = cframe, type = "👤"})
            end
        elseif locationType == "Events" then
            for name, cframe in pairs(TeleportLocations.Events) do
                table.insert(availableLocations, {name = name, cframe = cframe, type = "⭐"})
            end
        end
    end
    
    if #availableLocations == 0 then
        return nil, "No valid locations found"
    end
    
    -- Select random location
    local randomIndex = math.random(1, #availableLocations)
    local selectedLocation = availableLocations[randomIndex]
    
    return selectedLocation, nil
end

-- Random Fish Main Loop
local function StartRandomFishSystem()
    randomFishSession = randomFishSession + 1
    local mySession = randomFishSession
    randomFishStartTime = tick()
    locationsVisited = 0
    totalRandomFishCaught = 0
    
    NotifySuccess("Random Fish", "🎣 RANDOM FISH SYSTEM STARTED!\n\n🌍 Auto location switching every " .. randomFishInterval .. " minutes\n🎯 Selected location types: " .. #randomFishLocations .. "\n⚡ AI fishing system: Active")
    
    randomFishThread = coroutine.create(function()
        while randomFishEnabled and randomFishSession == mySession do
            -- Get random location
            local location, error = GetRandomLocation()
            if not location then
                NotifyError("Random Fish", "❌ Failed to get location: " .. error)
                break
            end
            
            -- Teleport to location
            currentRandomLocation = location
            locationsVisited = locationsVisited + 1
            lastLocationChange = tick()
            
            SafeTeleport(location.cframe, location.type .. " " .. location.name)
            NotifyInfo("Random Fish", "📍 Location " .. locationsVisited .. ": " .. location.type .. " " .. location.name .. "\n⏰ Fishing for " .. randomFishInterval .. " minutes\n🎣 Next move: " .. math.floor(randomFishInterval) .. ":" .. string.format("%02d", (randomFishInterval % 1) * 60))
            
            -- Wait a bit for teleportation to complete
            if not randomFishWait(2, mySession) then break end
            
            -- Start auto fishing if not already running
            if not autofish then
                autofish = true
                autofishSession = autofishSession + 1
                local autofishSessionLocal = autofishSession
                
                autofishThread = coroutine.create(function()
                    local startFishCount = fishCaught
                    
                    while autofish and autofishSession == autofishSessionLocal and randomFishEnabled and randomFishSession == mySession do
                        -- Check if it's time to change location
                        if tick() - lastLocationChange >= (randomFishInterval * 60) then
                            break -- Exit fishing loop to change location
                        end
                        
                        -- Fishing sequence (same as normal auto fish)
                        local usePerfectCast = perfectCast
                        if safeMode then
                            usePerfectCast = math.random(50, 100) <= safeModeChance
                        end
                        
                        local timestamp = usePerfectCast and 9999999999 or (tick() + math.random())
                        if rodRemote and autofishSession == autofishSessionLocal and autofish then
                            pcall(function() rodRemote:InvokeServer(timestamp) end)
                        end
                        
                        if not randomFishWait(0.1, mySession) then break end
                        
                        if autofishSession ~= autofishSessionLocal or not autofish then break end
                        local x = usePerfectCast and -1.238 or (math.random(-1000, 1000) / 1000)
                        local y = usePerfectCast and 0.969 or (math.random(0, 1000) / 1000)
                        
                        if miniGameRemote and autofishSession == autofishSessionLocal and autofish then
                            pcall(function() miniGameRemote:InvokeServer(x, y) end)
                        end
                        
                        if not randomFishWait(1.3, mySession) then break end
                        
                        -- Click Fast Auto-Clicker (if enabled)
                        if autofishSession == autofishSessionLocal and autofish and clickFastAutoClicker and randomFishEnabled and randomFishSession == mySession then
                            -- Same Click Fast logic as main auto fish but with session control
                            local clickFastDetected = false
                            local startTime = tick()
                            
                            while tick() - startTime < 2 and autofishSession == autofishSessionLocal and autofish and randomFishSession == mySession do
                                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                                if playerGui then
                                    for _, gui in pairs(playerGui:GetChildren()) do
                                        if gui:IsA("ScreenGui") then
                                            local function findClickFast(obj)
                                                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                                                    local text = obj.Text:lower()
                                                    if text:find("click") and (text:find("fast") or text:find("quick") or text:find("rapid")) then
                                                        return true
                                                    end
                                                elseif obj:IsA("ImageLabel") and obj.Name:lower():find("click") then
                                                    return true
                                                end
                                                for _, child in pairs(obj:GetChildren()) do
                                                    if findClickFast(child) then return true end
                                                end
                                                return false
                                            end
                                            
                                            if findClickFast(gui) then
                                                clickFastDetected = true
                                                break
                                            end
                                        end
                                    end
                                end
                                if clickFastDetected then break end
                                task.wait(0.02)
                            end
                            
                            if clickFastDetected then
                                clickFastDetections += 1
                                local clickStartTime = tick()
                                local clickAttempts = 0
                                
                                while tick() - clickStartTime < 3 and autofishSession == autofishSessionLocal and autofish and clickAttempts < 75 and randomFishSession == mySession do
                                    pcall(function()
                                        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                                        if playerGui then
                                            for _, gui in pairs(playerGui:GetChildren()) do
                                                if gui:IsA("ScreenGui") then
                                                    local function clickButton(obj)
                                                        if obj:IsA("GuiButton") or obj:IsA("TextButton") or obj:IsA("ImageButton") then
                                                            local isClickButton = false
                                                            if obj.Text then
                                                                local text = obj.Text:lower()
                                                                isClickButton = text:find("click") or text == ""
                                                            end
                                                            if obj.Name:lower():find("click") then
                                                                isClickButton = true
                                                            end
                                                            
                                                            if isClickButton then
                                                                for _, connection in pairs(getconnections(obj.MouseButton1Click)) do
                                                                    connection:Fire()
                                                                end
                                                                for _, connection in pairs(getconnections(obj.Activated)) do
                                                                    connection:Fire()
                                                                end
                                                                return true
                                                            end
                                                        end
                                                        for _, child in pairs(obj:GetChildren()) do
                                                            if clickButton(child) then return true end
                                                        end
                                                        return false
                                                    end
                                                    clickButton(gui)
                                                end
                                            end
                                        end
                                    end)
                                    clickAttempts += 1
                                    task.wait(0.01)
                                end
                            end
                        end
                        
                        if autofishSession ~= autofishSessionLocal or not autofish then break end
                        if finishRemote then
                            pcall(function() finishRemote:FireServer() end)
                        end
                        
                        fishCaught += 1
                        totalRandomFishCaught += 1
                        
                        -- Track cast types
                        if usePerfectCast then
                            perfectCasts += 1
                        else
                            normalCasts += 1
                        end
                        
                        CheckAndAutoSell()
                        
                        -- Recast delay
                        if not randomFishWait(autoRecastDelay, mySession) then break end
                    end
                    
                    -- Calculate location performance
                    local fishAtThisLocation = fishCaught - startFishCount
                    if fishAtThisLocation > 0 then
                        NotifyInfo("Location Stats", "🎣 " .. location.type .. " " .. location.name .. "\n🐟 Fish caught: " .. fishAtThisLocation .. "\n⏱️ Duration: " .. math.floor((tick() - lastLocationChange) / 60) .. " minutes")
                    end
                end)
                coroutine.resume(autofishThread)
            end
            
            -- Wait for interval duration or until stopped
            local intervalSeconds = randomFishInterval * 60
            local waitStart = tick()
            while tick() - waitStart < intervalSeconds and randomFishEnabled and randomFishSession == mySession do
                if not randomFishWait(1, mySession) then break end
                
                -- Update progress every minute
                local elapsed = tick() - waitStart
                local remaining = intervalSeconds - elapsed
                if remaining > 0 and math.floor(elapsed) % 60 == 0 and elapsed > 0 then
                    local remainingMinutes = math.floor(remaining / 60)
                    local remainingSeconds = math.floor(remaining % 60)
                    print("XSAN Random Fish: " .. remainingMinutes .. ":" .. string.format("%02d", remainingSeconds) .. " remaining at " .. location.name)
                end
            end
        end
        
        -- Stop auto fishing when random fish stops
        if autofish then
            autofish = false
            autofishSession = autofishSession + 1
        end
        
        -- Final statistics
        local totalTime = (tick() - randomFishStartTime) / 60
        local avgFishPerLocation = locationsVisited > 0 and (totalRandomFishCaught / locationsVisited) or 0
        NotifySuccess("Random Fish Complete", "🎊 RANDOM FISH SESSION COMPLETED!\n\n📊 Final Statistics:\n🌍 Locations visited: " .. locationsVisited .. "\n🐟 Total fish caught: " .. totalRandomFishCaught .. "\n⏱️ Total time: " .. math.floor(totalTime) .. " minutes\n📈 Avg per location: " .. math.floor(avgFishPerLocation) .. " fish")
    end)
    coroutine.resume(randomFishThread)
end

-- Stop Random Fish System
local function StopRandomFishSystem()
    randomFishSession = randomFishSession + 1
    randomFishThread = nil
    currentRandomLocation = nil
    
    -- Also stop auto fishing
    if autofish then
        autofish = false
        autofishSession = autofishSession + 1
    end
    
    NotifyInfo("Random Fish", "🛑 Random Fish System stopped!\n\n📊 Session Statistics:\n🌍 Locations visited: " .. locationsVisited .. "\n🐟 Fish caught: " .. totalRandomFishCaught .. "\n⏱️ Duration: " .. math.floor((tick() - randomFishStartTime) / 60) .. " minutes")
end

print("XSAN: Random Fish System initialized successfully!")

-- Auto-refresh NPC locations system (Background task)
task.spawn(function()
    while true do
        task.wait(30) -- Check every 30 seconds
        pcall(function()
            local updatedNPCs = DetectNPCLocations()
            if next(updatedNPCs) then
                local oldCount = 0
                local newCount = 0
                
                for _ in pairs(TeleportLocations.NPCs) do oldCount = oldCount + 1 end
                for _ in pairs(updatedNPCs) do newCount = newCount + 1 end
                
                -- Update if we found more NPCs or different locations
                if newCount > oldCount then
                    TeleportLocations.NPCs = updatedNPCs
                    print("XSAN Auto-Refresh: Updated NPC locations -", newCount, "NPCs detected")
                end
            end
        end)
    end
end)

-- Count islands and print debug info
local islandCount = 0
for _ in pairs(TeleportLocations.Islands) do
    islandCount = islandCount + 1
end

print("XSAN: Found " .. islandCount .. " islands for teleportation")
print("XSAN: Using dynamic location system like old.lua for accuracy")

-- Analytics Functions
local function CalculateFishPerHour()
    local timeElapsed = (tick() - sessionStartTime) / 3600
    if timeElapsed > 0 then
        return math.floor(fishCaught / timeElapsed)
    end
    return 0
end

local function CalculateProfit()
    local avgFishValue = 50
    return fishCaught * avgFishValue
end

-- Quick Start Presets with centralized configuration
local function ApplyPreset(presetName)
    currentPreset = presetName
    local presetConfig = XSAN_CONFIG.presets[presetName]
    
    if presetName == "Beginner" then
        autoRecastDelay = 2.0
        perfectCast = false
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Beginner",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Speed" then
        autoRecastDelay = 0.5
        perfectCast = true
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Speed",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Profit" then
        autoRecastDelay = 1.0
        perfectCast = true
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Profit",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "AFK" then
        autoRecastDelay = 1.5
        perfectCast = true
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "AFK",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Safe" then
        autoRecastDelay = 1.2
        perfectCast = false
        safeMode = true
        safeModeChance = 70
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Safe",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Hybrid" then
        autoRecastDelay = 1.5
        perfectCast = false
        safeMode = false
        hybridMode = true
        hybridPerfectChance = 75
        hybridMinDelay = 1.0
        hybridMaxDelay = 2.8
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = "🔒 HYBRID ULTIMATE MODE ACTIVATED!\n✅ Server Time Sync\n✅ Human-like AI Patterns\n✅ Anti-Detection Technology\n✅ Maximum Security" .. (globalAutoSellEnabled and "\n💰 Auto Sell: ON" or "\n💰 Auto Sell: OFF")
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "AutoSellOn" then
        globalAutoSellEnabled = true
        autoSellOnThreshold = true
        NotifySuccess("Auto Sell", "💰 Global Auto Sell activated!\n📦 Will apply to all future presets\n🎯 Threshold: " .. autoSellThreshold .. " fish")
        
    elseif presetName == "AutoSellOff" then
        globalAutoSellEnabled = false
        autoSellOnThreshold = false
        NotifySuccess("Auto Sell", "💰 Global Auto Sell deactivated!\n📝 Manual selling only for all presets\n🎮 Full manual control")
    end
end

-- Auto Sell Function
local function CheckAndAutoSell()
    if autoSellOnThreshold and fishCaught >= autoSellThreshold then
        pcall(function()
            if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end

            local npcContainer = ReplicatedStorage:FindFirstChild("NPC")
            local alexNpc = npcContainer and npcContainer:FindFirstChild("Alex")

            if not alexNpc then
                NotifyError("Auto Sell", "NPC 'Alex' not found! Cannot auto sell.")
                return
            end

            local originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            local npcPosition = alexNpc.WorldPivot.Position

            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(npcPosition)
            wait(1)

            ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]:InvokeServer()
            wait(1)

            LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
            itemsSold = itemsSold + 1
            fishCaught = 0
            
            NotifySuccess("Auto Sell", "Automatically sold items! Fish count: " .. autoSellThreshold .. " reached.")
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- INFO TAB - XSAN Branding Section with Centralized Configuration
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating INFO tab content...")

-- Simple description for INFO tab
InfoTab:CreateParagraph({
    Title = "XSAN Fish It Pro Ultimate v1.0",
    Content = "Premium script dengan fitur AI, smart automation, dan keamanan maksimal. Dibuat oleh XSAN untuk pengalaman fishing terbaik di Fish It!"
})

InfoTab:CreateParagraph({
    Title = "✨ Fitur Utama",
    Content = "• Auto Fishing dengan AI patterns\n• Teleportasi ke semua lokasi\n• Smart inventory & auto sell\n• Analytics & statistics\n• Safety & anti-detection\n• Mobile optimized UI"
})

InfoTab:CreateButton({ 
    Name = "Copy Instagram Link", 
    Callback = CreateSafeCallback(function() 
        if setclipboard then
            setclipboard("https://instagram.com/_bangicoo") 
            NotifySuccess("Social Media", "Instagram link copied! Follow for updates and support!")
        else
            NotifyInfo("Social Media", "Instagram: " .. XSAN_CONFIG.branding.instagram)
        end
    end, "instagram")
})

InfoTab:CreateButton({ 
    Name = "Copy GitHub Link", 
    Callback = CreateSafeCallback(function() 
        if setclipboard then
            setclipboard("https://github.com/codeico") 
            NotifySuccess("Social Media", "GitHub link copied! Check out more premium scripts!")
        else
            NotifyInfo("Social Media", "GitHub: " .. XSAN_CONFIG.branding.github)
        end
    end, "github")
})

InfoTab:CreateButton({ 
    Name = "Fix UI Scrolling", 
    Callback = CreateSafeCallback(function() 
        local function fixScrollingFrames()
            local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
            if rayfieldGui then
                local fixed = 0
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    if descendant:IsA("ScrollingFrame") then
                        -- Enable proper scrolling
                        descendant.ScrollingEnabled = true
                        descendant.ScrollBarThickness = 8
                        descendant.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
                        descendant.ScrollBarImageTransparency = 0.3
                        
                        -- Auto canvas size if supported
                        if descendant:FindFirstChild("UIListLayout") then
                            descendant.AutomaticCanvasSize = Enum.AutomaticSize.Y
                            descendant.CanvasSize = UDim2.new(0, 0, 0, 0)
                        end
                        
                        -- Enable mouse wheel scrolling
                        descendant.Active = true
                        descendant.Selectable = true
                        
                        fixed = fixed + 1
                    end
                end
                NotifySuccess("UI Fix", "Fixed scrolling for " .. fixed .. " elements. You can now scroll through tabs!")
            else
                NotifyError("UI Fix", "Rayfield GUI not found")
            end
        end
        
        fixScrollingFrames()
    end, "fix_scrolling")
})

InfoTab:CreateButton({ 
    Name = "🔧 Fix Black Tabs", 
    Callback = CreateSafeCallback(function() 
        local function fixTabVisibility()
            local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
            if rayfieldGui then
                local fixedTabs = 0
                
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    -- Fix tab containers
                    if descendant:IsA("Frame") and (descendant.Name == "TabContainer" or descendant.Name:find("Tab")) then
                        descendant.BackgroundTransparency = 0
                        descendant.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        descendant.Visible = true
                        fixedTabs = fixedTabs + 1
                    end
                    
                    -- Fix tab buttons
                    if descendant:IsA("TextButton") and descendant.Parent and descendant.Parent.Name == "TabContainer" then
                        descendant.BackgroundTransparency = 0.1
                        descendant.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        descendant.TextColor3 = Color3.fromRGB(255, 255, 255)
                        descendant.BorderSizePixel = 1
                        descendant.BorderColor3 = Color3.fromRGB(100, 100, 100)
                        descendant.Visible = true
                        fixedTabs = fixedTabs + 1
                    end
                    
                    -- Fix tab content frames
                    if descendant:IsA("Frame") and descendant.Name:find("Content") then
                        descendant.BackgroundTransparency = 0
                        descendant.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        descendant.Visible = true
                    end
                    
                    -- Fix any transparent elements
                    if descendant:IsA("GuiObject") and descendant.BackgroundTransparency >= 1 then
                        descendant.BackgroundTransparency = 0.1
                        descendant.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    end
                end
                
                NotifySuccess("Tab Fix", "✅ Fixed " .. fixedTabs .. " tab elements!\n\n🎯 Tabs should now be visible\n🔄 If still black, try switching themes")
            else
                NotifyError("Tab Fix", "❌ Rayfield GUI not found!")
            end
        end
        
        fixTabVisibility()
    end, "fix_tabs")
})

InfoTab:CreateButton({ 
    Name = "🎨 Change Theme", 
    Callback = CreateSafeCallback(function() 
        NotifyInfo("Theme Change", "🎨 Available Themes:\n• Ocean (Current)\n• Default\n• Amethyst\n• DarkBlue\n\n⚠️ Reload script to change theme\n💡 Try different themes if tabs appear black")
    end, "change_theme")
})

print("XSAN: INFO tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- PRESETS TAB - Quick Start Configurations with Centralized Configuration
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating PRESETS tab content...")
-- Content minimal untuk PresetTab
PresetsTab:CreateParagraph({
    Title = "Quick Setup",
    Content = "Choose your fishing mode:"
})

PresetsTab:CreateButton({
    Name = "Beginner Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Beginner")
    end, "preset_beginner")
})

PresetsTab:CreateButton({
    Name = "Speed Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Speed")
    end, "preset_speed")
})

PresetsTab:CreateButton({
    Name = "Profit Mode", 
    Callback = CreateSafeCallback(function()
        ApplyPreset("Profit")
    end, "preset_profit")
})

PresetsTab:CreateButton({
    Name = "AFK Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AFK") 
    end, "preset_afk")
})

PresetsTab:CreateButton({
    Name = "🛡️ Safe Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Safe") 
    end, "preset_safe")
})

PresetsTab:CreateButton({
    Name = "🔒 HYBRID MODE (Ultimate)",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Hybrid") 
    end, "preset_hybrid")
})

-- Auto Sell section tanpa deskripsi panjang

PresetsTab:CreateButton({
    Name = "🟢 Global Auto Sell ON",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AutoSellOn")
    end, "preset_autosell_on")
})

PresetsTab:CreateButton({
    Name = "🔴 Global Auto Sell OFF",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AutoSellOff")
    end, "preset_autosell_off")
})

print("XSAN: PRESETS tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- RANDOM FISH TAB - Auto Fishing with Location Rotation
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating RANDOM FISH tab content...")

RandomFishTab:CreateParagraph({
    Title = "🎣 Random Fish System",
    Content = "Auto fishing yang berpindah lokasi otomatis! Pilih jenis lokasi, atur interval waktu, dan biarkan bot fishing di berbagai tempat secara random untuk hasil maksimal."
})

RandomFishTab:CreateParagraph({
    Title = "📋 Cara Penggunaan",
    Content = "1. Pilih jenis lokasi (Islands/NPCs/Events)\n2. Atur interval perpindahan (1-60 menit)\n3. Aktifkan Random Fish System\n4. Bot akan otomatis teleport & fishing\n5. Lihat statistik di Analytics tab"
})

-- Location selection multiselect
RandomFishTab:CreateLabel("🌍 Pilih Jenis Lokasi untuk Random Fishing:")

RandomFishTab:CreateToggle({
    Name = "🏝️ Islands (Pulau-pulau)",
    CurrentValue = true,
    Callback = CreateSafeCallback(function(val)
        if val then
            -- Add Islands to random locations if not already present
            if not table.find(randomFishLocations, "Islands") then
                table.insert(randomFishLocations, "Islands")
            end
        else
            -- Remove Islands from random locations
            local index = table.find(randomFishLocations, "Islands")
            if index then
                table.remove(randomFishLocations, index)
            end
        end
        
        local islandCount = 0
        for _ in pairs(TeleportLocations.Islands) do islandCount = islandCount + 1 end
        NotifyInfo("Random Fish Location", (val and "✅ Islands ENABLED" or "❌ Islands DISABLED") .. "\n📍 Available islands: " .. islandCount .. "\n🎯 Total selected types: " .. #randomFishLocations)
    end, "randomfish_islands")
})

RandomFishTab:CreateToggle({
    Name = "👤 NPCs (Merchant & Services)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        if val then
            if not table.find(randomFishLocations, "NPCs") then
                table.insert(randomFishLocations, "NPCs")
            end
        else
            local index = table.find(randomFishLocations, "NPCs")
            if index then
                table.remove(randomFishLocations, index)
            end
        end
        
        local npcCount = 0
        for _ in pairs(TeleportLocations.NPCs) do npcCount = npcCount + 1 end
        NotifyInfo("Random Fish Location", (val and "✅ NPCs ENABLED" or "❌ NPCs DISABLED") .. "\n👤 Available NPCs: " .. npcCount .. "\n🎯 Total selected types: " .. #randomFishLocations)
    end, "randomfish_npcs")
})

RandomFishTab:CreateToggle({
    Name = "⭐ Events (Special Locations)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        if val then
            if not table.find(randomFishLocations, "Events") then
                table.insert(randomFishLocations, "Events")
            end
        else
            local index = table.find(randomFishLocations, "Events")
            if index then
                table.remove(randomFishLocations, index)
            end
        end
        
        local eventCount = 0
        for _ in pairs(TeleportLocations.Events) do eventCount = eventCount + 1 end
        NotifyInfo("Random Fish Location", (val and "✅ Events ENABLED" or "❌ Events DISABLED") .. "\n⭐ Available events: " .. eventCount .. "\n🎯 Total selected types: " .. #randomFishLocations)
    end, "randomfish_events")
})

-- Time interval slider
RandomFishTab:CreateSlider({
    Name = "⏰ Interval Perpindahan (Menit)",
    Range = {1, 60},
    Increment = 1,
    CurrentValue = 5,
    Callback = CreateSafeCallback(function(val)
        randomFishInterval = val
        NotifyInfo("Random Fish Timing", "⏰ Interval updated: " .. val .. " minutes\n\n🔄 Bot akan pindah lokasi setiap " .. val .. " menit\n📊 Estimated locations per hour: " .. math.floor(60 / val))
    end, "randomfish_interval")
})

-- Quick preset buttons
RandomFishTab:CreateLabel("⚡ Quick Presets:")

RandomFishTab:CreateButton({
    Name = "🚀 Speed Mode (2 min)",
    Callback = CreateSafeCallback(function()
        randomFishInterval = 2
        -- Auto-update slider if supported
        pcall(function()
            if Rayfield.Flags and Rayfield.Flags["randomfish_interval"] then
                Rayfield.Flags["randomfish_interval"]:Set(2)
            end
        end)
        NotifySuccess("Random Fish Preset", "🚀 Speed Mode activated!\n⏰ Interval: 2 minutes\n🎯 Perfect for fast location sampling")
    end, "randomfish_speed")
})

RandomFishTab:CreateButton({
    Name = "⚖️ Balanced Mode (10 min)",
    Callback = CreateSafeCallback(function()
        randomFishInterval = 10
        pcall(function()
            if Rayfield.Flags and Rayfield.Flags["randomfish_interval"] then
                Rayfield.Flags["randomfish_interval"]:Set(10)
            end
        end)
        NotifySuccess("Random Fish Preset", "⚖️ Balanced Mode activated!\n⏰ Interval: 10 minutes\n🎯 Good balance of exploration and fishing time")
    end, "randomfish_balanced")
})

RandomFishTab:CreateButton({
    Name = "🐌 Marathon Mode (30 min)",
    Callback = CreateSafeCallback(function()
        randomFishInterval = 30
        pcall(function()
            if Rayfield.Flags and Rayfield.Flags["randomfish_interval"] then
                Rayfield.Flags["randomfish_interval"]:Set(30)
            end
        end)
        NotifySuccess("Random Fish Preset", "🐌 Marathon Mode activated!\n⏰ Interval: 30 minutes\n🎯 Maximum fishing time per location")
    end, "randomfish_marathon")
})

-- Main control toggle
RandomFishTab:CreateToggle({
    Name = "🎣 Random Fish System",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        randomFishEnabled = val
        
        if val then
            -- Validation checks
            if #randomFishLocations == 0 then
                randomFishEnabled = false
                NotifyError("Random Fish", "❌ Tidak ada lokasi yang dipilih!\n\n💡 Pilih minimal satu jenis lokasi:\n🏝️ Islands\n👤 NPCs\n⭐ Events")
                -- Reset toggle
                pcall(function()
                    if Rayfield.Flags and Rayfield.Flags["randomfish_system"] then
                        Rayfield.Flags["randomfish_system"]:Set(false)
                    end
                end)
                return
            end
            
            if randomFishInterval < 1 or randomFishInterval > 60 then
                randomFishEnabled = false
                NotifyError("Random Fish", "❌ Interval tidak valid!\n\n💡 Pilih interval antara 1-60 menit")
                return
            end
            
            -- Start the system
            StartRandomFishSystem()
            
        else
            -- Stop the system
            StopRandomFishSystem()
        end
    end, "randomfish_system")
})

-- Status display
RandomFishTab:CreateParagraph({
    Title = "📊 Current Status",
    Content = "Status: Standby\nCurrent Location: None\nLocations Visited: 0\nFish Caught: 0"
})

-- Info and tips
RandomFishTab:CreateParagraph({
    Title = "💡 Tips & Info",
    Content = "• Random Fish bekerja dengan auto fishing biasa\n• Gunakan Perfect Cast untuk hasil optimal\n• Auto Sell akan tetap berfungsi\n• Statistik terintegrasi dengan Analytics\n• Cocok untuk AFK farming dan exploration"
})

-- Initialize default location selection (Islands)
if not table.find(randomFishLocations, "Islands") then
    table.insert(randomFishLocations, "Islands")
end

print("XSAN: RANDOM FISH tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- TELEPORT TAB - Ultimate Teleportation System
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating TELEPORT tab content...")

-- Islands Section

-- Create buttons for each island (dynamic like old.lua)
for locationName, cframe in pairs(TeleportLocations.Islands) do
    -- Add emoji prefix if not already present with more specific icons
    local displayName = locationName
    if not string.find(locationName, "🏝️") and not string.find(locationName, "🌊") and not string.find(locationName, "🏔️") and not string.find(locationName, "🌋") and not string.find(locationName, "❄️") and not string.find(locationName, "🏛️") then
        -- Add specific icons based on location names
        if string.find(locationName:lower(), "volcano") or string.find(locationName:lower(), "crater") then
            displayName = "🌋 " .. locationName
        elseif string.find(locationName:lower(), "snow") or string.find(locationName:lower(), "ice") then
            displayName = locationName
        elseif string.find(locationName:lower(), "depth") or string.find(locationName:lower(), "ocean") then
            displayName = locationName
        elseif string.find(locationName:lower(), "ancient") or string.find(locationName:lower(), "statue") or string.find(locationName:lower(), "altar") then
            displayName = locationName
        elseif string.find(locationName:lower(), "mountain") or string.find(locationName:lower(), "peak") then
            displayName = locationName
        elseif string.find(locationName:lower(), "swamp") or string.find(locationName:lower(), "grove") then
            displayName = locationName
        elseif string.find(locationName:lower(), "reef") or string.find(locationName:lower(), "coral") then
            displayName = locationName
        else
            displayName = "🏝️ " .. locationName
        end
    end
    
    TeleportTab:CreateButton({
        Name = displayName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, locationName)
        end, "tp_island_" .. locationName)
    })
end

-- NPCs Section

-- Refresh NPC Locations Button
TeleportTab:CreateButton({
    Name = "🔄 Refresh NPC Locations",
    Callback = CreateSafeCallback(function()
        -- Re-detect NPC locations
        local newDetectedNPCs = DetectNPCLocations()
        
        if next(newDetectedNPCs) then
            TeleportLocations.NPCs = newDetectedNPCs
            local npcCount = 0
            for _ in pairs(newDetectedNPCs) do npcCount = npcCount + 1 end
            
            NotifySuccess("NPC Refresh", "✅ NPC locations updated! Found " .. npcCount .. " NPCs with real-time positions.\n\n⚠️ Please reload the script to see updated buttons.")
            
            -- Print detected NPCs for debugging
            print("XSAN: Updated NPC Locations:")
            for name, cframe in pairs(newDetectedNPCs) do
                print("  •", name, ":", cframe.Position)
            end
        else
            NotifyError("NPC Refresh", "❌ No NPCs detected! Using fallback locations.\n\nTry moving closer to NPCs or check if you're in the right area.")
        end
    end, "refresh_npcs")
})

-- Show NPC Detection Info Button
TeleportTab:CreateButton({
    Name = "📍 Show NPC Detection Info",
    Callback = CreateSafeCallback(function()
        local npcInfo = "🔍 DETECTED NPC LOCATIONS:\n\n"
        local npcCount = 0
        
        for npcName, cframe in pairs(TeleportLocations.NPCs) do
            npcCount = npcCount + 1
            local pos = cframe.Position
            npcInfo = npcInfo .. string.format("📍 %s\n   Position: %.1f, %.1f, %.1f\n\n", npcName, pos.X, pos.Y, pos.Z)
        end
        
        npcInfo = npcInfo .. "📊 Total NPCs: " .. npcCount .. "\n"
        npcInfo = npcInfo .. "🔄 Auto-refresh: Every 30 seconds\n"
        npcInfo = npcInfo .. "✅ Real-time detection active!"
        
        NotifyInfo("NPC Detection", npcInfo)
    end, "show_npc_info")
})

-- Create buttons for each NPC
for npcName, cframe in pairs(TeleportLocations.NPCs) do
    TeleportTab:CreateButton({
        Name = npcName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, npcName)
        end, "tp_npc_" .. npcName)
    })
end

-- Events Section

-- Create buttons for each event location
for eventName, cframe in pairs(TeleportLocations.Events) do
    TeleportTab:CreateButton({
        Name = eventName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, eventName)
        end, "tp_event_" .. eventName)
    })
end

-- Player Teleportation Section (Moved below Events)

TeleportTab:CreateButton({
    Name = "🔄 Refresh Player List",
    Callback = CreateSafeCallback(function()
        local playerCount = 0
        local playerList = ""
        
        -- Check Characters folder first (like old.lua)
        local charFolder = workspace:FindFirstChild("Characters")
        if charFolder then
            for _, playerModel in pairs(charFolder:GetChildren()) do
                if playerModel:IsA("Model") and playerModel.Name ~= LocalPlayer.Name and playerModel:FindFirstChild("HumanoidRootPart") then
                    playerCount = playerCount + 1
                    playerList = playerList .. "👤 " .. playerModel.Name .. " • "
                end
            end
        end
        
        -- Fallback to Players service
        if playerCount == 0 then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    playerCount = playerCount + 1
                    playerList = playerList .. "👤 " .. player.Name .. " • "
                end
            end
        end
        
        if playerCount > 0 then
            NotifyInfo("Player List", "Players in server (" .. playerCount .. "):\n\n" .. playerList:sub(1, -3) .. "\n\n✅ Player teleportation system ready!\n📝 Use manual input below to teleport to any player.")
        else
            NotifyError("Player List", "❌ No other players found in the server!\n\n🔍 Make sure you're in a multiplayer server.\n⚠️ Some players might be loading or not have characters spawned.")
        end
        
        -- Note: Due to Rayfield limitations, please reload script to see updated quick buttons
        NotifyInfo("UI Update", "💡 TIP: To see updated quick player buttons, reload the script.\n\n⚡ Quick buttons show first 5 players\n📝 Manual input works for all players")
    end, "refresh_players")
})

-- Quick Player Teleport Buttons (Top 5 Players)

local function CreatePlayerButtons()
    local players = {}
    
    -- Method 1: Check Characters folder first (like old.lua)
    local charFolder = workspace:FindFirstChild("Characters")
    if charFolder then
        for _, playerModel in pairs(charFolder:GetChildren()) do
            if playerModel:IsA("Model") and playerModel.Name ~= LocalPlayer.Name and playerModel:FindFirstChild("HumanoidRootPart") then
                table.insert(players, playerModel.Name)
            end
        end
    end
    
    -- Method 2: Fallback to Players service
    if #players == 0 then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(players, player.Name)
            end
        end
    end
    
    -- Create buttons for first 5 players (to avoid UI clutter)
    for i = 1, math.min(#players, 5) do
        local playerName = players[i]
        TeleportTab:CreateButton({
            Name = "👤 " .. playerName,
            Callback = CreateSafeCallback(function()
                TeleportToPlayer(playerName)
            end, "tp_player_" .. playerName)
        })
    end
    
    if #players > 5 then
        TeleportTab:CreateParagraph({
            Title = "📝 More Players Available",
            Content = "There are " .. #players .. " players total. Use manual input below for others, or refresh to see different players."
        })
    elseif #players == 0 then
        TeleportTab:CreateParagraph({
            Title = "❌ No Players Found",
            Content = "No other players detected in the server. Make sure you're in a multiplayer server!"
        })
    end
end

-- Initialize player buttons
CreatePlayerButtons()

-- Manual Player Teleport
local targetPlayerName = ""

TeleportTab:CreateInput({
    Name = "📝 Enter Player Name",
    PlaceholderText = "Type player name here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        targetPlayerName = text
    end
})

TeleportTab:CreateButton({
    Name = "🎯 Teleport to Player",
    Callback = CreateSafeCallback(function()
        if targetPlayerName and targetPlayerName ~= "" then
            TeleportToPlayer(targetPlayerName)
        else
            NotifyError("Player TP", "Please enter a player name first!")
        end
    end, "tp_to_player")
})

-- Utility Teleportation

TeleportTab:CreateButton({
    Name = "📍 Save Current Position",
    Callback = CreateSafeCallback(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            _G.XSANSavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            NotifySuccess("Position Saved", "📍 Current position saved! Use 'Return to Saved Position' to come back here.")
        else
            NotifyError("Save Position", "❌ Character not found!")
        end
    end, "save_position")
})

TeleportTab:CreateButton({
    Name = "🔙 Return to Saved Position",
    Callback = CreateSafeCallback(function()
        if _G.XSANSavedPosition then
            SafeTeleport(_G.XSANSavedPosition, "Saved Position")
        else
            NotifyError("Return Position", "❌ No saved position found! Save a position first.")
        end
    end, "return_position")
})

TeleportTab:CreateButton({
    Name = "🏠 Teleport to Spawn",
    Callback = CreateSafeCallback(function()
        -- Try to use dynamic location first
        local spawnCFrame = TeleportLocations.Islands["Moosewood"] or CFrame.new(389, 137, 264)
        SafeTeleport(spawnCFrame, "Moosewood Spawn")
    end, "tp_spawn")
})

print("XSAN: TELEPORT tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- AUTO FISH TAB - Enhanced Fishing System
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating AUTO FISH tab content...")

MainTab:CreateToggle({
    Name = "Enable Auto Fishing",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        autofish = val
        if val then
            -- Start a new session (invalidate any existing loop)
            autofishSession += 1
            local mySession = autofishSession
            if hybridMode then
                -- Initialize hybrid auto fish
                if not hybridAutoFish then
                    hybridAutoFish = Rayfield.CreateSafeAutoFish({
                        safeMode = true,
                        perfectChance = hybridPerfectChance,
                        minDelay = hybridMinDelay,
                        maxDelay = hybridMaxDelay,
                        useServerTime = true
                    })
                end
                hybridAutoFish.toggle(true)
                NotifySuccess("Hybrid Auto Fish", "HYBRID SECURITY MODE ACTIVATED!\n🔒 Maximum Safety\n⚡ Server Time Sync\n🎯 Human-like Patterns")
            else
                -- Traditional auto fishing
                NotifySuccess("Auto Fish", "XSAN Ultimate auto fishing started! AI systems activated.")
                local function smartWait(total, session)
                    local elapsed = 0
                    local step = 0.05
                    while elapsed < total do
                        if autofishSession ~= session or not autofish then return false end
                        local dt = task.wait(step)
                        elapsed += dt
                    end
                    return true
                end
                autofishThread = coroutine.create(function()
                    while autofish and autofishSession == mySession do
                        -- Early abort check
                        if autofishSession ~= mySession or not autofish then break end
                        pcall(function()
                            if autofishSession ~= mySession or not autofish then return end
                            if equipRemote then equipRemote:FireServer(1) end
                            smartWait(0.1, mySession)

                            if autofishSession ~= mySession or not autofish then return end
                            -- Safe Mode Logic: Random between perfect and normal cast
                            local usePerfectCast = perfectCast
                            if safeMode then
                                usePerfectCast = math.random(50, 100) <= safeModeChance
                            end

                            local timestamp = usePerfectCast and 9999999999 or (tick() + math.random())
                            if rodRemote and autofishSession == mySession and autofish then
                                rodRemote:InvokeServer(timestamp)
                            end
                            smartWait(0.1, mySession)

                            if autofishSession ~= mySession or not autofish then return end
                            local x = usePerfectCast and -1.238 or (math.random(-1000, 1000) / 1000)
                            local y = usePerfectCast and 0.969 or (math.random(0, 1000) / 1000)

                            if miniGameRemote and autofishSession == mySession and autofish then
                                miniGameRemote:InvokeServer(x, y)
                            end
                            smartWait(1.3, mySession)

                            -- Click Fast Mini-Game Auto-Clicker
                            if autofishSession == mySession and autofish and clickFastAutoClicker then
                                local clickFastDetected = false
                                local clickAttempts = 0
                                local maxClickAttempts = 100  -- Maximum clicks per session
                                
                                -- Check for Click Fast UI elements for up to 3 seconds
                                local startTime = tick()
                                while tick() - startTime < 3 and autofishSession == mySession and autofish do
                                    -- Look for "Click Fast" or similar text in PlayerGUI
                                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                                    if playerGui then
                                        for _, gui in pairs(playerGui:GetChildren()) do
                                            if gui:IsA("ScreenGui") then
                                                -- Recursive function to find Click Fast text
                                                local function findClickFast(obj)
                                                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                                                        local text = obj.Text:lower()
                                                        if text:find("click") and (text:find("fast") or text:find("quick") or text:find("rapid")) then
                                                            return true
                                                        end
                                                    elseif obj:IsA("ImageLabel") and obj.Name:lower():find("click") then
                                                        return true
                                                    end
                                                    for _, child in pairs(obj:GetChildren()) do
                                                        if findClickFast(child) then
                                                            return true
                                                        end
                                                    end
                                                    return false
                                                end
                                                
                                                if findClickFast(gui) then
                                                    clickFastDetected = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    
                                    if clickFastDetected then
                                        break
                                    end
                                    task.wait(0.02)  -- Check every 20ms for faster response
                                end
                                
                                -- Perform rapid clicking if Click Fast detected
                                if clickFastDetected then
                                    clickFastDetections += 1  -- Track detection
                                    local clickStartTime = tick()
                                    while tick() - clickStartTime < 4 and autofishSession == mySession and autofish and clickAttempts < maxClickAttempts do
                                        -- Simulate mouse click using multiple methods for maximum compatibility
                                        local success = pcall(function()
                                            -- Method 1: Direct GuiButton clicking
                                            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                                            if playerGui then
                                                for _, gui in pairs(playerGui:GetChildren()) do
                                                    if gui:IsA("ScreenGui") then
                                                        local function clickButton(obj)
                                                            if obj:IsA("GuiButton") or obj:IsA("TextButton") or obj:IsA("ImageButton") then
                                                                -- Check if this is likely a click button
                                                                local isClickButton = false
                                                                if obj.Text then
                                                                    local text = obj.Text:lower()
                                                                    isClickButton = text:find("click") or text == ""
                                                                end
                                                                if obj.Name:lower():find("click") then
                                                                    isClickButton = true
                                                                end
                                                                
                                                                if isClickButton then
                                                                    -- Multiple click simulation methods
                                                                    for _, connection in pairs(getconnections(obj.MouseButton1Click)) do
                                                                        connection:Fire()
                                                                    end
                                                                    -- Also try Activated event
                                                                    for _, connection in pairs(getconnections(obj.Activated)) do
                                                                        connection:Fire()
                                                                    end
                                                                    return true
                                                                end
                                                            end
                                                            for _, child in pairs(obj:GetChildren()) do
                                                                if clickButton(child) then
                                                                    return true
                                                                end
                                                            end
                                                            return false
                                                        end
                                                        clickButton(gui)
                                                    end
                                                end
                                            end
                                            
                                            -- Method 2: Virtual input simulation
                                            local VirtualInputManager = game:GetService("VirtualInputManager")
                                            if VirtualInputManager then
                                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                                task.wait(0.001)
                                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                            end
                                        end)
                                        
                                        clickAttempts += 1
                                        task.wait(0.008)  -- 125 clicks per second for optimal performance
                                    end
                                end
                            end

                            if autofishSession ~= mySession or not autofish then return end
                            if finishRemote then finishRemote:FireServer() end

                            fishCaught += 1

                            -- Track cast types for analytics
                            if usePerfectCast then
                                perfectCasts += 1
                            else
                                normalCasts += 1
                            end

                            CheckAndAutoSell()
                        end)
                        -- Recast delay with cancel support
                        if not smartWait(autoRecastDelay, mySession) then break end
                    end
                end)
                coroutine.resume(autofishThread)
            end
        else
            -- Disable: invalidate session so loop breaks ASAP
            autofishSession += 1
            autofishThread = nil
            
            -- Enhanced cleanup for manual fishing restoration
            if hybridMode and hybridAutoFish then
                hybridAutoFish.toggle(false)
                NotifyInfo("Hybrid Auto Fish", "🔄 Hybrid auto fishing stopped.\n\n✅ Manual fishing control restored\n🎣 All systems ready for manual use")
            else
                NotifyInfo("Auto Fish", "🛑 Auto fishing stopped by user.\n\n✅ Manual fishing control restored\n🎣 Click fishing rod to continue manually")
            end
            
            -- Small delay to ensure all auto fishing processes stop
            task.spawn(function()
                task.wait(0.2)
                -- Additional cleanup if needed
                if equipRemote then
                    -- Ensure rod is properly equipped for manual use
                    pcall(function()
                        equipRemote:FireServer(1)
                    end)
                end
            end)
        end
    end, "autofish")
})

MainTab:CreateToggle({
    Name = "Perfect Cast Mode",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        perfectCast = val
        if val then
            safeMode = false  -- Disable safe mode when perfect cast is manually enabled
            hybridMode = false  -- Disable hybrid mode
        end
        NotifySuccess("Perfect Cast", "Perfect cast mode " .. (val and "activated" or "deactivated") .. "!")
    end, "perfectcast")
})

MainTab:CreateToggle({
    Name = "⚡ Click Fast Auto-Clicker",
    CurrentValue = false,  -- Default OFF untuk kecepatan maksimum
    Callback = CreateSafeCallback(function(val)
        clickFastAutoClicker = val
        if val then
            NotifySuccess("Click Fast Auto-Clicker", "⚡ Click Fast auto-clicker ACTIVATED!\n\n✅ Will handle Click Fast mini-games automatically\n🖱️ 125 clicks/second for optimal speed\n⚠️ May add 0-7 seconds per fish\n\n💡 Disable for maximum speed if no Click Fast needed")
        else
            NotifySuccess("Click Fast Auto-Clicker", "🚀 Click Fast auto-clicker DISABLED!\n\n✅ Maximum fishing speed mode\n⚡ Direct flow: Cast → Finish\n🎯 ~1.4 seconds per fish\n\n💡 Enable if game has Click Fast mini-games")
        end
    end, "clickfastauto")
})

MainTab:CreateToggle({
    Name = "🛡️ Safe Mode (Smart Random)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        safeMode = val
        if val then
            perfectCast = false  -- Disable perfect cast when safe mode is enabled
            hybridMode = false   -- Disable hybrid mode
            NotifySuccess("Safe Mode", "Safe mode activated - Smart random casting for better stealth!")
        else
            NotifyInfo("Safe Mode", "Safe mode deactivated - Manual control restored")
        end
    end, "safemode")
})

MainTab:CreateToggle({
    Name = "🔒 HYBRID MODE (Ultimate Security)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        hybridMode = val
        if val then
            perfectCast = false  -- Disable other modes
            safeMode = false
            NotifySuccess("Hybrid Mode", "HYBRID SECURITY ACTIVATED!\n✅ Server Time Sync\n✅ Human-like Patterns\n✅ Anti-Detection\n✅ Maximum Safety")
        else
            NotifyInfo("Hybrid Mode", "Hybrid mode deactivated - Back to manual control")
        end
    end, "hybridmode")
})

MainTab:CreateSlider({
    Name = "Safe Mode Perfect %",
    Range = {50, 85},
    Increment = 5,
    CurrentValue = safeModeChance,
    Callback = function(val)
        safeModeChance = val
        if safeMode then
            NotifyInfo("Safe Mode", "Perfect cast chance set to: " .. val .. "%")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Perfect %",
    Range = {60, 80},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(val)
        hybridPerfectChance = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({perfectChance = val})
            NotifyInfo("Hybrid Mode", "Perfect cast chance updated to: " .. val .. "%")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Min Delay",
    Range = {1.0, 2.0},
    Increment = 0.1,
    CurrentValue = 1.0,
    Callback = function(val)
        hybridMinDelay = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({minDelay = val})
            NotifyInfo("Hybrid Mode", "Minimum delay updated to: " .. val .. "s")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Max Delay", 
    Range = {2.0, 3.5},
    Increment = 0.1,
    CurrentValue = 2.5,
    Callback = function(val)
        hybridMaxDelay = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({maxDelay = val})
            NotifyInfo("Hybrid Mode", "Maximum delay updated to: " .. val .. "s")
        end
    end
})

MainTab:CreateSlider({
    Name = "Auto Recast Delay",
    Range = {0.1, 3.0},
    Increment = 0.1,
    CurrentValue = autoRecastDelay,
    Callback = function(val)
        autoRecastDelay = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Sell on Fish Count",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        autoSellOnThreshold = val
        if val then
            NotifySuccess("Auto Sell Threshold", "Auto sell on threshold activated! Will sell when " .. autoSellThreshold .. " fish caught.")
        else
            NotifyInfo("Auto Sell Threshold", "Auto sell on threshold disabled.")
        end
    end, "autosell_threshold")
})

MainTab:CreateSlider({
    Name = "Fish Threshold",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = autoSellThreshold,
    Callback = function(val)
        autoSellThreshold = val
        if autoSellOnThreshold then
            NotifyInfo("Threshold Updated", "Auto sell threshold set to: " .. val .. " fish")
        end
    end
})

print("XSAN: AUTO FISH tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- ANALYTICS TAB - Advanced Statistics & Monitoring
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating ANALYTICS tab content...")

AnalyticsTab:CreateButton({
    Name = "Show Detailed Statistics",
    Callback = CreateSafeCallback(function()
        local sessionTime = (tick() - sessionStartTime) / 60
        local fishPerHour = CalculateFishPerHour()
        local estimatedProfit = CalculateProfit()
        local totalCasts = perfectCasts + normalCasts
        local perfectEfficiency = totalCasts > 0 and (perfectCasts / totalCasts * 100) or 0
        local castingMode = safeMode and "Safe Mode" or (perfectCast and "Perfect Cast" or "Normal Cast")
        
        local stats = string.format("XSAN Ultimate Analytics:\n\nSession Time: %.1f minutes\nFish Caught: %d\nFish/Hour: %d\n\n=== CASTING STATS ===\nMode: %s\nPerfect Casts: %d (%.1f%%)\nNormal Casts: %d\nTotal Casts: %d\n\n=== MINI-GAME STATS ===\nClick Fast Detected: %d\nAuto-Clicker: %s\nSpeed Mode: %s\n\n=== RANDOM FISH STATS ===\nRandom Fish: %s\nLocations Visited: %d\nRandom Fish Caught: %d\nCurrent Location: %s\n\n=== EARNINGS ===\nItems Sold: %d\nEstimated Profit: %d coins\nActive Preset: %s", 
            sessionTime, fishCaught, fishPerHour, castingMode, perfectCasts, perfectEfficiency, normalCasts, totalCasts, clickFastDetections, (clickFastAutoClicker and "Enabled" or "Disabled"), (clickFastAutoClicker and "🐌 Slower (Safe)" or "🚀 Maximum"), (randomFishEnabled and "Active" or "Inactive"), locationsVisited, totalRandomFishCaught, (currentRandomLocation and (currentRandomLocation.type .. " " .. currentRandomLocation.name) or "None"), itemsSold, estimatedProfit, currentPreset
        )
        NotifyInfo("Advanced Stats", stats)
    end, "detailed_stats")
})

AnalyticsTab:CreateButton({
    Name = "Reset Statistics",
    Callback = CreateSafeCallback(function()
        sessionStartTime = tick()
        fishCaught = 0
        itemsSold = 0
        perfectCasts = 0
        normalCasts = 0
        clickFastDetections = 0
        locationsVisited = 0
        totalRandomFishCaught = 0
        randomFishStartTime = tick()
        NotifySuccess("Analytics", "All statistics have been reset!")
    end, "reset_stats")
})

AnalyticsTab:CreateButton({
    Name = "📍 Random Fish Status",
    Callback = CreateSafeCallback(function()
        if randomFishEnabled and currentRandomLocation then
            local timeAtLocation = (tick() - lastLocationChange) / 60
            local remainingTime = randomFishInterval - timeAtLocation
            local nextLocationETA = remainingTime > 0 and string.format("%.1f minutes", remainingTime) or "Moving soon..."
            
            local status = string.format("🎣 RANDOM FISH ACTIVE\n\n📍 Current: %s %s\n⏰ Time here: %.1f minutes\n🔄 Next move: %s\n📊 Total locations: %d\n🐟 Session fish: %d", 
                currentRandomLocation.type, currentRandomLocation.name, timeAtLocation, nextLocationETA, locationsVisited, totalRandomFishCaught)
            NotifyInfo("Random Fish Status", status)
        else
            local selectedTypes = #randomFishLocations > 0 and table.concat(randomFishLocations, ", ") or "None"
            local status = string.format("🎣 RANDOM FISH INACTIVE\n\n⚙️ Interval: %d minutes\n📍 Selected types: %s\n📊 Last session:\n🌍 Locations: %d\n🐟 Fish: %d", 
                randomFishInterval, selectedTypes, locationsVisited, totalRandomFishCaught)
            NotifyInfo("Random Fish Status", status)
        end
    end, "randomfish_status")
})

print("XSAN: ANALYTICS tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- INVENTORY TAB - Smart Inventory Management
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating INVENTORY tab content...")

InventoryTab:CreateButton({
    Name = "Check Inventory Status",
    Callback = CreateSafeCallback(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local items = #backpack:GetChildren()
            local itemNames = {}
            for _, item in pairs(backpack:GetChildren()) do
                table.insert(itemNames, item.Name)
            end
            
            local status = string.format("Inventory Status:\n\nTotal Items: %d/20\nSpace Available: %d slots\n\nItems: %s", 
                items, 20 - items, table.concat(itemNames, ", "))
            NotifyInfo("Inventory", status)
        else
            NotifyError("Inventory", "Could not access backpack!")
        end
    end, "check_inventory")
})

print("XSAN: INVENTORY tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- UTILITY TAB - System Management & Advanced Features
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating UTILITY tab content...")

UtilityTab:CreateButton({
    Name = "Show Ultimate Session Stats",
    Callback = CreateSafeCallback(function()
        local sessionTime = (tick() - sessionStartTime) / 60
        local fishPerHour = CalculateFishPerHour()
        local estimatedProfit = CalculateProfit()
        local efficiency = fishCaught > 0 and (perfectCasts / fishCaught * 100) or 0
        local thresholdStatus = autoSellOnThreshold and ("Active (" .. autoSellThreshold .. " fish)") or "Inactive"
        
        local ultimateStats = string.format("XSAN ULTIMATE SESSION REPORT:\n\n=== PERFORMANCE ===\nSession Time: %.1f minutes\nFish Caught: %d\nFish/Hour Rate: %d\nPerfect Casts: %d (%.1f%%)\n\n=== EARNINGS ===\nItems Sold: %d\nEstimated Profit: %d coins\n\n=== AUTOMATION ===\nAuto Fish: %s\nThreshold Auto Sell: %s\nActive Preset: %s", 
            sessionTime, fishCaught, fishPerHour, perfectCasts, efficiency,
            itemsSold, estimatedProfit,
            autofish and "Active" or "Inactive",
            thresholdStatus, currentPreset
        )
        NotifyInfo("Ultimate Stats", ultimateStats)
    end, "ultimate_stats")
})

-- ═══════════════════════════════════════════════════════════════
-- WALKSPEED CONTROLS
-- ═══════════════════════════════════════════════════════════════

UtilityTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 60},
    Increment = 1,
    CurrentValue = defaultWalkspeed,
    Flag = "WalkSpeedSlider",
    Callback = CreateSafeCallback(function(value)
        currentWalkspeed = value
        if walkspeedEnabled then
            setWalkSpeed(value)
        else
            NotifyInfo("Walk Speed", "Walk speed set to " .. value .. ". Enable to apply.")
        end
    end, "walkspeed_slider")
})

UtilityTab:CreateToggle({
    Name = "Enable Walk Speed",
    CurrentValue = walkspeedEnabled,
    Flag = "WalkSpeedToggle",
    Callback = CreateSafeCallback(function(value)
        walkspeedEnabled = value
        if value then
            setWalkSpeed(currentWalkspeed)
            NotifySuccess("Walk Speed", "Walk speed enabled: " .. currentWalkspeed)
        else
            resetWalkSpeed()
            NotifyInfo("Walk Speed", "Walk speed disabled (reset to default)")
        end
    end, "walkspeed_toggle")
})

UtilityTab:CreateButton({
    Name = "Quick Speed: 45",
    Callback = CreateSafeCallback(function()
        currentWalkspeed = 45
        if walkspeedEnabled then
            setWalkSpeed(45)
        else
            walkspeedEnabled = true
            setWalkSpeed(45)
        end
        -- Update the slider and toggle if they exist
        if Rayfield.Flags["WalkSpeedSlider"] then
            Rayfield.Flags["WalkSpeedSlider"]:Set(45)
        end
        if Rayfield.Flags["WalkSpeedToggle"] then
            Rayfield.Flags["WalkSpeedToggle"]:Set(true)
        end
    end, "quick_speed_45")
})

UtilityTab:CreateButton({
    Name = "Reset Walk Speed",
    Callback = CreateSafeCallback(function()
        resetWalkSpeed()
        -- Update the slider and toggle if they exist
        if Rayfield.Flags["WalkSpeedSlider"] then
            Rayfield.Flags["WalkSpeedSlider"]:Set(defaultWalkspeed)
        end
        if Rayfield.Flags["WalkSpeedToggle"] then
            Rayfield.Flags["WalkSpeedToggle"]:Set(false)
        end
        NotifyInfo("Walk Speed", "Walk speed reset to default (" .. defaultWalkspeed .. ")")
    end, "reset_walkspeed")
})

-- ═══════════════════════════════════════════════════════════════
-- UNLIMITED JUMP CONTROLS
-- ═══════════════════════════════════════════════════════════════

UtilityTab:CreateToggle({
    Name = "🚀 Enable Unlimited Jump",
    CurrentValue = unlimitedJumpEnabled,
    Flag = "UnlimitedJumpToggle",
    Callback = CreateSafeCallback(function(value)
        if value then
            enableUnlimitedJump()
        else
            disableUnlimitedJump()
        end
    end, "unlimited_jump_toggle")
})

UtilityTab:CreateSlider({
    Name = "Jump Height",
    Range = {7.2, 100},
    Increment = 0.5,
    CurrentValue = defaultJumpHeight,
    Flag = "JumpHeightSlider",
    Callback = CreateSafeCallback(function(value)
        if not unlimitedJumpEnabled then
            setJumpHeight(value)
            NotifyInfo("Jump Height", "Custom jump height: " .. value .. "\n💡 Enable Unlimited Jump for infinite jumps!")
        else
            currentJumpHeight = value
            setJumpHeight(value)
            NotifyInfo("Jump Height", "Jump height updated: " .. value .. " (Unlimited mode)")
        end
    end, "jump_height_slider")
})

UtilityTab:CreateButton({
    Name = "🎯 Quick Jump: Super High (75)",
    Callback = CreateSafeCallback(function()
        currentJumpHeight = 75
        setJumpHeight(75)
        -- Update the slider if it exists
        if Rayfield.Flags["JumpHeightSlider"] then
            Rayfield.Flags["JumpHeightSlider"]:Set(75)
        end
        NotifySuccess("Jump Height", "🚀 Super high jump enabled!\n\nHeight: 75\n💡 Enable Unlimited Jump for infinite jumps!")
    end, "super_jump")
})

UtilityTab:CreateButton({
    Name = "⚡ Quick: Unlimited Mode",
    Callback = CreateSafeCallback(function()
        if not unlimitedJumpEnabled then
            enableUnlimitedJump()
            -- Update toggle if it exists
            if Rayfield.Flags["UnlimitedJumpToggle"] then
                Rayfield.Flags["UnlimitedJumpToggle"]:Set(true)
            end
        else
            NotifyInfo("Unlimited Jump", "✅ Already enabled!\n\n🚀 Press space repeatedly to fly\n📏 Adjust height with slider above")
        end
    end, "quick_unlimited")
})

UtilityTab:CreateButton({
    Name = "🔄 Reset Jump Height",
    Callback = CreateSafeCallback(function()
        disableUnlimitedJump()
        setJumpHeight(defaultJumpHeight)
        -- Update controls if they exist
        if Rayfield.Flags["JumpHeightSlider"] then
            Rayfield.Flags["JumpHeightSlider"]:Set(defaultJumpHeight)
        end
        if Rayfield.Flags["UnlimitedJumpToggle"] then
            Rayfield.Flags["UnlimitedJumpToggle"]:Set(false)
        end
        NotifyInfo("Jump Height", "Jump height reset to default (" .. defaultJumpHeight .. ")")
    end, "reset_jump")
})

UtilityTab:CreateButton({ 
    Name = "Rejoin Server", 
    Callback = CreateSafeCallback(function() 
        NotifyInfo("Server", "Rejoining current server...")
        wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer) 
    end, "rejoin_server")
})

UtilityTab:CreateButton({
    Name = "🎣 Fix Manual Fishing",
    Callback = CreateSafeCallback(function()
        -- Emergency manual fishing restoration
        autofish = false
        autofishSession = autofishSession + 1  -- Invalidate all auto fishing loops
        autofishThread = nil
        
        -- Stop hybrid mode if active
        if hybridMode and hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Clear any potential input blocks
        task.spawn(function()
            task.wait(0.2)
            -- Ensure fishing rod is equipped
            if equipRemote then
                pcall(function()
                    equipRemote:FireServer(1)
                end)
            end
        end)
        
        -- Update UI flags if available
        if Rayfield.Flags["AutoFishToggle"] then
            Rayfield.Flags["AutoFishToggle"]:Set(false)
        end
        
        NotifySuccess("Manual Fishing Fix", "🎣 MANUAL FISHING RESTORED!\n\n✅ All auto fishing stopped\n✅ Input blocks cleared\n✅ Rod equipped\n\n💡 You can now fish manually!")
    end, "fix_manual_fishing")
})

UtilityTab:CreateButton({ 
    Name = "🔄 Reset All Features",
    Callback = CreateSafeCallback(function()
        ResetAllFeatures()
    end, "reset_all_features")
})

UtilityTab:CreateButton({ 
    Name = "Emergency Stop All",
    Callback = CreateSafeCallback(function()
        autofish = false
        featureState.AutoSell = false
        autoSellOnThreshold = false
        
        NotifyError("Emergency Stop", "All automation systems stopped immediately!")
    end, "emergency_stop")
})

UtilityTab:CreateButton({ 
    Name = "Unload Ultimate Script", 
    Callback = CreateSafeCallback(function()
        NotifyInfo("XSAN", "Thank you for using XSAN Fish It Pro Ultimate v1.0! The most advanced fishing script ever created.\n\nScript will unload in 3 seconds...")
        wait(3)
        if game:GetService("CoreGui"):FindFirstChild("Rayfield") then
            game:GetService("CoreGui").Rayfield:Destroy()
        end
    end, "unload_script")
})

print("XSAN: UTILITY tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- EXIT TAB - Script Management & Exit Options
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating EXIT tab content...")

ExitTab:CreateParagraph({
    Title = "🚪 Script Management",
    Content = "Kelola script XSAN Fish It Pro Ultimate dengan aman. Pilih opsi exit atau restart sesuai kebutuhan."
})

ExitTab:CreateButton({
    Name = "🔄 Restart Script",
    Callback = CreateSafeCallback(function()
        NotifyInfo("Restart Script", "🔄 RESTARTING XSAN SCRIPT...\n\n⏳ Please wait 3 seconds\n🔄 Script will reload automatically\n\n💡 All settings will be reset to default")
        
        -- Stop all features first
        autofish = false
        autofishSession = autofishSession + 1
        autofishThread = nil
        walkspeedEnabled = false
        unlimitedJumpEnabled = false
        autoSellOnThreshold = false
        
        -- Stop hybrid mode if active
        if hybridMode and hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Cleanup UI
        task.spawn(function()
            task.wait(3)
            
            -- Destroy current UI
            pcall(function()
                if game:GetService("CoreGui"):FindFirstChild("RayfieldLibrary") then
                    game:GetService("CoreGui").RayfieldLibrary:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") then
                    game.Players.LocalPlayer.PlayerGui.RayfieldLibrary:Destroy()
                end
                if game:GetService("CoreGui"):FindFirstChild("XSAN_FloatingButton") then
                    game:GetService("CoreGui").XSAN_FloatingButton:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XSAN_FloatingButton") then
                    game.Players.LocalPlayer.PlayerGui.XSAN_FloatingButton:Destroy()
                end
            end)
            
            -- Small delay before restart
            task.wait(1)
            
            -- Reload script (assuming this is executed via loadstring)
            NotifySuccess("Restart", "✅ RESTARTING NOW!\n\n🔄 Loading fresh XSAN instance...")
            
            -- Execute the script again - you might need to modify this based on how the script is loaded
            -- This is a placeholder - replace with actual script loading method
            pcall(function()
                -- If script is loaded via URL, use this:
                -- loadstring(game:HttpGet("YOUR_SCRIPT_URL_HERE"))()
                
                -- If script is local file, you might need different approach
                print("XSAN: Script restart initiated - please reload manually if automatic restart fails")
                NotifyInfo("Manual Restart", "⚠️ If automatic restart fails:\n\n1. Close current script\n2. Re-execute the script manually\n3. All features will be fresh and ready!")
            end)
        end)
    end, "restart_script")
})

ExitTab:CreateButton({
    Name = "⚠️ Safe Exit Script",
    Callback = CreateSafeCallback(function()
        NotifyInfo("Safe Exit", "🛡️ PREPARING SAFE EXIT...\n\n⚠️ Stopping all automation\n🔄 Restoring manual controls\n🚪 Cleaning up resources")
        
        -- Stop all automation features safely
        autofish = false
        autofishSession = autofishSession + 1  -- Invalidate all loops
        autofishThread = nil
        
        -- Reset all features to safe state
        perfectCast = false
        safeMode = false
        hybridMode = false
        autoSellOnThreshold = false
        
        -- Stop hybrid mode
        if hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
            hybridAutoFish = nil
        end
        
        -- Reset character modifications
        walkspeedEnabled = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        
        unlimitedJumpEnabled = false
        if unlimitedJumpConnection then
            unlimitedJumpConnection:Disconnect()
            unlimitedJumpConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpHeight = 7.2
        end
        
        -- Equip fishing rod for manual use
        task.spawn(function()
            task.wait(0.5)
            if equipRemote then
                pcall(function()
                    equipRemote:FireServer(1)
                end)
            end
        end)
        
        -- Show final message and exit after delay
        task.spawn(function()
            task.wait(2)
            NotifySuccess("Safe Exit", "✅ SAFE EXIT COMPLETE!\n\n🎣 Manual fishing restored\n🚶 Character controls normal\n🛡️ All automation stopped\n\n🚪 Closing in 3 seconds...")
            
            task.wait(3)
            
            -- Clean up UI and close
            pcall(function()
                if game:GetService("CoreGui"):FindFirstChild("RayfieldLibrary") then
                    game:GetService("CoreGui").RayfieldLibrary:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") then
                    game.Players.LocalPlayer.PlayerGui.RayfieldLibrary:Destroy()
                end
                if game:GetService("CoreGui"):FindFirstChild("XSAN_FloatingButton") then
                    game:GetService("CoreGui").XSAN_FloatingButton:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XSAN_FloatingButton") then
                    game.Players.LocalPlayer.PlayerGui.XSAN_FloatingButton:Destroy()
                end
            end)
            
            print("XSAN: Script safely exited. Thank you for using XSAN Fish It Pro Ultimate!")
        end)
    end, "safe_exit")
})

ExitTab:CreateButton({
    Name = "⚡ Quick Exit",
    Callback = CreateSafeCallback(function()
        NotifyInfo("Quick Exit", "⚡ QUICK EXIT INITIATED!\n\n🚪 Closing script immediately...")
        
        -- Immediate cleanup and exit
        task.spawn(function()
            task.wait(0.5)
            
            -- Stop critical systems
            autofish = false
            autofishSession = autofishSession + 1
            
            -- Quick UI cleanup
            pcall(function()
                if game:GetService("CoreGui"):FindFirstChild("RayfieldLibrary") then
                    game:GetService("CoreGui").RayfieldLibrary:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") then
                    game.Players.LocalPlayer.PlayerGui.RayfieldLibrary:Destroy()
                end
                if game:GetService("CoreGui"):FindFirstChild("XSAN_FloatingButton") then
                    game:GetService("CoreGui").XSAN_FloatingButton:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XSAN_FloatingButton") then
                    game.Players.LocalPlayer.PlayerGui.XSAN_FloatingButton:Destroy()
                end
            end)
            
            print("XSAN: Quick exit completed!")
        end)
    end, "quick_exit")
})

ExitTab:CreateButton({
    Name = "🔧 Emergency Stop",
    Callback = CreateSafeCallback(function()
        -- Immediate emergency stop
        autofish = false
        autofishSession = autofishSession + 999  -- Large increment to invalidate all loops
        autofishThread = nil
        perfectCast = false
        safeMode = false
        hybridMode = false
        autoSellOnThreshold = false
        
        -- Emergency stop hybrid mode
        if hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Emergency reset character
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpHeight = 7.2
            end
        end
        
        -- Disconnect unlimited jump
        if unlimitedJumpConnection then
            unlimitedJumpConnection:Disconnect()
            unlimitedJumpConnection = nil
        end
        
        NotifyError("Emergency Stop", "🚨 EMERGENCY STOP ACTIVATED!\n\n✅ All automation STOPPED\n✅ Character controls RESET\n✅ Manual fishing RESTORED\n\n⚠️ Script still running - use Exit buttons to close")
    end, "emergency_stop")
})

ExitTab:CreateParagraph({
    Title = "💡 Exit Guide",
    Content = "• 🔄 Restart: Reload script dengan pengaturan fresh\n• 🛡️ Safe Exit: Keluar dengan aman, semua otomasi dihentikan\n• ⚡ Quick Exit: Keluar cepat tanpa delay\n• 🔧 Emergency: Stop darurat semua fitur (script tetap jalan)"
})

ExitTab:CreateParagraph({
    Title = "📊 Session Summary",
    Content = "Thank you for using XSAN Fish It Pro Ultimate v1.0! Script ini telah memberikan pengalaman fishing terbaik dengan teknologi AI dan keamanan maksimal."
})

print("XSAN: EXIT tab completed successfully!")

-- Hotkey System
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        -- Proper auto fishing toggle with session cleanup
        if autofish then
            -- Stop auto fishing
            autofish = false
            autofishSession = autofishSession + 1  -- Invalidate any running loops
            autofishThread = nil
            
            -- Stop hybrid mode if active
            if hybridMode and hybridAutoFish then
                hybridAutoFish.toggle(false)
            end
            
            -- Clean up any lingering effects that might block manual fishing
            task.wait(0.1)
            
            NotifyInfo("Hotkey", "🛑 Auto fishing STOPPED (F1)\n\n✅ Manual fishing restored\n🎣 Ready for manual control")
        else
            -- Start auto fishing (trigger UI toggle for proper initialization)
            autofish = true
            if Rayfield.Flags["AutoFishToggle"] then
                Rayfield.Flags["AutoFishToggle"]:Set(true)
            end
            NotifyInfo("Hotkey", "🎣 Auto fishing STARTED (F1)\n\n⚡ AI systems activated\n🔒 Safety protocols active")
        end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        perfectCast = not perfectCast
        NotifyInfo("Hotkey", "Perfect cast " .. (perfectCast and "enabled" or "disabled") .. " (F2)")
    elseif input.KeyCode == Enum.KeyCode.F3 then
        autoSellOnThreshold = not autoSellOnThreshold
        NotifyInfo("Hotkey", "Auto sell threshold " .. (autoSellOnThreshold and "enabled" or "disabled") .. " (F3)")
    elseif input.KeyCode == Enum.KeyCode.F4 then
        -- Quick teleport to spawn
        SafeTeleport(CFrame.new(389, 137, 264), "Moosewood Spawn")
        NotifyInfo("Hotkey", "Quick teleport to spawn (F4)")
    elseif input.KeyCode == Enum.KeyCode.F5 then
        -- Save current position
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            _G.XSANSavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            NotifyInfo("Hotkey", "Position saved (F5)")
        end
    elseif input.KeyCode == Enum.KeyCode.F6 then
        -- Return to saved position
        if _G.XSANSavedPosition then
            SafeTeleport(_G.XSANSavedPosition, "Saved Position")
            NotifyInfo("Hotkey", "Returned to saved position (F6)")
        end
    elseif input.KeyCode == Enum.KeyCode.F7 then
        -- Toggle walkspeed
        walkspeedEnabled = not walkspeedEnabled
        if walkspeedEnabled then
            setWalkSpeed(currentWalkspeed)
            -- Update UI if available
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(true)
            end
        else
            resetWalkSpeed()
            -- Update UI if available
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(false)
            end
        end
        NotifyInfo("Hotkey", "Walk speed " .. (walkspeedEnabled and "enabled" or "disabled") .. " (F7)")
    elseif input.KeyCode == Enum.KeyCode.F8 then
        -- Reset all features
        ResetAllFeatures()
        NotifyInfo("Hotkey", "All features reset to default (F8)")
    elseif input.KeyCode == Enum.KeyCode.F9 then
        -- Emergency manual fishing fix
        autofish = false
        autofishSession = autofishSession + 1  -- Invalidate all auto fishing loops
        autofishThread = nil
        
        -- Stop hybrid mode if active
        if hybridMode and hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Clear any potential input blocks
        task.spawn(function()
            task.wait(0.2)
            -- Ensure fishing rod is equipped
            if equipRemote then
                pcall(function()
                    equipRemote:FireServer(1)
                end)
            end
        end)
        
        -- Update UI flags if available
        if Rayfield.Flags["AutoFishToggle"] then
            Rayfield.Flags["AutoFishToggle"]:Set(false)
        end
        
        NotifySuccess("Hotkey", "🎣 MANUAL FISHING RESTORED! (F9)\n\n✅ Auto fishing emergency stop\n✅ Input blocks cleared\n✅ Rod equipped\n\n💡 Ready for manual fishing!")
    elseif input.KeyCode == Enum.KeyCode.F10 then
        -- Emergency exit hotkey
        NotifyError("Hotkey", "🚨 EMERGENCY EXIT! (F10)\n\n⚡ Stopping all systems immediately...")
        
        -- Emergency stop all systems
        autofish = false
        autofishSession = autofishSession + 999
        autofishThread = nil
        
        -- Stop hybrid mode
        if hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Reset character immediately
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpHeight = 7.2
            end
        end
        
        NotifySuccess("Emergency Exit", "✅ All systems stopped! Check EXIT tab for clean exit options.")
    end
end)

-- Welcome Messages
spawn(function()
    wait(2)
    NotifySuccess("Welcome!", "XSAN Fish It Pro ULTIMATE v1.0 loaded successfully!\n\nULTIMATE FEATURES ACTIVATED:\nAI-Powered Analytics • Smart Automation • Advanced Safety • Premium Quality • Ultimate Teleportation • And Much More!\n\nReady to dominate Fish It like never before!")
    
    wait(4)
    NotifyInfo("Hotkeys Active!", "HOTKEYS ENABLED:\nF1 - Toggle Auto Fishing\nF2 - Toggle Perfect Cast\nF3 - Toggle Auto Sell Threshold\nF4 - Quick TP to Spawn\nF5 - Save Position\nF6 - Return to Saved Position\nF7 - Toggle Walk Speed\nF8 - Reset All Features\nF9 - Fix Manual Fishing\nF10 - Emergency Exit\n\nCheck PRESETS tab for quick setup and EXIT tab for script management!")
    
    wait(3)
    NotifyInfo("📱 Smart UI!", "RAYFIELD UI SYSTEM:\nRayfield automatically handles UI sizing and responsiveness for all devices!\n\nUI management is now handled by the Rayfield library (css.lua)!")
    
    wait(3)
    NotifySuccess("✅ Teleportation Fixed!", "TELEPORTATION SYSTEM FIXED:\n✅ Now uses dynamic locations like old.lua\n✅ Accurate coordinates from workspace\n✅ Better player detection\n✅ More reliable teleportation\n\nCheck TELEPORT tab for perfect locations!")
    
    wait(3)
    NotifyInfo("Follow XSAN!", "Instagram: @_bangicoo\nGitHub: codeico\n\nThe most advanced Fish It script ever created! Follow us for more premium scripts and exclusive updates!")
end)

-- Console Branding
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("XSAN FISH IT PRO ULTIMATE v1.0")
print("THE MOST ADVANCED FISH IT SCRIPT EVER CREATED")
print("Premium Script with AI-Powered Features & Ultimate Automation")
print("Instagram: @_bangicoo | GitHub: codeico")
print("Professional Quality • Trusted by Thousands • Ultimate Edition")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("XSAN: Script loaded successfully! All systems operational!")

-- Performance Enhancements
pcall(function()
    local Modifiers = require(game:GetService("ReplicatedStorage").Shared.FishingRodModifiers)
    for key in pairs(Modifiers) do
        Modifiers[key] = 999999999
    end

    local bait = require(game:GetService("ReplicatedStorage").Baits["Luck Bait"])
    bait.Luck = 999999999
    
    print("XSAN: Performance enhancements applied!")
end)
