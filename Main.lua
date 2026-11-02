-- Main.lua (Versi Terbaru)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local BASE_URL = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/main/Modules/"

local function LoadModule(moduleName)
    local url = BASE_URL .. moduleName .. ".lua?t=" .. tostring(tick())
    
    local success, code = pcall(function() return game:HttpGet(url) end)
    if not success or not code then
        warn("[ADI] Gagal mengunduh " .. moduleName .. ": " .. tostring(code))
        return nil
    end

    local func, compileErr = loadstring(code)
    if not func then
        warn("[ADI] Error Sintaks di " .. moduleName .. ".lua: " .. tostring(compileErr))
        return nil
    end

    local runSuccess, moduleData = pcall(func)
    if not runSuccess then
        warn("[ADI] Error eksekusi di " .. moduleName .. ".lua: " .. tostring(moduleData))
        return nil
    end

    return moduleData
end

print("[ADI] Memuat modul...")

local Config = LoadModule("Config")
local UI = LoadModule("UI")
local Survivor = LoadModule("Survivor")
local Killer = LoadModule("Killer")
local ESP = LoadModule("ESP")
local Visual = LoadModule("Visual")

if not Config or not UI then
    warn("[ADI] Fatal error saat memuat UI/Config.")
    return
end

_G.ADIConfig = Config

UI:CreateSidebar(Config)

if Survivor then Survivor:Init(Config, Player) end
if Killer then Killer:Init(Config, Player) end
if ESP then ESP:Init(Config, Player) end
if Visual then Visual:Init(Config, Player) end

print("[ADI] Script berhasil dimuat sempurna!")
