-- [[ ADI V44 - XENO EDITION ]] --

local lp = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- UI SEDERHANA (Hanya Tombol On/Off agar tidak crash di Xeno)
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 150, 0, 100)
frame.Position = UDim2.new(0, 10, 0.5, 0)
frame.BackgroundColor3 = Color3.new(0,0,0)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, 0, 0.5, 0)
btn.Text = "SKILLCHECK: OFF"
btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
btn.TextColor3 = Color3.new(1,1,1)

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1, 0, 0.5, 0)
speedBtn.Position = UDim2.new(0, 0, 0.5, 0)
speedBtn.Text = "SPEED: 16"
speedBtn.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
speedBtn.TextColor3 = Color3.new(1,1,1)

local scActive = false
btn.MouseButton1Click:Connect(function()
    scActive = not scActive
    btn.Text = scActive and "SKILLCHECK: ON" or "SKILLCHECK: OFF"
    btn.BackgroundColor3 = scActive and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0)
end)

local currentSpeed = 16
speedBtn.MouseButton1Click:Connect(function()
    if currentSpeed == 16 then currentSpeed = 100 else currentSpeed = 16 end
    speedBtn.Text = "SPEED: " .. tostring(currentSpeed)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = currentSpeed
    end
end)

-- --- LOGIC SKILLCHECK ---
RunService.Heartbeat:Connect(function()
    if not scActive then return end
    
    -- Mencari UI Skillcheck (Metode Iceware: Cari objek yang Visible)
    local skillUI = lp.PlayerGui:FindFirstChild("SkillCheck", true) or lp.PlayerGui:FindFirstChild("ActionUI", true)
    
    if skillUI and skillUI.Enabled then
        local needle = skillUI:FindFirstChild("Needle", true) or skillUI:FindFirstChild("Pointer", true)
        local perfect = skillUI:FindFirstChild("Perfect", true) or skillUI:FindFirstChild("Success", true)
        
        if needle and perfect and needle.Visible then
            local nRot = needle.Rotation % 360
            local pRot = perfect.Rotation % 360
            local diff = math.abs(nRot - pRot)
            
            -- Jika jarak rotasi dekat, tekan spasi
            if diff <= 12 or diff >= 348 then
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.01)
                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.5) -- Delay agar tidak spam
            end
        end
    end
end)

-- --- ESP GENERATOR ---
task.spawn(function()
    while true do
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():find("generator") and (v:IsA("Model") or v:IsA("BasePart")) then
                local h = v:FindFirstChild("GenESP") or Instance.new("Highlight", v)
                h.Name = "GenESP"
                h.OutlineTransparency = 1
                
                -- Cek warna lampu
                local finished = false
                for _, p in pairs(v:GetDescendants()) do
                    if p:IsA("BasePart") and p.Color.G > 0.7 and p.Color.R < 0.3 then
                        finished = true; break
                    end
                end
                h.FillColor = finished and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
            end
        end
        task.wait(3)
    end
end)
