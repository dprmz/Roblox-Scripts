-- [[ ADI PROJECT - V15 ULTRA-STABLE ]] --

-- 1. DETEKSI LOADING SCREEN GAME (SOLUSI BLACKSCREEN)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Cari LoadingGui bawaan game jika ada dan tunggu sampai hilang
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")

local function waitForLoadingToFinish()
    -- Cek jika ada ScreenGui yang namanya mengandung "Loading" atau "Intro"
    for _, gui in pairs(pGui:GetChildren()) do
        if gui:IsA("ScreenGui") and (gui.Name:lower():find("load") or gui.Name:lower():find("intro")) then
            repeat task.wait(1) until not gui.Enabled or not gui.Parent
        end
    end
end

waitForLoadingToFinish()
task.wait(7) -- Jeda "Napas" Engine (Sangat Penting)

-- 2. KONFIGURASI SERVICE
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 3. PEMBUATAN UI SECARA BERTAHAP (ASYNC)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV15_Stable"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Coba pasang UI di CoreGui agar tidak bentrok dengan PlayerGui game
local success, err = pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent = game:GetService("CoreGui")
    else ScreenGui.Parent = pGui end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.Size = UDim2.new(0, 260, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true -- Menu muncul setelah loading aman

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ADI MENU PRO V15"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Instance.new("UICorner", Title)

-- --- [MOUSE & MOVEMENT FIX] ---
local menuOpen = true
RunService.RenderStepped:Connect(function()
    if menuOpen and MainFrame.Visible then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
    end
end)

-- --- [UI BUILDER: SLIDERS] ---
local function createSlider(titleT, labelT, posY, color)
    local t = Instance.new("TextLabel", MainFrame)
    t.Text = titleT; t.Size = UDim2.new(1,0,0,20); t.Position = UDim2.new(0,0,0,posY); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(180,180,180); t.TextSize = 12
    local l = Instance.new("TextLabel", MainFrame)
    l.Text = labelT; l.Size = UDim2.new(1,0,0,20); l.Position = UDim2.new(0,0,0,posY+15); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.SourceSansBold
    local bg = Instance.new("Frame", MainFrame)
    bg.Size = UDim2.new(0.8,0,0,6); bg.Position = UDim2.new(0.1,0,0,posY+42); bg.BackgroundColor3 = Color3.fromRGB(45,45,45); bg.BorderSizePixel = 0; Instance.new("UICorner", bg)
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0,12,2.5,0); btn.Position = UDim2.new(0,0,-0.7,0); btn.Text = ""; btn.BackgroundColor3 = color; Instance.new("UICorner", btn)
    return btn, l, bg
end

local SpdBtn, SpdL, SpdBg = createSlider("WalkSpeed Adjuster", "Speed: 16", 45, Color3.fromRGB(0, 170, 255))
local HitBtn, HitL, HitBg = createSlider("Hitbox Extender", "Size: 2", 105, Color3.fromRGB(255, 50, 50))

-- Logic Slider (Optimized)
local dS, dH = false, false
SpdBtn.MouseButton1Down:Connect(function() dS = true end)
HitBtn.MouseButton1Down:Connect(function() dH = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false, false end end)

RunService.RenderStepped:Connect(function()
    local mX = UserInputService:GetMouseLocation().X
    if dS then
        local rX = math.clamp((mX - SpdBg.AbsolutePosition.X) / SpdBg.AbsoluteSize.X, 0, 1)
        SpdBtn.Position = UDim2.new(rX, -6, -0.7, 0)
        local val = 16 + (rX * 184)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = val; SpdL.Text = "Speed: "..math.floor(val) end
    end
    if dH then
        local rX = math.clamp((mX - HitBg.AbsolutePosition.X) / HitBg.AbsoluteSize.X, 0, 1)
        HitBtn.Position = UDim2.new(rX, -6, -0.7, 0)
        local size = math.floor(2 + (rX * 48))
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
        HitL.Text = "Size: "..size
    end
end)

-- --- [UI BUILDER: BUTTONS] ---
local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", MainFrame)
    b.Text = txt; b.Size = UDim2.new(0.8,0,0,32); b.Position = UDim2.new(0.1,0,0,pos); b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.BorderSizePixel = 0; Instance.new("UICorner", b)
    return b
end

local WhBtn = createBtn("Wallhack Player", 185, Color3.fromRGB(70, 0, 130))
local GenBtn = createBtn("ESP Generator", 225, Color3.fromRGB(160, 120, 0))
local VisBtn = createBtn("Visual Hitbox: OFF", 265, Color3.fromRGB(140, 0, 0))
local CrBtn = createBtn("Toggle Crosshair", 305, Color3.fromRGB(50, 50, 50))
local ScBtn = createBtn("Auto Skillcheck: OFF", 345, Color3.fromRGB(140, 0, 0))

-- Fitur Logic (Visuals & Skillcheck)
local vE = false
VisBtn.MouseButton1Click:Connect(function()
    vE = not vE
    VisBtn.Text = vE and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    VisBtn.BackgroundColor3 = vE and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local s = hrp:FindFirstChild("AdiVisual")
            if vE then
                if not s then s = Instance.new("SelectionBox", hrp); s.Name = "AdiVisual"; s.LineThickness = 0.05; s.Color3 = Color3.new(1,0,0); s.Adornee = hrp end
            elseif s then s:Destroy() end
        end
    end
end)

-- Wallhack & Generator ESP tetap sama
WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"; hl.FillColor = (p.Team and p.Team.Name:lower():find("killer")) and Color3.new(1,0,0) or Color3.new(0, 0.6, 1); hl.Enabled = true
        end
    end
end)

GenBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("generator") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            local hl = obj:FindFirstChild("GenESP") or Instance.new("Highlight", obj); hl.Name = "GenESP"; hl.FillColor = Color3.new(1, 1, 0); hl.Enabled = true
        end
    end
end)

-- Skillcheck logic
local aS = false
ScBtn.MouseButton1Click:Connect(function()
    aS = not aS
    ScBtn.Text = aS and "Auto Skillcheck: ON" or "Auto Skillcheck: OFF"
    ScBtn.BackgroundColor3 = aS and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

RunService.RenderStepped:Connect(function()
    if not aS then return end
    local gui = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI")
    if gui and gui.Visible then
        local bar = gui:FindFirstChild("Bar"); local zone = gui:FindFirstChild("PerfectZone") or gui:FindFirstChild("SuccessZone")
        if bar and zone then
            local bP, zS = bar.AbsolutePosition.X, zone.AbsolutePosition.X
            if bP >= zS and bP <= (zS + zone.AbsoluteSize.X) then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05); game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end
        end
    end
end)

warn("V15 READY - Loading Screen Guard Enabled")
