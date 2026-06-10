-- [[ ADI PROJECT - V33 IMAGE-BASED FIX + AUTO AIM ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- 1. UI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV33_Final"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = gethui() or game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Position = UDim2.new(0.5, -135, 0.5, -250)
Main.Size = UDim2.new(0, 270, 0, 550) -- Resized untuk tombol baru
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Text = "ADI MENU PRO V33 + AIM"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 20
Instance.new("UICorner", Title)

-- --- [FUNGSI PEMBUAT TOMBOL & SLIDER] ---
local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", Main)
    b.Text = txt; b.Size = UDim2.new(0.85, 0, 0, 38); b.Position = UDim2.new(0.075, 0, 0, pos)
    b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
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

-- --- [SLIDERS] ---
local sSpd, bSpd = createSlider("WalkSpeed Adjuster", 50, Color3.fromRGB(0, 150, 255))
local sHit, bHit = createSlider("Hitbox Adjuster", 100, Color3.fromRGB(255, 50, 50))
local sAimSmooth, bAimSmooth = createSlider("Aim Smoothness", 150, Color3.fromRGB(0, 255, 100))
local sAimFOV, bAimFOV = createSlider("Aim FOV (Radius)", 200, Color3.fromRGB(255, 200, 0))

local dS, dH, dAS, dAF = false, false, false, false
sSpd.MouseButton1Down:Connect(function() dS = true end)
sHit.MouseButton1Down:Connect(function() dH = true end)
sAimSmooth.MouseButton1Down:Connect(function() dAS = true end)
sAimFOV.MouseButton1Down:Connect(function() dAF = true end)

UIS.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        dS, dH, dAS, dAF = false, false, false, false
    end 
end)

-- Variabel untuk Aim
local aimEnabled = false
local aimSmoothness = 0.3 -- 0-1 (0 = instant, 1 = very smooth)
local aimFOV = 200 -- radius dalam pixels
local currentTarget = nil
local rightMousePressed = false

-- Update slider values
RunService.RenderStepped:Connect(function()
    local mX = UIS:GetMouseLocation().X
    if dS then
        local r = math.clamp((mX - bSpd.AbsolutePosition.X) / bSpd.AbsoluteSize.X, 0, 1)
        sSpd.Position = UDim2.new(r, -7, -0.7, 0)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 16 + (r * 150) end
    elseif dH then
        local r = math.clamp((mX - bHit.AbsolutePosition.X) / bHit.AbsoluteSize.X, 0, 1)
        sHit.Position = UDim2.new(r, -7, -0.7, 0)
        local sz = 2 + (r * 48)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(sz, sz, sz); p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    elseif dAS then
        local r = math.clamp((mX - bAimSmooth.AbsolutePosition.X) / bAimSmooth.AbsoluteSize.X, 0, 1)
        sAimSmooth.Position = UDim2.new(r, -7, -0.7, 0)
        aimSmoothness = r * 0.9 + 0.1 -- Range 0.1 - 1.0
    elseif dAF then
        local r = math.clamp((mX - bAimFOV.AbsolutePosition.X) / bAimFOV.AbsoluteSize.X, 0, 1)
        sAimFOV.Position = UDim2.new(r, -7, -0.7, 0)
        aimFOV = 50 + (r * 350) -- Range 50 - 400 pixels
    end
end)

-- --- [AUTO AIM CORE FUNCTION] ---
local function getClosestTarget()
    local mouseLoc = UIS:GetMouseLocation()
    local closestDist = aimFOV
    local closest = nil
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local hrp = p.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouseLoc.X, mouseLoc.Y)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = p
                end
            end
        end
    end
    return closest
end

local function smoothAim(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0) -- Aim ke kepala/dada
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
    
    -- Interpolasi smooth
    local newCFrame = currentCFrame:Lerp(targetCFrame, aimSmoothness)
    Camera.CFrame = newCFrame
end

-- --- [BUTTONS] ---
local AimB = createBtn("AUTO AIM: OFF (Hold RMB)", 155, Color3.fromRGB(200, 50, 50))
local WhB = createBtn("Wallhack Player", 200, Color3.fromRGB(80, 0, 150))
local GeB = createBtn("Generator ESP (Color Fix)", 245, Color3.fromRGB(160, 120, 0))
local ViB = createBtn("Visual Hitbox Line: OFF", 290, Color3.fromRGB(140, 0, 0))
local ScB = createBtn("AUTO PERFECT: OFF", 335, Color3.fromRGB(50, 50, 50))
local CrB = createBtn("Toggle Crosshair", 380, Color3.fromRGB(50, 50, 50))
createBtn("CLOSE SCRIPT", 485, Color3.fromRGB(180, 0, 0)).MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Toggle Auto Aim
AimB.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    AimB.Text = aimEnabled and "AUTO AIM: ON (Hold RMB)" or "AUTO AIM: OFF (Hold RMB)"
    AimB.BackgroundColor3 = aimEnabled and Color3.new(0, 0.7, 0) or Color3.new(0.6, 0, 0)
end)

-- Mouse button detection untuk Aim
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then -- Right Mouse Button
        rightMousePressed = true
    end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        rightMousePressed = false
        currentTarget = nil
    end
end)

-- Loop Auto Aim
RunService:BindToRenderStep("AutoAimV33", Enum.RenderPriority.Camera.Value, function()
    if aimEnabled and rightMousePressed and lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 then
        local target = getClosestTarget()
        if target then
            smoothAim(target)
        end
    end
end)

-- --- [FIX: GENERATOR COLOR DETECTION] ---
GeB.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if (o.Name:lower():find("generator") or o.Name:lower():find("computer")) and (o:IsA("Model") or o:IsA("BasePart")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.OutlineTransparency = 1; h.Enabled = true
            
            task.spawn(function()
                while h.Enabled do
                    local isFinished = false
                    for _, light in pairs(o:GetDescendants()) do
                        if light:IsA("BasePart") and light.Name:lower():find("light") then
                            if light.Color.G > 0.7 and light.Color.R < 0.3 then
                                isFinished = true; break
                            end
                        end
                    end
                    h.FillColor = isFinished and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
                    task.wait(1)
                end
            end)
        end
    end
end)

-- --- [FIX: RADIAL PERFECT SKILLCHECK] ---
local scOn = false
ScB.MouseButton1Click:Connect(function()
    scOn = not scOn
    ScB.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScB.BackgroundColor3 = scOn and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.2)
end)

RunService:BindToRenderStep("AdiPerfectV33", Enum.RenderPriority.Input.Value, function()
    if not scOn then return end
    local ui = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI") or pGui:FindFirstChild("TugOfWar")
    if ui and ui.Enabled then
        local needle = nil
        local whiteBar = nil
        
        for _, v in pairs(ui:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                if v.Name:lower():find("needle") or v.Name:lower():find("pointer") or v.BackgroundColor3 == Color3.new(1,0,0) then
                    needle = v
                elseif v.Name:lower():find("perfect") or v.Name:lower():find("target") or v.BackgroundColor3 == Color3.new(1,1,1) then
                    whiteBar = v
                end
            end
        end
        
        if needle and whiteBar then
            local nRot = needle.Rotation % 360
            local wRot = whiteBar.Rotation % 360
            local diff = math.abs(nRot - wRot)
            if diff <= 10 or diff >= 350 then
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.01)
                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.5)
            end
        end
    end
end)

-- --- [FITUR LAINNYA] ---
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
