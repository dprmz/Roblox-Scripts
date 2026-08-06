-- Survivor.lua
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Survivor = {}

function Survivor:Init(Config, Player)
    local function getKillerCharacter()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    -- heuristic: killer has a weapon tool or is on "Killers" team
                    local isKiller = false
                    if plr.Team and plr.Team.Name == "Killers" then isKiller = true end
                    if not isKiller then
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                                isKiller = true; break
                            end
                        end
                    end
                    if isKiller then return char end
                end
            end
        end
        return nil
    end

    -- Speed+
    local function applySpeed()
        local char = Player.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.SpeedEnabled and Config.SpeedValue or 16
        end
    end

    Player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applySpeed()
    end)

    RunService.Heartbeat:Connect(function()
        -- Keep speed enforced
        if Config.SpeedEnabled then
            local char = Player.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.WalkSpeed ~= Config.SpeedValue then
                    humanoid.WalkSpeed = Config.SpeedValue
                end
            end
        end
        -- Auto‑parry
        if Config.AutoParry then
            local killerChar = getKillerCharacter()
            if killerChar and Player.Character then
                local dist = (killerChar.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if dist <= Config.ParryRadius then
                    -- Check if killer is attacking (animation name contains attack/slash/hit)
                    local humanoid = killerChar:FindFirstChild("Humanoid")
                    if humanoid then
                        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                            if track.Animation and track.Animation.Name and
                               (track.Animation.Name:lower():find("attack") or
                                track.Animation.Name:lower():find("slash") or
                                track.Animation.Name:lower():find("hit")) then
                                -- Perform parry (simulate F key)
                                pcall(function()
                                    if syn and syn.input then
                                        syn.input(Enum.KeyCode.F)
                                    elseif keypress then
                                        keypress(Enum.KeyCode.F)
                                    else
                                        -- fallback: fire input event
                                        local inputService = game:GetService("UserInputService")
                                        inputService:FireInputBegan(Enum.KeyCode.F, Enum.UserInputState.Begin, false, nil, nil)
                                    end
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Auto‑Aim (lock to killer)
    RunService.RenderStepped:Connect(function()
        if not Config.AutoAim then return end
        local killerChar = getKillerCharacter()
        if not killerChar then return end
        local localChar = Player.Character
        if not localChar then return end
        local humanoid = localChar:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end

        local targetPart
        if Config.AimPart == "Head" then
            targetPart = killerChar:FindFirstChild("Head")
        else
            targetPart = killerChar:FindFirstChild("HumanoidRootPart") or killerChar:FindFirstChild("Torso")
        end
        if not targetPart then return end

        local root = localChar.HumanoidRootPart
        local look = (targetPart.Position - root.Position).Unit
        local newCF = CFrame.new(root.Position, Vector3.new(targetPart.Position.X, root.Position.Y, targetPart.Position.Z))
        root.CFrame = newCF
    end)

    -- Fast Vault
    local function isVaulting()
        local char = Player.Character
        if not char then return false end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return false end
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.Name and
               (track.Animation.Name:lower():find("vault") or
                track.Animation.Name:lower():find("climb") or
                track.Animation.Name:lower():find("window")) then
                return true
            end
        end
        return false
    end

    RunService.Heartbeat:Connect(function()
        if not Config.FastVault then return end
        local char = Player.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        if isVaulting() then
            humanoid.WalkSpeed = 50  -- fast vault speed
        else
            -- revert to speed+ or default
            humanoid.WalkSpeed = Config.SpeedEnabled and Config.SpeedValue or 16
        end
    end)

    print("[Survivor] Initialized.")
end

return Survivor