-- UI.lua (Redesigned & Modernized)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H4xUI_V2"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- TEMA & SKEMA WARNA
    -- ==========================================
    local Theme = {
        Primary = Color3.fromRGB(235, 55, 65),       -- Vibrant Crimson
        PrimaryDark = Color3.fromRGB(180, 35, 45),   -- Dark Crimson
        Background = Color3.fromRGB(14, 15, 20),     -- Deep Navy Charcoal
        SidebarBg = Color3.fromRGB(19, 20, 27),      -- Slightly Lighter Charcoal
        CardBg = Color3.fromRGB(25, 27, 36),         -- Card Background
        CardHover = Color3.fromRGB(32, 35, 48),      -- Card Hover
        TextPrimary = Color3.fromRGB(245, 245, 248),
        TextMuted = Color3.fromRGB(140, 145, 165),
        Stroke = Color3.fromRGB(45, 48, 62),
        StrokeAccent = Color3.fromRGB(235, 55, 65),
    }

    local function getConfig(key, default)
        if Config and Config[key] ~= nil then
            return Config[key]
        end
        return default
    end

    -- ==========================================
    -- 1. FLOATING TOGGLE BUTTON
    -- ==========================================
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0, 48, 0, 48)
    toggleBtn.Position = UDim2.new(0, 20, 0, 20)
    toggleBtn.BackgroundColor3 = Theme.SidebarBg
    toggleBtn.Text = "H"
    toggleBtn.TextColor3 = Theme.Primary
    toggleBtn.TextSize = 20
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 14)
    toggleCorner.Parent = toggleBtn

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Theme.Primary
    toggleStroke.Thickness = 1.5
    toggleStroke.Transparency = 0.3
    toggleStroke.Parent = toggleBtn

    -- ==========================================
    -- 2. MAIN WINDOW
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 720, 0, 480)
    mainWindow.Position = UDim2.new(0.5, -360, 0.5, -240)
    mainWindow.BackgroundColor3 = Theme.Background
    mainWindow.BackgroundTransparency = 0.05
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui

    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 16)
    windowCorner.Parent = mainWindow

    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = Theme.Stroke
    windowStroke.Thickness = 1
    windowStroke.Parent = mainWindow

    -- ==========================================
    -- 3. LOGIKA DRAGGING (Smooth & Reliable)
    -- ==========================================
    local dragging, dragInput, dragStart, startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        TweenService:Create(mainWindow, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end

    mainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainWindow.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    -- Toggle visibility button logic
    toggleBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = not mainWindow.Visible
    end)

    -- ==========================================
    -- 4. SIDEBAR (NAVIGASI KIRI)
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = Theme.SidebarBg
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 16)
    sidebarCorner.Parent = sidebar

    -- Patch untuk menutupi corner kanan sidebar agar rata dengan main window
    local cornerFix = Instance.new("Frame")
    cornerFix.Size = UDim2.new(0, 20, 1, 0)
    cornerFix.Position = UDim2.new(1, -20, 0, 0)
    cornerFix.BackgroundColor3 = Theme.SidebarBg
    cornerFix.BorderSizePixel = 0
    cornerFix.Parent = sidebar

    -- Logo & Brand
    local brandFrame = Instance.new("Frame")
    brandFrame.Size = UDim2.new(1, 0, 0, 60)
    brandFrame.BackgroundTransparency = 1
    brandFrame.Parent = sidebar

    local logoDot = Instance.new("Frame")
    logoDot.Size = UDim2.new(0, 10, 0, 10)
    logoDot.Position = UDim2.new(0, 20, 0.5, -5)
    logoDot.BackgroundColor3 = Theme.Primary
    logoDot.Parent = brandFrame
    Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1, 0)

    local brandTitle = Instance.new("TextLabel")
    brandTitle.Size = UDim2.new(1, -40, 1, 0)
    brandTitle.Position = UDim2.new(0, 36, 0, 0)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "H4xScripts"
    brandTitle.TextColor3 = Theme.TextPrimary
    brandTitle.TextSize = 16
    brandTitle.Font = Enum.Font.GothamBold
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    brandTitle.Parent = brandFrame

    -- Navigation Container
    local navContainer = Instance.new("ScrollingFrame")
    navContainer.Size = UDim2.new(1, 0, 1, -130)
    navContainer.Position = UDim2.new(0, 0, 0, 60)
    navContainer.BackgroundTransparency = 1
    navContainer.BorderSizePixel = 0
    navContainer.ScrollBarThickness = 0
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    -- Profile Footer
    local userProfile = Instance.new("Frame")
    userProfile.Size = UDim2.new(1, -24, 0, 52)
    userProfile.Position = UDim2.new(0, 12, 1, -64)
    userProfile.BackgroundColor3 = Theme.CardBg
    userProfile.Parent = sidebar
    Instance.new("UICorner", userProfile).CornerRadius = UDim.new(0, 10)

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(0, 32, 0, 32)
    avatarImg.Position = UDim2.new(0, 10, 0.5, -16)
    avatarImg.BackgroundColor3 = Theme.Background
    avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    avatarImg.Parent = userProfile
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -52, 0, 18)
    userLbl.Position = UDim2.new(0, 48, 0, 10)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = player.DisplayName
    userLbl.TextColor3 = Theme.TextPrimary
    userLbl.TextSize = 12
    userLbl.Font = Enum.Font.GothamBold
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.TextTruncate = Enum.TextTruncate.AtEnd
    userLbl.Parent = userProfile

    local roleLbl = Instance.new("TextLabel")
    roleLbl.Size = UDim2.new(1, -52, 0, 14)
    roleLbl.Position = UDim2.new(0, 48, 0, 28)
    roleLbl.BackgroundTransparency = 1
    roleLbl.Text = "@" .. player.Name
    roleLbl.TextColor3 = Theme.TextMuted
    roleLbl.TextSize = 10
    roleLbl.Font = Enum.Font.Gotham
    roleLbl.TextXAlignment = Enum.TextXAlignment.Left
    roleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    roleLbl.Parent = userProfile

    -- ==========================================
    -- 5. HEADER (TOP BAR ATAS)
    -- ==========================================
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, -200, 0, 60)
    topBar.Position = UDim2.new(0, 200, 0, 0)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainWindow

    local currentTabTitle = Instance.new("TextLabel")
    currentTabTitle.Size = UDim2.new(0, 200, 1, 0)
    currentTabTitle.Position = UDim2.new(0, 24, 0, 0)
    currentTabTitle.BackgroundTransparency = 1
    currentTabTitle.Text = "Dashboard"
    currentTabTitle.TextColor3 = Theme.TextPrimary
    currentTabTitle.TextSize = 16
    currentTabTitle.Font = Enum.Font.GothamBold
    currentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    currentTabTitle.Parent = topBar

    -- Badges
    local badgeContainer = Instance.new("Frame")
    badgeContainer.Size = UDim2.new(0, 220, 1, 0)
    badgeContainer.Position = UDim2.new(1, -260, 0, 0)
    badgeContainer.BackgroundTransparency = 1
    badgeContainer.Parent = topBar

    local badgeLayout = Instance.new("UIListLayout")
    badgeLayout.FillDirection = Enum.FillDirection.Horizontal
    badgeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    badgeLayout.Padding = UDim.new(0, 8)
    badgeLayout.Parent = badgeContainer

    local function createBadge(text, isAccent)
        local badge = Instance.new("TextLabel")
        badge.Size = UDim2.new(0, 0, 0, 24)
        badge.AutomaticSize = Enum.AutomaticSize.X
        badge.BackgroundColor3 = isAccent and Theme.Primary or Theme.CardBg
        badge.Text = "  " .. text .. "  "
        badge.TextColor3 = isAccent and Theme.TextPrimary or Theme.TextMuted
        badge.TextSize = 10
        badge.Font = Enum.Font.GothamBold
        badge.Parent = badgeContainer
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
    end

    createBadge("Violence District", true)
    createBadge("v2.0", false)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
    closeBtn.BackgroundColor3 = Theme.CardBg
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.TextMuted
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Primary, TextColor3 = Theme.TextPrimary}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextMuted}):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)

    -- ==========================================
    -- 6. CONTENT AREA
    -- ==========================================
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -200, 1, -60)
    contentArea.Position = UDim2.new(0, 200, 0, 60)
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
            local indicator = btn:FindFirstChild("Indicator")
            if name == tabName then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextPrimary}):Play()
                if indicator then
                    TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                end
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SidebarBg, TextColor3 = Theme.TextMuted}):Play()
                if indicator then
                    TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -24, 0, 36)
        btn.BackgroundColor3 = Theme.SidebarBg
        btn.Text = "     " .. icon .. "   " .. name
        btn.TextColor3 = Theme.TextMuted
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 3, 0, 16)
        indicator.Position = UDim2.new(0, 6, 0.5, -8)
        indicator.BackgroundColor3 = Theme.Primary
        indicator.BackgroundTransparency = 1
        indicator.Parent = btn
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        navButtons[name] = btn

        btn.MouseEnter:Connect(function()
            if currentTabTitle.Text ~= name then
                TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Theme.TextPrimary}):Play()
            end
        end)

        btn.MouseLeave:Connect(function()
            if currentTabTitle.Text ~= name then
                TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Theme.TextMuted}):Play()
            end
        end)

        btn.MouseButton1Click:Connect(function()
            SwitchTab(name)
        end)
    end

    local function CreateTab(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = Theme.Stroke
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 24)
        padding.PaddingRight = UDim.new(0, 24)
        padding.PaddingBottom = UDim.new(0, 24)
        padding.Parent = scroll

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    -- ==========================================
    -- 7. UI BUILDERS (TOGGLE, SLIDER, DROPDOWN, DLL)
    -- ==========================================
    local function createSectionHeader(parent, text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.upper(text)
        lbl.TextColor3 = Theme.TextMuted
        lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.Parent = parent
    end

    local function createCard(parent, height, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, height)
        card.BackgroundColor3 = Theme.CardBg
        card.LayoutOrder = order
        card.Parent = parent

        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.Stroke
        stroke.Thickness = 1
        stroke.Parent = card

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = card

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 12)
        padding.PaddingBottom = UDim.new(0, 12)
        padding.PaddingLeft = UDim.new(0, 16)
        padding.PaddingRight = UDim.new(0, 16)
        padding.Parent = card

        return card
    end

    local function createToggleInCard(card, labelText, settingKey, order)
        local initialVal = getConfig(settingKey, false)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 28)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 42, 0, 22)
        toggle.Position = UDim2.new(1, -42, 0.5, -11)
        toggle.BackgroundColor3 = initialVal and Theme.Primary or Theme.Background
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 16, 0, 16)
        indicator.Position = initialVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        indicator.BackgroundColor3 = Theme.TextPrimary
        indicator.Parent = toggle
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        toggle.MouseButton1Click:Connect(function()
            if Config then
                Config[settingKey] = not getConfig(settingKey, false)
            end
            local isActive = getConfig(settingKey, false)
            
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = isActive and Theme.Primary or Theme.Background
            }):Play()
            
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = isActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            }):Play()
        end)
    end

    local function createSliderInCard(card, labelText, settingKey, minVal, maxVal, step, order)
        local initialVal = getConfig(settingKey, minVal)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 42)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.Parent = frame

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.4, 0, 0, 18)
        valLabel.Position = UDim2.new(0.6, 0, 0, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(initialVal)
        valLabel.TextColor3 = Theme.Primary
        valLabel.TextSize = 12
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Font = Enum.Font.GothamBold
        valLabel.Parent = frame

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 0, 0, 6)
        sliderBtn.Position = UDim2.new(0, 0, 0, 26)
        sliderBtn.BackgroundColor3 = Theme.Background
        sliderBtn.Text = ""
        sliderBtn.AutoButtonColor = false
        sliderBtn.Parent = frame
        Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

        local startPercent = math.clamp((initialVal - minVal) / (maxVal - minVal), 0, 1)
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Theme.Primary
        sliderFill.Parent = sliderBtn
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

        local draggingSlider = false
        sliderBtn.InputBegan:Connect(function(input)
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
                local percent = math.clamp((mousePos - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
                local newValue = math.floor((minVal + (maxVal - minVal) * percent) / step + 0.5) * step
                newValue = math.clamp(newValue, minVal, maxVal)

                if Config then
                    Config[settingKey] = newValue
                end
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                local fmt = step % 1 == 0 and "%.0f" or "%.1f"
                valLabel.Text = string.format(fmt, newValue)
            end
        end)
    end

    -- ==========================================
    -- 8. DEKLARASI TAB & POPULASI KONTEN
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

    -- --- TAB ABOUT ---
    createSectionHeader(tabAbout, "Information", 1)
    local aboutCard = createCard(tabAbout, 90, 2)
    local aboutLbl = Instance.new("TextLabel")
    aboutLbl.Size = UDim2.new(1, 0, 1, 0)
    aboutLbl.BackgroundTransparency = 1
    aboutLbl.Text = "H4xScripts Premium Interface\nDeveloped with precision by @Mallo\n\nPress 'Insert' key on keyboard to hide/show window."
    aboutLbl.TextColor3 = Theme.TextMuted
    aboutLbl.TextSize = 12
    aboutLbl.Font = Enum.Font.Gotham
    aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
    aboutLbl.Parent = aboutCard

    -- --- TAB GENERATORS ---
    createSectionHeader(tabGenerators, "Automation Settings", 1)
    local genCard = createCard(tabGenerators, 76, 2)
    createToggleInCard(genCard, "Anti-Fail Generator", "AntiFailGen", 1)
    createToggleInCard(genCard, "Auto Perfect Skill Check", "AutoPerfect", 2)

    -- --- TAB MAIN STUFF ---
    createSectionHeader(tabMain, "Combat & Movement", 1)
    local mainCard = createCard(tabMain, 120, 2)
    createToggleInCard(mainCard, "Auto Parry System", "AutoParry", 1)
    createToggleInCard(mainCard, "Speed Boost", "SpeedBoost", 2)
    createSliderInCard(mainCard, "Targeting Range", "RangeValue", 5, 50, 1, 3)

    -- --- TAB VISUALS ---
    createSectionHeader(tabVisuals, "ESP & Wallhack", 1)
    local visCard = createCard(tabVisuals, 110, 2)
    createToggleInCard(visCard, "Wallhack (Survivor)", "WallhackS", 1)
    createToggleInCard(visCard, "Wallhack (Killer)", "WallhackK", 2)
    createToggleInCard(visCard, "Hook Highlight ESP", "HookESP", 3)

    -- --- TAB OTHERS ---
    createSectionHeader(tabOthers, "Player Modifications", 1)
    local otherCard = createCard(tabOthers, 76, 2)
    createToggleInCard(otherCard, "Auto Vault", "AutoVault", 1)
    createToggleInCard(otherCard, "No Recoil Weapon", "NoRecoil", 2)

    -- --- TAB MISC ---
    createSectionHeader(tabMisc, "Miscellaneous", 1)
    local miscCard = createCard(tabMisc, 76, 2)
    createToggleInCard(miscCard, "LocalPlayer Tweaks", "LocalPlayer", 1)
    createToggleInCard(miscCard, "Range Checker Overlay", "RangeCheck", 2)

    -- --- TAB EMOTES ---
    createSectionHeader(tabEmotes, "Emote Selection", 1)
    local emoteCard = createCard(tabEmotes, 48, 2)
    
    local frameEmote = Instance.new("Frame")
    frameEmote.Size = UDim2.new(1, 0, 1, 0)
    frameEmote.BackgroundTransparency = 1
    frameEmote.Parent = emoteCard

    local labelEmote = Instance.new("TextLabel")
    labelEmote.Size = UDim2.new(0.4, 0, 1, 0)
    labelEmote.BackgroundTransparency = 1
    labelEmote.Text = "Emote Animation"
    labelEmote.TextColor3 = Theme.TextPrimary
    labelEmote.TextSize = 12
    labelEmote.Font = Enum.Font.GothamMedium
    labelEmote.TextXAlignment = Enum.TextXAlignment.Left
    labelEmote.Parent = frameEmote

    local emoteInput = Instance.new("TextBox")
    emoteInput.Size = UDim2.new(0, 110, 0, 26)
    emoteInput.Position = UDim2.new(1, -180, 0.5, -13)
    emoteInput.BackgroundColor3 = Theme.Background
    emoteInput.Text = "4EverLvu"
    emoteInput.TextColor3 = Theme.TextPrimary
    emoteInput.TextSize = 11
    emoteInput.Font = Enum.Font.GothamBold
    emoteInput.Parent = frameEmote
    Instance.new("UICorner", emoteInput).CornerRadius = UDim.new(0, 6)

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0, 60, 0, 26)
    playBtn.Position = UDim2.new(1, -60, 0.5, -13)
    playBtn.BackgroundColor3 = Theme.Primary
    playBtn.Text = "Play"
    playBtn.TextColor3 = Theme.TextPrimary
    playBtn.TextSize = 11
    playBtn.Font = Enum.Font.GothamBold
    playBtn.AutoButtonColor = false
    playBtn.Parent = frameEmote
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)

    playBtn.MouseButton1Click:Connect(function()
        print("Playing emote: " .. emoteInput.Text)
    end)

    -- ==========================================
    -- 9. INITIALIZATION & KEYBINDING
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
