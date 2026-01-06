-- [[ ADI PROJECT - V38 ULTRA PRECISION FIX ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- --- [ UI SETUP ] ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV38_Final"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = gethui() or game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Position = UDim2.new(0.5, -135, 0.5, -250); Main.Size = UDim2.new(0, 270, 0, 520)
Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Text = "ADI MENU V38 PRO"; Title.Size = UDim2.new(1, 0, 0, 45); Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 22; Instance.new("UICorner", Title)

-- --- [ BUILDER FUNCTIONS ] ---
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

-- --- [ FEATURES SLIDERS ] ---
local sSp, bSp = createSlider("WalkSpeed Adjuster", 55, Color3.fromRGB(0, 150, 255))
local sHi, bHi = createSlider("Hitbox Adjuster", 105, Color3.fromRGB(255, 50, 50))
local dS, dH = false, false
sSp.MouseButton1Down:Connect(function() dS = true end)
sHi.MouseButton1Down:Connect(function() dH = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false end end)

RunService.Heartbeat:Connect(function()
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

-- --- [ BUTTONS ] ---
local WhB = createBtn("Wallhack Player", 165, Color3.fromRGB(80, 0, 150))
local GeB = createBtn("Generator ESP (Color Fix)", 210, Color3.fromRGB(160, 120, 0))
local ViB = createBtn("Visual Hitbox Line: OFF", 255, Color3.fromRGB(140, 0, 0))
local ScB = createBtn("AUTO PERFECT: OFF", 300, Color3.fromRGB(50, 50, 50))
local CrB = createBtn("Toggle Crosshair", 345, Color3.fromRGB(50, 50, 50))
createBtn("EXIT SCRIPT", 450, Color3.fromRGB(180, 0, 0)).MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- --- [ LOGIC: AUTO PERFECT SKILLCHECK (SUPER FIX) ] ---
local scOn = false
ScB.MouseButton1Click:Connect(function()
    scOn = not scOn; ScB.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScB.BackgroundColor3 = scOn and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.2)
end)

local function press()
    VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.01)
    VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

RunService.RenderStepped:Connect(function()
    if not scOn then return end
    
    -- Mencari semua ScreenGui untuk menemukan UI Skillcheck
    for _, gui in pairs(pGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            local needle = nil
            local white = nil
            
            -- Scan mendalam mencari jarum merah dan zona putih
            for _, v in pairs(gui:GetDescendants()) do
                if v:IsA("GuiObject") and v.Visible and v.AbsoluteSize.X > 0 then
                    -- Deteksi Jarum (Biasanya merah atau tipis)
                    if v.BackgroundColor3 == Color3.new(1, 0, 0) or v.Name:lower():find("needle") or v.Name:lower():find("pointer") then
                        needle = v
                    -- Deteksi Zona Putih (Perfect)
                    elseif v.BackgroundColor3 == Color3.new(1, 1, 1) or v.Name:lower():find("perfect") or v.Name:lower():find("target") then
                        white = v
                    end
                end
            end
            
            if needle and white then
                -- Metode 1: Jarak Absolut (Paling Mantap untuk Radial/Melingkar)
                local nPos = needle.AbsolutePosition + (needle.AbsoluteSize / 2)
                local wPos = white.AbsolutePosition + (white.AbsoluteSize / 2)
                local distance = (nPos - wPos).Magnitude
                
                -- Metode 2: Rotasi (Backup)
                local nRot = needle.Rotation % 360
                local wRot = white.Rotation % 360
                local diff = math.abs(nRot - wRot)
                
                -- Jika Jarak sangat dekat ATAU Rotasi hampir sama
                if distance < 10 or diff < 12 or diff > 348 then
                    press()
                    task.wait(0.6) -- Cooldown
                end
            end
        end
    end
end)

-- --- [ LOGIC: GEN ESP & WH ] ---
GeB.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if (o.Name:lower():find("generator") or o.Name:lower():find("computer")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.OutlineTransparency = 1; h.Enabled = true
            task.spawn(function()
                while h.Enabled do
                    local fin = false
                    for _, v in pairs(o:GetDescendants()) do
                        if v:IsA("BasePart") and v.Color.G > 0.7 and v.Color.R < 0.3 then fin = true break end
                        if (v:IsA("ValueBase")) and (v.Value == 100 or v.Value == 1) then fin = true break end
                    end
                    h.FillColor = fin and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
                    task.wait(1.5)
                end
            end)
        end
    end
end)

WhB.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            h.Name = "AdiESP"; h.OutlineTransparency = 1; h.Enabled = true
            h.FillColor = (p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("beast"))) and Color3.new(1,0,0) or Color3.new(0,0.4,1)
        end
    end
end)

UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.LeftControl then Main.Visible = not Main.Visible end end)
