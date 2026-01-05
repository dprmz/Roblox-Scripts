-- [[ ADI PROJECT - MAIN SCRIPT V2 ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedInput = Instance.new("TextBox")
local WallhackBtn = Instance.new("TextButton")
local SkillcheckBtn = Instance.new("TextButton")
local CrosshairBtn = Instance.new("TextButton")

-- Setup GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
MainFrame.Size = UDim2.new(0, 220, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Text = "ADI MENU PRO"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 1. FITUR WALLHACK (ESP)
WallhackBtn.Parent = MainFrame
WallhackBtn.Text = "Enable Wallhack"
WallhackBtn.Position = UDim2.new(0.1, 0, 0.15, 0)
WallhackBtn.Size = UDim2.new(0.8, 0, 0, 30)
WallhackBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)

WallhackBtn.MouseButton1Click:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- 2. FITUR SKILLCHECK (Violence District / DBD)
SkillcheckBtn.Parent = MainFrame
SkillcheckBtn.Text = "Auto Perfect Skillcheck"
SkillcheckBtn.Position = UDim2.new(0.1, 0, 0.30, 0)
SkillcheckBtn.Size = UDim2.new(0.8, 0, 0, 30)
SkillcheckBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120)

SkillcheckBtn.MouseButton1Click:Connect(function()
    -- Logika untuk mencari UI Skillcheck di game
    -- Catatan: Nama UI harus sesuai dengan yang ada di game target
    game:GetService("RunService").RenderStepped:Connect(function()
        local pGui = game.Players.LocalPlayer.PlayerGui
        -- Contoh deteksi untuk game tipe DBD/Violence District
        local success, err = pcall(function()
            if pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI") then
                -- Logika otomatis menekan (FireServer/VirtualInput)
                -- Di sini kamu perlu tahu event remote game-nya
                print("Skillcheck Terdeteksi!")
            end
        end)
    end)
end)

-- 3. FITUR ADJUST SPEED (Bisa Diatur)
SpeedInput.Parent = MainFrame
SpeedInput.PlaceholderText = "Set Speed (ex: 50)"
SpeedInput.Text = ""
SpeedInput.Position = UDim2.new(0.1, 0, 0.45, 0)
SpeedInput.Size = UDim2.new(0.8, 0, 0, 30)

SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local speed = tonumber(SpeedInput.Text)
        if speed then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
end)

-- 4. FITUR CROSSHAIR (Titik Tengah)
CrosshairBtn.Parent = MainFrame
CrosshairBtn.Text = "Toggle Crosshair"
CrosshairBtn.Position = UDim2.new(0.1, 0, 0.60, 0)
CrosshairBtn.Size = UDim2.new(0.8, 0, 0, 30)
CrosshairBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)

local ch = Instance.new("Frame", ScreenGui)
ch.Size = UDim2.new(0, 5, 0, 5)
ch.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ch.Position = UDim2.new(0.5, -2, 0.5, -2)
ch.Visible = false

CrosshairBtn.MouseButton1Click:Connect(function()
    ch.Visible = not ch.Visible
end)
