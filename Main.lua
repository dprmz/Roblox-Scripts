-- [[ ADI PROJECT - V19 FINAL STABLE FIX ]] --

-- 1. INITIAL GUARD (Mencegah Black Screen)
if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
task.wait(5) 

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 2. GUI SETUP (CORE UI OVERLAY)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiMenu_V19_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483647 -- Prioritas di atas menu ESC

pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then ScreenGui.Parent = game:GetService("CoreGui")
    else ScreenGui.Parent = pGui end
end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.Size = UDim2.new(0, 260, 0, 460)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ADI MENU PRO V19"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Instance.new("UICorner", Title)

-- --- [MOUSE CONTROL FIX] ---
local menuOpen = true
RunService.RenderStepped:Connect(function()
    if menuOpen and MainFrame.Visible then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
    end
end)

-- --- [BUILDER FUNCTIONS] ---
local function createSlider(titleT, labelT, posY, color)
    local t = Instance.new("TextLabel", MainFrame)
    t.Text = titleT; t.Size = UDim2.new(1,0,0,20); t.Position = UDim2.new(0,0,0,posY); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(180,180,180); t.TextSize = 11
    local l = Instance.new("TextLabel", MainFrame)
    l.Text = labelT; l.Size = UDim2.new(1,0,0,20); l.Position = UDim2.new(0,0,0,posY+15); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.SourceSansBold
    local bg = Instance.new("Frame", MainFrame)
    bg.Size = UDim2.new(0.8,0,0,6); bg.Position = UDim2.new(0.1,0,0,posY+42); bg.BackgroundColor3 = Color3.fromRGB(45,45,45); bg.BorderSizePixel = 0; Instance.new("UICorner", bg)
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0,12,2.5,0); btn.Position = UDim2.new(0,0,-0.7,0); btn.Text = ""; btn.BackgroundColor3 = color; Instance.new("UICorner", btn)
    return btn, l, bg
end

local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", MainFrame)
    b.Text = txt; b.Size = UDim2.new(0.8,0,0,32); b.Position = UDim2.new(0.1,0,0,pos); b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.BorderSizePixel = 0; Instance.new("UICorner", b)
    return b
end

-- --- [FITUR: SPEED & HITBOX] ---
local SpdBtn, SpdL, SpdBg = createSlider("WalkSpeed Adjuster", "Speed: 16", 45, Color3.fromRGB(0, 170, 255))
local HitBtn, HitL, HitBg = createSlider("Hitbox Extender", "Size: 2", 105, Color3.fromRGB(255, 50, 50))
local dS, dH = false, false

SpdBtn.MouseButton1Down:Connect(function() dS = true end)
HitBtn.MouseButton1Down:Connect(function() dH = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS, dH = false, false end end)

RunService.RenderStepped:Connect(function()
    local mX = UserInputService:GetMouseLocation().X
    if dS then
        local rX = math.clamp((mX - SpdBg.AbsolutePosition.X) / SpdBg.AbsoluteSize.X, 0, 1)
        SpdBtn.Position = UDim2.new(rX, -6, -0.7, 0)
        local val = 16 + (rX * 184)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = val; SpdL.Text = "Speed: "..math.floor(val) end
    end
    if dH then
        local rX = math.clamp((mX - HitBg.AbsolutePosition.X) / HitBg.AbsoluteSize.X, 0, 1)
        HitBtn.Position = UDim2.new(rX, -6, -0.7, 0)
        local size = math.floor(2 + (rX * 48))
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
        HitL.Text = "Size: "..size
    end
end)

-- --- [FITUR: BUTTONS] ---
local WhBtn = createBtn("Wallhack Player", 185, Color3.fromRGB(70, 0, 130))
local GenBtn = createBtn("ESP Generator", 225, Color3.fromRGB(160, 120, 0))
local VisBtn = createBtn("Visual Hitbox: OFF", 265, Color3.fromRGB(140, 0, 0))
local CrBtn = createBtn("Toggle Crosshair", 305, Color3.fromRGB(50, 50, 50))
local ScBtn = createBtn("Auto Skillcheck: OFF", 345, Color3.fromRGB(140, 0, 0))

-- --- [FIXED ESP: SURVIVOR BLUE, KILLER RED] ---
WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"
            
            -- Logika Deteksi Tim yang Akurat
            local isKiller = false
            if p.Team then
                local teamName = p.Team.Name:lower()
                if teamName:find("killer") or teamName:find("murder") or teamName:find("beast") then
                    isKiller = true
                end
            end
            
            -- FIX WARNA: Killer Merah, Survivor Biru
            hl.FillColor = isKiller and Color3.new(1, 0, 0) or Color3.new(0, 0.4, 1)
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.FillTransparency = 0.5
            hl.Enabled = true
        end
    end
end)

-- --- [FIXED AUTO SKILLCHECK] ---
local autoSkill = false
ScBtn.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    ScBtn.Text = autoSkill and "Auto Skillcheck: ON" or "Auto Skillcheck: OFF"
    ScBtn.BackgroundColor3 = autoSkill and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    if not autoSkill then return end
    local sg = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI")
    if sg and sg.Enabled then
        local pointer, target = nil, nil
        for _, v in pairs(sg:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                -- Cari Jarum Merah
                if v.BackgroundColor3 == Color3.new(1, 0, 0) or (v:IsA("ImageLabel") and v.ImageColor3 == Color3.new(1, 0, 0)) then
                    pointer = v
                -- Cari Garis Putih (Perfect)
                elseif v.Name:lower():find("perfect") or v.BackgroundColor3 == Color3.new(1, 1, 1) then
                    target = v
                end
            end
        end
        if pointer and target then
            local pP = pointer.AbsolutePosition.X
            local tP = target.AbsolutePosition.X
            local tS = target.AbsoluteSize.X
            -- Hit bila jarum di dalam area target
            if pP >= (tP - 1) and pP <= (tP + tS + 1) then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.5)
            end
        end
    end
end)

-- --- [VISUAL & CROSSHAIR] ---
local vE = false
VisBtn.MouseButton1Click:Connect(function()
    vE = not vE
    VisBtn.Text = vE and "Visual Hitbox: ON" or "Visual Hitbox: OFF"
    VisBtn.BackgroundColor3 = vE and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

RunService.Heartbeat:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local s = hrp:FindFirstChild("AdiVisual")
            if vE then
                if not s then
                    s = Instance.new("SelectionBox", hrp); s.Name = "AdiVisual"; s.LineThickness = 0.05; s.Color3 = Color3.new(1,0,0); s.Adornee = hrp
                end
            elseif s then s:Destroy() end
        end
    end
end)

GenBtn.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if o.Name:lower():find("generator") and (o:IsA("Model") or o:IsA("BasePart")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o); h.Name = "GenESP"; h.FillColor = Color3.new(1,1,0); h.Enabled = true
        end
    end
end)

local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 4, 0, 4); dot.Position = UDim2.new(0.5, -2, 0.5, -2); dot.BackgroundColor3 = Color3.new(1,0,0); dot.Visible = false; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

print("V19 DEPLOYED: ALL BUGS FIXED")
