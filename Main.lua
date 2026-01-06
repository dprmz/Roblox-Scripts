-- [[ ADI PROJECT - V39 ICEWARE METHODOLOGY ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
local lp = game:GetService("Players").LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- --- [ UI SETUP ] ---
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AdiV39_IcewareLogic"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 270, 0, 500); Main.Position = UDim2.new(0.5, -135, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", Main)
    b.Text = txt; b.Size = UDim2.new(0.85, 0, 0, 40); b.Position = UDim2.new(0.075, 0, 0, pos)
    b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", b); return b
end

local ScB = createBtn("AUTO PERFECT: OFF", 280, Color3.fromRGB(40, 40, 40))
local GeB = createBtn("GEN ESP (COLOR TRACK)", 180, Color3.fromRGB(150, 120, 0))
-- (Fitur lain seperti Speed/Hitbox tetap ada di kode lengkap, ini fokus ke fix)

-- --- [ THE "ICEWARE" SKILLCHECK LOGIC ] ---
local scOn = false
ScB.MouseButton1Click:Connect(function()
    scOn = not scOn
    ScB.Text = scOn and "AUTO PERFECT: ON" or "AUTO PERFECT: OFF"
    ScB.BackgroundColor3 = scOn and Color3.new(0, 0.4, 0) or Color3.fromRGB(40, 40, 40)
end)

-- Fungsi Press Space Tanpa Delay
local function instantPress()
    VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.01)
    VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

-- ICEWARE LOGIC: Memantau "Changed" Event pada UI agar 100% Akurat
RunService.PostSimulation:Connect(function()
    if not scOn then return end
    
    -- Cari UI secara agresif
    local activeUI = pGui:FindFirstChild("SkillCheck") or pGui:FindFirstChild("ActionUI") or pGui:FindFirstChild("Minigame")
    if activeUI and activeUI.Enabled then
        local needle = activeUI:FindFirstChild("Needle", true) or activeUI:FindFirstChild("Pointer", true)
        local perfectZone = activeUI:FindFirstChild("Perfect", true) or activeUI:FindFirstChild("Success", true)
        
        -- Jika tidak ketemu berdasarkan nama, cari berdasarkan Warna (seperti Iceware)
        if not needle or not perfectZone then
            for _, v in pairs(activeUI:GetDescendants()) do
                if v:IsA("GuiObject") and v.Visible then
                    if v.BackgroundColor3 == Color3.new(1, 0, 0) then needle = v end
                    if v.BackgroundColor3 == Color3.new(1, 1, 1) then perfectZone = v end
                end
            end
        end

        if needle and perfectZone then
            local nRot = needle.Rotation % 360
            local pRot = perfectZone.Rotation % 360
            
            -- Iceware menggunakan 'Prediction Offset'
            -- Jika jarum berputar cepat, kita klik 5-8 derajat sebelum benar-benar pas
            local diff = math.abs(nRot - pRot)
            
            if diff <= 8 or diff >= 352 then
                instantPress()
                task.wait(0.5) -- Mencegah double click
            end
        end
    end
end)

-- --- [ LOGIC GENERATOR: COLOR TRACKING ] ---
GeB.MouseButton1Click:Connect(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("generator") or obj.Name:lower():find("computer") then
            local esp = obj:FindFirstChild("GenESP") or Instance.new("Highlight", obj)
            esp.Name = "GenESP"; esp.OutlineTransparency = 1; esp.Enabled = true
            
            -- Memantau perubahan warna lampu secara real-time
            task.spawn(function()
                while esp.Enabled do
                    local isDone = false
                    for _, child in pairs(obj:GetDescendants()) do
                        if child:IsA("BasePart") then
                            -- Deteksi warna hijau lampu generator
                            if child.Color.G > 0.8 and child.Color.R < 0.3 then
                                isDone = true; break
                            end
                        end
                    end
                    esp.FillColor = isDone and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
                    task.wait(1)
                end
            end)
        end
    end
end)
