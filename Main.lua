-- [[ ADI PROJECT - MAIN SCRIPT ]] --

-- 1. Buat ScreenGui (Kontainer utama)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedBtn = Instance.new("TextButton")
local JumpBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

-- Setup GUI ke Player
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. Tampilan Frame Utama
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true -- Agar bisa digeser-geser

-- Judul
Title.Parent = MainFrame
Title.Text = "ADI MENU"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 3. Tombol Kecepatan (Speed)
SpeedBtn.Parent = MainFrame
SpeedBtn.Text = "Super Speed"
SpeedBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
SpeedBtn.Size = UDim2.new(0.8, 0, 0, 35)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

SpeedBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    print("Speed diatur ke 100")
end)

-- 4. Tombol Lompat (Jump)
JumpBtn.Parent = MainFrame
JumpBtn.Text = "High Jump"
JumpBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
JumpBtn.Size = UDim2.new(0.8, 0, 0, 35)
JumpBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 150)

JumpBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
    print("JumpPower diatur ke 150")
end)

-- 5. Tombol Tutup (Close)
CloseBtn.Parent = MainFrame
CloseBtn.Text = "Close"
CloseBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
CloseBtn.Size = UDim2.new(0.8, 0, 0, 30)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Notifikasi Berhasil
game.StarterGui:SetCore("SendNotification", {
    Title = "ADI System";
    Text = "Menu Berhasil Dimuat!";
    Duration = 3;
})
