-- [[ ADI PROJECT - FINAL FIX V13 (MOUSE MOVEMENT FIX) ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local players = game:GetService("Players")
local lp = players.LocalPlayer

-- 1. SETUP GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiMenuGui"
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.Size = UDim2.new(0, 260, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true -- Default terbuka biar kelihatan

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ADI MENU PRO V13"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Instance.new("UICorner", Title)

-- --- [FIX: MOUSE MOVEMENT LOGIC] ---
local menuOpen = true

local function UpdateMouseState()
    if menuOpen then
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    else
        -- Kembalikan ke normal sesuai setting game
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end

-- Force mouse behavior agar tidak ditarik ke tengah oleh game
RunService.RenderStepped:Connect(function()
    if menuOpen then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
        UpdateMouseState()
    end
end)

-- Inisialisasi awal kursor
UpdateMouseState()

-- --- [SLIDER & BUTTONS COPY DARI V12 DENGAN PENYESUAIAN] ---

local function createSlider(titleText, labelText, posY, color)
    local title = Instance.new("TextLabel", MainFrame)
    title.Text = titleText
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, posY)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(180, 180, 180)
    title.TextSize = 12

    local label = Instance.new("TextLabel", MainFrame)
    label.Text = labelText
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, posY + 15)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold

    local bg = Instance.new("Frame", MainFrame)
    bg.Size = UDim2.new(0.8, 0, 0, 6)
    bg.Position = UDim2.new(0.1, 0, 0, posY + 42)
    bg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg)

    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0, 12, 2.5, 0)
    btn.Position = UDim2.new(0, 0, -0.7, 0)
    btn.Text = ""
    btn.BackgroundColor3 = color
    Instance.new("UICorner", btn)

    return btn, label, bg
end

local SpdBtn, SpdLabel, SpdBg = createSlider("WalkSpeed Adjuster", "Speed: 16", 45, Color3.fromRGB(0, 170, 255))
local HitBtn, HitLabel, HitBg = createSlider("Hitbox Extender", "Size: 2", 105, Color3.fromRGB(255, 50, 50))

local dragSpd, dragHit = false, false
SpdBtn.MouseButton1Down:Connect(function() dragSpd = true end)
HitBtn.MouseButton1Down:Connect(function() dragHit = true end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragSpd, dragHit = false, false end
end)

RunService.RenderStepped:Connect(function()
    local mX = UserInputService:GetMouseLocation().X
    if dragSpd then
        local rX = math.clamp((mX - SpdBg.AbsolutePosition.X) / SpdBg.AbsoluteSize.X, 0, 1)
        SpdBtn.Position = UDim2.new(rX, -6, -0.7, 0)
        local val = 16 + (rX * 184)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = val
            SpdLabel.Text = "Speed: " .. math.floor(val)
        end
    end
    if dragHit then
        local rX = math.clamp((mX - HitBg.AbsolutePosition.X) / HitBg.AbsoluteSize.X, 0, 1)
        HitBtn.Position = UDim2.new(rX, -6, -0.7, 0)
        local size = math.floor(2 + (rX * 48))
        for _, p in pairs(players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
        HitLabel.Text = "Size: " .. size
    end
end)

local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Text = text
    btn.Size = UDim2.new(0.8, 0, 0, 32)
    btn.Position = UDim2.new(0.1, 0, 0, pos)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    return btn
end

local WhBtn = createBtn("Wallhack Player", 185, Color3.fromRGB(70, 0, 130))
local GenBtn = createBtn("ESP Generator", 225, Color3.fromRGB(160, 120, 0))
local VisBtn = createBtn("Visual Hitbox: OFF", 265, Color3.fromRGB(140, 0, 0))
local CrBtn = createBtn("Toggle Crosshair", 305, Color3.fromRGB(50, 50, 50))
local ScBtn = createBtn("Auto Skillcheck: OFF", 345, Color3.fromRGB(140, 0, 0))

-- LOGIC FITUR (ESP, Visual, Skillcheck)
local vE = false
VisBtn.MouseButton1Click:Connect(function()
    vE = not vE
    VisBtn.Text = vE and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    VisBtn.BackgroundColor3 = vE and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local s = hrp:FindFirstChild("AdiVisual")
            if vE then
                if not s then
                    s = Instance.new("SelectionBox", hrp)
                    s.Name = "AdiVisual"
                    s.LineThickness = 0.05
                    s.Color3 = Color3.new(1, 0, 0)
                    s.Adornee = hrp
                end
            elseif s then s:Destroy() end
        end
    end
end)

WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"
            local isKiller = (p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("murder")))
            hl.FillColor = isKiller and Color3.new(1,0,0) or Color3.new(0, 0.6, 1)
            hl.Enabled = true
        end
    end
end)

GenBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("generator") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            local hl = obj:FindFirstChild("GenESP") or Instance.new("Highlight", obj)
            hl.Name = "GenESP"
            hl.FillColor = Color3.fromRGB(255, 255, 0)
            hl.Enabled = true
        end
    end
end)

local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 4, 0, 4)
dot.Position = UDim2.new(0.5, -2, 0.5, -2)
dot.BackgroundColor3 = Color3.new(1, 0, 0)
dot.Visible = false
Instance.new("UICorner", dot)
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

local aS = false
ScBtn.MouseButton1Click:Connect(function()
    aS = not aS
    ScBtn.Text = aS and "Auto Skillcheck: ON" or "Auto Skillcheck: OFF"
    ScBtn.BackgroundColor3 = aS and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
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
