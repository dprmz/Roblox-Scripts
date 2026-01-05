-- [[ ADI PROJECT - MAIN SCRIPT FINAL V8 ]] --

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
MainFrame.Size = UDim2.new(0, 260, 0, 420) 
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Text = "ADI MENU PRO FINAL V8"
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

-- --- [1] WALK SPEED SLIDER ---
local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Text = "WalkSpeed: 16"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)

local SliderSpdBg = Instance.new("Frame", MainFrame)
SliderSpdBg.Size = UDim2.new(0.8, 0, 0, 8)
SliderSpdBg.Position = UDim2.new(0.1, 0, 0, 75)
SliderSpdBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local SliderSpdBtn = Instance.new("TextButton", SliderSpdBg)
SliderSpdBtn.Size = UDim2.new(0, 15, 1.8, 0)
SliderSpdBtn.Position = UDim2.new(0, 0, -0.4, 0)
SliderSpdBtn.Text = ""
SliderSpdBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)

-- --- [2] HITBOX SLIDER ---
local HitboxLabel = Instance.new("TextLabel", MainFrame)
HitboxLabel.Text = "Hitbox Size: 2 (100%)"
HitboxLabel.Size = UDim2.new(1, 0, 0, 20)
HitboxLabel.Position = UDim2.new(0, 0, 0, 100)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.TextColor3 = Color3.new(1, 1, 1)

local SliderHitBg = Instance.new("Frame", MainFrame)
SliderHitBg.Size = UDim2.new(0.8, 0, 0, 8)
SliderHitBg.Position = UDim2.new(0.1, 0, 0, 125)
SliderHitBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local SliderHitBtn = Instance.new("TextButton", SliderHitBg)
SliderHitBtn.Size = UDim2.new(0, 15, 1.8, 0)
SliderHitBtn.Position = UDim2.new(0, 0, -0.4, 0)
SliderHitBtn.Text = ""
SliderHitBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

-- --- FUNGSI LOGIKA SLIDER ---
local draggingSpd = false
local draggingHit = false

SliderSpdBtn.MouseButton1Down:Connect(function() draggingSpd = true end)
SliderHitBtn.MouseButton1Down:Connect(function() draggingHit = true end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSpd = false
        draggingHit = false
    end
end)

RunService.RenderStepped:Connect(function()
    local mouseX = UserInputService:GetMouseLocation().X
    
    if draggingSpd then
        local relX = math.clamp((mouseX - SliderSpdBg.AbsolutePosition.X) / SliderSpdBg.AbsoluteSize.X, 0, 1)
        SliderSpdBtn.Position = UDim2.new(relX, -7, -0.4, 0)
        local val = 16 + (relX * 234)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = val
            SpeedLabel.Text = "WalkSpeed: " .. math.floor(val)
        end
    end
    
    if draggingHit then
        local relX = math.clamp((mouseX - SliderHitBg.AbsolutePosition.X) / SliderHitBg.AbsoluteSize.X, 0, 1)
        SliderHitBtn.Position = UDim2.new(relX, -7, -0.4, 0)
        local size = math.floor(2 + (relX * 48))
        for _, p in pairs(players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
        HitboxLabel.Text = "Hitbox Size: " .. size .. " (" .. math.floor((size/2)*100) .. "%)"
    end
end)

-- --- TOMBOL FITUR LAINNYA ---

local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Text = text
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Position = UDim2.new(0.1, 0, 0, pos)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    return btn
end

local WhBtn = createBtn("Wallhack Player", 155, Color3.fromRGB(80, 0, 150))
local GenBtn = createBtn("ESP Generator", 195, Color3.fromRGB(180, 140, 0))
local VisBtn = createBtn("Visual Hitbox: OFF", 235, Color3.fromRGB(150, 0, 0))
local CrBtn = createBtn("Toggle Crosshair", 275, Color3.fromRGB(60, 60, 60))
local ScBtn = createBtn("Auto Skillcheck: OFF", 315, Color3.fromRGB(150, 0, 0))

-- --- LOGIKA TOMBOL ---

WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"
            hl.FillTransparency = 0.4
            local isKiller = (p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("murder")))
            hl.FillColor = isKiller and Color3.new(1,0,0) or Color3.new(0, 0.6, 1)
            hl.Enabled = true
        end
    end
end)

GenBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name:lower():find("generator") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            local hl = obj:FindFirstChild("GenESP") or Instance.new("Highlight", obj)
            hl.Name = "GenESP"
            hl.FillColor = Color3.fromRGB(255, 255, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    end
end)

local visualEnabled = false
VisBtn.MouseButton1Click:Connect(function()
    visualEnabled = not visualEnabled
    VisBtn.Text = visualEnabled and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    VisBtn.BackgroundColor3 = visualEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local s = hrp:FindFirstChild("AdiHitboxVisual")
            if visualEnabled then
                if not s then
                    s = Instance.new("SelectionBox", hrp)
                    s.Name = "AdiHitboxVisual"
                    s.LineThickness = 0.05
                    s.SurfaceTransparency = 1
                    s.Adornee = hrp
                end
            elseif s then s:Destroy() end
        end
    end
end)

local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 4, 0, 4)
dot.Position = UDim2.new(0.5, -2, 0.5, -2)
dot.BackgroundColor3 = Color3.new(1, 0, 0)
dot.Visible = false
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

local autoSkill = false
ScBtn.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    ScBtn.Text = autoSkill and "Auto Skillcheck: ON" or "Auto Skillcheck: OFF"
    ScBtn.BackgroundColor3 = autoSkill and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

RunService.RenderStepped:Connect(function()
    if not autoSkill then return end
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
