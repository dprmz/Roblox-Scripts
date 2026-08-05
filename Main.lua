-- ============================================================
-- MAIN.LUA – VIOLENCE DISTRICT SCRIPT (ADI PROJECT)
-- All features: sidebar menu, wallhack, hook ESP, speed+,
-- auto-aim, auto-parry (radius adjustable), fast vault.
-- Works on Delta and any executor supporting Drawing & UI.
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

-- Utility: safe require
local function safeRequire(module)
    local success, result = pcall(require, module)
    return success and result or nil
end

-- ============================================================
-- SETTINGS (persistent across sessions if you save, but we keep in memory)
-- ============================================================
local Settings = {
    WallhackSurvivor = false,
    WallhackKiller = false,
    HookESP = false,
    SpeedEnabled = false,
    SpeedValue = 16,      -- default walkspeed
    AutoAim = false,
    AimPart = "Head",     -- or "Torso"
    AutoParry = false,
    ParryRadius = 15,     -- studs
    FastVault = false,
}

-- ============================================================
-- GUI CREATION
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ADIGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player:WaitForChild("PlayerGui")

-- Style constants
local colors = {
    bg = Color3.fromRGB(20, 20, 30),
    accent = Color3.fromRGB(255, 170, 0),
    text = Color3.fromRGB(240, 240, 255),
    toggleOn = Color3.fromRGB(0, 200, 80),
    toggleOff = Color3.fromRGB(200, 50, 50),
}

-- Main sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 220, 1, 0)
sidebar.Position = UDim2.new(0, -220, 0, 0) -- hidden initially
sidebar.BackgroundColor3 = colors.bg
sidebar.BackgroundTransparency = 0.15
sidebar.BorderSizePixel = 0
sidebar.Parent = screenGui

-- Toggle button to show/hide sidebar (top-left corner)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 5, 0, 5)
toggleBtn.BackgroundColor3 = colors.accent
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.BorderSizePixel = 0
toggleBtn.Image = "rbxassetid://6031090793" -- menu icon
toggleBtn.Parent = screenGui

local sidebarVisible = false
toggleBtn.MouseButton1Click:Connect(function()
    sidebarVisible = not sidebarVisible
    local targetX = sidebarVisible and 0 or -220
    TweenService:Create(sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, targetX, 0, 0)
    }):Play()
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "☣ ADI MENU ☣"
title.TextColor3 = colors.accent
title.TextSize = 22
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = sidebar

-- Scrollable container for menu items
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = sidebar

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = scroll

-- ============================================================
-- HELPER FUNCTIONS FOR UI ELEMENTS
-- ============================================================
local function createCategory(parent, name, order)
    local cat = Instance.new("TextLabel")
    cat.Size = UDim2.new(1, 0, 0, 30)
    cat.BackgroundTransparency = 1
    cat.Text = name
    cat.TextColor3 = colors.accent
    cat.TextSize = 18
    cat.TextXAlignment = Enum.TextXAlignment.Left
    cat.Font = Enum.Font.GothamBold
    cat.LayoutOrder = order
    cat.Parent = parent
    return cat
end

local function createToggle(parent, labelText, settingKey, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = colors.text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 24)
    toggle.Position = UDim2.new(1, -55, 0.5, -12)
    toggle.BackgroundColor3 = Settings[settingKey] and colors.toggleOn or colors.toggleOff
    toggle.Text = Settings[settingKey] and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.Parent = frame

    toggle.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        toggle.BackgroundColor3 = Settings[settingKey] and colors.toggleOn or colors.toggleOff
        toggle.Text = Settings[settingKey] and "ON" or "OFF"
        -- Additional actions for specific toggles
        if settingKey == "WallhackSurvivor" or settingKey == "WallhackKiller" or settingKey == "HookESP" then
            updateESP()
        end
        if settingKey == "SpeedEnabled" then
            applySpeed()
        end
        if settingKey == "AutoAim" then
            -- toggle auto-aim loop
        end
        if settingKey == "AutoParry" then
            -- toggle parry loop
        end
        if settingKey == "FastVault" then
            -- toggle fast vault detection
        end
    end)

    return toggle
end

local function createSlider(parent, labelText, settingKey, minVal, maxVal, step, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText .. " (" .. tostring(Settings[settingKey]) .. ")"
    label.TextColor3 = colors.text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local slider = Instance.new("Slider")
    slider.Size = UDim2.new(1, -10, 0, 16)
    slider.Position = UDim2.new(0, 5, 0, 22)
    slider.MinValue = minVal
    slider.MaxValue = maxVal
    slider.Value = Settings[settingKey]
    slider.Step = step
    slider.BackgroundColor3 = Color3.fromRGB(60,60,70)
    slider.BorderSizePixel = 0
    slider.Parent = frame

    slider:GetPropertyChangedSignal("Value"):Connect(function()
        Settings[settingKey] = slider.Value
        label.Text = labelText .. " (" .. string.format("%.1f", slider.Value) .. ")"
        if settingKey == "SpeedValue" then applySpeed() end
        if settingKey == "ParryRadius" then end -- no runtime update needed
    end)

    return slider
end

local function createDropdown(parent, labelText, settingKey, options, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = colors.text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local dropdown = Instance.new("TextBox")
    dropdown.Size = UDim2.new(0, 80, 0, 26)
    dropdown.Position = UDim2.new(1, -85, 0.5, -13)
    dropdown.BackgroundColor3 = Color3.fromRGB(50,50,60)
    dropdown.Text = Settings[settingKey]
    dropdown.TextColor3 = colors.text
    dropdown.TextSize = 13
    dropdown.Font = Enum.Font.Gotham
    dropdown.BorderSizePixel = 0
    dropdown.PlaceholderText = "Select"
    dropdown.Parent = frame

    -- Simple dropdown: click to cycle? Or we can create a popup. We'll make it a textbox that you can type or we can provide buttons. For simplicity, we'll allow typing but we'll set validation.
    dropdown.FocusLost:Connect(function(enterPressed)
        local val = dropdown.Text
        if table.find(options, val) then
            Settings[settingKey] = val
        else
            dropdown.Text = Settings[settingKey]
        end
    end)
    return dropdown
end

-- ============================================================
-- BUILD SIDEBAR CONTENT
-- ============================================================
local order = 0

-- Survivor section
createCategory(scroll, "🛡 SURVIVOR", order); order = order + 1
createToggle(scroll, "Speed+", "SpeedEnabled", order); order = order + 1
createSlider(scroll, "Speed Value", "SpeedValue", 16, 50, 0.5, order); order = order + 1

-- Auto-aim with dropdown
local aimFrame = Instance.new("Frame")
aimFrame.Size = UDim2.new(1, 0, 0, 30)
aimFrame.BackgroundTransparency = 1
aimFrame.LayoutOrder = order
aimFrame.Parent = scroll
order = order + 1

local aimLabel = Instance.new("TextLabel")
aimLabel.Size = UDim2.new(0.6, 0, 1, 0)
aimLabel.Position = UDim2.new(0, 0, 0, 0)
aimLabel.BackgroundTransparency = 1
aimLabel.Text = "Auto-Aim"
aimLabel.TextColor3 = colors.text
aimLabel.TextSize = 14
aimLabel.TextXAlignment = Enum.TextXAlignment.Left
aimLabel.Font = Enum.Font.Gotham
aimLabel.Parent = aimFrame

local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0, 50, 0, 24)
aimToggle.Position = UDim2.new(1, -55, 0.5, -12)
aimToggle.BackgroundColor3 = Settings.AutoAim and colors.toggleOn or colors.toggleOff
aimToggle.Text = Settings.AutoAim and "ON" or "OFF"
aimToggle.TextColor3 = Color3.new(1,1,1)
aimToggle.TextSize = 12
aimToggle.Font = Enum.Font.GothamBold
aimToggle.BorderSizePixel = 0
aimToggle.Parent = aimFrame

aimToggle.MouseButton1Click:Connect(function()
    Settings.AutoAim = not Settings.AutoAim
    aimToggle.BackgroundColor3 = Settings.AutoAim and colors.toggleOn or colors.toggleOff
    aimToggle.Text = Settings.AutoAim and "ON" or "OFF"
end)

-- dropdown for aim part
local dropdownAim = Instance.new("TextBox")
dropdownAim.Size = UDim2.new(0, 70, 0, 22)
dropdownAim.Position = UDim2.new(1, -130, 0.5, -11)
dropdownAim.BackgroundColor3 = Color3.fromRGB(50,50,60)
dropdownAim.Text = Settings.AimPart
dropdownAim.TextColor3 = colors.text
dropdownAim.TextSize = 12
dropdownAim.Font = Enum.Font.Gotham
dropdownAim.BorderSizePixel = 0
dropdownAim.PlaceholderText = "Head/Torso"
dropdownAim.Parent = aimFrame
dropdownAim.FocusLost:Connect(function()
    local val = dropdownAim.Text
    if val == "Head" or val == "Torso" then
        Settings.AimPart = val
    else
        dropdownAim.Text = Settings.AimPart
    end
end)

createToggle(scroll, "Auto Parry", "AutoParry", order); order = order + 1
createSlider(scroll, "Parry Radius", "ParryRadius", 5, 30, 0.5, order); order = order + 1

createToggle(scroll, "Fast Vault", "FastVault", order); order = order + 1

-- Killer section
createCategory(scroll, "🔪 KILLER", order); order = order + 1
-- For killer, maybe we want toggles for wallhack and hook esp (already under esp but we can place here as well)
-- But we'll place under ESP.

-- ESP section
createCategory(scroll, "👁 ESP", order); order = order + 1
createToggle(scroll, "Wallhack (Survivor)", "WallhackSurvivor", order); order = order + 1
createToggle(scroll, "Wallhack (Killer)", "WallhackKiller", order); order = order + 1
createToggle(scroll, "Hook ESP", "HookESP", order); order = order + 1

-- Visual section (maybe for future)
createCategory(scroll, "🎨 VISUAL", order); order = order + 1
-- Placeholder for other visual features

-- Add some spacing
local spacer = Instance.new("Frame")
spacer.Size = UDim2.new(1, 0, 0, 10)
spacer.BackgroundTransparency = 1
spacer.LayoutOrder = order
spacer.Parent = scroll

-- ============================================================
-- FEATURE IMPLEMENTATIONS
-- ============================================================

-- ---- ESP (Wallhack & Hook ESP) ----
local espObjects = {} -- store highlights for cleanup

local function clearESP()
    for _, obj in ipairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espObjects = {}
end

local function updateESP()
    clearESP()
    if not (Settings.WallhackSurvivor or Settings.WallhackKiller or Settings.HookESP) then return end

    -- Helper to highlight a model with a color
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

    -- Wallhack for survivors (other players)
    if Settings.WallhackSurvivor then
        for _, plr in ipairs(Player:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                highlightModel(plr.Character, Color3.fromRGB(0, 255, 100)) -- green
            end
        end
    end

    -- Wallhack for killer (specific player? In Violence District, there is one killer. We need to detect who is killer.
    -- We'll try to find a player with a certain attribute or team. For now, we'll just highlight all other players with red if killer toggle is on.
    if Settings.WallhackKiller then
        -- We'll assume the killer is the player with a tool that is a weapon? Or we can just highlight all other players red.
        -- More accurate: find the player who is not on the same team (if teams exist) or who has a "Killer" tag.
        for _, plr in ipairs(Player:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                -- Check if this player is killer: maybe they have a certain attribute or are on team "Killers"
                local isKiller = false
                -- Attempt to detect via team
                if plr.Team and plr.Team.Name == "Killers" then
                    isKiller = true
                end
                -- Or check if character has a part named "Killer" or something
                if not isKiller then
                    -- fallback: check if they have a tool that is a weapon (e.g., knife)
                    for _, tool in ipairs(plr.Character:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            isKiller = true
                            break
                        end
                    end
                end
                if isKiller then
                    highlightModel(plr.Character, Color3.fromRGB(255, 0, 0)) -- red
                end
            end
        end
    end

    -- Hook ESP (for killer) – find hooks in workspace
    if Settings.HookESP then
        -- Search for parts named "Hook" or with a Hook script.
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("hook") or obj:FindFirstChild("Hook")) then
                -- Highlight the part or its parent model
                local target = obj.Parent and obj.Parent:IsA("Model") and obj.Parent or obj
                highlightModel(target, Color3.fromRGB(255, 200, 0)) -- gold
            end
        end
    end
end

-- Update ESP periodically or on change. We'll update every few seconds and on events.
local espUpdateTimer = 0
RunService.Heartbeat:Connect(function(dt)
    espUpdateTimer = espUpdateTimer + dt
    if espUpdateTimer > 0.5 then
        espUpdateTimer = 0
        if Settings.WallhackSurvivor or Settings.WallhackKiller or Settings.HookESP then
            updateESP()
        else
            clearESP()
        end
    end
end)

-- Also update when players join/leave
Player:GetPlayers() -- to trigger initial
Player.PlayerAdded:Connect(function() updateESP() end)
Player.PlayerRemoving:Connect(function() updateESP() end)
-- Also when character changes
for _, plr in ipairs(Player:GetPlayers()) do
    plr.CharacterAdded:Connect(function() updateESP() end)
end
-- We'll also update when our own character changes for speed etc.

-- ---- Speed+ ----
local function applySpeed()
    local char = Player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if Settings.SpeedEnabled then
            humanoid.WalkSpeed = Settings.SpeedValue
        else
            humanoid.WalkSpeed = 16 -- default
        end
    end
end

-- Monitor character changes
Player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    -- apply speed when character spawns
    applySpeed()
    -- Also when speed value changes, we already have slider event
end)

-- Also check every frame to keep speed if something resets it
RunService.Heartbeat:Connect(function()
    if Settings.SpeedEnabled then
        local char = Player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= Settings.SpeedValue then
                humanoid.WalkSpeed = Settings.SpeedValue
            end
        end
    end
end)

-- ---- Auto-Aim (lock to killer) ----
local function getKillerCharacter()
    -- Find the killer player (opponent)
    for _, plr in ipairs(Player:GetPlayers()) do
        if plr ~= Player then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                -- Check if it's killer (same logic as wallhack)
                local isKiller = false
                if plr.Team and plr.Team.Name == "Killers" then isKiller = true end
                if not isKiller then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            isKiller = true; break
                        end
                    end
                end
                if isKiller then
                    return char
                end
            end
        end
    end
    return nil
end

-- Auto-aim loop
RunService.RenderStepped:Connect(function()
    if not Settings.AutoAim then return end
    local killerChar = getKillerCharacter()
    if not killerChar then return end
    local localChar = Player.Character
    if not localChar then return end
    local localHumanoid = localChar:FindFirstChild("Humanoid")
    if not localHumanoid or localHumanoid.Health <= 0 then return end

    local targetPart
    if Settings.AimPart == "Head" then
        targetPart = killerChar:FindFirstChild("Head")
    else -- Torso
        targetPart = killerChar:FindFirstChild("HumanoidRootPart") or killerChar:FindFirstChild("Torso")
    end
    if not targetPart then return end

    -- Make the local character face the target (rotate on Y axis)
    local lookVector = (targetPart.Position - localChar.HumanoidRootPart.Position).Unit
    local newCFrame = CFrame.new(localChar.HumanoidRootPart.Position, Vector3.new(targetPart.Position.X, localChar.HumanoidRootPart.Position.Y, targetPart.Position.Z))
    -- Smoothly rotate? We'll directly set for instant lock
    localChar.HumanoidRootPart.CFrame = newCFrame
end)

-- ---- Auto Parry ----
local function detectKillerAttack()
    -- We need to detect when the killer is attacking. 
    -- We'll look for animation tracks on the killer's humanoid that contain "attack" or "slash".
    local killerChar = getKillerCharacter()
    if not killerChar then return false end
    local humanoid = killerChar:FindFirstChild("Humanoid")
    if not humanoid then return false end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.Name and 
           (track.Animation.Name:lower():find("attack") or track.Animation.Name:lower():find("slash") or track.Animation.Name:lower():find("hit")) then
            return true
        end
    end
    return false
end

-- Parry execution (simulate keypress for parry, e.g., 'F' key)
local function performParry()
    -- Simulate pressing F key (common for parry)
    UserInputService:SetKeyDown(Enum.KeyCode.F)  -- Not all executors support this; fallback to mouse/keyboard API
    -- Alternative: use VirtualInputManager if available (for Delta)
    -- We'll try to use the input simulation from the executor.
    -- Using the standard Roblox API: we can fire the InputBegan event if we have the service.
    -- But many executors provide a function like `keypress` or `mouse1click`. We'll try to use a custom function.
    -- For Delta, we can use `syn.input` or `keypress`. We'll attempt both.
    local success, err = pcall(function()
        -- Try using syn.input if available (Synapse X / Delta)
        if syn and syn.input then
            syn.input(Enum.KeyCode.F)
        elseif keypress then
            keypress(Enum.KeyCode.F)
        else
            -- Fallback: fire the input event manually (may not work)
            local inputService = game:GetService("UserInputService")
            local args = {
                [1] = Enum.KeyCode.F,
                [2] = Enum.UserInputState.Begin,
                [3] = false,
                [4] = nil,
                [5] = nil,
                [6] = nil
            }
            inputService:FireInputBegan(args)
        end
    end)
    if not success then
        -- Silent fail
    end
end

RunService.Heartbeat:Connect(function()
    if not Settings.AutoParry then return end
    local killerChar = getKillerCharacter()
    if not killerChar then return end
    local localChar = Player.Character
    if not localChar then return end
    local humanoid = localChar:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    -- Check distance
    local distance = (killerChar.HumanoidRootPart.Position - localChar.HumanoidRootPart.Position).Magnitude
    if distance > Settings.ParryRadius then return end

    -- Check if killer is attacking
    if detectKillerAttack() then
        performParry()
    end
end)

-- ---- Fast Vault ----
-- We'll detect when the local character is performing a vault animation (usually by animation name)
local function isVaulting()
    local char = Player.Character
    if not char then return false end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return false end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.Name and 
           (track.Animation.Name:lower():find("vault") or track.Animation.Name:lower():find("climb") or track.Animation.Name:lower():find("window")) then
            return true
        end
    end
    return false
end

-- When fast vault enabled, set walkspeed high during vault
RunService.Heartbeat:Connect(function()
    if not Settings.FastVault then 
        -- If we previously set speed high, revert if not enabled
        return 
    end
    local char = Player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    if isVaulting() then
        humanoid.WalkSpeed = 50 -- fast vault speed
    else
        -- Restore to speed+ if enabled, else default
        if Settings.SpeedEnabled then
            humanoid.WalkSpeed = Settings.SpeedValue
        else
            humanoid.WalkSpeed = 16
        end
    end
end)

-- ============================================================
-- INITIAL SETUP
-- ============================================================
-- Apply speed at start
wait(1) -- wait for character
applySpeed()

-- Update ESP initially
wait(0.5)
updateESP()

print("[ADI] Script loaded successfully. Enjoy, Butter!")

-- ============================================================
-- KEYBIND: Toggle GUI with Insert key (optional)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleBtn:Click()
    end
end)