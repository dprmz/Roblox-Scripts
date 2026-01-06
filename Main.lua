-- [[ ADI PROJECT - V31 ALL FEATURES FIXED ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- 1. SETUP UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV31_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
pcall(function() ScreenGui.Parent = gethui() or game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Position = UDim2.new(0.5, -135, 0.5, -250)
Main.Size = UDim2.new(0, 270, 0, 500)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Text = "ADI MENU PRO V31"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Instance.new("UICorner", Title)

-- --- [BUILDER HELPERS] ---
local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", Main)
    b.Text = txt
    b.Size = UDim2.new(0.85, 0, 0, 38)
    b.Position = UDim2.new(0.075, 0, 0, pos)
    b.BackgroundColor3 = col
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    Instance.new("UICorner", b)
    return b
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

-- --- [2 SLIDERS] ---
local sSpd, bSpd = createSlider("WalkSpeed Adjuster", 50, Color3.fromRGB(0, 150, 255))
local sHit, bHit = createSlider("Hitbox Adjuster", 100, Color3.fromRGB(255, 50, 50))
local dS, dH = false, false

sSpd.MouseButton1Down:Connect(function() dS = true end)
sHit.MouseButton1Down:Connect(function() dH = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false end end)

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
                p.Character.HumanoidRootPart.Size = Vector3.new(sz, sz, sz)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- --- [6 BUTTONS] ---
local WhB = createBtn("Wallhack Player", 155, Color3.fromRGB(80, 0, 150))
local GeB = createBtn("Generator ESP (Yellow/Green)", 200, Color3.fromRGB(150, 120, 0))
local ViB = createBtn("Visual Hitbox Line: OFF", 245, Color3.fromRGB(140, 0, 0))
local ScB = createBtn("AUTO PERFECT: OFF", 290, Color3.fromRGB(50, 50, 50))
local CrB = createBtn("Toggle Crosshair", 335, Color3.fromRGB(50, 50, 50))
local ExB = createBtn("CLOSE SCRIPT", 440, Color3.fromRGB(180, 0, 0))

-- --- [LOGIC: VISUAL LINE] ---
local visOn = false
ViB.MouseButton1Click:Connect(function()
    visOn = not visOn
    ViB.Text = visOn and "Visual Hitbox Line: ON" or "Visual Hitbox Line: OFF"
    ViB.BackgroundColor3 = visOn and Color3.new(0, 0.5, 0) or Color3.new(0.6, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local l = hrp:FindFirstChild("AdiVisual")
            if visOn then
                if not l then
                    l = Instance.new("SelectionBox", hrp); l.Name = "AdiVisual"; l.Color3 = Color3.new(1, 0, 0); l.Adornee = hrp; l.LineThickness = 0.05
                end
            elseif l then l:Destroy() end
        end
    end
end)

-- --- [LOGIC: WALLHACK PLAYER] ---
WhB.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            h.Name = "AdiESP"; h.OutlineTransparency = 1
            local k = false
            if p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("beast")) then k = true end
            h.FillColor = k and Color3.new(1, 0, 0) or Color3.new(0, 0.4, 1)
            h.Enabled = true
        end
    end
end)

-- --- [LOGIC: GENERATOR YELLOW/GREEN] ---
GeB.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if (o.Name:lower():find("generator") or o.Name:lower():find("computer")) and (o:IsA("Model") or o:IsA("BasePart")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.OutlineTransparency = 1; h.Enabled = true
            
            task.spawn(function()
                while h.Enabled do
                    local isDone = false
                    -- Cari Value di dlm Generator
                    for _, v in pairs(o:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("IntValue") then
                            if v.Value >= 100 or (v.Value >= 0.99 and v.Value <= 1.1) then
                                isDone = true; break
                            end
                        end
                    end
                    h.FillColor = isDone and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
                    task.wait(1.5)
                end
            end)
        end
    end
end)

-- --- [LOGIC: PERFECT SKILLCHECK] ---
local scOn = false
ScB.MouseButton1Click:Connect(function()
    scOn = not scOn
    ScB.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScB.BackgroundColor3 = scOn and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.2)
end)

RunService:BindToRenderStep("AdiPerfectV31", 100, function()
    if not scOn then return end
    local ui = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI")
    if ui and ui.Enabled then
        local needle, perfect = nil, nil
        for _, v in pairs(ui:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                if v.BackgroundColor3 == Color3.new(1,0,0) or v.Name:lower():find("needle") then needle = v
                elseif v.BackgroundColor3 == Color3.new(1,1,1) or v.Name:lower():find("perfect") then perfect = v end
            end
        end
        if needle and perfect then
            local nPos = needle.AbsolutePosition.X + (needle.AbsoluteSize.X/2)
            local pPos = perfect.AbsolutePosition.X
            local pWid = perfect.AbsoluteSize.X
            -- Deteksi Range Bar Putih
            if nPos >= (pPos - 5) and nPos <= (pPos + pWid + 5) then
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.01); VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.6)
            end
        end
    end
end)

-- --- [MISC] ---
local dot = Instance.new("Frame", ScreenGui); dot.Size = UDim2.new(0,6,0,6); dot.Position = UDim2.new(0.5,-3,0.5,-3); dot.BackgroundColor3 = Color3.new(1,0,0); dot.Visible = false; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
CrB.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)
ExB.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local menuOpen = true
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.LeftControl then menuOpen = not menuOpen; Main.Visible = menuOpen end end)
