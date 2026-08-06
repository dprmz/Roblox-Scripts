-- ============================================================
-- MAIN.LUA – Violence District Full Script (ADI Project)
-- Modular design, Delta compatible.
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ✅ SEMUA MODULE MENGGUNAKAN URL YANG SUDAH BENAR
local BASE_URL = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/main/Modules/"

local Modules = {
    Config = loadstring(game:HttpGet(BASE_URL .. "Config.lua"))(),
    UI = loadstring(game:HttpGet(BASE_URL .. "UI.lua"))(),
    Survivor = loadstring(game:HttpGet(BASE_URL .. "Survivor.lua"))(),
    Killer = loadstring(game:HttpGet(BASE_URL .. "Killer.lua"))(),
    ESP = loadstring(game:HttpGet(BASE_URL .. "ESP.lua"))(),
    Visual = loadstring(game:HttpGet(BASE_URL .. "Visual.lua"))(),
}

-- Initialize Config (global settings)
local Config = Modules.Config
_G.ADIConfig = Config  -- expose for debugging

-- Build UI
local UI = Modules.UI
UI:CreateSidebar(Config)

-- Start feature loops (Survivor, ESP, etc.)
local Survivor = Modules.Survivor
Survivor:Init(Config, Player)

local ESP = Modules.ESP
ESP:Init(Config, Player)

-- Optional: Killer module (placeholder)
-- local Killer = Modules.Killer
-- Killer:Init(Config, Player)

print("[ADI] Main script initialized. All systems go.")