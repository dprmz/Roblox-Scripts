-- [[ ADI PROJECT - MAIN SCRIPT V3 ]] --

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local players = game:GetService("Players")
local lp = players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

-- GUI Setup
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "AdiMenuGui"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Text = "ADI MENU PRO V3"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- --- 1. FITUR HIDE/SHOW (CTRL) ---
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)

-- --- 2. FITUR ADJUST SPEED (SLIDER + TYPING) ---
local SpeedLabel = Instance.new("TextLabel", MainFrame)
SpeedLabel.Text = "WalkSpeed: 16"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)

-- Slider Background
local SliderBg = Instance.new("Frame", MainFrame)
SliderBg.Size = UDim2.new(0.8, 0, 0, 10)
SliderBg.Position = UDim2.new(0.1, 0, 0, 75)
SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Slider Button (The Knob)
local SliderBtn = Instance.new("TextButton", SliderBg)
SliderBtn.Size = UDim2.new(0, 15, 1.5, 0)
SliderBtn.Position = UDim2.new(0, 0, -0.25, 0)
SliderBtn.Text = ""
SliderBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)

-- Textbox for Typing
local SpeedInput = Instance.new("TextBox", MainFrame)
SpeedInput.Size = UDim2.new(0.4, 0, 0, 25)
SpeedInput.Position = UDim2.new(0.3, 0, 0, 95)
SpeedInput.PlaceholderText = "Type Speed"
SpeedInput.Text = "16"

local function setSpeed(value)
    local val = math.clamp(tonumber(value) or 16, 16, 250)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = val
        SpeedLabel.Text = "WalkSpeed: " .. math.floor(val)
        SpeedInput.Text = math.floor(val)
    end
end

-- Slider Logic
local dragging = false
SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = SliderBg.AbsolutePosition.X
        local sliderWidth = SliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        SliderBtn.Position = UDim2.new(percent, -7, -0.25, 0)
        setSpeed(16 + (percent * 234)) -- Min 16, Max 250
    end
end)

SpeedInput.FocusLost:Connect(function()
    setSpeed(SpeedInput.Text)
end)

-- --- 3. FITUR WALLHACK (ESP 2 WARNA) ---
local WhBtn = Instance.new("TextButton", MainFrame)
WhBtn.Text = "Wallhack (ESP)"
WhBtn.Size = UDim2.new(0.8, 0, 0, 35)
WhBtn.Position = UDim2.new(0.1, 0, 0, 140)
WhBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
WhBtn.TextColor3 = Color3.new(1, 1, 1)

WhBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            -- Cari atau buat Highlight
            local hl = p.Character:FindFirstChild("AdiESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AdiESP"
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.FillTransparency = 0.4
            
            -- --- LOGIKA DETEKSI KILLER SUPER KUAT ---
            local isKiller = false
            
            -- 1. Cek dari Team (Nama atau Warna)
            if p.Team then
                local teamName = p.Team.Name:lower()
                if teamName:find("killer") or teamName:find("murder") or teamName:find("slasher") or teamName:find("death") then
                    isKiller = true
                end
            end
            
            -- 2. Cek dari Tool/Senjata (Paling Akurat untuk game DBD/Violence District)
            -- Kita cek apakah mereka punya benda yang namanya sering dipakai senjata
            local function checkTools(location)
                for _, item in pairs(location:GetChildren()) do
                    if item:IsA("Tool") then
                        local n = item.Name:lower()
                        if n:find("knife") or n:find("sword") or n:find("machete") or n:find("weapon") or n:find("bat") or n:find("hammer") then
                            return true
                        end
                    end
                end
                return false
            end

            if checkTools(p.Backpack) or (p.Character and checkTools(p.Character)) then
                isKiller = true
            end

            -- 3. Cek Atribut Khusus (Beberapa game menggunakan ini)
            if p:GetAttribute("Role") == "Killer" or p:GetAttribute("IsKiller") == true then
                isKiller = true
            end

            -- --- TERAPKAN WARNA ---
            if isKiller then
                hl.FillColor = Color3.fromRGB(255, 0, 0) -- MERAH MURNI
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                print("[ ADI ] " .. p.Name .. " terdeteksi sebagai KILLER")
            else
                hl.FillColor = Color3.fromRGB(0, 150, 255) -- BIRU untuk Survivor
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
            
            hl.Enabled = true
        end
    end
end)
)

-- --- 4. FITUR KILLER HITBOX (LOGIC ONLY) ---
local HitboxLabel = Instance.new("TextLabel", MainFrame)
HitboxLabel.Text = "Hitbox Extender: 2 (Default)"
HitboxLabel.Size = UDim2.new(1, 0, 0, 20)
HitboxLabel.Position = UDim2.new(0, 0, 0, 275)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.TextColor3 = Color3.new(1, 1, 1)

local HitboxInput = Instance.new("TextBox", MainFrame)
HitboxInput.Size = UDim2.new(0.8, 0, 0, 25)
HitboxInput.Position = UDim2.new(0.1, 0, 0, 295)
HitboxInput.PlaceholderText = "Set Size (ex: 15)"
HitboxInput.Text = "2"
HitboxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HitboxInput.TextColor3 = Color3.new(1, 1, 1)

-- Fungsi Extend Hitbox (Hanya Logika Ukuran)
local function extendHitbox(size)
    local s = tonumber(size) or 2
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(s, s, s)
            p.Character.HumanoidRootPart.CanCollide = false
        end
    end
    HitboxLabel.Text = "Hitbox Extender: " .. s .. " (" .. math.floor((s/2)*100) .. "%)"
end

HitboxInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then extendHitbox(HitboxInput.Text) end
end)

-- --- 4B. FITUR VISUAL HITBOX (LINE ONLY) ---
local VisualBtn = Instance.new("TextButton", MainFrame)
VisualBtn.Text = "Visual Hitbox: OFF"
VisualBtn.Size = UDim2.new(0.8, 0, 0, 30)
VisualBtn.Position = UDim2.new(0.1, 0, 0, 325)
VisualBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VisualBtn.TextColor3 = Color3.new(1, 1, 1)

local visualEnabled = false

-- Fungsi membuat kotak garis (SelectionBox)
local function updateVisuals()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local selection = hrp:FindFirstChild("AdiHitboxVisual")
            
            if visualEnabled then
                if not selection then
                    selection = Instance.new("SelectionBox")
                    selection.Name = "AdiHitboxVisual"
                    selection.Parent = hrp
                    selection.Adornee = hrp
                    selection.LineThickness = 0.05
                    selection.SurfaceTransparency = 1 -- Hanya garis saja, isi kotak bening
                end
                selection.Color3 = (p.TeamColor == BrickColor.new("Really red")) and Color3.new(1,0,0) or Color3.new(1,1,1)
            else
                if selection then selection:Destroy() end
            end
        end
    end
end

VisualBtn.MouseButton1Click:Connect(function()
    visualEnabled = not visualEnabled
    if visualEnabled then
        VisualBtn.Text = "Visual Hitbox: ON"
        VisualBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        VisualBtn.Text = "Visual Hitbox: OFF"
        VisualBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
    updateVisuals()
end)

-- Loop agar visual selalu nempel meskipun pemain baru spawn
RunService.Heartbeat:Connect(function()
    if visualEnabled then updateVisuals() end
end)

-- --- 5. FITUR CROSSHAIR ---
local CrBtn = Instance.new("TextButton", MainFrame)
CrBtn.Text = "Toggle Crosshair"
CrBtn.Size = UDim2.new(0.8, 0, 0, 35)
CrBtn.Position = UDim2.new(0.1, 0, 0, 185)
CrBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
CrBtn.TextColor3 = Color3.new(1, 1, 1)

local dot = Instance.new("Frame", ScreenGui)
dot.Size = UDim2.new(0, 4, 0, 4)
dot.Position = UDim2.new(0.5, -2, 0.5, -2)
dot.BackgroundColor3 = Color3.new(1, 0, 0)
dot.Visible = false

CrBtn.MouseButton1Click:Connect(function() dot.Visible = not dot.Visible end)

-- --- 6. FITUR PERFECT SKILLCHECK (AUTO SPACE) ---
local ScBtn = Instance.new("TextButton", MainFrame)
ScBtn.Text = "Auto Skillcheck: OFF"
ScBtn.Size = UDim2.new(0.8, 0, 0, 35)
ScBtn.Position = UDim2.new(0.1, 0, 0, 230)
ScBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Merah (OFF)
ScBtn.TextColor3 = Color3.new(1, 1, 1)

local autoSkillEnabled = false

-- Fungsi utama deteksi Bar
local function startSkillCheckBot()
    RunService.RenderStepped:Connect(function()
        if not autoSkillEnabled then return end
        
        local playerGui = lp:WaitForChild("PlayerGui")
        
        -- Mencari UI Skillcheck (Coba deteksi nama umum di game)
        -- Kamu bisa ganti "SkillCheck" dengan nama folder UI di game tersebut
        local gui = playerGui:FindFirstChild("SkillCheck") or playerGui:FindFirstChild("ActionUI")
        
        if gui and gui.Visible then
            local bar = gui:FindFirstChild("Bar") -- Garis yang bergerak
            local zone = gui:FindFirstChild("PerfectZone") or gui:FindFirstChild("SuccessZone") -- Target
            
            if bar and zone then
                -- Logika matematika: Jika posisi Bar berada di dalam posisi Zone
                local barPos = bar.AbsolutePosition.X
                local zoneStart = zone.AbsolutePosition.X
                local zoneEnd = zone.AbsolutePosition.X + zone.AbsoluteSize.X
                
                if barPos >= zoneStart and barPos <= zoneEnd then
                    -- Simulasi tekan Space Bar menggunakan VirtualUser (agar tidak terdeteksi)
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.05)
                    vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    print("[ ADI ] Perfect Skillcheck Success!")
                end
            end
        end
    end)
end

ScBtn.MouseButton1Click:Connect(function()
    autoSkillEnabled = not autoSkillEnabled
    if autoSkillEnabled then
        ScBtn.Text = "Auto Skillcheck: ON"
        ScBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Hijau (ON)
        startSkillCheckBot()
    else
        ScBtn.Text = "Auto Skillcheck: OFF"
        ScBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
