-- Debug Event & Location Full v1.0
-- Menampilkan semua label dan objek di CoreGui & Workspace yang mengandung kata kunci event

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local screen = Instance.new("ScreenGui")
screen.Name = "DebugEventLocationFull"
screen.Parent = CoreGui
screen.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screen
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
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
title.Text = "🔎 Debug Event & Location Full"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

local infoBox = Instance.new("TextBox")
infoBox.Parent = mainFrame
infoBox.Size = UDim2.new(1, -20, 1, -50)
infoBox.Position = UDim2.new(0, 10, 0, 40)
infoBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
infoBox.TextColor3 = Color3.fromRGB(200, 255, 200)
infoBox.Font = Enum.Font.Code
infoBox.TextSize = 14
infoBox.TextXAlignment = Enum.TextXAlignment.Left
infoBox.TextYAlignment = Enum.TextYAlignment.Top
infoBox.TextWrapped = true
infoBox.TextEditable = false
infoBox.ClearTextOnFocus = false
infoBox.MultiLine = true
infoBox.Text = ""

local exportBtn = Instance.new("TextButton")
exportBtn.Parent = mainFrame
exportBtn.Size = UDim2.new(0, 120, 0, 30)
exportBtn.Position = UDim2.new(1, -130, 1, -35)
exportBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
exportBtn.BorderSizePixel = 0
exportBtn.Text = "📋 Export Debug"
exportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportBtn.TextScaled = true
exportBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", exportBtn).CornerRadius = UDim.new(0, 6)

local lastInfo = ""
exportBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(lastInfo)
        infoBox.Text = infoBox.Text .. "\n[Export] Debug info dicopy ke clipboard!"
    else
        infoBox.Text = infoBox.Text .. "\n[Export] setclipboard tidak tersedia di executor ini."
    end
end)

local keywords = {"event", "black", "hole", "admin", "galaxy", "corrupt", "mutation", "limited"}

local function scanAll()
    local results = {}
    table.insert(results, "=== CoreGui ===")
    local function scanObj(obj, path)
        local objInfo = ""
        local objName = obj.Name or "?"
        local objType = obj.ClassName or "?"
        local objText = obj.Text or ""
        local found = false
        for _, kw in ipairs(keywords) do
            if tostring(objName):lower():find(kw) or tostring(objText):lower():find(kw) then
                found = true
                break
            end
        end
        if found then
            objInfo = string.format("[%s] %s | Name: %s | Text: %s", objType, path, objName, objText)
            table.insert(results, objInfo)
        end
        for _, child in ipairs(obj:GetChildren()) do
            scanObj(child, path .. "/" .. child.Name)
        end
    end
    scanObj(CoreGui, "CoreGui")
    table.insert(results, "\n=== Workspace ===")
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local objName = obj.Name or "?"
        local objType = obj.ClassName or "?"
        local found = false
        for _, kw in ipairs(keywords) do
            if tostring(objName):lower():find(kw) then
                found = true
                break
            end
        end
        if found then
            local pos = obj.Position and tostring(obj.Position) or "-"
            local objInfo = string.format("[%s] Name: %s | Pos: %s", objType, objName, pos)
            table.insert(results, objInfo)
        end
    end
    infoBox.Text = table.concat(results, "\n")
    lastInfo = infoBox.Text
end

scanAll()

-- Refresh setiap 10 detik
while true do
    wait(10)
    scanAll()
end
