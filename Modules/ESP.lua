-- ESP.lua
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP = {}
local espObjects = {}

local function clearESP()
    for _, obj in ipairs(espObjects) do
        if obj and obj.Parent then 
            obj:Destroy() 
        end
    end
    espObjects = {}
end

local function highlightModel(model, color)
    if not model or not model:IsA("Model") then return end
    if model:FindFirstChildOfClass("Highlight") then return end -- Hindari duplikasi Highlight
    
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
        if not (Config.WallhackS or Config.WallhackK or Config.HookESP) then return end

        -- Wallhack Survivor
        if Config.WallhackS then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    highlightModel(plr.Character, Color3.fromRGB(0, 255, 100))
                end
            end
        end

        -- Wallhack Killer
        if Config.WallhackK then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    local isKiller = false
                    if plr.Team and (plr.Team.Name:lower():find("killer") or plr.Team.Name:lower():find("hunter")) then
                        isKiller = true
                    else
                        for _, tool in ipairs(plr.Character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                                isKiller = true
                                break
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

    local timer = 0
    RunService.Heartbeat:Connect(function(dt)
        timer = timer + dt
        if timer > 1 then
            timer = 0
            if Config.WallhackS or Config.WallhackK or Config.HookESP then
                updateESP()
            else
                clearESP()
            end
        end
    end)

    print("[ESP] Initialized.")
end

return ESP
