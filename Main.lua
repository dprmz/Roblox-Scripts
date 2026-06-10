-- [[ ADI PROJECT - V33 MODERN MODERNIZED UI ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- --- [1. MAIN UI SETUP] ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV33_Modernized"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = gethui() or game:GetService("CoreGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14) -- Darker, richer tone
Main.BackgroundTransparency = 0.05
Main.Position = UDim2.new(0.5, -150, 0.5, -230)
Main.Size = UDim2.new(0, 300, 0, 460)
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 10)

-- Border Stroke untuk kesan premium
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(45, 45, 50)
MainStroke.Thickness = 1.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Header/Title Bar
local Title = Instance.new("TextLabel", Main)
Title.Text = "  ADI MENU PRO V33"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitleCorner = Instance.new("UICorner", Title)
TitleCorner.CornerRadius = UDim.new(0, 10)

-- Garis pemisah bawah title
local HeaderLine = Instance.new("Frame", Main)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 0, 44)
HeaderLine.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
HeaderLine.BorderSizePixel = 0

-- Container untuk scroll menu agar rapi
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -65)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 500)
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)

local ListLayout = Instance.new("UIListLayout", Container)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 10)

-- --- [FUNGSI GENERATOR KOMPONEN UI ESTETIK] ---
local function createBtn(txt, col)
    local btnFrame = Instance.new("Frame", Container)
    btnFrame.Size = UDim2.new(1, 0, 0, 38)
    btnFrame.BackgroundTransparency = 1

    local b = Instance.new("TextButton", btnFrame)
    b.Text = txt
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundColor3 = col
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    
    local btnCorner = Instance.new("UICorner", b)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", b)
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.85
    
    return b
end

local function createSlider(title, col)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 45)
    sliderFrame.BackgroundTransparency = 1
    
    local t = Instance.new("TextLabel", sliderFrame)
    t.Text = title
    t.Size = UDim2.new(1, 0, 0, 18)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.fromRGB(180, 180, 190)
    t.Font = Enum.Font.GothamSemibold
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left
    
    local bg = Instance.new("Frame", sliderFrame)
    bg.Size = UDim2.new(1, 0, 0, 5)
    bg.Position = UDim2.new(0, 0, 0, 26)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = col
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0, 12, 0, 12)
    btn.Position = UDim2.new(0, -6, 0, -4)
    btn.Text = ""
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = col
    btnStroke.Thickness = 1.5
    
    return btn, bg, fill
end

-- --- [SLIDERS IMPLEMENTATION] ---
local sSpd, bSpd, fSpd = createSlider("WalkSpeed Adjuster", Color3.fromRGB(0, 140, 255))
local sHit, bHit, fHit = createSlider("Hitbox Adjuster", Color3.fromRGB(255, 60, 60))
local dS, dH = false, false

sSpd.MouseButton1Down:Connect(function() dS = true end)
sHit.MouseButton1Down:Connect(function() dH = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false end end)

RunService.RenderStepped:Connect(function()
    local mX = UIS:GetMouseLocation().X
    if dS then
        local r = math.clamp((mX - bSpd.AbsolutePosition.X) / bSpd.AbsoluteSize.X, 0, 1)
        sSpd.Position = UDim2.new(r, -6, 0, -4)
        fSpd.Size = UDim2.new(r, 0, 1, 0)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 16 + (r * 150) end
    elseif dH then
        local r = math.clamp((mX - bHit.AbsolutePosition.X) / bHit.AbsoluteSize.X, 0, 1)
        sHit.Position = UDim2.new(r, -6, 0, -4)
        fHit.Size = UDim2.new(r, 0, 1, 0)
        local sz = 2 + (r * 48)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(sz, sz, sz); p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- --- [BUTTONS IMPLEMENTATION] ---
local WhB = createBtn("Wallhack Player", Color3.fromRGB(45, 30, 85))
local GeB = createBtn("Generator ESP (Color Fix)", Color3.fromRGB(90, 70, 20))
local ViB = createBtn("Visual Hitbox Line: OFF", Color3.fromRGB(80, 25, 25))
local ScB = createBtn("AUTO PERFECT: OFF", Color3.fromRGB(35, 35, 40))
local CrB = createBtn("Toggle Crosshair", Color3.fromRGB(35, 35, 40))
local ClB = createBtn("CLOSE SCRIPT", Color3.fromRGB(130, 25, 25))

ClB.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- --- [FIX: GENERATOR COLOR DETECTION LOGIC] ---
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

-- --- [FIX: RADIAL PERFECT SKILLCHECK LOGIC] ---
local scOn = false
ScB.MouseButton1Click:Connect(function()
    scOn = not scOn
    ScB.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScB.BackgroundColor3 = scOn and Color3.fromRGB(20, 75, 40) or Color3.fromRGB(35, 35, 40)
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

-- --- [PLAYER VISUALS LOGIC] ---
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
    ViB.BackgroundColor3 = visOn and Color3.fromRGB(20, 75, 40) or Color3.fromRGB(80, 25, 25)
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

-- Toggle Menu Buka/Tutup dengan tombol LeftControl
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.LeftControl then Main.Visible = not Main.Visible end end)
```[cite: 3]

Kamu bisa langsung menyalin seluruh isi kode di atas dan mengeksekusinya di Solara. Tampilannya dijamin jauh lebih bersih, modern, dan nyaman dipandang saat kamu bermain[cite: 3]!
