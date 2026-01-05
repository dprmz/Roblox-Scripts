-- [[ ADI PROJECT - V21 FINAL ULTIMATE (BIG FONT & PERFECT FIX) ]] --

-- 1. INITIAL GUARD
if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
task.wait(3) 

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 2. GUI SETUP (CORE UI OVERLAY)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiMenu_V21_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483647 -- Prioritas tertinggi (di atas menu ESC)

pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then ScreenGui.Parent = game:GetService("CoreGui")
    else ScreenGui.Parent = pGui end
end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -220)
MainFrame.Size = UDim2.new(0, 270, 0, 480) -- Ukuran Frame sedikit diperbesar
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ADI MENU PRO V21"
Title.Size = UDim2.new(1, 0, 0, 50) -- Judul lebih besar
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24 -- FONT JUDUL DIPERBESAR
Instance.new("UICorner", Title)

-- --- [MOUSE & TOGGLE LOGIC] ---
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

-- --- [BUILDER FUNCTIONS WITH BIG FONT] ---
local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", MainFrame)
    b.Text = txt
    b.Size = UDim2.new(0.85, 0, 0, 45) -- Ukuran tombol diperbesar
    b.Position = UDim2.new(0.075, 0, 0, pos)
    b.BackgroundColor3 = col
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18 -- FONT TOMBOL DIPERBESAR
    b.BorderSizePixel = 0
    Instance.new("UICorner", b)
    return b
end

-- --- [FITUR LIST] ---
local WhBtn = createBtn("Wallhack (Blue/Red)", 65, Color3.fromRGB(70, 0, 130))
local GenBtn = createBtn("ESP Generator", 125, Color3.fromRGB(160, 120, 0))
local HitBtn = createBtn("Extend Hitbox", 185, Color3.fromRGB(200, 50, 50))
local ScBtn = createBtn("AUTO PERFECT: OFF", 245, Color3.fromRGB(140, 0, 0))
local CrBtn = createBtn("Toggle Crosshair", 305, Color3.fromRGB(50, 50, 50))
local ExitBtn = createBtn("Close Script", 400, Color3.fromRGB(200, 0, 0))

-- --- [LOGIKA AUTO PERFECT SKILLCHECK V21 - HIGH PRECISION] ---
local autoSkill = false
ScBtn.MouseButton1Click:Connect(function()
    autoSkill = not autoSkill
    ScBtn.Text = autoSkill and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScBtn.BackgroundColor3 = autoSkill and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(140, 0, 0)
end)

RunService.RenderStepped:Connect(function()
    if not autoSkill then return end
    
    -- Mencari UI Skillcheck secara luas
    local sg = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI") or pGui:FindFirstChild("TugOfWar")
    if sg and sg.Enabled then
        local pointer = nil
        local target = nil
        
        -- Memindai elemen UI untuk Jarum Merah dan Zona Putih
        for _, v in pairs(sg:GetDescendants()) do
            if v:IsA("GuiObject") and v.Visible then
                -- Cari objek merah (Jarum)
                if v.BackgroundColor3 == Color3.new(1, 0, 0) or (v:IsA("ImageLabel") and v.ImageColor3 == Color3.new(1, 0, 0)) then
                    pointer = v
                -- Cari objek putih atau bernama 'perfect' (Zona Sukses)
                elseif v.BackgroundColor3 == Color3.new(1, 1, 1) or v.Name:lower():find("perfect") or v.Name:lower():find("white") then
                    target = v
                end
            end
        end
        
        if pointer and target then
            -- Logika Deteksi Berdasarkan Rotasi (FTF Style)
            if pointer.Rotation ~= 0 or target.Rotation ~= 0 then
                local pRot = pointer.Rotation % 360
                local tRot = target.Rotation % 360
                
                -- Jika jarak rotasi mendekati (Toleransi diperketat untuk Perfect)
                if math.abs(pRot - tRot) < 7 then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.6) -- Jeda stabilisasi
                end
            else
                -- Logika Deteksi Berdasarkan Posisi X (Bar Mendatar)
                local pX = pointer.AbsolutePosition.X + (pointer.AbsoluteSize.X / 2)
                local tX = target.AbsolutePosition.X
                local tWidth = target.AbsoluteSize.X
                
                if pX >= tX and pX <= (tX + tWidth) then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.6)
                end
            end
        end
    end
end)

-- --- [FIXED ESP: SURVIVOR BLUE, KILLER RED] ---
WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"
            
            local isKiller = false
            if p.Team then
                local teamName = p.Team.Name:lower()
                if teamName:find("killer") or teamName:find("beast") or teamName:find("murder") then
                    isKiller = true
                end
            end
            
            hl.FillColor = isKiller and Color3.new(1, 0, 0) or Color3.new(0, 0.5, 1)
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.Enabled = true
        end
    end
end)

-- --- [HITBOX & GENERATOR] ---
HitBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
            p.Character.HumanoidRootPart.CanCollide = false
            p.Character.HumanoidRootPart.Transparency = 0.8
        end
    end
end)

GenBtn.MouseButton1Click:Connect(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if (o.Name:lower():find("generator") or o.Name:lower():find("computer")) and (o:IsA("Model") or o:IsA("BasePart")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.FillColor = Color3.new(1, 1, 0); h.Enabled = true
        end
    end
end)

-- Crosshair
local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 6, 0, 6); dot.Position = UDim2.new(0.5, -3, 0.5, -3); dot.BackgroundColor3 = Color3.new(1,0,0)
dot.Visible = false; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

ExitBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("ADI MENU V21 FINAL LOADED - BIG FONT EDITION")
