-- [[ ADI PROJECT - MAIN SCRIPT V6 (ESP GEN) ]] --

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local players = game:GetService("Players")
local lp = players.LocalPlayer

-- 1. Setup ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiMenuGui"
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. Setup Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.Size = UDim2.new(0, 260, 0, 440) -- Ukuran diperpanjang untuk tombol baru
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Text = "ADI MENU PRO V6"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- --- FITUR HIDE/SHOW (L-CTRL) ---
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)

-- --- FITUR WALK SPEED ---
local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Text = "WalkSpeed: 16"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)

local SliderBg = Instance.new("Frame", MainFrame)
SliderBg.Size = UDim2.new(0.8, 0, 0, 8)
SliderBg.Position = UDim2.new(0.1, 0, 0, 75)
SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local SliderBtn = Instance.new("TextButton", SliderBg)
SliderBtn.Size = UDim2.new(0, 15, 1.8, 0)
SliderBtn.Position = UDim2.new(0, 0, -0.4, 0)
SliderBtn.Text = ""
SliderBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)

local SpeedInput = Instance.new("TextBox", MainFrame)
SpeedInput.Size = UDim2.new(0.4, 0, 0, 25)
SpeedInput.Position = UDim2.new(0.3, 0, 0, 90)
SpeedInput.PlaceholderText = "Type Speed"
SpeedInput.Text = "16"
SpeedInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpeedInput.TextColor3 = Color3.new(1,1,1)

local function setSpeed(v)
    local val = math.clamp(tonumber(v) or 16, 16, 250)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = val
        SpeedLabel.Text = "WalkSpeed: " .. math.floor(val)
        SpeedInput.Text = math.floor(val)
    end
end

local dragging = false
SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mP = UserInputService:GetMouseLocation().X
        local sP = SliderBg.AbsolutePosition.X
        local sW = SliderBg.AbsoluteSize.X
        local pc = math.clamp((mP - sP) / sW, 0, 1)
        SliderBtn.Position = UDim2.new(pc, -7, -0.4, 0)
        setSpeed(16 + (pc * 234))
    end
end)
SpeedInput.FocusLost:Connect(function() setSpeed(SpeedInput.Text) end)

-- --- FITUR WALLHACK (ESP PLAYER) ---
local WhBtn = Instance.new("TextButton", MainFrame)
WhBtn.Text = "Wallhack Player"
WhBtn.Size = UDim2.new(0.8, 0, 0, 30)
WhBtn.Position = UDim2.new(0.1, 0, 0, 130)
WhBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
WhBtn.TextColor3 = Color3.new(1, 1, 1)

WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"
            hl.FillTransparency = 0.4
            local isKiller = false
            if p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("murder")) then isKiller = true end
            hl.FillColor = isKiller and Color3.new(1,0,0) or Color3.new(0, 0.6, 1)
            hl.Enabled = true
        end
    end
end)

-- --- FITUR ESP GENERATOR (NEW) ---
local GenBtn = Instance.new("TextButton", MainFrame)
GenBtn.Text = "ESP Generator"
GenBtn.Size = UDim2.new(0.8, 0, 0, 30)
GenBtn.Position = UDim2.new(0.1, 0, 0, 170)
GenBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0) -- Oranye/Kuning
GenBtn.TextColor3 = Color3.new(1, 1, 1)

GenBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        -- Cek objek yang namanya mengandung "Generator"
        if obj.Name:lower():find("generator") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            local hl = obj:FindFirstChild("GenESP") or Instance.new("Highlight", obj)
            hl.Name = "GenESP"
            hl.FillColor = Color3.fromRGB(255, 255, 0) -- Kuning Terang
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.FillTransparency = 0.5
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled = true
        end
    end
    print("[ ADI ] Generator ESP Activated")
end)

-- --- FITUR KILLER HITBOX ---
local HitboxLabel = Instance.new("TextLabel", MainFrame)
HitboxLabel.Text = "Hitbox: 2 (100%)"
HitboxLabel.Size = UDim2.new(1, 0, 0, 20)
HitboxLabel.Position = UDim2.new(0, 0, 0, 210)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.TextColor3 = Color3.new(1, 1, 1)

local HitboxInput = Instance.new("TextBox", MainFrame)
HitboxInput.Size = UDim2.new(0.8, 0, 0, 25)
HitboxInput.Position = UDim2.new(0.1, 0, 0, 235)
HitboxInput.PlaceholderText = "Set Hitbox (ex: 15)"
HitboxInput.Text = "2"
HitboxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HitboxInput.TextColor3 = Color3.new(1, 1, 1)

local function extendHitbox(s)
    local size = tonumber(s) or 2
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
            p.Character.HumanoidRootPart.CanCollide = false
        end
    end
    HitboxLabel.Text = "Hitbox: " .. size .. " (" .. math.floor((size/2)*100) .. "%)"
end
HitboxInput.FocusLost:Connect(function(ep) if ep then extendHitbox(HitboxInput.Text) end end)

-- --- VISUAL HITBOX ---
local VisualBtn = Instance.new("TextButton", MainFrame)
VisualBtn.Text = "Visual Hitbox: OFF"
VisualBtn.Size = UDim2.new(0.8, 0, 0, 30)
VisualBtn.Position = UDim2.new(0.1, 0, 0, 270)
VisualBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VisualBtn.TextColor3 = Color3.new(1, 1, 1)

local vE = false
VisualBtn.MouseButton1Click:Connect(function()
    vE = not vE
    VisualBtn.Text = vE and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    VisualBtn.BackgroundColor3 = vE and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    if vE then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local s = hrp:FindFirstChild("AdiHitboxVisual") or Instance.new("SelectionBox", hrp)
                s.Name = "AdiHitboxVisual"
                s.Adornee = hrp
                s.LineThickness = 0.05
                s.SurfaceTransparency = 1
            end
        end
    else
        for _, p in pairs(players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local s = p.Character.HumanoidRootPart:FindFirstChild("AdiHitboxVisual")
                if s then s:Destroy() end
            end
        end
    end
end)

-- --- CROSSHAIR & AUTO SKILLCHECK ---
local CrBtn = Instance.new("TextButton", MainFrame)
CrBtn.Text = "Toggle Crosshair"
CrBtn.Size = UDim2.new(0.8, 0, 0, 30)
CrBtn.Position = UDim2.new(0.1, 0, 0, 310)
CrBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 0)

local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 4, 0, 4)
dot.Position = UDim2.new(0.5, -2, 0.5, -2)
dot.BackgroundColor3 = Color3.new(1, 0, 0)
dot.Visible = false
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

local ScBtn = Instance.new("TextButton", MainFrame)
ScBtn.Text = "Auto Skillcheck: OFF"
ScBtn.Size = UDim2.new(0.8, 0, 0, 30)
ScBtn.Position = UDim2.new(0.1, 0, 0, 350)
ScBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local aS = false
ScBtn.MouseButton1Click:Connect(function()
    aS = not aS
    ScBtn.Text = aS and "Auto Skillcheck: ON" or "Auto Skillcheck: OFF"
    ScBtn.BackgroundColor3 = aS and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

RunService.RenderStepped:Connect(function()
    if not aS then return end
    local gui = lp.PlayerGui:FindFirstChild("SkillCheck") or lp.PlayerGui:FindFirstChild("ActionUI")
    if gui and gui.Visible then
        local bar = gui:FindFirstChild("Bar")
        local zone = gui:FindFirstChild("PerfectZone") or gui:FindFirstChild("SuccessZone")
        if bar and zone then
            local bP, zS = bar.AbsolutePosition.X, zone.AbsolutePosition.X
            if bP >= zS and bP <= (zS + zone.AbsoluteSize.X) then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end
        end
    end
end)
