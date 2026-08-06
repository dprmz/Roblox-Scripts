-- UI.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ADIGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- 1. TOGGLE BUTTON (Untuk buka/tutup menu)
    -- ==========================================
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 45, 0, 45)
    toggleBtn.Position = UDim2.new(0, 10, 0, 10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    toggleBtn.Image = "rbxassetid://6031090793"
    toggleBtn.Parent = screenGui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleBtn

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(255, 170, 0)
    toggleStroke.Thickness = 2
    toggleStroke.Parent = toggleBtn

    -- ==========================================
    -- 2. MAIN WINDOW (Modern Rounded UI)
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Size = UDim2.new(0, 480, 0, 320)
    mainWindow.Position = UDim2.new(0.5, -240, 0.5, -160)
    mainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainWindow.BorderSizePixel = 0
    mainWindow.Visible = true
    mainWindow.Parent = screenGui

    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 10)
    windowCorner.Parent = mainWindow

    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = Color3.fromRGB(255, 170, 0)
    windowStroke.Thickness = 1
    windowStroke.Parent = mainWindow

    -- Logika Toggle Buka/Tutup
    toggleBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = not mainWindow.Visible
    end)

    -- Logika Dragging
    local dragging, dragInput, dragStart, startPos
    mainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainWindow.Position
        end
    end)
    mainWindow.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ==========================================
    -- 3. SIDEBAR & NAVIGATION (FIXED POSITION)
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 130, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    sidebarCorner.Parent = sidebar

    local sidebarFix = Instance.new("Frame")
    sidebarFix.Size = UDim2.new(0, 10, 1, 0)
    sidebarFix.Position = UDim2.new(1, -10, 0, 0)
    sidebarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    sidebarFix.BorderSizePixel = 0
    sidebarFix.Parent = sidebar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = " ☣ ADI"
    title.TextColor3 = Color3.fromRGB(255, 170, 0)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = sidebar

    -- Wadah Navigasi yang ukurannya dikunci pas di bawah title sidebar
    local navContainer = Instance.new("Frame")
    navContainer.Size = UDim2.new(1, 0, 1, -50)
    navContainer.Position = UDim2.new(0, 0, 0, 50)
    navContainer.BackgroundTransparency = 1
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 6)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    -- ==========================================
    -- 4. CONTENT AREA & TAB SYSTEM
    -- ==========================================
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -130, 1, 0)
    contentArea.Position = UDim2.new(0, 130, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainWindow

    local tabs = {}
    local navButtons = {}

    local function SwitchTab(tabName)
        for name, tab in pairs(tabs) do
            tab.Visible = (name == tabName)
        end
        for name, btn in pairs(navButtons) do
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                btn.TextColor3 = Color3.fromRGB(255, 170, 0)
                if stroke then stroke.Transparency = 0 end
            else
                btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                btn.TextColor3 = Color3.fromRGB(150, 150, 150)
                if stroke then stroke.Transparency = 1 end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 115, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        btn.Text = icon .. "  " .. name
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navContainer -- Dimasukkan ke dalam navContainer yang posisinya aman

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 12)
        padding.Parent = btn

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 170, 0)
        stroke.Thickness = 1
        stroke.Transparency = 1
        stroke.Parent = btn

        navButtons[name] = btn
        btn.MouseButton1Click:Connect(function() 
            SwitchTab(name) 
        end)
    end

    local function CreateTab(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, -20, 1, -20)
        scroll.Position = UDim2.new(0, 10, 0, 10)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    -- ==========================================
    -- 5. COMPONENT BUILDERS (UI Elements)
    -- ==========================================
    local function createToggle(parent, labelText, settingKey, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        frame.LayoutOrder = order
        frame.Parent = parent

        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 60, 0, 24)
        toggle.Position = UDim2.new(1, -70, 0.5, -12)
        toggle.BackgroundColor3 = Config[settingKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        toggle.Text = Config[settingKey] and "ON" or "OFF"
        toggle.TextColor3 = Color3.new(1,1,1)
        toggle.TextSize = 12
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 4)

        toggle.MouseButton1Click:Connect(function()
            Config[settingKey] = not Config[settingKey]
            toggle.BackgroundColor3 = Config[settingKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
            toggle.Text = Config[settingKey] and "ON" or "OFF"
        end)
    end

    local function createSlider(parent, labelText, settingKey, minVal, maxVal, step, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        frame.LayoutOrder = order
        frame.Parent = parent

        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = labelText .. " : " .. tostring(Config[settingKey])
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, -20, 0, 12)
        sliderBtn.Position = UDim2.new(0, 10, 0, 28)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        sliderBtn.Text = ""
        sliderBtn.AutoButtonColor = false
        sliderBtn.Parent = frame
        Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

        local startPercent = math.clamp((Config[settingKey] - minVal) / (maxVal - minVal), 0, 1)
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        sliderFill.Parent = sliderBtn
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

        local dragging = false
        sliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mousePos = UserInputService:GetMouseLocation().X
                local percent = math.clamp((mousePos - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
                local newValue = math.floor((minVal + (maxVal - minVal) * percent) / step + 0.5) * step

                Config[settingKey] = newValue
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                local fmt = step % 1 == 0 and "%.0f" or "%.1f"
                label.Text = labelText .. " : " .. string.format(fmt, newValue)
            end
        end)
    end

    local function createDropdown(parent, labelText, settingKey, options, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local dropdown = Instance.new("TextBox")
        dropdown.Size = UDim2.new(0, 80, 0, 24)
        dropdown.Position = UDim2.new(1, -90, 0.5, -12)
        dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        dropdown.Text = Config[settingKey]
        dropdown.TextColor3 = Color3.fromRGB(255, 170, 0)
        dropdown.TextSize = 12
        dropdown.Font = Enum.Font.GothamBold
        dropdown.Parent = frame
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 4)

        dropdown.FocusLost:Connect(function()
            local val = dropdown.Text
            local isValid = false
            for _, opt in ipairs(options) do
                if val:lower() == opt:lower() then val = opt isValid = true break end
            end
            if isValid then Config[settingKey] = val else dropdown.Text = Config[settingKey] end
        end)
    end

    -- ==========================================
    -- 6. BUILD TABS & NAVIGATION BUTTONS
    -- ==========================================
    CreateNavButton("Survivor", "🛡️", 1)
    CreateNavButton("Killer", "🔪", 2)
    CreateNavButton("ESP", "👁️", 3)
    CreateNavButton("Visual", "🎨", 4)

    local tabSurvivor = CreateTab("Survivor")
    local tabKiller = CreateTab("Killer")
    local tabESP = CreateTab("ESP")
    local tabVisual = CreateTab("Visual")

    -- Isi Konten Survivor
    createToggle(tabSurvivor, "Speed+", "SpeedEnabled", 1)
    createSlider(tabSurvivor, "Speed Value", "SpeedValue", 16, 50, 0.5, 2)
    createToggle(tabSurvivor, "Auto Aim", "AutoAim", 3)
    createDropdown(tabSurvivor, "Aim Part", "AimPart", {"Head", "Torso"}, 4)
    createToggle(tabSurvivor, "Auto Parry", "AutoParry", 5)
    createSlider(tabSurvivor, "Parry Radius", "ParryRadius", 5, 30, 0.5, 6)
    createToggle(tabSurvivor, "Fast Vault", "FastVault", 7)

    -- Isi Konten ESP
    createToggle(tabESP, "Wallhack (Survivor)", "WallhackSurvivor", 1)
    createToggle(tabESP, "Wallhack (Killer)", "WallhackKiller", 2)
    createToggle(tabESP, "Hook ESP", "HookESP", 3)

    -- Set Default Tab yang aktif pertama kali
    SwitchTab("Survivor")

    -- Keybind (Insert) untuk PC
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            mainWindow.Visible = not mainWindow.Visible
        end
    end)

    return screenGui
end

return UI
