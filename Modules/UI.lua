-- UI.lua (Compact & Next-Gen Modern Redesign)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H4xUI_Compact"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- COLOR PALETTE & DESIGN SYSTEM
    -- ==========================================
    local Theme = {
        Accent = Color3.fromRGB(245, 45, 75),          -- Crimson Neon
        AccentGlow = Color3.fromRGB(255, 60, 90),
        Background = Color3.fromRGB(12, 13, 17),       -- Dark Glass
        Sidebar = Color3.fromRGB(16, 17, 23),          -- Deep Charcoal
        CardBg = Color3.fromRGB(21, 23, 31),           -- Elevated Surface
        CardBorder = Color3.fromRGB(35, 38, 52),       -- Subtle Border
        TextPrimary = Color3.fromRGB(250, 250, 252),
        TextMuted = Color3.fromRGB(130, 135, 155),
        TextDisabled = Color3.fromRGB(80, 85, 105),
    }

    local function getConfig(key, default)
        if Config and Config[key] ~= nil then
            return Config[key]
        end
        return default
    end

    local function animate(obj, props, time)
        return TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    end

    -- ==========================================
    -- 1. FLOATING TOGGLE BUTTON (MOBILE FRIENDLY)
    -- ==========================================
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleUI"
    toggleBtn.Size = UDim2.new(0, 42, 0, 42)
    toggleBtn.Position = UDim2.new(0, 15, 0, 15)
    toggleBtn.BackgroundColor3 = Theme.Sidebar
    toggleBtn.Text = "H"
    toggleBtn.TextColor3 = Theme.Accent
    toggleBtn.TextSize = 18
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = screenGui

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Theme.Accent
    toggleStroke.Thickness = 1.2
    toggleStroke.Transparency = 0.3
    toggleStroke.Parent = toggleBtn

    -- ==========================================
    -- 2. MAIN WINDOW (UKURAN KOMPAK: 560 x 340)
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 560, 0, 340)
    mainWindow.Position = UDim2.new(0.5, -280, 0.5, -170)
    mainWindow.BackgroundColor3 = Theme.Background
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui

    Instance.new("UICorner", mainWindow).CornerRadius = UDim.new(0, 14)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.CardBorder
    mainStroke.Thickness = 1
    mainStroke.Parent = mainWindow

    -- Top Accent Line
    local topBarLine = Instance.new("Frame")
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.BackgroundColor3 = Theme.Accent
    topBarLine.BorderSizePixel = 0
    topBarLine.Parent = mainWindow

    -- ==========================================
    -- 3. DRAGGING SYSTEM (SMOOTH & RESPONSIVE)
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
        mainWindow.Visible = not mainWindow.Visible
    end)

    -- ==========================================
    -- 4. SIDEBAR NAVIGATION
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 160, 1, 0)
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    -- Brand Area
    local brandFrame = Instance.new("Frame")
    brandFrame.Size = UDim2.new(1, 0, 0, 48)
    brandFrame.BackgroundTransparency = 1
    brandFrame.Parent = sidebar

    local logoDot = Instance.new("Frame")
    logoDot.Size = UDim2.new(0, 8, 0, 8)
    logoDot.Position = UDim2.new(0, 14, 0.5, -4)
    logoDot.BackgroundColor3 = Theme.Accent
    logoDot.Parent = brandFrame
    Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1, 0)

    local brandTitle = Instance.new("TextLabel")
    brandTitle.Size = UDim2.new(1, -30, 1, 0)
    brandTitle.Position = UDim2.new(0, 28, 0, 0)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "H4xScripts"
    brandTitle.TextColor3 = Theme.TextPrimary
    brandTitle.TextSize = 13
    brandTitle.Font = Enum.Font.GothamBold
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    brandTitle.Parent = brandFrame

    -- Nav Scroll Container
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -95)
    navScroll.Position = UDim2.new(0, 0, 0, 48)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 0
    navScroll.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navScroll

    -- Profile Footer
    local userProfile = Instance.new("Frame")
    userProfile.Size = UDim2.new(1, -16, 0, 38)
    userProfile.Position = UDim2.new(0, 8, 1, -44)
    userProfile.BackgroundColor3 = Theme.CardBg
    userProfile.Parent = sidebar
    Instance.new("UICorner", userProfile).CornerRadius = UDim.new(0, 8)

    local profileAvatar = Instance.new("ImageLabel")
    profileAvatar.Size = UDim2.new(0, 24, 0, 24)
    profileAvatar.Position = UDim2.new(0, 8, 0.5, -12)
    profileAvatar.BackgroundColor3 = Theme.Background
    profileAvatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    profileAvatar.Parent = userProfile
    Instance.new("UICorner", profileAvatar).CornerRadius = UDim.new(1, 0)

    local profileName = Instance.new("TextLabel")
    profileName.Size = UDim2.new(1, -40, 1, 0)
    profileName.Position = UDim2.new(0, 38, 0, 0)
    profileName.BackgroundTransparency = 1
    profileName.Text = player.DisplayName
    profileName.TextColor3 = Theme.TextPrimary
    profileName.TextSize = 11
    profileName.Font = Enum.Font.GothamSemibold
    profileName.TextXAlignment = Enum.TextXAlignment.Left
    profileName.TextTruncate = Enum.TextTruncate.AtEnd
    profileName.Parent = userProfile

    -- ==========================================
    -- 5. TOP HEADER BAR
    -- ==========================================
    local topHeader = Instance.new("Frame")
    topHeader.Size = UDim2.new(1, -160, 0, 48)
    topHeader.Position = UDim2.new(0, 160, 0, 0)
    topHeader.BackgroundTransparency = 1
    topHeader.Parent = mainWindow

    local currentTabTitle = Instance.new("TextLabel")
    currentTabTitle.Size = UDim2.new(0, 150, 1, 0)
    currentTabTitle.Position = UDim2.new(0, 16, 0, 0)
    currentTabTitle.BackgroundTransparency = 1
    currentTabTitle.Text = "Dashboard"
    currentTabTitle.TextColor3 = Theme.TextPrimary
    currentTabTitle.TextSize = 14
    currentTabTitle.Font = Enum.Font.GothamBold
    currentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    currentTabTitle.Parent = topHeader

    -- Badges
    local badgeBox = Instance.new("Frame")
    badgeBox.Size = UDim2.new(0, 200, 1, 0)
    badgeBox.Position = UDim2.new(1, -236, 0, 0)
    badgeBox.BackgroundTransparency = 1
    badgeBox.Parent = topHeader

    local badgeLayout = Instance.new("UIListLayout")
    badgeLayout.FillDirection = Enum.FillDirection.Horizontal
    badgeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    badgeLayout.Padding = UDim.new(0, 6)
    badgeLayout.Parent = badgeBox

    local function createBadge(text, isAccent)
        local b = Instance.new("TextLabel")
        b.Size = UDim2.new(0, 0, 0, 22)
        b.AutomaticSize = Enum.AutomaticSize.X
        b.BackgroundColor3 = isAccent and Theme.Accent or Theme.CardBg
        b.Text = "  " .. text .. "  "
        b.TextColor3 = Theme.TextPrimary
        b.TextSize = 9
        b.Font = Enum.Font.GothamBold
        b.Parent = badgeBox
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

        if not isAccent then
            local stroke = Instance.new("UIStroke")
            stroke.Color = Theme.CardBorder
            stroke.Thickness = 1
            stroke.Parent = b
        end
    end

    createBadge("Violence District", true)
    createBadge("v2.0", false)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
    closeBtn.BackgroundColor3 = Theme.CardBg
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.TextMuted
    closeBtn.TextSize = 10
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topHeader
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)

    -- ==========================================
    -- 6. CONTENT TABS
    -- ==========================================
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -160, 1, -48)
    contentArea.Position = UDim2.new(0, 160, 0, 48)
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
                animate(btn, {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextPrimary}):Play()
                if line then animate(line, {BackgroundTransparency = 0}):Play() end
            else
                animate(btn, {BackgroundColor3 = Theme.Sidebar, TextColor3 = Theme.TextMuted}):Play()
                if line then animate(line, {BackgroundTransparency = 1}):Play() end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -16, 0, 32)
        btn.BackgroundColor3 = Theme.Sidebar
        btn.Text = "    " .. icon .. "  " .. name
        btn.TextColor3 = Theme.TextMuted
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navScroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local line = Instance.new("Frame")
        line.Name = "ActiveLine"
        line.Size = UDim2.new(0, 3, 0, 14)
        line.Position = UDim2.new(0, 4, 0.5, -7)
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
        scroll.ScrollBarImageColor3 = Theme.CardBorder
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 16)
        pad.PaddingRight = UDim.new(0, 16)
        pad.PaddingBottom = UDim.new(0, 16)
        pad.Parent = scroll

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    -- ==========================================
    -- 7. COMPONENTS (CARDS, TOGGLES, SLIDERS)
    -- ==========================================
    local function createSectionHeader(parent, text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.upper(text)
        lbl.TextColor3 = Theme.TextDisabled
        lbl.TextSize = 9
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

        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.CardBorder
        stroke.Thickness = 1
        stroke.Parent = card

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = card

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
        pad.Parent = card

        return card
    end

    local function createToggleInCard(card, labelText, settingKey, order)
        local initialVal = getConfig(settingKey, false)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 24)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 36, 0, 18)
        toggle.Position = UDim2.new(1, -36, 0.5, -9)
        toggle.BackgroundColor3 = initialVal and Theme.Accent or Theme.Background
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = initialVal and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        knob.BackgroundColor3 = Theme.TextPrimary
        knob.Parent = toggle
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        toggle.MouseButton1Click:Connect(function()
            if Config then
                Config[settingKey] = not getConfig(settingKey, false)
            end
            local isActive = getConfig(settingKey, false)

            animate(toggle, {BackgroundColor3 = isActive and Theme.Accent or Theme.Background}):Play()
            animate(knob, {Position = isActive and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        end)
    end

    local function createSliderInCard(card, labelText, settingKey, minVal, maxVal, step, order)
        local initialVal = getConfig(settingKey, minVal)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 34)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 14)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.TextPrimary
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.Parent = frame

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.4, 0, 0, 14)
        valLabel.Position = UDim2.new(0.6, 0, 0, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(initialVal)
        valLabel.TextColor3 = Theme.Accent
        valLabel.TextSize = 11
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Font = Enum.Font.GothamBold
        valLabel.Parent = frame

        local sliderTrack = Instance.new("TextButton")
        sliderTrack.Size = UDim2.new(1, 0, 0, 4)
        sliderTrack.Position = UDim2.new(0, 0, 0, 22)
        sliderTrack.BackgroundColor3 = Theme.Background
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
    -- 8. TABS INITIALIZATION
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
    local aboutCard = createCard(tabAbout, 75, 2)
    local aboutLbl = Instance.new("TextLabel")
    aboutLbl.Size = UDim2.new(1, 0, 1, 0)
    aboutLbl.BackgroundTransparency = 1
    aboutLbl.Text = "H4xScripts Premium Interface\nDeveloped with precision by @Mallo\n\nPress 'Insert' key to toggle window."
    aboutLbl.TextColor3 = Theme.TextMuted
    aboutLbl.TextSize = 11
    aboutLbl.Font = Enum.Font.Gotham
    aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
    aboutLbl.Parent = aboutCard

    -- Generators Tab
    createSectionHeader(tabGenerators, "Automation", 1)
    local genCard = createCard(tabGenerators, 64, 2)
    createToggleInCard(genCard, "Anti-Fail Generator", "AntiFailGen", 1)
    createToggleInCard(genCard, "Auto Perfect Check", "AutoPerfect", 2)

    -- Main Tab
    createSectionHeader(tabMain, "Combat Features", 1)
    local mainCard = createCard(tabMain, 100, 2)
    createToggleInCard(mainCard, "Auto Parry", "AutoParry", 1)
    createToggleInCard(mainCard, "Speed Boost", "SpeedBoost", 2)
    createSliderInCard(mainCard, "Target Range", "RangeValue", 5, 50, 1, 3)

    -- Visuals Tab
    createSectionHeader(tabVisuals, "ESP & Visuals", 1)
    local visCard = createCard(tabVisuals, 94, 2)
    createToggleInCard(visCard, "Wallhack (Survivor)", "WallhackS", 1)
    createToggleInCard(visCard, "Wallhack (Killer)", "WallhackK", 2)
    createToggleInCard(visCard, "Hook ESP", "HookESP", 3)

    -- Others Tab
    createSectionHeader(tabOthers, "Utilities", 1)
    local otherCard = createCard(tabOthers, 64, 2)
    createToggleInCard(otherCard, "Auto Vault", "AutoVault", 1)
    createToggleInCard(otherCard, "No Recoil", "NoRecoil", 2)

    -- Misc Tab
    createSectionHeader(tabMisc, "System", 1)
    local miscCard = createCard(tabMisc, 64, 2)
    createToggleInCard(miscCard, "LocalPlayer Tweaks", "LocalPlayer", 1)
    createToggleInCard(miscCard, "Range Checker", "RangeCheck", 2)

    -- Emotes Tab
    createSectionHeader(tabEmotes, "Animations", 1)
    local emoteCard = createCard(tabEmotes, 40, 2)
    local emoteFrame = Instance.new("Frame")
    emoteFrame.Size = UDim2.new(1, 0, 1, 0)
    emoteFrame.BackgroundTransparency = 1
    emoteFrame.Parent = emoteCard

    local emoteLbl = Instance.new("TextLabel")
    emoteLbl.Size = UDim2.new(0.4, 0, 1, 0)
    emoteLbl.BackgroundTransparency = 1
    emoteLbl.Text = "Emote Name"
    emoteLbl.TextColor3 = Theme.TextPrimary
    emoteLbl.TextSize = 11
    emoteLbl.Font = Enum.Font.GothamMedium
    emoteLbl.TextXAlignment = Enum.TextXAlignment.Left
    emoteLbl.Parent = emoteFrame

    local emoteBox = Instance.new("TextBox")
    emoteBox.Size = UDim2.new(0, 90, 0, 22)
    emoteBox.Position = UDim2.new(1, -145, 0.5, -11)
    emoteBox.BackgroundColor3 = Theme.Background
    emoteBox.Text = "4EverLvu"
    emoteBox.TextColor3 = Theme.TextPrimary
    emoteBox.TextSize = 10
    emoteBox.Font = Enum.Font.GothamBold
    emoteBox.Parent = emoteFrame
    Instance.new("UICorner", emoteBox).CornerRadius = UDim.new(0, 6)

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0, 50, 0, 22)
    playBtn.Position = UDim2.new(1, -50, 0.5, -11)
    playBtn.BackgroundColor3 = Theme.Accent
    playBtn.Text = "Play"
    playBtn.TextColor3 = Theme.TextPrimary
    playBtn.TextSize = 10
    playBtn.Font = Enum.Font.GothamBold
    playBtn.AutoButtonColor = false
    playBtn.Parent = emoteFrame
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)

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
