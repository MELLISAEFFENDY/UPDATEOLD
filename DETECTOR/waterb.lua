--[[
Weather Purchase Argument Probe
--------------------------------------------------
Tujuan:
  Mencoba berbagai kemungkinan argumen ke RF/PurchaseWeatherEvent untuk mengetahui format yang benar
  tanpa perlu menunggu klik manual atau hook gagal.

Cara Pakai:
  1. Jalankan file ini SESUDAH kamu berada di dalam game & asset ReplicatedStorage sudah termuat.
  2. Lihat output console (F9) untuk hasil setiap percobaan.
  3. Hentikan sebelum spam berlebihan (skrip punya jeda & limit aman).

Catatan Keamanan:
  - Script memakai pcall agar error remote tidak menghentikan loop.
  - Delay default 1.2s antar percobaan agar tidak flooding.
  - Set MAX_ATTEMPTS lebih kecil jika khawatir.
  - Jika remote memerlukan token khusus / state GUI server-side, semua percobaan bisa gagal -> perlu capture real click.

Set Argumen Kandidat:
  - Default daftar mencakup string umum untuk cuaca.
  - Tambah / ubah di WEATHER_CANDIDATES sesuai hasil pengamatan.

Output Legend:
  [OK]    => pcall sukses (InvokeServer tidak error). Menampilkan return value (bisa nil).
  [FAIL]  => pcall error / remote menolak.
  [STOP]  => Dihentikan manual lewat _G.WeatherProbeStop = true
--------------------------------------------------
]]

if _G.WeatherProbeRunning then
    warn('[WeatherProbe] Sudah berjalan. Set _G.WeatherProbeStop = true untuk menghentikan lalu jalankan lagi.')
    return
end

_G.WeatherProbeRunning = true
_G.WeatherProbeStop = false

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local success, net = pcall(function()
    return ReplicatedStorage:WaitForChild('Packages'):WaitForChild('_Index'):WaitForChild('sleitnick_net@0.2.0'):WaitForChild('net')
end)
if not success then
    warn('[WeatherProbe] Net folder tidak ditemukan. Pastikan game sudah load.')
    return
end

local remote = net:FindFirstChild('RF/PurchaseWeatherEvent')
if not remote then
    warn('[WeatherProbe] RF/PurchaseWeatherEvent tidak ditemukan di net folder.')
    return
end

if not remote:IsA('RemoteFunction') then
    warn('[WeatherProbe] Diharapkan RemoteFunction, dapat:', remote.ClassName, '-> tetap coba FireServer fall-back')
end

-- Kandidat argumen (string). Bisa ganti / tambah.
local WEATHER_CANDIDATES = {
    'Cloudy','Wind','Snow','Storm','SharkHunt','Shark Hunt','Shark','Rain','Fog','Sunny'
}

-- Jika kemungkinan butuh table, definisikan template di sini
local TABLE_TEMPLATES = {
    -- Contoh (aktifkan jika diperlukan):
    -- { weather = 'Cloudy' },
    -- { Weather = 'Cloudy' },
}

local MAX_ATTEMPTS =  #WEATHER_CANDIDATES + (#TABLE_TEMPLATES * #WEATHER_CANDIDATES)
local DELAY = 1.2 -- detik antar percobaan

print('[WeatherProbe] Mulai uji', MAX_ATTEMPTS, 'kombinasi dengan delay', DELAY,'detik')
print('[WeatherProbe] Set _G.WeatherProbeStop = true untuk menghentikan lebih awal.')

local attempt = 0

local function pretty(v)
    if typeof(v) == 'table' then
        local ok,res = pcall(function()
            local parts={'{'}
            for k,val in pairs(v) do table.insert(parts, ('%s=%s; '):format(k, tostring(val))) end
            table.insert(parts,'}')
            return table.concat(parts,' ')
        end)
        return ok and res or '<table>'
    else
        return tostring(v)
    end
end

local function callRemote(arg)
    attempt += 1
    if _G.WeatherProbeStop then
        print('[WeatherProbe][STOP] Dihentikan manual pada attempt', attempt)
        return false
    end
    local label
    if typeof(arg)=='table' then
        label = '[TABLE] '..pretty(arg)
    else
        label = '[STRING] '..tostring(arg)
    end
    local ok,ret = pcall(function()
        if remote.InvokeServer then
            return remote:InvokeServer(arg)
        else
            remote:FireServer(arg)
            return nil
        end
    end)
    if ok then
        print(('[OK] #%d Arg=%s Return=%s'):format(attempt,label, pretty(ret)))
    else
        print(('[FAIL] #%d Arg=%s Error=%s'):format(attempt,label, tostring(ret)))
    end
    return true
end

-- Uji string langsung
for _,w in ipairs(WEATHER_CANDIDATES) do
    if not _G.WeatherProbeRunning or _G.WeatherProbeStop then break end
    if not callRemote(w) then break end
    task.wait(DELAY)
end

-- Uji template table (jika diisi)
for _,tpl in ipairs(TABLE_TEMPLATES) do
    for _,w in ipairs(WEATHER_CANDIDATES) do
        if _G.WeatherProbeStop then break end
        local clone = {}
        for k,v in pairs(tpl) do clone[k]=v end
        -- Ganti nilai weather jika key ada
        if clone.weather then clone.weather = w end
        if clone.Weather then clone.Weather = w end
        callRemote(clone)
        task.wait(DELAY)
    end
    if _G.WeatherProbeStop then break end
end

_G.WeatherProbeRunning = false
print('[WeatherProbe] Selesai. Jika tidak ada satupun [OK], perlu capture klik asli (GUI) atau remote memerlukan argumen kompleks tambahan).')
