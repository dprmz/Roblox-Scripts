-- ESP.lua
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP = {}
local espObjects = {}

local function clearESP()
    for _, obj in ipairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espObjects = {}
end

local function highlightModel(model, color)
    if not model or not model:IsA("Model") then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    table.insert(espObjects, highlight)
end

function ESP:Init(Config, Player)
    local function updateESP()
        clearESP()
        if not (Config.WallhackSurvivor or Config.WallhackKiller or Config.HookESP) then return end

        -- Wallhack Survivor (other survivors)
        if Config.WallhackSurvivor then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    highlightModel(plr.Character, Color3.fromRGB(0, 255, 100))
                end
            end
        end

        -- Wallhack Killer
        if Config.WallhackKiller then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    local isKiller = false
                    if plr.Team and plr.Team.Name == "Killers" then
                        isKiller = true
                    elseif not isKiller then
                        for _, tool in ipairs(plr.Character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                                isKiller = true; break
                            end
                        end
                    end
                    if isKiller then
                        highlightModel(plr.Character, Color3.fromRGB(255, 0, 0))
                    end
                end
            end
        end

        -- Hook ESP
        if Config.HookESP then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("hook") or obj:FindFirstChild("Hook")) then
                    local target = obj.Parent and obj.Parent:IsA("Model") and obj.Parent or obj
                    highlightModel(target, Color3.fromRGB(255, 200, 0))
                end
            end
        end
    end

    -- Update periodically and on events
    local timer = 0
    RunService.Heartbeat:Connect(function(dt)
        timer = timer + dt
        if timer > 0.5 then
            timer = 0
            if Config.WallhackSurvivor or Config.WallhackKiller or Config.HookESP then
                updateESP()
            else
                clearESP()
            end
        end
    end)

    -- Hook player changes
    Players.PlayerAdded:Connect(updateESP)
    Players.PlayerRemoving:Connect(updateESP)
    for _, plr in ipairs(Players:GetPlayers()) do
        plr.CharacterAdded:Connect(updateESP)
    end

    print("[ESP] Initialized.")
end

return ESP