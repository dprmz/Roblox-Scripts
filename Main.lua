-- [[ ADI PROJECT - V27 FINAL (GEN COLOR FIX & ALL FEATURES) ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
task.wait(2) 

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. UI SETUP (ALWAYS ON TOP)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiMenu_V27_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483647 

pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then ScreenGui.Parent = game:GetService("CoreGui")
    else ScreenGui.Parent = pGui end
end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -240)
MainFrame.Size = UDim2.new(0, 270, 0, 520) 
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ADI MENU PRO V27"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 22
Instance.new("UICorner", Title)

-- --- [MOUSE & TOGGLE] ---
local menuOpen = true
RunService.RenderStepped:Connect(function()
    if menuOpen and MainFrame.Visible then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end)
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.LeftControl then
        menuOpen = not menuOpen; MainFrame.Visible = menuOpen
    end
end)

-- --- [BUILDER FUNCTIONS] ---
local function createSlider(titleT, labelT, posY, color)
    local t = Instance.new("TextLabel", MainFrame)
    t.Text = titleT; t.Size = UDim2.new(1,0,0,20); t.Position = UDim2.new(0,0,0,posY); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(180,180,180); t.TextSize = 14
    local l = Instance.new("TextLabel", MainFrame)
    l.Text = labelT; l.Size = UDim2.new(1,0,0,20); l.Position = UDim2.new(0,0,0,posY+18); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.SourceSansBold; l.TextSize = 16
    local bg = Instance.new("Frame", MainFrame)
    bg.Size = UDim2.new(0.8,0,0,6); bg.Position = UDim2.new(0.1,0,0,posY+45); bg.BackgroundColor3 = Color3.fromRGB(45,45,45); bg.BorderSizePixel = 0; Instance.new("UICorner", bg)
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0,14,2.5,0); btn.Position = UDim2.new(0,0,-0.7,0); btn.Text = ""; btn.BackgroundColor3 = color; Instance.new("UICorner", btn)
    return btn, l, bg
end

local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", MainFrame)
    b.Text = txt; b.Size = UDim2.new(0.85,0,0,40); b.Position = UDim2.new(0.075,0,0,pos); b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 17; Instance.new("UICorner", b)
    return b
end

-- --- [FITUR: SPEED & HITBOX ADJUSTER] ---
local SpdBtn, SpdL, SpdBg = createSlider("WalkSpeed Adjuster", "Speed: 16", 50, Color3.fromRGB(0, 170, 255))
local HitBtn, HitL, HitBg = createSlider("Hitbox Adjuster", "Size: 2", 110, Color3.fromRGB(255, 50, 50))
local dS, dH = false, false

SpdBtn.MouseButton1Down:Connect(function() dS = true end)
HitBtn.MouseButton1Down:Connect(function() dH = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false end end)

RunService.RenderStepped:Connect(function()
    local mX = UserInputService:GetMouseLocation().X
    if dS then
        local rX = math.clamp((mX - SpdBg.AbsolutePosition.X) / SpdBg.AbsoluteSize.X, 0, 1)
        SpdBtn.Position = UDim2.new(rX, -7, -0.7, 0)
        local val = 16 + (rX * 184)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = val; SpdL.Text = "Speed: "..math.floor(val) end
    end
    if dH then
        local rX = math.clamp((mX - HitBg.AbsolutePosition.X) / HitBg.AbsoluteSize.X, 0, 1)
        HitBtn.Position = UDim2.new(rX, -7, -0.7, 0)
        local size = math.floor(2 + (rX * 48))
        HitL.Text = "Size: "..size
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- --- [BUTTONS LIST] ---
local WhBtn = createBtn("Wallhack Player", 175, Color3.fromRGB(70, 0, 130))
local GenBtn = createBtn("ESP Generator (Fix Color)", 225, Color3.fromRGB(160, 120, 0))
local VisBtn = createBtn("Visual Hitbox Line: OFF", 275, Color3.fromRGB(140, 0, 0))
local ScBtn = createBtn("AUTO PERFECT: OFF", 325, Color3.fromRGB(50, 50, 50))
local CrBtn = createBtn("Toggle Crosshair", 375, Color3.fromRGB(50, 50, 50))
local ExitBtn = createBtn("Close Script", 440, Color3.fromRGB(200, 0, 0))

-- --- [VISUAL HITBOX LINE] ---
local visualEnabled = false
VisBtn.MouseButton1Click:Connect(function()
    visualEnabled = not visualEnabled
    VisBtn.Text = visualEnabled and "Visual Hitbox Line: ON" or "Visual Hitbox Line: OFF"
    VisBtn.BackgroundColor3 = visualEnabled and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local line = hrp:FindFirstChild("AdiVisualLine")
            if visualEnabled then
                if not line then
                    line = Instance.new("SelectionBox", hrp)
                    line.Name = "AdiVisualLine"; line.LineThickness = 0.05
                    line.Color3 = Color3.new(1, 0, 0); line.Adornee = hrp
                end
            elseif line then line:Destroy() end
        end
    end
end)

-- --- [ESP PLAYER: SURVIVOR BLUE, KILLER RED] ---
WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"; hl.OutlineTransparency = 1 
            local isKiller = false
            if p.Team then
                local tn = p.Team.Name:lower()
                if tn:find("killer") or tn:find("beast") or tn:find("murder") then isKiller = true end
            end
            hl.FillColor = isKiller and Color3.new(1, 0, 0) or Color3.new(0, 0.4, 1)
            hl.FillTransparency = 0.5; hl.Enabled = true
        end
    end
end)

-- --- [FIXED: GEN ESP COLOR LOGIC (YELLOW TO GREEN)] ---
GenBtn.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if (o.Name:lower():find("generator") or o.Name:lower():find("computer")) and (o:IsA("Model") or o:IsA("BasePart")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.OutlineTransparency = 1; h.Enabled = true
            
            task.spawn(function()
                while h.Enabled do
                    local isFinished = false
                    -- Scan semua Value di dalam Generator untuk mencari progres
                    for _, v in pairs(o:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("StringValue") then
                            local val = tonumber(v.Value)
                            if val and (val >= 100 or (val >= 1 and val < 2)) then
                                isFinished = true
                                break
                            end
                        end
                    end
                    
                    if isFinished then
                        h.FillColor = Color3.new(0, 1, 0) -- Hijau
                    else
                        h.FillColor = Color3.new(1, 1, 0) -- Kuning
                    end
                    task.wait(1.5)
                end
            end)
        end
    end
end)

-- --- [SKILLCHECK LOGIC (STABLE MODE)] ---
local autoSkill = false
ScBtn.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    ScBtn.Text = autoSkill and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScBtn.BackgroundColor3 = autoSkill and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(50, 50, 50)
end)

RunService:BindToRenderStep("SkillCheckUpdate", 100, function()
    if not autoSkill then return end
    local sg = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI")
    if sg and sg.Enabled then
        local ptr, tgt = nil, nil
        for _, v in pairs(sg:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                if v.BackgroundColor3 == Color3.new(1, 0, 0) or v.Name:lower():find("needle") then ptr = v
                elseif v.BackgroundColor3 == Color3.new(1, 1, 1) or v.Name:lower():find("perfect") then tgt = v end
            end
        end
        if ptr and tgt then
            if ptr.Rotation ~= 0 then
                if math.abs((ptr.Rotation % 360) - (tgt.Rotation % 360)) < 10 then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.01); VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.5)
                end
            else
                local pX = ptr.AbsolutePosition.X + (ptr.AbsoluteSize.X / 2)
                if pX >= tgt.AbsolutePosition.X and pX <= (tgt.AbsolutePosition.X + tgt.AbsoluteSize.X) then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.01); VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.5)
                end
            end
        end
    end
end)

-- --- [CROSSHAIR & EXIT] ---
local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 6, 0, 6); dot.Position = UDim2.new(0.5, -3, 0.5, -3); dot.BackgroundColor3 = Color3.new(1,0,0); dot.Visible = false; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)
ExitBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
