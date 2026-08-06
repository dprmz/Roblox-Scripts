-- ============================================================
-- MAIN.LUA – Violence District Full Script (ADI Project)
-- Modular design, Delta compatible.
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local BASE_URL = "https://raw.githubusercontent.com/dprmz/Roblox-Scripts/main/Modules/"
local bypassCache = "?t=" .. tostring(tick())

local Modules = {
    Config = loadstring(game:HttpGet(BASE_URL .. "Config.lua" .. bypassCache))(),
    UI = loadstring(game:HttpGet(BASE_URL .. "UI.lua" .. bypassCache))(),
    Survivor = loadstring(game:HttpGet(BASE_URL .. "Survivor.lua" .. bypassCache))(),
    Killer = loadstring(game:HttpGet(BASE_URL .. "Killer.lua" .. bypassCache))(),
    ESP = loadstring(game:HttpGet(BASE_URL .. "ESP.lua" .. bypassCache))(),
    Visual = loadstring(game:HttpGet(BASE_URL .. "Visual.lua" .. bypassCache))(),
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

print("[ADI] Main script initialized. All systems go.")
