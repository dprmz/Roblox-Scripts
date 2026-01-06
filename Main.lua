-- [[ ADI PROJECT - V37 HYBRID ULTIMATE ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- 1. UI SETUP (ADI MENU STYLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV37_Ultimate"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = gethui() or game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Position = UDim2.new(0.5, -135, 0.5, -250)
Main.Size = UDim2.new(0, 270, 0, 520)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Text = "ADI MENU V37 PRO"; Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 22
Instance.new("UICorner", Title)

-- --- [BUILDER FUNCTIONS] ---
local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", Main)
    b.Text = txt; b.Size = UDim2.new(0.85, 0, 0, 38); b.Position = UDim2.new(0.075, 0, 0, pos)
    b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
    Instance.new("UICorner", b); return b
end

local function createSlider(title, pos, col)
    local t = Instance.new("TextLabel", Main)
    t.Text = title; t.Size = UDim2.new(1,0,0,20); t.Position = UDim2.new(0,0,0,pos); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(0.8,0.8,0.8); t.TextSize = 14
    local bg = Instance.new("Frame", Main)
    bg.Size = UDim2.new(0.8,0,0,6); bg.Position = UDim2.new(0.1,0,0,pos+25); bg.BackgroundColor3 = Color3.fromRGB(50,50,50)
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0,14,2.5,0); btn.Position = UDim2.new(0,0,-0.7,0); btn.Text = ""; btn.BackgroundColor3 = col; Instance.new("UICorner", btn)
    return btn, bg
end

-- --- [SLIDERS: SPEED & HITBOX] ---
local sSp, bSp = createSlider("WalkSpeed Adjuster", 55, Color3.fromRGB(0, 150, 255))
local sHi, bHi = createSlider("Hitbox Adjuster", 105, Color3.fromRGB(255, 50, 50))
local dS, dH = false, false
sSp.MouseButton1Down:Connect(function() dS = true end)
sHi.MouseButton1Down:Connect(function() dH = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false end end)

RunService.RenderStepped:Connect(function()
    local mX = UIS:GetMouseLocation().X
    if dS then
        local r = math.clamp((mX - bSp.AbsolutePosition.X) / bSp.AbsoluteSize.X, 0, 1)
        sSp.Position = UDim2.new(r, -7, -0.7, 0)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 16 + (r * 150) end
    elseif dH then
        local r = math.clamp((mX - bHi.AbsolutePosition.X) / bHi.AbsoluteSize.X, 0, 1)
        sHi.Position = UDim2.new(r, -7, -0.7, 0)
        local sz = 2 + (r * 48)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(sz, sz, sz); p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- --- [BUTTONS: FEATURES] ---
local WhB = createBtn("Wallhack Player (No Outline)", 165, Color3.fromRGB(80, 0, 150))
local GeB = createBtn("Generator ESP (Iceware Logic)", 210, Color3.fromRGB(160, 120, 0))
local ViB = createBtn("Visual Hitbox Line: OFF", 255, Color3.fromRGB(140, 0, 0))
local ScB = createBtn("AUTO PERFECT: OFF", 300, Color3.fromRGB(50, 50, 50))
local CrB = createBtn("Toggle Crosshair", 345, Color3.fromRGB(50, 50, 50))
createBtn("EXIT SCRIPT", 450, Color3.fromRGB(180, 0, 0)).MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- --- [LOGIC 1: ICEWARE-STYLE GENERATOR ESP] ---
GeB.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if (o.Name:lower():find("generator") or o.Name:lower():find("computer")) and (o:IsA("Model") or o:IsA("BasePart")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.OutlineTransparency = 1; h.Enabled = true
            
            task.spawn(function()
                while h.Enabled do
                    local finished = false
                    -- Scan Progres berdasarkan Warna Lampu & Nilai Progress
                    for _, v in pairs(o:GetDescendants()) do
                        if v:IsA("BasePart") and (v.Color.G > 0.8 and v.Color.R < 0.2) then
                            finished = true; break
                        elseif (v:IsA("NumberValue") or v:IsA("IntValue")) and (v.Value >= 100 or v.Value >= 1) then
                            finished = true; break
                        end
                    end
                    h.FillColor = finished and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
                    task.wait(1)
                end
            end)
        end
    end
end)

-- --- [LOGIC 2: ICEWARE-STYLE PERFECT SKILLCHECK] ---
local scOn = false
ScB.MouseButton1Click:Connect(function()
    scOn = not scOn; ScB.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScB.BackgroundColor3 = scOn and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.2)
end)

-- Menggunakan Heartbeat untuk Zero-Latency
RunService.Heartbeat:Connect(function()
    if not scOn then return end
    local ui = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI") or pGui:FindFirstChild("TugOfWar")
    if ui and ui.Enabled then
        local needle, white = nil, nil
        for _, v in pairs(ui:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                if v.BackgroundColor3 == Color3.new(1, 0, 0) or v.Name:lower():find("needle") then needle = v
                elseif v.BackgroundColor3 == Color3.new(1, 1, 1) or v.Name:lower():find("perfect") then white = v end
            end
        end
        if needle and white then
            local nRot = needle.Rotation % 360
            local wRot = white.Rotation % 360
            local diff = math.abs(nRot - wRot)
            
            -- Iceware menggunakan toleransi dinamis (12 derajat cukup untuk rata-rata ping)
            if diff <= 12 or diff >= 348 then
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.01); VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.5)
            end
        end
    end
end)

-- --- [OTHER FEATURES] ---
WhB.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            h.Name = "AdiESP"; h.OutlineTransparency = 1; h.Enabled = true
            h.FillColor = (p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("beast"))) and Color3.new(1,0,0) or Color3.new(0,0.4,1)
        end
    end
end)

local visOn = false
ViB.MouseButton1Click:Connect(function()
    visOn = not visOn; ViB.Text = visOn and "Visual Hitbox Line: ON" or "Visual Hitbox Line: OFF"
    ViB.BackgroundColor3 = visOn and Color3.new(0, 0.5, 0) or Color3.new(0.6, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local l = hrp:FindFirstChild("AdiVisual")
            if visOn then
                if not l then l = Instance.new("SelectionBox", hrp); l.Adornee = hrp; l.LineThickness = 0.05; l.Color3 = Color3.new(1,0,0); l.Name = "AdiVisual" end
            elseif l then l:Destroy() end
        end
    end
end)

local dot = Instance.new("Frame", ScreenGui); dot.Size = UDim2.new(0,6,0,6); dot.Position = UDim2.new(0.5,-3,0.5,-3); dot.BackgroundColor3 = Color3.new(1,0,0); dot.Visible = false; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
CrB.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.LeftControl then Main.Visible = not Main.Visible end end)
