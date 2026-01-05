-- [[ ADI PROJECT - V20 FINAL PERFECT SKILLCHECK ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
task.wait(3) 

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 1. SETUP UI (OVERLAY ALWAYS ON TOP)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiFinal_V20"
ScreenGui.DisplayOrder = 2147483647
ScreenGui.ResetOnSpawn = false

pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then ScreenGui.Parent = game:GetService("CoreGui")
    else ScreenGui.Parent = pGui end
end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.Size = UDim2.new(0, 260, 0, 430)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ADI MENU PRO V20"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18
Instance.new("UICorner", Title)

-- --- [MOUSE UNLOCKER] ---
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
local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", MainFrame)
    b.Text = txt; b.Size = UDim2.new(0.8, 0, 0, 35); b.Position = UDim2.new(0.1, 0, 0, pos)
    b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold
    b.BorderSizePixel = 0; Instance.new("UICorner", b)
    return b
end

-- --- [FITUR LIST] ---
local WhBtn = createBtn("Wallhack (Blue/Red)", 50, Color3.fromRGB(70, 0, 130))
local GenBtn = createBtn("ESP Generator", 95, Color3.fromRGB(160, 120, 0))
local HitBtn = createBtn("Extend Hitbox", 140, Color3.fromRGB(200, 50, 50))
local ScBtn = createBtn("AUTO PERFECT: OFF", 185, Color3.fromRGB(140, 0, 0))
local CrBtn = createBtn("Toggle Crosshair", 230, Color3.fromRGB(50, 50, 50))

-- --- [LOGIKA AUTO PERFECT SKILLCHECK - V20 REWRITTEN] ---
local autoSkill = false
ScBtn.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    ScBtn.Text = autoSkill and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScBtn.BackgroundColor3 = autoSkill and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

-- Scan Skillcheck di RenderStepped (Lebih cepat dari Heartbeat)
RunService.RenderStepped:Connect(function()
    if not autoSkill then return end
    
    -- Cari UI Skillcheck (Mendukung FTF dan game sejenis)
    local gui = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI") or pGui:FindFirstChild("TugOfWar")
    if gui and gui.Enabled then
        local needle = nil
        local whiteZone = nil
        
        -- Cari Jarum (Merah) dan Area Perfect (Putih)
        for _, v in pairs(gui:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                -- Cek warna merah (Jarum)
                if v.BackgroundColor3 == Color3.new(1, 0, 0) or (v:IsA("ImageLabel") and v.ImageColor3 == Color3.new(1, 0, 0)) then
                    needle = v
                -- Cek warna putih atau nama "Perfect" (Target)
                elseif v.Name:lower():find("perfect") or v.BackgroundColor3 == Color3.new(1, 1, 1) then
                    whiteZone = v
                end
            end
        end

        if needle and whiteZone then
            -- LOGIKA ROTASI (Jika Jarum Berputar)
            if needle.Rotation ~= 0 or whiteZone.Rotation ~= 0 then
                local nRot = needle.Rotation % 360
                local wRot = whiteZone.Rotation % 360
                
                -- Hitung jarak rotasi (Toleransi 5 derajat untuk Perfect)
                if math.abs(nRot - wRot) < 6 then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.5) -- Anti-spam
                end
            else
                -- LOGIKA POSISI (Jika Jarum Mendatar)
                local nPos = needle.AbsolutePosition.X + (needle.AbsoluteSize.X / 2)
                local wPos = whiteZone.AbsolutePosition.X
                local wSize = whiteZone.AbsoluteSize.X
                
                -- Hit bila jarum masuk ke area putih
                if nPos >= wPos and nPos <= (wPos + wSize) then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.5)
                end
            end
        end
    end
end)

-- --- [FIXED ESP & HITBOX] ---
WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"
            local isKiller = false
            if p.Team then
                local tn = p.Team.Name:lower()
                if tn:find("killer") or tn:find("beast") or tn:find("murder") then isKiller = true end
            end
            hl.FillColor = isKiller and Color3.new(1, 0, 0) or Color3.new(0, 0.5, 1)
            hl.OutlineColor = Color3.new(1, 1, 1); hl.Enabled = true
        end
    end
end)

HitBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(20, 20, 20)
            p.Character.HumanoidRootPart.CanCollide = false
            p.Character.HumanoidRootPart.Transparency = 0.7
        end
    end
end)

GenBtn.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if o.Name:lower():find("generator") or o.Name:lower():find("computer") then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.FillColor = Color3.new(1, 1, 0); h.Enabled = true
        end
    end
end)

-- Crosshair
local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 4, 0, 4); dot.Position = UDim2.new(0.5, -2, 0.5, -2); dot.BackgroundColor3 = Color3.new(1,0,0)
dot.Visible = false; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

print("ADI MENU V20 PERFECT LOADED")
