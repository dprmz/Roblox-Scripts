-- [[ ADI PROJECT - V35 HYBRID EDITION (ICEWARE LOADED) ]] --

-- 1. LOAD EXTERNAL PERFECT SCRIPT (ICEWARE)
-- Kita panggil script yang kamu suka karena fiturnya sudah matang
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Iceware-RBLX/Roblox/refs/heads/main/loader.lua",true))()
    end)
end)

-- 2. ADI MENU CUSTOM (FITUR TAMBAHAN)
local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV35_Hybrid"
pcall(function() ScreenGui.Parent = gethui() or game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0, 50, 0.5, -150) -- Di samping kiri agar tidak menumpuk menu Iceware
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Text = "ADI EXTRA FEATURES"; Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Title)

-- --- [FITUR TAMBAHAN YANG TIDAK ADA DI ICEWARE] ---

local function createSlider(title, pos)
    local t = Instance.new("TextLabel", Main)
    t.Text = title; t.Size = UDim2.new(1,0,0,20); t.Position = UDim2.new(0,0,0,pos); t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1
    local bg = Instance.new("Frame", Main)
    bg.Size = UDim2.new(0.8,0,0,5); bg.Position = UDim2.new(0.1,0,0,pos+25); bg.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0,10,2,0); btn.Position = UDim2.new(0,0,-0.5,0); btn.Text = ""; btn.BackgroundColor3 = Color3.new(0,0.6,1)
    return btn, bg
end

local sSpd, bSpd = createSlider("WalkSpeed", 60)
local sHit, bHit = createSlider("Hitbox Player", 120)
local dS, dH = false, false

sSpd.MouseButton1Down:Connect(function() dS = true end)
sHit.MouseButton1Down:Connect(function() dH = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false end end)

RunService.RenderStepped:Connect(function()
    local mX = UIS:GetMouseLocation().X
    if dS then
        local r = math.clamp((mX - bSpd.AbsolutePosition.X) / bSpd.AbsoluteSize.X, 0, 1)
        sSpd.Position = UDim2.new(r, -5, -0.5, 0)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 16 + (r * 150) end
    elseif dH then
        local r = math.clamp((mX - bHit.AbsolutePosition.X) / bHit.AbsoluteSize.X, 0, 1)
        sHit.Position = UDim2.new(r, -5, -0.5, 0)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2 + (r*48), 2 + (r*48), 2 + (r*48))
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

local close = Instance.new("TextButton", Main)
close.Text = "Close Adi Menu"; close.Size = UDim2.new(0.8,0,0,30); close.Position = UDim2.new(0.1,0,0,240); close.BackgroundColor3 = Color3.new(0.5,0,0)
close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
