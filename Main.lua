-- ============================================================
-- MAIN.LUA – Violence District Full Script (ADI Project)
-- Modular design, Delta compatible.
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Load all modules (they must exist in the same GitHub folder structure)
local Modules = {
    Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/Roblox-Script/main/Modules/Config.lua"))(),
    UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/Roblox-Script/main/Modules/UI.lua"))(),
    Survivor = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/Roblox-Script/main/Modules/Survivor.lua"))(),
    Killer = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/Roblox-Script/main/Modules/Killer.lua"))(),
    ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/Roblox-Script/main/Modules/ESP.lua"))(),
    Visual = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/Roblox-Script/main/Modules/Visual.lua"))(),
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