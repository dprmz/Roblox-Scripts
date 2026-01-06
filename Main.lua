-- [[ ADI PROJECT - V29 LIGHTWEIGHT STABLE ]] --

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- Pindahkan UI ke CoreGui agar tidak terdeteksi/lebih stabil
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiMenuV29"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 500)
Main.Position = UDim2.new(0.5, -130, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ADI PRO V29"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Instance.new("UICorner", Title)

-- --- [FUNGSI TOMBOL] ---
local function makeBtn(txt, y, col)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.85, 0, 0, 38)
    b.Position = UDim2.new(0.075, 0, 0, y)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    Instance.new("UICorner", b)
    return b
end

-- --- [SLIDERS] ---
local function makeSlider(txt, y)
    local lab = Instance.new("TextLabel", Main)
    lab.Text = txt; lab.Size = UDim2.new(1,0,0,20); lab.Position = UDim2.new(0,0,0,y); lab.BackgroundTransparency = 1; lab.TextColor3 = Color3.new(0.8,0.8,0.8)
    local bg = Instance.new("Frame", Main)
    bg.Size = UDim2.new(0.8,0,0,5); bg.Position = UDim2.new(0.1,0,0,y+25); bg.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new(0,12,2,0); fill.Position = UDim2.new(0,0,-0.5,0); fill.BackgroundColor3 = Color3.new(1,0,0)
    return fill, bg
end

local sSpd, bSpd = makeSlider("Speed Adjuster", 50)
local sHit, bHit = makeSlider("Hitbox Adjuster", 100)
local dS, dH = false, false

sSpd.MouseButton1Down:Connect(function() dS = true end)
sHit.MouseButton1Down:Connect(function() dH = true end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dS = false; dH = false end end)

RunService.RenderStepped:Connect(function()
    local mX = UIS:GetMouseLocation().X
    if dS then
        local r = math.clamp((mX - bSpd.AbsolutePosition.X) / bSpd.AbsoluteSize.X, 0, 1)
        sSpd.Position = UDim2.new(r, -6, -0.5, 0)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 16 + (r * 100) end
    elseif dH then
        local r = math.clamp((mX - bHit.AbsolutePosition.X) / bHit.AbsoluteSize.X, 0, 1)
        sHit.Position = UDim2.new(r, -6, -0.5, 0)
        local sz = 2 + (r * 50)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(sz, sz, sz)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- --- [BUTTONS] ---
local WhBtn = makeBtn("Wallhack (No Outline)", 160, Color3.fromRGB(80, 0, 150))
local GeBtn = makeBtn("Generator ESP (Yellow/Green)", 205, Color3.fromRGB(150, 120, 0))
local ViBtn = makeBtn("Visual Hitbox: OFF", 250, Color3.fromRGB(130, 0, 0))
local ScBtn = makeBtn("AUTO PERFECT: OFF", 295, Color3.fromRGB(50, 50, 50))
local CrBtn = makeBtn("Toggle Crosshair", 340, Color3.fromRGB(50, 50, 50))
makeBtn("CLOSE SCRIPT", 440, Color3.fromRGB(180, 0, 0)).MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- --- [LOGICS] ---
local visOn = false
ViBtn.MouseButton1Click:Connect(function()
    visOn = not visOn
    ViBtn.Text = visOn and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    ViBtn.BackgroundColor3 = visOn and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local l = hrp:FindFirstChild("AdiL")
            if visOn then
                if not l then
                    l = Instance.new("SelectionBox", hrp); l.Name = "AdiL"; l.Color3 = Color3.new(1,0,0); l.Adornee = hrp; l.LineThickness = 0.05
                end
            elseif l then l:Destroy() end
        end
    end
end)

-- --- [FIXED GEN COLOR LOGIC] ---
GeBtn.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if o.Name:lower():find("generator") or o.Name:lower():find("computer") then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.OutlineTransparency = 1
            task.spawn(function()
                while h.Parent do
                    local fin = false
                    for _, v in pairs(o:GetDescendants()) do
                        if (v:IsA("NumberValue") or v:IsA("IntValue")) and (v.Value >= 100 or v.Value >= 0.99) then
                            fin = true; break
                        end
                    end
                    h.FillColor = fin and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
                    task.wait(2)
                end
            end)
        end
    end
end)

WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            h.Name = "AdiESP"; h.OutlineTransparency = 1
            local k = false
            if p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("beast")) then k = true end
            h.FillColor = k and Color3.new(1,0,0) or Color3.new(0,0.5,1); h.Enabled = true
        end
    end
end)

local scOn = false
ScBtn.MouseButton1Click:Connect(function()
    scOn = not scOn
    ScBtn.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScBtn.BackgroundColor3 = scOn and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.2)
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
            local pX = p.AbsolutePosition.X + (p.AbsoluteSize.X/2)
            if pX >= t.AbsolutePosition.X and pX <= (t.AbsolutePosition.X + t.AbsoluteSize.X) then
                VIM:SendKeyEvent(true, "Space", false, game); task.wait(); VIM:SendKeyEvent(false, "Space", false, game); task.wait(0.5)
            end
        end
    end
end)

local mO = true
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.LeftControl then mO = not mO; Main.Visible = mO end end)
