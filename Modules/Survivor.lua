-- Survivor.lua
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Survivor = {}

function Survivor:Init(Config, Player)
    local function getKillerCharacter()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local isKiller = false
                    if plr.Team and (plr.Team.Name:lower():find("killer") or plr.Team.Name:lower():find("hunter")) then 
                        isKiller = true 
                    end
                    if not isKiller then
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                                isKiller = true
                                break
                            end
                        end
                    end
                    if isKiller then return char end
                end
            end
        end
        return nil
    end

    RunService.Heartbeat:Connect(function()
        local char = Player.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end

        -- Speed Modifier
        if Config.SpeedEnabled then
            if humanoid.WalkSpeed ~= Config.SpeedValue then
                humanoid.WalkSpeed = Config.SpeedValue
            end
        end

        -- Fast Vault Modifier
        if Config.FastVault or Config.AutoVault then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation and track.Animation.Name and
                   (track.Animation.Name:lower():find("vault") or
                    track.Animation.Name:lower():find("climb") or
                    track.Animation.Name:lower():find("window")) then
                    humanoid.WalkSpeed = 50
                    break
                end
            end
        end

        -- Auto-Parry
        if Config.AutoParry then
            local killerChar = getKillerCharacter()
            if killerChar and killerChar:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                local dist = (killerChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                local radius = Config.ParryRadius or Config.RangeValue or 15
                if dist <= radius then
                    local kHumanoid = killerChar:FindFirstChild("Humanoid")
                    if kHumanoid then
                        for _, track in ipairs(kHumanoid:GetPlayingAnimationTracks()) do
                            if track.Animation and track.Animation.Name and
                               (track.Animation.Name:lower():find("attack") or
                                track.Animation.Name:lower():find("slash") or
                                track.Animation.Name:lower():find("hit")) then
                                pcall(function()
                                    local VirtualInputManager = game:GetService("VirtualInputManager")
                                    VirtualInputManager:SendKeyPressEvent(Enum.KeyCode.F, true, game)
                                    task.wait(0.05)
                                    VirtualInputManager:SendKeyPressEvent(Enum.KeyCode.F, false, game)
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end)

    print("[Survivor] Initialized.")
end

return Survivor
