
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


    -- Cari nama rod otomatis dari Backpack/Inventory
    local rodName = nil
    local backpack = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item.Name:lower():find("rod") then
                rodName = item.Name
                break
            end
        end
    end
    if not rodName then
        rodName = "Starter Rod" -- fallback jika tidak ketemu
    end

    -- Proses awal: equip rod (jika remote ada)
    if equipRemote then
        print("Equip rod... (" .. rodName .. ")")
        if equipRemote:IsA("RemoteFunction") then
            equipRemote:InvokeServer(rodName)
        else
            equipRemote:FireServer(rodName)
        end
        wait(1) -- Tunggu 1 detik agar natural
    else
        print("Equip remote not found, lanjut tanpa equip.")
    end

    if rodRemote and finishRemote then
        for i = 1, 10 do
            if rodRemote:IsA("RemoteFunction") then
                rodRemote:InvokeServer()
            else
                rodRemote:FireServer()
            end
            wait(0.1)
            finishRemote:FireServer("Perfect")
            wait(0.1)
        end
    else
        print("Remotes not found!")
    end

    print("❌ Method 3: Unnatural frequency - Bot pattern detection")
    print("🚨 Detection: Statistical analysis + human behavior modeling")
end

FrequencyExploit_HIGH_RISK()
