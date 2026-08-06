-- [[ ROBLOX SCRIPTS - OFFICIAL LOADER ]] --
local ProjectName = "RobloxScripts"

-- Buat folder lokal untuk settings/logs
local folders = {ProjectName, ProjectName.."/Settings", ProjectName.."/Logs"}
for _, v in pairs(folders) do
    if not isfolder(v) then makefolder(v) end
end

-- GANTI "dprmz" DENGAN USERNAME GITHUB ASLI KAMU (SUDAH TERCANTUM)
local GITHUB_RAW = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/main/"

local GameScripts = {
    [93978595733734] = GITHUB_RAW .. "Main.lua",  -- Violence District Place ID
    -- Tambahkan Place ID game lain di sini
}

local currentId = game.PlaceId

if GameScripts[currentId] then
    print("[" .. ProjectName .. "] Map detected! Loading fresh script...")
    local success, err = pcall(function()
        -- ?t= menghancurkan cache browser GitHub
        local scriptUrl = GameScripts[currentId] .. "?t=" .. tick()
        loadstring(game:HttpGet(scriptUrl))()
    end)
    if success then
        print("[" .. ProjectName .. "] Script loaded perfectly!")
    else
        warn("[" .. ProjectName .. "] Load error: " .. tostring(err))
    end
else
    warn("[" .. ProjectName .. "] Place ID not found: " .. currentId)
end
