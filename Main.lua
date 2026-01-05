-- [[ ADI PROJECT - MAIN SCRIPT V5 CLEAN ]] --

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
MainFrame.Size = UDim2.new(0, 260, 0, 400) -- Ukuran disesuaikan agar rapi
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Text = "ADI MENU PRO FINAL"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- --- FITUR HIDE/SHOW (L-CTRL) ---
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)

-- --- FITUR WALK SPEED (SLIDER + TYPING) ---
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

local function setSpeed(value)
    local val = math.clamp(tonumber(value) or 16, 16, 250)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = val
        SpeedLabel.Text = "WalkSpeed: " .. math.floor(val)
        SpeedInput.Text = math.floor(val)
    end
end

local dragging = false
SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = SliderBg.AbsolutePosition.X
        local sliderWidth = SliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        SliderBtn.Position = UDim2.new(percent, -7, -0.4, 0)
        setSpeed(16 + (percent * 234))
    end
end)
SpeedInput.FocusLost:Connect(function() setSpeed(SpeedInput.Text) end)

-- --- FITUR WALLHACK (ESP) ---
local WhBtn = Instance.new("TextButton", MainFrame)
WhBtn.Text = "Wallhack (ESP)"
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

-- --- FITUR KILLER HITBOX (LOGIC) ---
local HitboxLabel = Instance.new("TextLabel", MainFrame)
HitboxLabel.Text = "Hitbox: 2 (100%)"
HitboxLabel.Size = UDim2.new(1, 0, 0, 20)
HitboxLabel.Position = UDim2.new(0, 0, 0, 170)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.TextColor3 = Color3.new(1, 1, 1)

local HitboxInput = Instance.new("TextBox", MainFrame)
HitboxInput.Size = UDim2.new(0.8, 0, 0, 25)
HitboxInput.Position = UDim2.new(0.1, 0, 0, 195)
HitboxInput.PlaceholderText = "Set Hitbox (ex: 15)"
HitboxInput.Text = "2"
HitboxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HitboxInput.TextColor3 = Color3.new(1, 1, 1)

local function extendHitbox(size)
    local s = tonumber(size) or 2
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(s, s, s)
            p.Character.HumanoidRootPart.CanCollide = false
        end
    end
    HitboxLabel.Text = "Hitbox: " .. s .. " (" .. math.floor((s/2)*100) .. "%)"
end
HitboxInput.FocusLost:Connect(function(ep) if ep then extendHitbox(HitboxInput.Text) end end)

-- --- VISUAL HITBOX (LINE ONLY) ---
local VisualBtn = Instance.new("TextButton", MainFrame)
VisualBtn.Text = "Visual Hitbox: OFF"
VisualBtn.Size = UDim2.new(0.8, 0, 0, 30)
VisualBtn.Position = UDim2.new(0.1, 0, 0, 230)
VisualBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VisualBtn.TextColor3 = Color3.new(1, 1, 1)

local visualEnabled = false
local function updateVisuals()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local selection = hrp:FindFirstChild("AdiHitboxVisual")
            if visualEnabled then
                if not selection then
                    selection = Instance.new("SelectionBox", hrp)
                    selection.Name = "AdiHitboxVisual"
                    selection.LineThickness = 0.05
                    selection.SurfaceTransparency = 1
                    selection.Adornee = hrp
                end
            else
                if selection then selection:Destroy() end
            end
        end
    end
end

VisualBtn.MouseButton1Click:Connect(function()
    visualEnabled = not visualEnabled
    VisualBtn.Text = visualEnabled and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    VisualBtn.BackgroundColor3 = visualEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    updateVisuals()
end)
RunService.Heartbeat:Connect(function() if visualEnabled then updateVisuals() end end)

-- --- FITUR CROSSHAIR ---
local CrBtn = Instance.new("TextButton", MainFrame)
CrBtn.Text = "Toggle Crosshair"
CrBtn.Size = UDim2.new(0.8, 0, 0, 30)
CrBtn.Position = UDim2.new(0.1, 0, 0, 270)
CrBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
CrBtn.TextColor3 = Color3.new(1, 1, 1)

local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 4, 0, 4)
dot.Position = UDim2.new(0.5, -2, 0.5, -2)
dot.BackgroundColor3 = Color3.new(1, 0, 0)
dot.Visible = false
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

-- --- FITUR AUTO SKILLCHECK ---
local ScBtn = Instance.new("TextButton", MainFrame)
ScBtn.Text = "Auto Skillcheck: OFF"
ScBtn.Size = UDim2.new(0.8, 0, 0, 30)
ScBtn.Position = UDim2.new(0.1, 0, 0, 310)
ScBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ScBtn.TextColor3 = Color3.new(1, 1, 1)

local autoSkillEnabled = false
ScBtn.MouseButton1Click:Connect(function()
    autoSkillEnabled = not autoSkillEnabled
    ScBtn.Text = autoSkillEnabled and "Auto Skillcheck: ON" or "Auto Skillcheck: OFF"
    ScBtn.BackgroundColor3 = autoSkillEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

RunService.RenderStepped:Connect(function()
    if not autoSkillEnabled then return end
    local gui = lp.PlayerGui:FindFirstChild("SkillCheck") or lp.PlayerGui:FindFirstChild("ActionUI")
    if gui and gui.Visible then
        local bar = gui:FindFirstChild("Bar")
        local zone = gui:FindFirstChild("PerfectZone") or gui:FindFirstChild("SuccessZone")
        if bar and zone then
            local bP = bar.AbsolutePosition.X
            local zS = zone.AbsolutePosition.X
            local zE = zS + zone.AbsoluteSize.X
            if bP >= zS and bP <= zE then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end
        end
    end
end)
