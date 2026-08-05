-- [[ ADI PROJECT - OFFICIAL LOADER ]] --
local ProjectName = "ADI"

-- Buat folder lokal untuk settings/logs
local folders = {ProjectName, ProjectName.."/Settings", ProjectName.."/Logs"}
for _, v in pairs(folders) do
    if not isfolder(v) then
        makefolder(v)
    end
end

-- GitHub Raw
local GITHUB_RAW = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/main/"

local GameScripts = {
    [93978595733734] = GITHUB_RAW .. "Main.lua",
}

local currentId = game.PlaceId

local scriptUrl = GameScripts[currentId]

if scriptUrl then
    print("[" .. ProjectName .. "] Map detected! Loading script...")

    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl .. "?t=" .. os.time()))()
    end)

    if success then
        print("[" .. ProjectName .. "] Script loaded successfully!")
    else
        warn("[" .. ProjectName .. "] Error: " .. tostring(err))
    end
else
    warn("[" .. ProjectName .. "] Unsupported PlaceId: " .. currentId)
end