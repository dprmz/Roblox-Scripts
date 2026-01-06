-- [[ ADI V43 - ULTRA LIGHT ]] --
local lp = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

print("V43 Running - Auto Skillcheck & ESP Gen Active")

-- 1. AUTO PERFECT SKILLCHECK
RunService.Heartbeat:Connect(function()
    local gui = lp.PlayerGui:FindFirstChild("SkillCheck", true) or lp.PlayerGui:FindFirstChild("ActionUI", true)
    if gui and gui.Enabled then
        local needle = gui:FindFirstChild("Needle", true) or gui:FindFirstChild("Pointer", true)
        local bar = gui:FindFirstChild("Perfect", true) or gui:FindFirstChild("Success", true) or gui:FindFirstChild("White", true)
        
        if needle and bar and needle.Visible then
            local diff = math.abs((needle.Rotation % 360) - (bar.Rotation % 360))
            if diff <= 10 or diff >= 350 then
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.01)
                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.5) -- Cooldown
            end
        end
    end
end)

-- 2. ESP GENERATOR (WARNA OTOMATIS)
task.spawn(function()
    while task.wait(2) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():find("generator") and (v:IsA("Model") or v:IsA("BasePart")) then
                local h = v:FindFirstChild("GenESP") or Instance.new("Highlight", v)
                h.Name = "GenESP"; h.OutlineTransparency = 1
                
                local isDone = false
                for _, part in pairs(v:GetDescendants()) do
                    if part:IsA("BasePart") and part.Color.G > 0.7 and part.Color.R < 0.3 then
                        isDone = true; break
                    end
                end
                h.FillColor = isDone and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
            end
        end
    end
end)

-- 3. SPEED (Tekan Q untuk aktifkan Speed 100)
local speedActive = false
game:GetService("UserInputService").InputBegan:Connect(function(io, gpe)
    if gpe then return end
    if io.KeyCode == Enum.KeyCode.Q then
        speedActive = not speedActive
        lp.Character.Humanoid.WalkSpeed = speedActive and 100 or 16
    end
end)
