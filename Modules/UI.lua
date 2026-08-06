-- UI.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ADIGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Sidebar frame
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 220, 1, 0)
    sidebar.Position = UDim2.new(0, -220, 0, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    sidebar.BackgroundTransparency = 0.15
    sidebar.BorderSizePixel = 0
    sidebar.Parent = screenGui

    -- Toggle button (top-left)
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 40)
    toggleBtn.Position = UDim2.new(0, 5, 0, 5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    toggleBtn.BackgroundTransparency = 0.4
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Image = "rbxassetid://6031090793"
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
    title.TextColor3 = Color3.fromRGB(255, 170, 0)
    title.TextSize = 22
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = sidebar

    -- Scrolling frame
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

    -- Helper functions to build controls
    local function createCategory(name, order)
        local cat = Instance.new("TextLabel")
        cat.Size = UDim2.new(1, 0, 0, 30)
        cat.BackgroundTransparency = 1
        cat.Text = name
        cat.TextColor3 = Color3.fromRGB(255, 170, 0)
        cat.TextSize = 18
        cat.TextXAlignment = Enum.TextXAlignment.Left
        cat.Font = Enum.Font.GothamBold
        cat.LayoutOrder = order
        cat.Parent = scroll
        return cat
    end

    local function createToggle(labelText, settingKey, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 30)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(240, 240, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 24)
        toggle.Position = UDim2.new(1, -55, 0.5, -12)
        toggle.BackgroundColor3 = Config[settingKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        toggle.Text = Config[settingKey] and "ON" or "OFF"
        toggle.TextColor3 = Color3.new(1,1,1)
        toggle.TextSize = 12
        toggle.Font = Enum.Font.GothamBold
        toggle.BorderSizePixel = 0
        toggle.Parent = frame

        toggle.MouseButton1Click:Connect(function()
            Config[settingKey] = not Config[settingKey]
            toggle.BackgroundColor3 = Config[settingKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
            toggle.Text = Config[settingKey] and "ON" or "OFF"
        end)

        return toggle
    end

    local function createSlider(labelText, settingKey, minVal, maxVal, step, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText .. " (" .. tostring(Config[settingKey]) .. ")"
        label.TextColor3 = Color3.fromRGB(240, 240, 255)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame

        local slider = Instance.new("Slider")
        slider.Size = UDim2.new(1, -10, 0, 16)
        slider.Position = UDim2.new(0, 5, 0, 22)
        slider.MinValue = minVal
        slider.MaxValue = maxVal
        slider.Value = Config[settingKey]
        slider.Step = step
        slider.BackgroundColor3 = Color3.fromRGB(60,60,70)
        slider.BorderSizePixel = 0
        slider.Parent = frame

        slider:GetPropertyChangedSignal("Value"):Connect(function()
            Config[settingKey] = slider.Value
            label.Text = labelText .. " (" .. string.format("%.1f", slider.Value) .. ")"
        end)

        return slider
    end

    local function createDropdown(labelText, settingKey, options, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(240, 240, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame

        local dropdown = Instance.new("TextBox")
        dropdown.Size = UDim2.new(0, 80, 0, 26)
        dropdown.Position = UDim2.new(1, -85, 0.5, -13)
        dropdown.BackgroundColor3 = Color3.fromRGB(50,50,60)
        dropdown.Text = Config[settingKey]
        dropdown.TextColor3 = Color3.fromRGB(240, 240, 255)
        dropdown.TextSize = 13
        dropdown.Font = Enum.Font.Gotham
        dropdown.BorderSizePixel = 0
        dropdown.PlaceholderText = "Select"
        dropdown.Parent = frame

        dropdown.FocusLost:Connect(function(enterPressed)
            local val = dropdown.Text
            if table.find(options, val) then
                Config[settingKey] = val
            else
                dropdown.Text = Config[settingKey]
            end
        end)

        return dropdown
    end

    -- Build the sidebar layout
    local order = 0

    -- Survivor
    createCategory("🛡 SURVIVOR", order); order = order + 1
    createToggle("Speed+", "SpeedEnabled", order); order = order + 1
    createSlider("Speed Value", "SpeedValue", 16, 50, 0.5, order); order = order + 1

    -- Auto‑aim with dropdown
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
    aimLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
    aimLabel.TextSize = 14
    aimLabel.TextXAlignment = Enum.TextXAlignment.Left
    aimLabel.Font = Enum.Font.Gotham
    aimLabel.Parent = aimFrame

    local aimToggle = Instance.new("TextButton")
    aimToggle.Size = UDim2.new(0, 50, 0, 24)
    aimToggle.Position = UDim2.new(1, -55, 0.5, -12)
    aimToggle.BackgroundColor3 = Config.AutoAim and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
    aimToggle.Text = Config.AutoAim and "ON" or "OFF"
    aimToggle.TextColor3 = Color3.new(1,1,1)
    aimToggle.TextSize = 12
    aimToggle.Font = Enum.Font.GothamBold
    aimToggle.BorderSizePixel = 0
    aimToggle.Parent = aimFrame
    aimToggle.MouseButton1Click:Connect(function()
        Config.AutoAim = not Config.AutoAim
        aimToggle.BackgroundColor3 = Config.AutoAim and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        aimToggle.Text = Config.AutoAim and "ON" or "OFF"
    end)

    local aimDropdown = Instance.new("TextBox")
    aimDropdown.Size = UDim2.new(0, 70, 0, 22)
    aimDropdown.Position = UDim2.new(1, -130, 0.5, -11)
    aimDropdown.BackgroundColor3 = Color3.fromRGB(50,50,60)
    aimDropdown.Text = Config.AimPart
    aimDropdown.TextColor3 = Color3.fromRGB(240, 240, 255)
    aimDropdown.TextSize = 12
    aimDropdown.Font = Enum.Font.Gotham
    aimDropdown.BorderSizePixel = 0
    aimDropdown.PlaceholderText = "Head/Torso"
    aimDropdown.Parent = aimFrame
    aimDropdown.FocusLost:Connect(function()
        local val = aimDropdown.Text
        if val == "Head" or val == "Torso" then
            Config.AimPart = val
        else
            aimDropdown.Text = Config.AimPart
        end
    end)

    createToggle("Auto Parry", "AutoParry", order); order = order + 1
    createSlider("Parry Radius", "ParryRadius", 5, 30, 0.5, order); order = order + 1
    createToggle("Fast Vault", "FastVault", order); order = order + 1

    -- ESP
    createCategory("👁 ESP", order); order = order + 1
    createToggle("Wallhack (Survivor)", "WallhackSurvivor", order); order = order + 1
    createToggle("Wallhack (Killer)", "WallhackKiller", order); order = order + 1
    createToggle("Hook ESP", "HookESP", order); order = order + 1

    -- Visual (placeholder)
    createCategory("🎨 VISUAL", order); order = order + 1
    -- additional future toggles can be added here

    -- Spacer
    local spacer = Instance.new("Frame")
    spacer.Size = UDim2.new(1, 0, 0, 10)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = order
    spacer.Parent = scroll

    -- Keybind: Insert toggles sidebar
    UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            toggleBtn:Click()
        end
    end)

    return screenGui
end

return UI
