-- Nama Project Kamu
local ProjectName = "ADI"

-- 1. Setup Folder di Workspace (untuk menyimpan log/settings)
local folders = {ProjectName, ProjectName.."/Settings", ProjectName.."/Logs"}
for _, v in pairs(folders) do
    if not isfolder(v) then makefolder(v) end
end

-- 2. Database Game (Masukkan PlaceId map kamu di sini)
local GameScripts = {
    [93978595733734] = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/refs/heads/main/Main.lua", 
    -- [ID_MAP_LAIN] = "URL_RAW_LAINNYA",
}

-- 3. Deteksi Map dan Jalankan Script
local currentId = game.PlaceId

if GameScripts[currentId] then
    print("[" .. ProjectName .. "] Map terdeteksi! Memuat script...")
    
    -- Menjalankan script dari GitHub kamu
    local success, err = pcall(function()
        loadstring(game:HttpGet(GameScripts[currentId]))()
    end)
    
    if success then
        print("[" .. ProjectName .. "] Script berhasil dijalankan!")
    else
        warn("[" .. ProjectName .. "] Error saat menjalankan script: " .. tostring(err))
    end
else
    -- Jika map tidak ada di daftar, script tidak akan jalan
    warn("[" .. ProjectName .. "] Maaf, map ini (ID: " .. currentId .. ") tidak terdaftar di database.")
    
    -- Opsional: Jalankan script default jika map tidak terdaftar
    -- loadstring(game:HttpGet("URL_SCRIPT_UNIVERSAL"))()
end
