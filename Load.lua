-- [[ ADI PROJECT - LOADER ]] --
local ProjectName = "ADI"

-- 1. Setup Folder
local folders = {ProjectName, ProjectName.."/Settings", ProjectName.."/Logs"}
for _, v in pairs(folders) do
    if not isfolder(v) then makefolder(v) end
end

-- 2. Database Game
-- Tambahkan "?t=" .. tick() di akhir URL untuk menghindari Cache (selalu ambil yang terbaru)
local GameScripts = {
    [93978595733734] = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/refs/heads/main/Main.lua", 
}

-- 3. Deteksi Map
local currentId = game.PlaceId

if GameScripts[currentId] then
    print("[" .. ProjectName .. "] Map terdeteksi! Memuat script terbaru...")
    
    -- Menjalankan script
    local success, err = pcall(function()
        -- Kita tambahkan tick() agar GitHub selalu memberikan file yang paling baru diedit
        local scriptUrl = GameScripts[currentId] .. "?t=" .. tick()
        loadstring(game:HttpGet(scriptUrl))()
    end)
    
    if success then
        print("[" .. ProjectName .. "] Script berhasil dijalankan!")
    else
        warn("[" .. ProjectName .. "] Error saat memuat Main.lua: " .. tostring(err))
    end
else
    warn("[" .. ProjectName .. "] Map ID: " .. currentId .. " belum terdaftar.")
end
