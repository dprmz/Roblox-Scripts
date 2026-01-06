-- [[ ADI PROJECT - V28 OPTIMIZED LOAD ]] --
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- 1. UI SETUP (Compact Logic)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV28"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 999999
pcall(function() ScreenGui.Parent = gethui() or game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Position = UDim2.new(0.5, -135, 0.5, -240); Main.Size = UDim2.new(0, 270, 0, 520); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Text = "ADI PRO V28"; Title.Size = UDim2.new(1, 0, 0, 45); Title.BackgroundColor3 = Color3.fromRGB(30,30,30); Title.TextColor3 = Color3.new(1,1,1); Title.Font = "SourceSansBold"; Title.TextSize = 22
Instance.new("UICorner", Title)

-- --- [BUILDER HELPERS] ---
local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", Main)
    b.Text = txt; b.Size = UDim2.new(0.85, 0, 0, 40); b.Position = UDim2.new(0.075, 0, 0, pos); b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 17
    Instance.new("UICorner", b); return b
end

local function createSlider(title, pos, col)
    local t = Instance.new("TextLabel", Main); t.Text = title; t.Size = UDim2.new(1,0,0,20); t.Position = UDim2.new(0,0,0,pos); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(0.7,0.7,0.7); t.TextSize = 14
    local bg = Instance.new("Frame", Main); bg.Size = UDim2.new(0.8,0,0,6); bg.Position = UDim2.new(0.1,0,0,pos+30); bg.BackgroundColor3 = Color3.fromRGB(40,40,40); bg.BorderSizePixel = 0
    local b = Instance.new("TextButton", bg); b.Size = UDim2.new(0,14,2.5,0); b.Position = UDim2.new(0,0,-0.7,0); b.Text = ""; b.BackgroundColor3 = col; Instance.new("UICorner", b)
    return b, bg
end

-- --- [SLIDERS] ---
local sSpd, bgSpd = createSlider("WalkSpeed", 55, Color3.fromRGB(0,150,255))
local sHit, bgHit = createSlider("Hitbox Size", 105, Color3.fromRGB(255,50,50))
local dS, dH = false, false
sSpd.MouseButton1Down:Connect(function() dS = true end)
sHit.MouseButton1Down:Connect(function() dH = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false end end)

RunService.RenderStepped:Connect(function()
    local mX = UIS:GetMouseLocation().X
    if dS then
        local r = math.clamp((mX - bgSpd.AbsolutePosition.X) / bgSpd.AbsoluteSize.X, 0, 1)
        sSpd.Position = UDim2.new(r, -7, -0.7, 0)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 16 + (r * 100) end
    end
    if dH then
        local r = math.clamp((mX - bgHit.AbsolutePosition.X) / bgHit.AbsoluteSize.X, 0, 1)
        sHit.Position = UDim2.new(r, -7, -0.7, 0)
        local sz = 2 + (r * 48)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(sz, sz, sz); p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- --- [FEATURES BUTTONS] ---
local WhB = createBtn("Wallhack (No Outline)", 165, Color3.fromRGB(70,0,130))
local GeB = createBtn("Generator ESP", 215, Color3.fromRGB(160,120,0))
local ViB = createBtn("Visual Hitbox: OFF", 265, Color3.fromRGB(140,0,0))
local ScB = createBtn("AUTO PERFECT: OFF", 315, Color3.fromRGB(50,50,50))
local CrB = createBtn("Toggle Crosshair", 365, Color3.fromRGB(50,50,50))
createBtn("Close Script", 440, Color3.fromRGB(150,0,0)).MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- --- [VISUALS LOGIC] ---
local visualOn = false
ViB.MouseButton1Click:Connect(function()
    visualOn = not visualOn; ViB.Text = visualOn and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    ViB.BackgroundColor3 = visualOn and Color3.new(0,0.5,0) or Color3.new(0.6,0,0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local l = hrp:FindFirstChild("AdiL")
            if visualOn then
                if not l then l = Instance.new("SelectionBox", hrp); l.Name = "AdiL"; l.LineThickness = 0.05; l.Color3 = Color3.new(1,0,0); l.Adornee = hrp end
            elseif l then l:Destroy() end
        end
    end
end)

-- --- [GEN ESP FIX (Kuning -> Hijau)] ---
GeB.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if o.Name:lower():find("generator") or o.Name:lower():find("computer") then
            local h = o:FindFirstChild("GenH") or Instance.new("Highlight", o)
            h.Name = "GenH"; h.OutlineTransparency = 1
            task.spawn(function()
                while h.Parent do
                    local done = false
                    for _, v in pairs(o:GetDescendants()) do
                        if (v:IsA("NumberValue") or v:IsA("IntValue")) and (v.Value >= 100 or (v.Value >= 0.99 and v.Value <= 1.1)) then
                            done = true; break
                        end
                    end
                    h.FillColor = done and Color3.new(0,1,0) or Color3.new(1,1,0)
                    task.wait(2)
                end
            end)
        end
    end
end)

-- --- [WALLHACK] ---
WhB.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            h.Name = "AdiESP"; h.OutlineTransparency = 1
            local k = false; if p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("beast")) then k = true end
            h.FillColor = k and Color3.new(1,0,0) or Color3.new(0,0.5,1); h.Enabled = true
        end
    end
end)

-- --- [AUTO PERFECT (Fast Detect)] ---
local scOn = false
ScB.MouseButton1Click:Connect(function()
    scOn = not scOn; ScB.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScB.BackgroundColor3 = scOn and Color3.new(0,0.5,0) or Color3.new(0.2,0.2,0.2)
end)

RunService.RenderStepped:Connect(function()
    if not scOn then return end
    local ui = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI")
    if ui and ui.Enabled then
        local p, t = nil, nil
        for _, v in pairs(ui:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                if v.BackgroundColor3 == Color3.new(1,0,0) then p = v
                elseif v.BackgroundColor3 == Color3.new(1,1,1) or v.Name:lower():find("perfect") then t = v end
            end
        end
        if p and t then
            if p.Rotation ~= 0 then
                if math.abs((p.Rotation%360)-(t.Rotation%360)) < 10 then
                    VIM:SendKeyEvent(true, "Space", false, game); task.wait(); VIM:SendKeyEvent(false, "Space", false, game); task.wait(0.5)
                end
            else
                local px = p.AbsolutePosition.X + (p.AbsoluteSize.X/2)
                if px >= t.AbsolutePosition.X and px <= (t.AbsolutePosition.X + t.AbsoluteSize.X) then
                    VIM:SendKeyEvent(true, "Space", false, game); task.wait(); VIM:SendKeyEvent(false, "Space", false, game); task.wait(0.5)
                end
            end
        end
    end
end)

-- --- [MOUSE TOGGLE & CROSSHAIR] ---
local mO = true
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.LeftControl then mO = not mO; Main.Visible = mO end end)
local dot = Instance.new("Frame", ScreenGui); dot.Size = UDim2.new(0,6,0,6); dot.Position = UDim2.new(0.5,-3,0.5,-3); dot.BackgroundColor3 = Color3.new(1,0,0); dot.Visible = false; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
CrB.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)
