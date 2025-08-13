--[[
    XSAN Admin Event Detector v1.0
    
    Mendeteksi Admin Event seperti Ghost Worm dan event admin lainnya
    dengan lokasi real-time yang akurat.
    
    Features:
    • Real-time Admin Event Detection
    • Event Location Tracking
    • Auto Notification System
    • Event Timer Monitoring
    • Teleportation to Event Location
    
    Developer: XSAN
    GitHub: github.com/codeico
--]]

print("XSAN: Loading Admin Event Detector...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Notification Function
local function Notify(title, text, duration)
    duration = duration or 5
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "XSAN Event Detector",
            Text = text or "Event Detected",
            Duration = duration,
            Icon = "rbxassetid://6023426923"
        })
    end)
    print("XSAN EVENT:", title, "-", text)
end

-- Safe Teleport Function
local function SafeTeleport(targetCFrame, eventName)
    pcall(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Notify("Teleport Error", "Character not found! Cannot teleport to " .. eventName)
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        
        -- Teleport with slight offset to avoid collision
        local safePosition = targetCFrame.Position + Vector3.new(0, 10, 0)
        humanoidRootPart.CFrame = CFrame.new(safePosition)
        
        wait(0.2)
        
        -- Lower to event position
        humanoidRootPart.CFrame = targetCFrame
        
        Notify("Event Teleport", "Successfully teleported to: " .. eventName)
        print("XSAN: Teleported to event -", eventName, "at", targetCFrame.Position)
    end)
end

-- Event Detection System
local detectedEvents = {}
local eventLocations = {}

-- Known Admin Events (akan diperluas berdasarkan game updates)
local adminEventsList = {
    ["Ghost Worm"] = {
        keywords = {"ghost", "worm", "ghostworm"},
        icon = "👻",
        rarity = "LEGENDARY",
        description = "Limited 1 in 1,000,000 Ghost Worm Fish!"
    },
    ["Meteor Rain"] = {
        keywords = {"meteor", "rain", "meteorrain"},
        icon = "☄️",
        rarity = "LEGENDARY",
        description = "Fish in Meteor Rain area for x6 mutation chance!"
    },
    ["Kraken Event"] = {
        keywords = {"kraken", "tentacle"},
        icon = "🐙",
        rarity = "MYTHIC",
        description = "Legendary Kraken has appeared!"
    },
    ["Whale Event"] = {
        keywords = {"whale", "megalodon"},
        icon = "🐋",
        rarity = "EPIC",
        description = "Giant Whale sighting!"
    },
    ["Aurora Event"] = {
        keywords = {"aurora", "lights"},
        icon = "🌌",
        rarity = "RARE",
        description = "Aurora Borealis event!"
    },
    ["Tsunami Event"] = {
        keywords = {"tsunami", "wave"},
        icon = "🌊",
        rarity = "EPIC", 
        description = "Massive Tsunami incoming!"
    }
}

-- Function to detect admin events from GUI notifications
local function ScanForAdminEvents()
    pcall(function()
        -- Method 1: Check PlayerGui for event notifications
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, descendant in pairs(gui:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        local text = descendant.Text:lower()
                        
                        -- Method A: Check for direct admin event notifications (like the blue box in screenshot)
                        if text:find("admin event") or text:find("limited time") then
                            -- Check for specific events in the text
                            for eventName, eventData in pairs(adminEventsList) do
                                for _, keyword in pairs(eventData.keywords) do
                                    if text:find(keyword) then
                                        if not detectedEvents[eventName] then
                                            detectedEvents[eventName] = {
                                                startTime = tick(),
                                                detected = true,
                                                location = nil,
                                                gui = descendant
                                            }
                                            
                                            Notify("🚨 ADMIN EVENT DETECTED!", 
                                                eventData.icon .. " " .. eventName .. " ACTIVE!\n\n" ..
                                                "📍 Scanning for location...\n" ..
                                                "⭐ " .. eventData.rarity .. " Event\n" ..
                                                "📝 " .. eventData.description,
                                                8
                                            )
                                            
                                            print("XSAN: Admin Event Detected -", eventName)
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- Method B: Check for event keywords directly
                        for eventName, eventData in pairs(adminEventsList) do
                            for _, keyword in pairs(eventData.keywords) do
                                if text:find(keyword) and (text:find("event") or text:find("rain") or text:find("worm")) then
                                    if not detectedEvents[eventName] then
                                        detectedEvents[eventName] = {
                                            startTime = tick(),
                                            detected = true,
                                            location = nil,
                                            gui = descendant
                                        }
                                        
                                        Notify("🚨 ADMIN EVENT DETECTED!", 
                                            eventData.icon .. " " .. eventName .. " ACTIVE!\n\n" ..
                                            "📍 Scanning for location...\n" ..
                                            "⭐ " .. eventData.rarity .. " Event\n" ..
                                            "📝 " .. eventData.description,
                                            8
                                        )
                                        
                                        print("XSAN: Admin Event Detected -", eventName)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- Method 2: Check StarterGui notifications
        pcall(function()
            for _, notification in pairs(StarterGui.CoreGui:GetDescendants()) do
                if notification:IsA("TextLabel") then
                    local text = notification.Text:lower()
                    if text:find("admin") or text:find("event") then
                        for eventName, eventData in pairs(adminEventsList) do
                            for _, keyword in pairs(eventData.keywords) do
                                if text:find(keyword) then
                                    if not detectedEvents[eventName] then
                                        detectedEvents[eventName] = {
                                            startTime = tick(),
                                            detected = true,
                                            location = nil,
                                            gui = notification
                                        }
                                        
                                        Notify("🚨 ADMIN EVENT DETECTED!", 
                                            eventData.icon .. " " .. eventName .. " ACTIVE!\n\n" ..
                                            "📍 From CoreGui notifications\n" ..
                                            "⭐ " .. eventData.rarity .. " Event",
                                            6
                                        )
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end

-- Function to find event locations in workspace
local function ScanEventLocations()
    pcall(function()
        -- Method 1: Check for event-related objects in workspace
        for eventName, eventInfo in pairs(detectedEvents) do
            if eventInfo.detected and not eventInfo.location then
                local eventData = adminEventsList[eventName]
                
                -- Search workspace for event objects
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") or obj:IsA("Model") then
                        local objName = obj.Name:lower()
                        
                        -- Check if object name matches event keywords
                        for _, keyword in pairs(eventData.keywords) do
                            if objName:find(keyword) then
                                local location = obj:IsA("Part") and obj.CFrame or (obj.PrimaryPart and obj.PrimaryPart.CFrame)
                                
                                if location then
                                    eventInfo.location = location
                                    eventLocations[eventName] = location
                                    
                                    Notify("📍 EVENT LOCATION FOUND!", 
                                        eventData.icon .. " " .. eventName .. " Location:\n\n" ..
                                        "🎯 Position: " .. math.floor(location.Position.X) .. ", " .. 
                                        math.floor(location.Position.Y) .. ", " .. 
                                        math.floor(location.Position.Z) .. "\n" ..
                                        "⚡ Use teleport command to go there!",
                                        7
                                    )
                                    
                                    print("XSAN: Event location found -", eventName, "at", location.Position)
                                end
                            end
                        end
                    end
                end
                
                -- Method 2: Check ReplicatedStorage for event data
                if ReplicatedStorage:FindFirstChild("Events") then
                    local eventsFolder = ReplicatedStorage.Events
                    for _, eventObj in pairs(eventsFolder:GetChildren()) do
                        local objName = eventObj.Name:lower()
                        for _, keyword in pairs(eventData.keywords) do
                            if objName:find(keyword) and eventObj:FindFirstChild("Position") then
                                local pos = eventObj.Position.Value
                                local location = CFrame.new(pos)
                                
                                eventInfo.location = location
                                eventLocations[eventName] = location
                                
                                Notify("📍 EVENT DATA FOUND!",
                                    eventData.icon .. " " .. eventName .. " Location:\n\n" ..
                                    "🎯 Position: " .. math.floor(pos.X) .. ", " .. 
                                    math.floor(pos.Y) .. ", " .. 
                                    math.floor(pos.Z),
                                    6
                                )
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Function to get all detected events
local function GetDetectedEvents()
    local activeEvents = {}
    local eventCount = 0
    
    for eventName, eventInfo in pairs(detectedEvents) do
        if eventInfo.detected then
            eventCount = eventCount + 1
            local eventData = adminEventsList[eventName]
            local duration = math.floor((tick() - eventInfo.startTime) / 60)
            local locationStatus = eventInfo.location and "Located" or "Scanning..."
            
            table.insert(activeEvents, {
                name = eventName,
                icon = eventData.icon,
                rarity = eventData.rarity,
                duration = duration,
                location = locationStatus,
                position = eventInfo.location
            })
        end
    end
    
    return activeEvents, eventCount
end

-- Function to teleport to specific event
local function TeleportToEvent(eventName)
    if eventLocations[eventName] then
        SafeTeleport(eventLocations[eventName], eventName)
    elseif detectedEvents[eventName] and detectedEvents[eventName].detected then
        Notify("Event Teleport", "⚠️ " .. eventName .. " detected but location not found yet!\n\n📍 Still scanning for location...")
    else
        Notify("Event Teleport", "❌ " .. eventName .. " event not detected!")
    end
end

-- Auto-scan system
local function StartAutoScan()
    spawn(function()
        while true do
            ScanForAdminEvents()
            wait(2)
            ScanEventLocations() 
            wait(3)
        end
    end)
end

-- Export Functions
return {
    -- Core Functions
    ScanForAdminEvents = ScanForAdminEvents,
    ScanEventLocations = ScanEventLocations,
    GetDetectedEvents = GetDetectedEvents,
    TeleportToEvent = TeleportToEvent,
    StartAutoScan = StartAutoScan,
    
    -- Data Access
    detectedEvents = detectedEvents,
    eventLocations = eventLocations,
    adminEventsList = adminEventsList,
    
    -- Utility Functions
    SafeTeleport = SafeTeleport,
    Notify = Notify
}
