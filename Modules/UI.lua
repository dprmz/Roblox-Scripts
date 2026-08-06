Berikut adalah kode UI.lua yang sepenuhnya mempertahankan desain Glassmorphism sebelumnya, dengan 2 perbaikan sesuai permintaan:
 * Ukuran Jendela Makin Ringkas: Diperkecil dari 560x340 menjadi 440x280 (proporsional, rapi, dan tidak memakan area layar).
 * Tombol Floating Bebas (Draggable): Tombol pemanggil (ToggleUI) sekarang bisa digeser/ditarik bebas ke posisi mana saja di layar (Mobile/PC), serta memiliki proteksi klik agar tidak sengaja terbuka saat tombol sedang digeser.
-- UI.lua (Glassmorphism Redesign - Compact Size & Draggable Floating Button)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H4xUI_Glassmorphism"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- COLOR PALETTE & GLASS DESIGN SYSTEM (UNCHANGED)
    -- ==========================================
    local Theme = {
        Accent = Color3.fromRGB(255, 45, 85),           -- Neon Crimson
        AccentGlow = Color3.fromRGB(255, 80, 110),
        Background = Color3.fromRGB(10, 11, 16),        -- Translucent Dark
        Sidebar = Color3.fromRGB(14, 15, 22),           -- Translucent Charcoal
        CardBg = Color3.fromRGB(20, 22, 32),            -- Card Surface
        CardBorder = Color3.fromRGB(255, 255, 255),     -- Glass Edge
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(150, 155, 175),
        TextDisabled = Color3.fromRGB(90, 95, 115),
    }

    local function getConfig(key, default)
        if Config and Config[key] ~= nil then
            return Config[key]
        end
        return default
    end

    local function animate(obj, props, time)
        return TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    end

    -- ==========================================
    -- 1. FLOATING TOGGLE BUTTON (BEBAS DRAGGABLE)
    -- ==========================================
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleUI"
    toggleBtn.Size = UDim2.new(0, 38, 0, 38)
    toggleBtn.Position = UDim2.new(0, 15, 0, 15)
    toggleBtn.BackgroundColor3 = Theme.Sidebar
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Text = "H"
    toggleBtn.TextColor3 = Theme.Accent
    toggleBtn.TextSize = 16
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = screenGui

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Theme.Accent
    toggleStroke.Thickness = 1.2
    toggleStroke.Transparency = 0.3
    toggleStroke.Parent = toggleBtn

    -- Logika Dragging Tombol Floating
    local btnDragging, btnDragStart, btnStartPos, isBtnDragged
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = true
            isBtnDragged = false
            btnDragStart = input.Position
            btnStartPos = toggleBtn.Position
        end
    end)

    toggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - btnDragStart
            if delta.Magnitude > 5 then
                isBtnDragged = true
            end
            animate(toggleBtn, {
                Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
            }, 0.05):Play()
        end
    end)

    -- ==========================================
    -- 2. MAIN WINDOW (RINGKAS: 440 x 280)
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 440, 0, 280)
    mainWindow.Position = UDim2.new(0.5, -220, 0.5, -140)
    mainWindow.BackgroundColor3 = Theme.Background
    mainWindow.BackgroundTransparency = 0.25
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui

    Instance.new("UICorner", mainWindow).CornerRadius = UDim.new(0, 12)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.CardBorder
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.88
    mainStroke.Parent = mainWindow

    local topBarLine = Instance.new("Frame")
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topBarLine.BorderSizePixel = 0
    topBarLine.Parent = mainWindow

    local topGradient = Instance.new("UIGradient")
    topGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Theme.AccentGlow),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 30))
    })
    topGradient.Parent = topBarLine

    -- ==========================================
    -- 3. DRAGGING SYSTEM MAIN WINDOW
    -- ==========================================
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
            animate(mainWindow, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.05):Play()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        if not isBtnDragged then
            mainWindow.Visible = not mainWindow.Visible
        end
    end)

    -- ==========================================
    -- 4. SIDEBAR NAVIGATION
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 130, 1, 0)
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.BackgroundTransparency = 0.35
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    local brandFrame = Instance.new("Frame")
    brandFrame.Size = UDim2.new(1, 0, 0, 38)
    brandFrame.BackgroundTransparency = 1
    brandFrame.Parent = sidebar

    local logoDot = Instance.new("Frame")
    logoDot.Size = UDim2.new(0, 6, 0, 6)
    logoDot.Position = UDim2.new(0, 12, 0.5, -3)
    logoDot.BackgroundColor3 = Theme.Accent
    logoDot.Parent = brandFrame
    Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1, 0)

    local brandTitle = Instance.new("TextLabel")
    brandTitle.Size = UDim2.new(1, -24, 1, 0)
    brandTitle.Position = UDim2.new(0, 24, 0, 0)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "H4xScripts"
    brandTitle.TextColor3 = Theme.TextPrimary
    brandTitle.TextSize = 12
    brandTitle.Font = Enum.Font.GothamBold
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    brandTitle.Parent = brandFrame

    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -74)
    navScroll.Position = UDim2.new(0, 0, 0, 38)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 0
    navScroll.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 3)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navScroll

    local userProfile = Instance.new("Frame")
    userProfile.Size = UDim2.new(1, -12, 0, 30)
    userProfile.Position = UDim2.new(0, 6, 1, -34)
    userProfile.BackgroundColor3 = Theme.CardBg
    userProfile.BackgroundTransparency = 0.4
    userProfile.Parent = sidebar
    Instance.new("UICorner", userProfile).CornerRadius = UDim.new(0, 6)

    local profileAvatar = Instance.new("ImageLabel")
    profileAvatar.Size = UDim2.new(0, 18, 0, 18)
    profileAvatar.Position = UDim2.new(0, 6, 0.5, -9)
    profileAvatar.BackgroundColor3 = Theme.Background
    profileAvatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    profileAvatar.Parent = userProfile
    Instance.new("UICorner", profileAvatar).CornerRadius = UDim.new(1, 0)

    local profileName = Instance.new("TextLabel")
    profileName.Size = UDim2.new(1, -30, 1, 0)
    profileName.Position = UDim2.new(0, 30, 0, 0)
    profileName.BackgroundTransparency = 1
    profileName.Text = player.DisplayName
    profileName.TextColor3 = Theme.TextPrimary
    profileName.TextSize = 10
    profileName.Font = Enum.Font.GothamSemibold
    profileName.TextXAlignment = Enum.TextXAlignment.Left
    profileName.TextTruncate = Enum.TextTruncate.AtEnd
    profileName.Parent = userProfile

    -- ==========================================
    -- 5. TOP HEADER BAR
    -- ==========================================
    local topHeader = Instance.new("Frame")
    topHeader.Size = UDim2.new(1, -130, 0, 38)
    topHeader.Position = UDim2.new(0, 130, 0, 0)
    topHeader.BackgroundTransparency = 1
    topHeader.Parent = mainWindow

    local currentTabTitle = Instance.new("TextLabel")
    currentTabTitle.Size = UDim2.new(0, 120, 1, 0)
    currentTabTitle.Position = UDim2.new(0, 12, 0, 0)
    currentTabTitle.BackgroundTransparency = 1
    currentTabTitle.Text = "Dashboard"
    currentTabTitle.TextColor3 = Theme.TextPrimary
    currentTabTitle.TextSize = 12
    currentTabTitle.Font = Enum.Font.GothamBold
    currentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    currentTabTitle.Parent = topHeader

    local badgeBox = Instance.new("Frame")
    badgeBox.Size = UDim2.new(0, 160, 1, 0)
    badgeBox.Position = UDim2.new(1, -188, 0, 0)
    badgeBox.BackgroundTransparency = 1
    badgeBox.Parent = topHeader

    local badgeLayout = Instance.new("UIListLayout")
    badgeLayout.FillDirection = Enum.FillDirection.Horizontal
    badgeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    badgeLayout.Padding = UDim.new(0, 4)
    badgeLayout.Parent = badgeBox

    local function createBadge(text, isAccent)
        local b = Instance.new("TextLabel")
        b.Size = UDim2.new(0, 0, 0, 18)
        b.AutomaticSize = Enum.AutomaticSize.X
        b.BackgroundColor3 = isAccent and Theme.Accent or Theme.CardBg
        b.BackgroundTransparency = isAccent and 0.1 or 0.4
        b.Text = "  " .. text .. "  "
        b.TextColor3 = Theme.TextPrimary
        b.TextSize = 8
        b.Font = Enum.Font.GothamBold
        b.Parent = badgeBox
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

        if not isAccent then
            local stroke = Instance.new("UIStroke")
            stroke.Color = Theme.CardBorder
            stroke.Thickness = 1
            stroke.Transparency = 0.9
            stroke.Parent = b
        end
    end

    createBadge("Violence District", true)
    createBadge("v2.0", false)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -24, 0.5, -10)
    closeBtn.BackgroundColor3 = Theme.CardBg
    closeBtn.BackgroundTransparency = 0.4
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.TextMuted
    closeBtn.TextSize = 9
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topHeader
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)

    -- ==========================================
    -- 6. CONTENT TABS & NAVIGATION
    -- ==========================================
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -130, 1, -38)
    contentArea.Position = UDim2.new(0, 130, 0, 38)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainWindow

    local tabs = {}
    local navButtons = {}

    local function SwitchTab(tabName)
        currentTabTitle.Text = tabName
        for name, tab in pairs(tabs) do
            tab.Visible = (name == tabName)
        end
        for name, btn in pairs(navButtons) do
            local line = btn:FindFirstChild("ActiveLine")
            if name == tabName then
                animate(btn, {BackgroundTransparency = 0.3, TextColor3 = Theme.TextPrimary}):Play()
                if line then animate(line, {BackgroundTransparency = 0}):Play() end
            else
                animate(btn, {BackgroundTransparency = 1, TextColor3 = Theme.TextMuted}):Play()
                if line then animate(line, {BackgroundTransparency = 1}):Play() end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -12, 0, 26)
        btn.BackgroundColor3 = Theme.CardBg
        btn.BackgroundTransparency = 1
        btn.Text = "    " .. icon .. "  " .. name
        btn.TextColor3 = Theme.TextMuted
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 10
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navScroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

        local line = Instance.new("Frame")
        line.Name = "ActiveLine"
        line.Size = UDim2.new(0, 3, 0, 12)
        line.Position = UDim2.new(0, 3, 0.5, -6)
        line.BackgroundColor3 = Theme.Accent
        line.BackgroundTransparency = 1
        line.Parent = btn
        Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

        navButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            SwitchTab(name)
        end)
    end

    local function CreateTab(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = Theme.Accent
        scroll.ScrollBarImageTransparency = 0.5
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.Parent = scroll

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    -- ==========================================
    -- 7. GLASS COMPONENTS
    -- ==========================================
    local function createSectionHeader(parent, text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 12)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.upper(text)
        lbl.TextColor3 = Theme.TextDisabled
        lbl.TextSize = 8
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.Parent = parent
    end

    local function createCard(parent, height, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, height)
        card.BackgroundColor3 = Theme.CardBg
        card.BackgroundTransparency = 0.4
        card.LayoutOrder = order
        card.Parent = parent

        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.CardBorder
        stroke.Thickness = 1
        stroke.Transparency = 0.92
        stroke.Parent = card

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = card

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 6)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.Parent = card

        return card
    end

    local function createToggleInCard(card, labelText, settingKey, order)
        local initialVal = getConfig(settingKey, false)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 20)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 32, 0, 16)
        toggle.Position = UDim2.new(1, -32, 0.5, -8)
        toggle.BackgroundColor3 = initialVal and Theme.Accent or Theme.Background
        toggle.BackgroundTransparency = initialVal and 0.1 or 0.5
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.Position = initialVal and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        knob.BackgroundColor3 = Theme.TextPrimary
        knob.Parent = toggle
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        toggle.MouseButton1Click:Connect(function()
            if Config then
                Config[settingKey] = not getConfig(settingKey, false)
            end
            local isActive = getConfig(settingKey, false)

            animate(toggle, {
                BackgroundColor3 = isActive and Theme.Accent or Theme.Background,
                BackgroundTransparency = isActive and 0.1 or 0.5
            }):Play()
            animate(knob, {Position = isActive and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        end)
    end

    local function createSliderInCard(card, labelText, settingKey, minVal, maxVal, step, order)
        local initialVal = getConfig(settingKey, minVal)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 28)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 12)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.Parent = frame

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.4, 0, 0, 12)
        valLabel.Position = UDim2.new(0.6, 0, 0, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(initialVal)
        valLabel.TextColor3 = Theme.Accent
        valLabel.TextSize = 10
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Font = Enum.Font.GothamBold
        valLabel.Parent = frame

        local sliderTrack = Instance.new("TextButton")
        sliderTrack.Size = UDim2.new(1, 0, 0, 4)
        sliderTrack.Position = UDim2.new(0, 0, 0, 18)
        sliderTrack.BackgroundColor3 = Theme.Background
        sliderTrack.BackgroundTransparency = 0.5
        sliderTrack.Text = ""
        sliderTrack.AutoButtonColor = false
        sliderTrack.Parent = frame
        Instance.new("UICorner", sliderTrack).CornerRadius = UDim.new(1, 0)

        local startPercent = math.clamp((initialVal - minVal) / (maxVal - minVal), 0, 1)
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Theme.Accent
        sliderFill.Parent = sliderTrack
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

        local draggingSlider = false
        sliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mousePos = UserInputService:GetMouseLocation().X
                local percent = math.clamp((mousePos - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                local newValue = math.floor((minVal + (maxVal - minVal) * percent) / step + 0.5) * step
                newValue = math.clamp(newValue, minVal, maxVal)

                if Config then
                    Config[settingKey] = newValue
                end
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valLabel.Text = tostring(newValue)
            end
        end)
    end

    -- ==========================================
    -- 8. INITIALIZE TABS & CONTROLS
    -- ==========================================
    CreateNavButton("About", "ℹ️", 1)
    CreateNavButton("Generators", "⚡", 2)
    CreateNavButton("Main Stuff", "🎯", 3)
    CreateNavButton("Visuals", "👁️", 4)
    CreateNavButton("Others", "📂", 5)
    CreateNavButton("Misc", "⚙️", 6)
    CreateNavButton("Emotes", "💃", 7)

    local tabAbout = CreateTab("About")
    local tabGenerators = CreateTab("Generators")
    local tabMain = CreateTab("Main Stuff")
    local tabVisuals = CreateTab("Visuals")
    local tabOthers = CreateTab("Others")
    local tabMisc = CreateTab("Misc")
    local tabEmotes = CreateTab("Emotes")

    -- About Tab
    createSectionHeader(tabAbout, "Information", 1)
    local aboutCard = createCard(tabAbout, 60, 2)
    local aboutLbl = Instance.new("TextLabel")
    aboutLbl.Size = UDim2.new(1, 0, 1, 0)
    aboutLbl.BackgroundTransparency = 1
    aboutLbl.Text = "H4xScripts Premium Interface\nDeveloped with precision by @Mallo\nPress 'Insert' to toggle window."
    aboutLbl.TextColor3 = Theme.TextMuted
    aboutLbl.TextSize = 9
    aboutLbl.Font = Enum.Font.Gotham
    aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
    aboutLbl.Parent = aboutCard

    -- Generators Tab
    createSectionHeader(tabGenerators, "Automation", 1)
    local genCard = createCard(tabGenerators, 52, 2)
    createToggleInCard(genCard, "Anti-Fail Generator", "AntiFailGen", 1)
    createToggleInCard(genCard, "Auto Perfect Check", "AutoPerfect", 2)

    -- Main Tab
    createSectionHeader(tabMain, "Combat Features", 1)
    local mainCard = createCard(tabMain, 82, 2)
    createToggleInCard(mainCard, "Auto Parry", "AutoParry", 1)
    createToggleInCard(mainCard, "Speed Boost", "SpeedBoost", 2)
    createSliderInCard(mainCard, "Target Range", "RangeValue", 5, 50, 1, 3)

    -- Visuals Tab
    createSectionHeader(tabVisuals, "ESP & Visuals", 1)
    local visCard = createCard(tabVisuals, 76, 2)
    createToggleInCard(visCard, "Wallhack (Survivor)", "WallhackS", 1)
    createToggleInCard(visCard, "Wallhack (Killer)", "WallhackK", 2)
    createToggleInCard(visCard, "Hook ESP", "HookESP", 3)

    -- Others Tab
    createSectionHeader(tabOthers, "Utilities", 1)
    local otherCard = createCard(tabOthers, 52, 2)
    createToggleInCard(otherCard, "Auto Vault", "AutoVault", 1)
    createToggleInCard(otherCard, "No Recoil", "NoRecoil", 2)

    -- Misc Tab
    createSectionHeader(tabMisc, "System", 1)
    local miscCard = createCard(tabMisc, 52, 2)
    createToggleInCard(miscCard, "LocalPlayer Tweaks", "LocalPlayer", 1)
    createToggleInCard(miscCard, "Range Checker", "RangeCheck", 2)

    -- Emotes Tab
    createSectionHeader(tabEmotes, "Animations", 1)
    local emoteCard = createCard(tabEmotes, 32, 2)
    local emoteFrame = Instance.new("Frame")
    emoteFrame.Size = UDim2.new(1, 0, 1, 0)
    emoteFrame.BackgroundTransparency = 1
    emoteFrame.Parent = emoteCard

    local emoteLbl = Instance.new("TextLabel")
    emoteLbl.Size = UDim2.new(0.4, 0, 1, 0)
    emoteLbl.BackgroundTransparency = 1
    emoteLbl.Text = "Emote Name"
    emoteLbl.TextColor3 = Theme.TextPrimary
    emoteLbl.TextSize = 10
    emoteLbl.Font = Enum.Font.GothamMedium
    emoteLbl.TextXAlignment = Enum.TextXAlignment.Left
    emoteLbl.Parent = emoteFrame

    local emoteBox = Instance.new("TextBox")
    emoteBox.Size = UDim2.new(0, 75, 0, 18)
    emoteBox.Position = UDim2.new(1, -120, 0.5, -9)
    emoteBox.BackgroundColor3 = Theme.Background
    emoteBox.BackgroundTransparency = 0.4
    emoteBox.Text = "4EverLvu"
    emoteBox.TextColor3 = Theme.TextPrimary
    emoteBox.TextSize = 9
    emoteBox.Font = Enum.Font.GothamBold
    emoteBox.Parent = emoteFrame
    Instance.new("UICorner", emoteBox).CornerRadius = UDim.new(0, 4)

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0, 40, 0, 18)
    playBtn.Position = UDim2.new(1, -40, 0.5, -9)
    playBtn.BackgroundColor3 = Theme.Accent
    playBtn.BackgroundTransparency = 0.1
    playBtn.Text = "Play"
    playBtn.TextColor3 = Theme.TextPrimary
    playBtn.TextSize = 9
    playBtn.Font = Enum.Font.GothamBold
    playBtn.AutoButtonColor = false
    playBtn.Parent = emoteFrame
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 4)

    playBtn.MouseButton1Click:Connect(function()
        print("Playing emote: " .. emoteBox.Text)
    end)

    -- ==========================================
    -- 9. INITIALIZATION
    -- ==========================================
    SwitchTab("About")

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            mainWindow.Visible = not mainWindow.Visible
        end
    end)

    return screenGui
end

return UI

