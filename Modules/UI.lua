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
    -- 1. TOGGLE BUTTON (Floating Button)
    -- ==========================================
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 45, 0, 45)
    toggleBtn.Position = UDim2.new(0, 10, 0, 10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Image = "rbxassetid://6031090793"
    toggleBtn.Parent = screenGui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleBtn

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(220, 40, 40)
    toggleStroke.Thickness = 2
    toggleStroke.Parent = toggleBtn

    -- ==========================================
    -- 2. MAIN WINDOW (Transparent Red Modern UI)
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Size = UDim2.new(0, 560, 0, 360)
    mainWindow.Position = UDim2.new(0.5, -280, 0.5, -180)
    mainWindow.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    mainWindow.BackgroundTransparency = 0.15 -- Semi-transparan elegan
    mainWindow.BorderSizePixel = 0
    mainWindow.Visible = true
    mainWindow.Parent = screenGui

    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 10)
    windowCorner.Parent = mainWindow

    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = Color3.fromRGB(220, 40, 40)
    windowStroke.Thickness = 1.5
    windowStroke.Transparency = 0.3
    windowStroke.Parent = mainWindow

    -- Logika Toggle Buka/Tutup
    toggleBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = not mainWindow.Visible
    end)

    -- Logika Dragging Jendela
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
    -- 3. TOP BAR (Header ala Referensi)
    -- ==========================================
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainWindow

    -- Judul Script / Logo
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 160, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔴 ADI Hub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Badge Game Info (Violence District / Remake)
    local badge1 = Instance.new("TextLabel")
    badge1.Size = UDim2.new(0, 95, 0, 22)
    badge1.Position = UDim2.new(0, 130, 0.5, -11)
    badge1.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    badge1.Text = "Violence district"
    badge1.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge1.TextSize = 10
    badge1.Font = Enum.Font.GothamBold
    badge1.Parent = topBar
    Instance.new("UICorner", badge1).CornerRadius = UDim.new(1, 0)

    local badge2 = Instance.new("TextLabel")
    badge2.Size = UDim2.new(0, 60, 0, 22)
    badge2.Position = UDim2.new(0, 235, 0.5, -11)
    badge2.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    badge2.Text = "Remake"
    badge2.TextColor3 = Color3.fromRGB(220, 220, 220)
    badge2.TextSize = 10
    badge2.Font = Enum.Font.GothamBold
    badge2.Parent = topBar
    Instance.new("UICorner", badge2).CornerRadius = UDim.new(1, 0)

    -- Tombol Close (X) di Pojok Kanan Atas
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)

    -- ==========================================
    -- 4. SIDEBAR & NAVIGATION (Red Theme & Not Bold Active)
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, -45)
    sidebar.Position = UDim2.new(0, 0, 0, 45)
    sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
    sidebar.BackgroundTransparency = 0.3
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    -- Garis pembatas tipis sidebar
    local sideDivider = Instance.new("Frame")
    sideDivider.Size = UDim2.new(0, 1, 1, 0)
    sideDivider.Position = UDim2.new(1, 0, 0, 0)
    sideDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sideDivider.BorderSizePixel = 0
    sideDivider.Parent = sidebar

    local navContainer = Instance.new("Frame")
    navContainer.Size = UDim2.new(1, 0, 1, -60)
    navContainer.Position = UDim2.new(0, 0, 0, 10)
    navContainer.BackgroundTransparency = 1
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 5)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    -- Profil User di Bawah Sidebar
    local userProfile = Instance.new("Frame")
    userProfile.Size = UDim2.new(1, -16, 0, 45)
    userProfile.Position = UDim2.new(0, 8, 1, -50)
    userProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    userProfile.Parent = sidebar
    Instance.new("UICorner", userProfile).CornerRadius = UDim.new(0, 6)

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -10, 1, 0)
    userLbl.Position = UDim2.new(0, 10, 0, 0)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = player.Name
    userLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    userLbl.TextSize = 11
    userLbl.Font = Enum.Font.GothamSemibold
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.Parent = userProfile

    -- ==========================================
    -- 5. CONTENT AREA & TAB SYSTEM
    -- ==========================================
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -150, 1, -45)
    contentArea.Position = UDim2.new(0, 150, 0, 45)
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
                -- State Active (Merah menyala, teks tidak terlalu tebal)
                btn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamSemibold
                if stroke then stroke.Transparency = 0 end
            else
                -- State Inactive (Gelap transparan)
                btn.BackgroundColor3 = Color3.transparent or Color3.fromRGB(0,0,0)
                btn.BackgroundTransparency = 1
                btn.TextColor3 = Color3.fromRGB(150, 150, 150)
                btn.Font = Enum.Font.Gotham
                if stroke then stroke.Transparency = 1 end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -16, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        btn.BackgroundTransparency = 1
        btn.Text = icon .. "    " .. name
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navContainer

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 12)
        padding.Parent = btn

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(220, 40, 40)
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
        scroll.Size = UDim2.new(1, -16, 1, -16)
        scroll.Position = UDim2.new(0, 8, 0, 8)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    -- ==========================================
    -- 6. CARD GROUPING & UI BUILDERS (Red Theme)
    -- ==========================================
    local function createSectionHeader(parent, text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.Parent = parent
    end

    local function createCard(parent, height, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, height)
        card.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        card.BackgroundTransparency = 0.2
        card.LayoutOrder = order
        card.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = card

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = card

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)
        padding.Parent = card

        return card
    end

    local function createToggleInCard(card, labelText, settingKey, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 30)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 22)
        toggle.Position = UDim2.new(1, -50, 0.5, -11)
        toggle.BackgroundColor3 = Config[settingKey] and Color3.fromRGB(220, 40, 40) or Color3.fromRGB(45, 45, 55)
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 16, 0, 16)
        indicator.Position = Config[settingKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = toggle
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        toggle.MouseButton1Click:Connect(function()
            Config[settingKey] = not Config[settingKey]
            local isActive = Config[settingKey]
            toggle.BackgroundColor3 = isActive and Color3.fromRGB(220, 40, 40) or Color3.fromRGB(45, 45, 55)
            
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = isActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            }):Play()
        end)
    end

    local function createSliderInCard(card, labelText, settingKey, minVal, maxVal, step, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = labelText .. " : " .. tostring(Config[settingKey])
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 0, 0, 8)
        sliderBtn.Position = UDim2.new(0, 0, 0, 24)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        sliderBtn.Text = ""
        sliderBtn.AutoButtonColor = false
        sliderBtn.Parent = frame
        Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

        local startPercent = math.clamp((Config[settingKey] - minVal) / (maxVal - minVal), 0, 1)
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
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

    local function createDropdownInCard(card, labelText, settingKey, options, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 30)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local dropdown = Instance.new("TextBox")
        dropdown.Size = UDim2.new(0, 90, 0, 22)
        dropdown.Position = UDim2.new(1, -90, 0.5, -11)
        dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        dropdown.Text = Config[settingKey]
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.TextSize = 11
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
    -- 7. BUILD TABS & CONTENT
    -- ==========================================
    CreateNavButton("Survivor", "🛡️", 1)
    CreateNavButton("Killer", "🔪", 2)
    CreateNavButton("ESP", "👁️", 3)
    CreateNavButton("Visual", "🎨", 4)

    local tabSurvivor = CreateTab("Survivor")
    local tabKiller = CreateTab("Killer")
    local tabESP = CreateTab("ESP")
    local tabVisual = CreateTab("Visual")

    -- Tab Survivor Content
    createSectionHeader(tabSurvivor, "Movement & Combat", 1)
    local cardSpeed = createCard(tabSurvivor, 80, 2)
    createToggleInCard(cardSpeed, "Speed+", "SpeedEnabled", 1)
    createSliderInCard(cardSpeed, "Speed Value", "SpeedValue", 16, 50, 0.5, 2)

    local cardAim = createCard(tabSurvivor, 70, 3)
    createToggleInCard(cardAim, "Auto Aim", "AutoAim", 1)
    createDropdownInCard(cardAim, "Aim Part", "AimPart", {"Head", "Torso"}, 2)

    createSectionHeader(tabSurvivor, "Defensive & Utilities", 4)
    local cardParry = createCard(tabSurvivor, 80, 5)
    createToggleInCard(cardParry, "Auto Parry", "AutoParry", 1)
    createSliderInCard(cardParry, "Parry Radius", "ParryRadius", 5, 30, 0.5, 2)

    local cardVault = createCard(tabSurvivor, 42, 6)
    createToggleInCard(cardVault, "Fast Vault", "FastVault", 1)

    -- Tab ESP Content
    createSectionHeader(tabESP, "ESP Features", 1)
    local cardESP = createCard(tabESP, 110, 2)
    createToggleInCard(cardESP, "Wallhack (Survivor)", "WallhackSurvivor", 1)
    createToggleInCard(cardESP, "Wallhack (Killer)", "WallhackKiller", 2)
    createToggleInCard(cardESP, "Hook ESP", "HookESP", 3)

    -- Set Default Tab
    SwitchTab("Survivor")

    -- Keybind (Insert)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            mainWindow.Visible = not mainWindow.Visible
        end
    end)

    return screenGui
end

return UI
