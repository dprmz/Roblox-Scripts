-- UI.lua (Ultra-Modern Glassmorphism Edition)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H4xUI_Ultra"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- COLOR PALETTE & DESIGN SYSTEM
    -- ==========================================
    local Theme = {
        Accent = Color3.fromRGB(255, 60, 90),         -- Neon Crimson Accent
        AccentGlow = Color3.fromRGB(255, 60, 90),     -- Glow Base
        AccentGradient = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 75, 105)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 30, 60))
        },
        Background = Color3.fromRGB(11, 12, 16),      -- Ultra Dark Canvas
        Sidebar = Color3.fromRGB(16, 18, 24),         -- Glass Sidebar Base
        CardBg = Color3.fromRGB(22, 25, 34),          -- Surface Card Color
        CardBorder = Color3.fromRGB(38, 42, 56),      -- Soft Inner Border
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(160, 165, 185),
        TextDisabled = Color3.fromRGB(90, 95, 115),
    }

    local function getConfig(key, default)
        if Config and Config[key] ~= nil then
            return Config[key]
        end
        return default
    end

    -- Helper Animasi
    local function springTween(obj, props, duration)
        return TweenService:Create(obj, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    end

    -- ==========================================
    -- 1. FLOATING TOGGLE BUTTON (Modern Pill)
    -- ==========================================
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "FloatingToggle"
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 24, 0, 24)
    toggleBtn.BackgroundColor3 = Theme.Sidebar
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = screenGui

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 14)

    local toggleGlow = Instance.new("UIStroke")
    toggleGlow.Color = Theme.Accent
    toggleGlow.Thickness = 1.5
    toggleGlow.Transparency = 0.2
    toggleGlow.Parent = toggleBtn

    local toggleIcon = Instance.new("ImageLabel")
    toggleIcon.Size = UDim2.new(0, 24, 0, 24)
    toggleIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
    toggleIcon.BackgroundTransparency = 1
    toggleIcon.Image = "rbxassetid://6031090793"
    toggleIcon.ImageColor3 = Theme.Accent
    toggleIcon.Parent = toggleBtn

    -- ==========================================
    -- 2. MAIN CONTAINER WINDOW
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 760, 0, 500)
    mainWindow.Position = UDim2.new(0.5, -380, 0.5, -250)
    mainWindow.BackgroundColor3 = Theme.Background
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui

    Instance.new("UICorner", mainWindow).CornerRadius = UDim.new(0, 20)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.CardBorder
    mainStroke.Thickness = 1
    mainStroke.Parent = mainWindow

    -- Glow Accent Shadow (Visual Highlight)
    local topGlowLine = Instance.new("Frame")
    topGlowLine.Size = UDim2.new(1, 0, 0, 2)
    topGlowLine.Position = UDim2.new(0, 0, 0, 0)
    topGlowLine.BorderSizePixel = 0
    topGlowLine.Parent = mainWindow

    local glowGradient = Instance.new("UIGradient")
    glowGradient.Color = Theme.AccentGradient
    glowGradient.Parent = topGlowLine

    -- ==========================================
    -- 3. SMOOTH DRAGGING LOGIC
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
            springTween(mainWindow, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.08):Play()
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
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 220, 1, 0)
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    -- Top Branding Area
    local brandBox = Instance.new("Frame")
    brandBox.Size = UDim2.new(1, 0, 0, 70)
    brandBox.BackgroundTransparency = 1
    brandBox.Parent = sidebar

    local logoBadge = Instance.new("Frame")
    logoBadge.Size = UDim2.new(0, 32, 0, 32)
    logoBadge.Position = UDim2.new(0, 20, 0.5, -16)
    logoBadge.BackgroundColor3 = Theme.Accent
    logoBadge.Parent = brandBox
    Instance.new("UICorner", logoBadge).CornerRadius = UDim.new(0, 10)

    local logoGradient = Instance.new("UIGradient")
    logoGradient.Color = Theme.AccentGradient
    logoGradient.Parent = logoBadge

    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "H"
    logoText.TextColor3 = Theme.TextPrimary
    logoText.TextSize = 18
    logoText.Font = Enum.Font.GothamBold
    logoText.Parent = logoBadge

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -70, 0, 20)
    titleLbl.Position = UDim2.new(0, 62, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "H4xScripts"
    titleLbl.TextColor3 = Theme.TextPrimary
    titleLbl.TextSize = 15
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = brandBox

    local verLbl = Instance.new("TextLabel")
    verLbl.Size = UDim2.new(1, -70, 0, 16)
    verLbl.Position = UDim2.new(0, 62, 0, 36)
    verLbl.BackgroundTransparency = 1
    verLbl.Text = "v2.0 Premium Hub"
    verLbl.TextColor3 = Theme.TextDisabled
    verLbl.TextSize = 10
    verLbl.Font = Enum.Font.Gotham
    verLbl.TextXAlignment = Enum.TextXAlignment.Left
    verLbl.Parent = brandBox

    -- Navigation List Container
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -145)
    navScroll.Position = UDim2.new(0, 0, 0, 70)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 0
    navScroll.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 6)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navScroll

    -- Profile Card Bottom
    local userCard = Instance.new("Frame")
    userCard.Size = UDim2.new(1, -28, 0, 56)
    userCard.Position = UDim2.new(0, 14, 1, -70)
    userCard.BackgroundColor3 = Theme.CardBg
    userCard.Parent = sidebar
    Instance.new("UICorner", userCard).CornerRadius = UDim.new(0, 12)

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Theme.CardBorder
    cardStroke.Thickness = 1
    cardStroke.Parent = userCard

    local userAvatar = Instance.new("ImageLabel")
    userAvatar.Size = UDim2.new(0, 36, 0, 36)
    userAvatar.Position = UDim2.new(0, 10, 0.5, -18)
    userAvatar.BackgroundColor3 = Theme.Background
    userAvatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    userAvatar.Parent = userCard
    Instance.new("UICorner", userAvatar).CornerRadius = UDim.new(1, 0)

    local uNameLbl = Instance.new("TextLabel")
    uNameLbl.Size = UDim2.new(1, -56, 0, 18)
    uNameLbl.Position = UDim2.new(0, 52, 0, 10)
    uNameLbl.BackgroundTransparency = 1
    uNameLbl.Text = player.DisplayName
    uNameLbl.TextColor3 = Theme.TextPrimary
    uNameLbl.TextSize = 12
    uNameLbl.Font = Enum.Font.GothamBold
    uNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    uNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    uNameLbl.Parent = userCard

    local uTagLbl = Instance.new("TextLabel")
    uTagLbl.Size = UDim2.new(1, -56, 0, 14)
    uTagLbl.Position = UDim2.new(0, 52, 0, 28)
    uTagLbl.BackgroundTransparency = 1
    uTagLbl.Text = "@" .. player.Name
    uTagLbl.TextColor3 = Theme.TextSecondary
    uTagLbl.TextSize = 10
    uTagLbl.Font = Enum.Font.Gotham
    uTagLbl.TextXAlignment = Enum.TextXAlignment.Left
    uTagLbl.TextTruncate = Enum.TextTruncate.AtEnd
    uTagLbl.Parent = userCard

    -- ==========================================
    -- 5. TOP HEADER BAR
    -- ==========================================
    local topHeader = Instance.new("Frame")
    topHeader.Size = UDim2.new(1, -220, 0, 70)
    topHeader.Position = UDim2.new(0, 220, 0, 0)
    topHeader.BackgroundTransparency = 1
    topHeader.Parent = mainWindow

    local currentTabTitle = Instance.new("TextLabel")
    currentTabTitle.Size = UDim2.new(0, 200, 1, 0)
    currentTabTitle.Position = UDim2.new(0, 24, 0, 0)
    currentTabTitle.BackgroundTransparency = 1
    currentTabTitle.Text = "Dashboard"
    currentTabTitle.TextColor3 = Theme.TextPrimary
    currentTabTitle.TextSize = 18
    currentTabTitle.Font = Enum.Font.GothamBold
    currentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    currentTabTitle.Parent = topHeader

    -- Header Badges
    local badgeContainer = Instance.new("Frame")
    badgeContainer.Size = UDim2.new(0, 250, 1, 0)
    badgeContainer.Position = UDim2.new(1, -290, 0, 0)
    badgeContainer.BackgroundTransparency = 1
    badgeContainer.Parent = topHeader

    local badgeLayout = Instance.new("UIListLayout")
    badgeLayout.FillDirection = Enum.FillDirection.Horizontal
    badgeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    badgeLayout.Padding = UDim.new(0, 8)
    badgeLayout.Parent = badgeContainer

    local function addBadge(text, isAccent)
        local b = Instance.new("TextLabel")
        b.Size = UDim2.new(0, 0, 0, 26)
        b.AutomaticSize = Enum.AutomaticSize.X
        b.BackgroundColor3 = isAccent and Theme.Accent or Theme.CardBg
        b.Text = "  " .. text .. "  "
        b.TextColor3 = Theme.TextPrimary
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.Parent = badgeContainer
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

        if not isAccent then
            local stroke = Instance.new("UIStroke")
            stroke.Color = Theme.CardBorder
            stroke.Thickness = 1
            stroke.Parent = b
        end
    end

    addBadge("Violence District", true)
    addBadge("Remake", false)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
    closeBtn.BackgroundColor3 = Theme.CardBg
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topHeader
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Theme.CardBorder
    closeStroke.Thickness = 1
    closeStroke.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        springTween(closeBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        springTween(closeBtn, {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextSecondary}):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)

    -- ==========================================
    -- 6. TABS & CONTENT SYSTEM
    -- ==========================================
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -220, 1, -70)
    contentArea.Position = UDim2.new(0, 220, 0, 70)
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
            local pillar = btn:FindFirstChild("ActivePillar")
            if name == tabName then
                springTween(btn, {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextPrimary}):Play()
                if pillar then springTween(pillar, {BackgroundTransparency = 0}):Play() end
            else
                springTween(btn, {BackgroundColor3 = Theme.Sidebar, TextColor3 = Theme.TextSecondary}):Play()
                if pillar then springTween(pillar, {BackgroundTransparency = 1}):Play() end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -24, 0, 40)
        btn.BackgroundColor3 = Theme.Sidebar
        btn.Text = "     " .. icon .. "   " .. name
        btn.TextColor3 = Theme.TextSecondary
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navScroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local pillar = Instance.new("Frame")
        pillar.Name = "ActivePillar"
        pillar.Size = UDim2.new(0, 4, 0, 18)
        pillar.Position = UDim2.new(0, 6, 0.5, -9)
        pillar.BackgroundColor3 = Theme.Accent
        pillar.BackgroundTransparency = 1
        pillar.Parent = btn
        Instance.new("UICorner", pillar).CornerRadius = UDim.new(1, 0)

        navButtons[name] = btn

        btn.MouseEnter:Connect(function()
            if currentTabTitle.Text ~= name then
                springTween(btn, {TextColor3 = Theme.TextPrimary}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if currentTabTitle.Text ~= name then
                springTween(btn, {TextColor3 = Theme.TextSecondary}):Play()
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
        scroll.ScrollBarImageColor3 = Theme.CardBorder
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 24)
        pad.PaddingRight = UDim.new(0, 24)
        pad.PaddingBottom = UDim.new(0, 24)
        pad.Parent = scroll

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 14)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    -- ==========================================
    -- 7. MODERN COMPONENT BUILDERS
    -- ==========================================
    local function createSectionHeader(parent, text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.upper(text)
        lbl.TextColor3 = Theme.TextDisabled
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

        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.CardBorder
        stroke.Thickness = 1
        stroke.Parent = card

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = card

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 12)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 16)
        pad.PaddingRight = UDim.new(0, 16)
        pad.Parent = card

        return card
    end

    local function createToggleInCard(card, labelText, settingKey, order)
        local initialVal = getConfig(settingKey, false)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 30)
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
        toggle.Size = UDim2.new(0, 44, 0, 24)
        toggle.Position = UDim2.new(1, -44, 0.5, -12)
        toggle.BackgroundColor3 = initialVal and Theme.Accent or Theme.Background
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.CardBorder
        stroke.Thickness = 1
        stroke.Parent = toggle

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = initialVal and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Theme.TextPrimary
        knob.Parent = toggle
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        toggle.MouseButton1Click:Connect(function()
            if Config then
                Config[settingKey] = not getConfig(settingKey, false)
            end
            local isActive = getConfig(settingKey, false)

            springTween(toggle, {BackgroundColor3 = isActive and Theme.Accent or Theme.Background}):Play()
            springTween(knob, {Position = isActive and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
        end)
    end

    local function createSliderInCard(card, labelText, settingKey, minVal, maxVal, step, order)
        local initialVal = getConfig(settingKey, minVal)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 44)
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
        valLabel.TextColor3 = Theme.Accent
        valLabel.TextSize = 12
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Font = Enum.Font.GothamBold
        valLabel.Parent = frame

        local sliderTrack = Instance.new("TextButton")
        sliderTrack.Size = UDim2.new(1, 0, 0, 6)
        sliderTrack.Position = UDim2.new(0, 0, 0, 28)
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
                local fmt = step % 1 == 0 and "%.0f" or "%.1f"
                valLabel.Text = string.format(fmt, newValue)
            end
        end)
    end

    -- ==========================================
    -- 8. BUILD ALL TABS & CONTENT
    -- ==========================================
    CreateNavButton("About", "💎", 1)
    CreateNavButton("Generators", "⚡", 2)
    CreateNavButton("Main Stuff", "⚔️", 3)
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
    createSectionHeader(tabAbout, "Script Information", 1)
    local aboutCard = createCard(tabAbout, 90, 2)
    local aboutLbl = Instance.new("TextLabel")
    aboutLbl.Size = UDim2.new(1, 0, 1, 0)
    aboutLbl.BackgroundTransparency = 1
    aboutLbl.Text = "H4xScripts - Premium Edition\nDeveloper: @Mallo\nFramework: V2 Glassmorphism Core\nPress 'Insert' key to toggle window visibility."
    aboutLbl.TextColor3 = Theme.TextSecondary
    aboutLbl.TextSize = 12
    aboutLbl.Font = Enum.Font.GothamMedium
    aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
    aboutLbl.Parent = aboutCard

    -- Generators Tab
    createSectionHeader(tabGenerators, "Generator Automations", 1)
    local genCard = createCard(tabGenerators, 80, 2)
    createToggleInCard(genCard, "Anti-Fail Generator Check", "AntiFailGen", 1)
    createToggleInCard(genCard, "Auto Perfect Skill Check", "AutoPerfect", 2)

    -- Main Tab
    createSectionHeader(tabMain, "Combat Features", 1)
    local mainCard = createCard(tabMain, 124, 2)
    createToggleInCard(mainCard, "Auto Parry Protection", "AutoParry", 1)
    createToggleInCard(mainCard, "Movement Speed Boost", "SpeedBoost", 2)
    createSliderInCard(mainCard, "Interaction Range", "RangeValue", 5, 50, 1, 3)

    -- Visuals Tab
    createSectionHeader(tabVisuals, "ESP & Vision", 1)
    local visCard = createCard(tabVisuals, 116, 2)
    createToggleInCard(visCard, "Wallhack (Survivor)", "WallhackS", 1)
    createToggleInCard(visCard, "Wallhack (Killer)", "WallhackK", 2)
    createToggleInCard(visCard, "Hook Highlight ESP", "HookESP", 3)

    -- Others Tab
    createSectionHeader(tabOthers, "Utility Tools", 1)
    local otherCard = createCard(tabOthers, 80, 2)
    createToggleInCard(otherCard, "Auto Vault Obstacles", "AutoVault", 1)
    createToggleInCard(otherCard, "No Recoil Weapon", "NoRecoil", 2)

    -- Misc Tab
    createSectionHeader(tabMisc, "System Tweaks", 1)
    local miscCard = createCard(tabMisc, 80, 2)
    createToggleInCard(miscCard, "LocalPlayer Tweaks", "LocalPlayer", 1)
    createToggleInCard(miscCard, "Range Checker Indicator", "RangeCheck", 2)

    -- Emotes Tab
    createSectionHeader(tabEmotes, "Custom Animations", 1)
    local emoteCard = createCard(tabEmotes, 52, 2)
    local emoteFrame = Instance.new("Frame")
    emoteFrame.Size = UDim2.new(1, 0, 1, 0)
    emoteFrame.BackgroundTransparency = 1
    emoteFrame.Parent = emoteCard

    local emoteLbl = Instance.new("TextLabel")
    emoteLbl.Size = UDim2.new(0.4, 0, 1, 0)
    emoteLbl.BackgroundTransparency = 1
    emoteLbl.Text = "Select Animation"
    emoteLbl.TextColor3 = Theme.TextPrimary
    emoteLbl.TextSize = 12
    emoteLbl.Font = Enum.Font.GothamMedium
    emoteLbl.TextXAlignment = Enum.TextXAlignment.Left
    emoteLbl.Parent = emoteFrame

    local emoteBox = Instance.new("TextBox")
    emoteBox.Size = UDim2.new(0, 110, 0, 28)
    emoteBox.Position = UDim2.new(1, -180, 0.5, -14)
    emoteBox.BackgroundColor3 = Theme.Background
    emoteBox.Text = "4EverLvu"
    emoteBox.TextColor3 = Theme.TextPrimary
    emoteBox.TextSize = 11
    emoteBox.Font = Enum.Font.GothamBold
    emoteBox.Parent = emoteFrame
    Instance.new("UICorner", emoteBox).CornerRadius = UDim.new(0, 8)

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Theme.CardBorder
    boxStroke.Thickness = 1
    boxStroke.Parent = emoteBox

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0, 60, 0, 28)
    playBtn.Position = UDim2.new(1, -60, 0.5, -14)
    playBtn.BackgroundColor3 = Theme.Accent
    playBtn.Text = "Play"
    playBtn.TextColor3 = Theme.TextPrimary
    playBtn.TextSize = 11
    playBtn.Font = Enum.Font.GothamBold
    playBtn.AutoButtonColor = false
    playBtn.Parent = emoteFrame
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 8)

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
