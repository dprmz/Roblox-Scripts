-- ============================================================
-- MAIN.LUA – Violence District Full Script (ADI Project)
-- Modular design, Delta compatible & Safe Loader.
-- ============================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local BASE_URL = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/main/Modules/"

-- Fungsi pintar untuk load module satu per satu (mencegah bug Delta)
local function LoadModule(moduleName)
    local url = BASE_URL .. moduleName .. ".lua?t=" .. tostring(tick())
    
    -- 1. Coba download file
    local success, code = pcall(function() return game:HttpGet(url) end)
    if not success then
        warn("[ADI] Gagal mengunduh " .. moduleName .. ": " .. tostring(code))
        return nil
    end

    -- 2. Coba compile kode (cek syntax error)
    local func, compileErr = loadstring(code)
    if not func then
        warn("[ADI] Error Sintaks di " .. moduleName .. ".lua: " .. tostring(compileErr))
        return nil
    end

    -- 3. Coba jalankan module
    local runSuccess, moduleData = pcall(func)
    if not runSuccess then
        warn("[ADI] Error eksekusi di " .. moduleName .. ".lua: " .. tostring(moduleData))
        return nil
    end

    return moduleData
end

print("[ADI] Mulai memuat modul...")

-- Load secara berurutan
local Config = LoadModule("Config")
local UI = LoadModule("UI")
local Survivor = LoadModule("Survivor")
local ESP = LoadModule("ESP")

-- Pengecekan krusial sebelum menjalankan script utama
if not Config then
    warn("[ADI] FATAL: Config gagal dimuat. Script dihentikan.")
    return
end
if not UI then
    warn("[ADI] FATAL: UI gagal dimuat. Cek error di atas. Script dihentikan.")
    return
end

-- Expose Config untuk debugging
_G.ADIConfig = Config

-- Eksekusi fitur (Pastikan module Survivor dan ESP juga berhasil dimuat)
UI:CreateSidebar(Config)

if Survivor then
    Survivor:Init(Config, Player)
else
    warn("[ADI] Module Survivor tidak ditemukan/error.")
end

if ESP then
    ESP:Init(Config, Player)
else
    warn("[ADI] Module ESP tidak ditemukan/error.")
end

print("[ADI] Main script berhasil dieksekusi 100%. Semua sistem aktif.")
