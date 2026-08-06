-- UI.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H4xUI_Modern"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- Warna & Tema Glassmorphism (Hitam Transparan)
    -- ==========================================
    local accentColor = Color3.fromRGB(255, 55, 65)      -- Neon Crimson Red Accent
    local bgMainColor = Color3.fromRGB(10, 10, 14)       -- Charcoal/Hitam Transparan
    local bgCardColor = Color3.fromRGB(18, 18, 24)       -- Dark Card Background
    local textPrimary = Color3.fromRGB(245, 245, 250)
    local textSecondary = Color3.fromRGB(150, 150, 165)
    
    local mainTransparency = 0.25                       -- Tingkat Transparansi Background
    local cardTransparency = 0.45

    -- Helper Function Ambil Config Safe
    local function getConfig(key, default)
        if Config and Config[key] ~= nil then
            return Config[key]
        end
        return default
    end

    -- ==========================================
    -- 1. FLOATING TOGGLE BUTTON (Icon Menu Minimalis)
    -- ==========================================
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 48, 0, 48)
    toggleBtn.Position = UDim2.new(0, 20, 0, 20)
    toggleBtn.BackgroundColor3 = bgMainColor
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Image = "rbxassetid://6031090793"
    toggleBtn.ImageColor3 = accentColor
    toggleBtn.Parent = screenGui

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = accentColor
    toggleStroke.Thickness = 1.5
    toggleStroke.Transparency = 0.3

    -- ==========================================
    -- 2. MAIN WINDOW (Jendela Utama Glassmorphism)
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Size = UDim2.new(0, 720, 0, 460)
    mainWindow.Position = UDim2.new(0.5, -360, 0.5, -230)
    mainWindow.BackgroundColor3 = bgMainColor
    mainWindow.BackgroundTransparency = mainTransparency
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Visible = true
    mainWindow.Parent = screenGui

    Instance.new("UICorner", mainWindow).CornerRadius = UDim.new(0, 16)
    
    local mainStroke = Instance.new("UIStroke", mainWindow)
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.85

    -- ==========================================
    -- 3. DRAGGING SYSTEM (Smooth Motion)
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
            TweenService:Create(mainWindow, TweenInfo.new(0.08, Enum.EasingStyle.Sine), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Toggle Frame via Float Button
    toggleBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = not mainWindow.Visible
    end)

    -- ==========================================
    -- 4. SIDEBAR NAVIGATION
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    sidebar.BackgroundTransparency = 0.3
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    local sideDivider = Instance.new("Frame")
    sideDivider.Size = UDim2.new(0, 1, 1, 0)
    sideDivider.Position = UDim2.new(1, -1, 0, 0)
    sideDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sideDivider.BackgroundTransparency = 0.9
    sideDivider.BorderSizePixel = 0
    sideDivider.Parent = sidebar

    -- Logo & Brand Header
    local brandFrame = Instance.new("Frame")
    brandFrame.Size = UDim2.new(1, 0, 0, 60)
    brandFrame.BackgroundTransparency = 1
    brandFrame.Parent = sidebar

    local brandTitle = Instance.new("TextLabel")
    brandTitle.Size = UDim2.new(1, -24, 0, 24)
    brandTitle.Position = UDim2.new(0, 18, 0, 14)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "H4X <font color=\"rgb(255,55,65)\">HUB</font>"
    brandTitle.RichText = true
    brandTitle.TextColor3 = textPrimary
    brandTitle.TextSize = 18
    brandTitle.Font = Enum.Font.GothamBold
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    brandTitle.Parent = brandFrame

    local brandSub = Instance.new("TextLabel")
    brandSub.Size = UDim2.new(1, -24, 0, 14)
    brandSub.Position = UDim2.new(0, 18, 0, 36)
    brandSub.BackgroundTransparency = 1
    brandSub.Text = "Violence District • Remake"
    brandSub.TextColor3 = textSecondary
    brandSub.TextSize = 10
    brandSub.Font = Enum.Font.Gotham
    brandSub.TextXAlignment = Enum.TextXAlignment.Left
    brandSub.Parent = brandFrame

    -- Navigation Container
    local navContainer = Instance.new("ScrollingFrame")
    navContainer.Size = UDim2.new(1, 0, 1, -130)
    navContainer.Position = UDim2.new(0, 0, 0, 65)
    navContainer.BackgroundTransparency = 1
    navContainer.BorderSizePixel = 0
    navContainer.ScrollBarThickness = 0
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    -- User Info Card Bottom
    local userProfile = Instance.new("Frame")
    userProfile.Size = UDim2.new(1, -24, 0, 48)
    userProfile.Position = UDim2.new(0, 12, 1, -58)
    userProfile.BackgroundColor3 = bgCardColor
    userProfile.BackgroundTransparency = 0.5
    userProfile.Parent = sidebar
    Instance.new("UICorner", userProfile).CornerRadius = UDim.new(0, 10)

    local profileAvatar = Instance.new("ImageLabel")
    profileAvatar.Size = UDim2.new(0, 32, 0, 32)
    profileAvatar.Position = UDim2.new(0, 8, 0.5, -16)
    profileAvatar.BackgroundTransparency = 1
    profileAvatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    profileAvatar.Parent = userProfile
    Instance.new("UICorner", profileAvatar).CornerRadius = UDim.new(1, 0)

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -50, 0, 16)
    userLbl.Position = UDim2.new(0, 46, 0, 8)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = player.DisplayName
    userLbl.TextColor3 = textPrimary
    userLbl.TextSize = 12
    userLbl.Font = Enum.Font.GothamBold
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.Parent = userProfile

    local userSubLbl = Instance.new("TextLabel")
    userSubLbl.Size = UDim2.new(1, -50, 0, 14)
    userSubLbl.Position = UDim2.new(0, 46, 0, 24)
    userSubLbl.BackgroundTransparency = 1
    userSubLbl.Text = "@" .. player.Name
    userSubLbl.TextColor3 = textSecondary
    userSubLbl.TextSize = 10
    userSubLbl.Font = Enum.Font.Gotham
    userSubLbl.TextXAlignment = Enum.TextXAlignment.Left
    userSubLbl.Parent = userProfile

    -- ==========================================
    -- 5. TOP BAR & CONTENT AREA
    -- ==========================================
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, -200, 0, 50)
    topBar.Position = UDim2.new(0, 200, 0, 0)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainWindow

    local currentTabTitle = Instance.new("TextLabel")
    currentTabTitle.Size = UDim2.new(0, 200, 1, 0)
    currentTabTitle.Position = UDim2.new(0, 20, 0, 0)
    currentTabTitle.BackgroundTransparency = 1
    currentTabTitle.Text = "Dashboard"
    currentTabTitle.TextColor3 = textPrimary
    currentTabTitle.TextSize = 16
    currentTabTitle.Font = Enum.Font.GothamBold
    currentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    currentTabTitle.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 0.9
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = textPrimary
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -200, 1, -50)
    contentArea.Position = UDim2.new(0, 200, 0, 50)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainWindow

    -- Navigasi Controller
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
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, BackgroundColor3 = accentColor}):Play()
                btn.TextColor3 = textPrimary
                btn.Font = Enum.Font.GothamBold
                if indicator then
                    TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 18)}):Play()
                end
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                btn.TextColor3 = textSecondary
                btn.Font = Enum.Font.Gotham
                if indicator then
                    TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
                end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -24, 0, 38)
        btn.BackgroundColor3 = accentColor
        btn.BackgroundTransparency = 1
        btn.Text = "   " .. icon .. "   " .. name
        btn.TextColor3 = textSecondary
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 3, 0, 0)
        indicator.Position = UDim2.new(0, 0, 0.5, 0)
        indicator.AnchorPoint = Vector2.new(0, 0.5)
        indicator.BackgroundColor3 = accentColor
        indicator.BorderSizePixel = 0
        indicator.Parent = btn
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

        navButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            SwitchTab(name)
        end)
    end

    local function CreateTab(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, -30, 1, -15)
        scroll.Position = UDim2.new(0, 15, 0, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = accentColor
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
    -- 6. MODERN UI COMPONENT BUILDERS
    -- ==========================================
    local function createSectionHeader(parent, text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.upper(text)
        lbl.TextColor3 = accentColor
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.Parent = parent
    end

    local function createCard(parent, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = bgCardColor
        card.BackgroundTransparency = cardTransparency
        card.LayoutOrder = order
        card.Parent = parent
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1
        stroke.Transparency = 0.92

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = card

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)
        padding.Parent = card

        return card
    end

    local function createToggleInCard(card, labelText, settingKey, order)
        local initialVal = getConfig(settingKey, false)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 32)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = textPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 44, 0, 22)
        toggle.Position = UDim2.new(1, -44, 0.5, -11)
        toggle.BackgroundColor3 = initialVal and accentColor or Color3.fromRGB(35, 35, 45)
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 16, 0, 16)
        indicator.Position = initialVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = toggle
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        toggle.MouseButton1Click:Connect(function()
            if Config then
                Config[settingKey] = not getConfig(settingKey, false)
            end
            local isActive = getConfig(settingKey, false)
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = isActive and accentColor or Color3.fromRGB(35, 35, 45)
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
        label.TextColor3 = textPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.4, 0, 0, 18)
        valLabel.Position = UDim2.new(0.6, 0, 0, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(initialVal)
        valLabel.TextColor3 = accentColor
        valLabel.TextSize = 13
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Font = Enum.Font.GothamBold
        valLabel.Parent = frame

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 0, 0, 6)
        sliderBtn.Position = UDim2.new(0, 0, 0, 26)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        sliderBtn.Text = ""
        sliderBtn.AutoButtonColor = false
        sliderBtn.Parent = frame
        Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

        local startPercent = math.clamp((initialVal - minVal) / (maxVal - minVal), 0, 1)
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = accentColor
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
    -- 7. BUILD TABS & CONTENT
    -- ==========================================
    CreateNavButton("About", "ℹ️", 1)
    CreateNavButton("Generators", "⚡", 2)
    CreateNavButton("Main Stuff", "🔧", 3)
    CreateNavButton("Visuals", "🎨", 4)
    CreateNavButton("Others", "📂", 5)
    CreateNavButton("Misc", "🔄", 6)
    CreateNavButton("Emotes", "💃", 7)

    local tabAbout = CreateTab("About")
    local tabGenerators = CreateTab("Generators")
    local tabMain = CreateTab("Main Stuff")
    local tabVisuals = CreateTab("Visuals")
    local tabOthers = CreateTab("Others")
    local tabMisc = CreateTab("Misc")
    local tabEmotes = CreateTab("Emotes")

    -- Tab About
    createSectionHeader(tabAbout, "Information", 1)
    local aboutCard = createCard(tabAbout, 2)
    local aboutLbl = Instance.new("TextLabel")
    aboutLbl.Size = UDim2.new(1, 0, 0, 60)
    aboutLbl.BackgroundTransparency = 1
    aboutLbl.Text = "H4xScripts - Premium Edition\nDeveloped by @Mallo\nVersion: 2.0 (Glassmorphism Redesign)"
    aboutLbl.TextColor3 = textSecondary
    aboutLbl.TextSize = 13
    aboutLbl.Font = Enum.Font.Gotham
    aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
    aboutLbl.Parent = aboutCard

    -- Tab Generators
    createSectionHeader(tabGenerators, "Automation", 1)
    local genCard = createCard(tabGenerators, 2)
    createToggleInCard(genCard, "Anti-Fail Generator", "AntiFailGen", 1)
    createToggleInCard(genCard, "Auto Perfect Skill Check", "AutoPerfect", 2)

    -- Tab Main Stuff
    createSectionHeader(tabMain, "Combat & Movement", 1)
    local mainCard = createCard(tabMain, 2)
    createToggleInCard(mainCard, "Auto Parry", "AutoParry", 1)
    createToggleInCard(mainCard, "Speed Boost", "SpeedBoost", 2)
    createSliderInCard(mainCard, "Parry Range", "RangeValue", 5, 50, 1, 3)

    -- Tab Visuals
    createSectionHeader(tabVisuals, "ESP & Overlays", 1)
    local visCard = createCard(tabVisuals, 2)
    createToggleInCard(visCard, "Wallhack (Survivor)", "WallhackS", 1)
    createToggleInCard(visCard, "Wallhack (Killer)", "WallhackK", 2)
    createToggleInCard(visCard, "Hook ESP", "HookESP", 3)

    -- Tab Others
    createSectionHeader(tabOthers, "Player Utilities", 1)
    local otherCard = createCard(tabOthers, 2)
    createToggleInCard(otherCard, "Auto Vault", "AutoVault", 1)
    createToggleInCard(otherCard, "No Recoil", "NoRecoil", 2)

    -- Tab Misc
    createSectionHeader(tabMisc, "Miscellaneous", 1)
    local miscCard = createCard(tabMisc, 2)
    createToggleInCard(miscCard, "LocalPlayer Modifications", "LocalPlayer", 1)
    createToggleInCard(miscCard, "Range Check Indicator", "RangeCheck", 2)

    -- Tab Emotes
    createSectionHeader(tabEmotes, "Emote Player", 1)
    local emoteCard = createCard(tabEmotes, 2)
    local frameEmote = Instance.new("Frame")
    frameEmote.Size = UDim2.new(1, 0, 0, 36)
    frameEmote.BackgroundTransparency = 1
    frameEmote.LayoutOrder = 1
    frameEmote.Parent = emoteCard

    local labelEmote = Instance.new("TextLabel")
    labelEmote.Size = UDim2.new(0.4, 0, 1, 0)
    labelEmote.BackgroundTransparency = 1
    labelEmote.Text = "Select Animation"
    labelEmote.TextColor3 = textPrimary
    labelEmote.TextSize = 13
    labelEmote.Font = Enum.Font.GothamSemibold
    labelEmote.TextXAlignment = Enum.TextXAlignment.Left
    labelEmote.Parent = frameEmote

    local emoteDropdown = Instance.new("TextBox")
    emoteDropdown.Size = UDim2.new(0, 110, 0, 28)
    emoteDropdown.Position = UDim2.new(1, -180, 0.5, -14)
    emoteDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    emoteDropdown.Text = "4EverLvu"
    emoteDropdown.TextColor3 = textPrimary
    emoteDropdown.TextSize = 12
    emoteDropdown.Font = Enum.Font.GothamMedium
    emoteDropdown.Parent = frameEmote
    Instance.new("UICorner", emoteDropdown).CornerRadius = UDim.new(0, 6)

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0, 60, 0, 28)
    playBtn.Position = UDim2.new(1, -60, 0.5, -14)
    playBtn.BackgroundColor3 = accentColor
    playBtn.Text = "Play"
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.TextSize = 12
    playBtn.Font = Enum.Font.GothamBold
    playBtn.Parent = frameEmote
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)

    playBtn.MouseButton1Click:Connect(function()
        print("Playing emote: " .. emoteDropdown.Text)
    end)

    -- ==========================================
    -- 8. DEFAULT INITIALIZATION & KEYBIND
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
