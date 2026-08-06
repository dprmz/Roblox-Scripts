-- [[ ADI PROJECT - OFFICIAL LOADER ]] --
local ProjectName = "ADI"

-- Buat folder lokal untuk settings/logs
local folders = {ProjectName, ProjectName.."/Settings", ProjectName.."/Logs"}
for _, v in pairs(folders) do
    if not isfolder(v) then makefolder(v) end
end

-- ✅ SUDAH DISESUAIKAN DENGAN USERNAME DAN REPO ASLI
local GITHUB_RAW = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/main/"

local GameScripts = {
    [93978595733734] = GITHUB_RAW .. "Main.lua",  -- Violence District Place ID
}

local currentId = game.PlaceId

if GameScripts[currentId] then
    print("[" .. ProjectName .. "] Map detected! Loading fresh script...")
    local success, err = pcall(function()
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