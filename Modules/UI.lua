```lua
-- UI.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UI = {}

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H4xUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- Warna & Tema
    -- ==========================================
    local primaryColor = Color3.fromRGB(220, 40, 40)   -- Merah utama
    local bgColor = Color3.fromRGB(12, 12, 16)
    local bgTransparency = 0.25

    -- ==========================================
    -- 1. TOGGLE BUTTON (Floating)
    -- ==========================================
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 15, 0, 15)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Image = "rbxassetid://6031090793" -- ikon roda gigi
    toggleBtn.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = primaryColor
    toggleStroke.Thickness = 2
    toggleStroke.Transparency = 0.4
    toggleStroke.Parent = toggleBtn

    -- ==========================================
    -- 2. MAIN WINDOW (Modern, Transparan)
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Size = UDim2.new(0, 680, 0, 440)
    mainWindow.Position = UDim2.new(0.5, -340, 0.5, -220)
    mainWindow.BackgroundColor3 = bgColor
    mainWindow.BackgroundTransparency = bgTransparency
    mainWindow.BorderSizePixel = 0
    mainWindow.Visible = true
    mainWindow.Parent = screenGui

    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 12)
    windowCorner.Parent = mainWindow

    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = primaryColor
    windowStroke.Thickness = 1.5
    windowStroke.Transparency = 0.25
    windowStroke.Parent = mainWindow

    -- ==========================================
    -- 3. DRAGGING LOGIC
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
            mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ==========================================
    -- 4. TOP BAR (Header mirip gambar)
    -- ==========================================
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 52)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainWindow

    -- Logo / Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 18, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "H4xScripts"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Dev tag
    local devLabel = Instance.new("TextLabel")
    devLabel.Size = UDim2.new(0, 100, 0, 20)
    devLabel.Position = UDim2.new(0, 130, 0.5, -10)
    devLabel.BackgroundTransparency = 1
    devLabel.Text = "Dev @Mallo"
    devLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    devLabel.TextSize = 12
    devLabel.Font = Enum.Font.Gotham
    devLabel.TextXAlignment = Enum.TextXAlignment.Left
    devLabel.Parent = topBar

    -- Game badge (Violence district Remake)
    local badgeContainer = Instance.new("Frame")
    badgeContainer.Size = UDim2.new(0, 200, 1, 0)
    badgeContainer.Position = UDim2.new(1, -210, 0, 0)
    badgeContainer.BackgroundTransparency = 1
    badgeContainer.Parent = topBar

    local badge1 = Instance.new("TextLabel")
    badge1.Size = UDim2.new(0, 110, 0, 26)
    badge1.Position = UDim2.new(0, 0, 0.5, -13)
    badge1.BackgroundColor3 = primaryColor
    badge1.Text = "Violence district"
    badge1.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge1.TextSize = 11
    badge1.Font = Enum.Font.GothamBold
    badge1.Parent = badgeContainer
    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(1, 0)
    c1.Parent = badge1

    local badge2 = Instance.new("TextLabel")
    badge2.Size = UDim2.new(0, 65, 0, 26)
    badge2.Position = UDim2.new(0, 115, 0.5, -13)
    badge2.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    badge2.Text = "Remake"
    badge2.TextColor3 = Color3.fromRGB(200, 200, 200)
    badge2.TextSize = 11
    badge2.Font = Enum.Font.GothamBold
    badge2.Parent = badgeContainer
    local c2 = Instance.new("UICorner")
    c2.CornerRadius = UDim.new(1, 0)
    c2.Parent = badge2

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
    closeBtn.BackgroundColor3 = primaryColor
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 6)
    cc.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)

    -- ==========================================
    -- 5. SIDEBAR NAVIGASI (Modern, Transparan)
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 170, 1, -52)
    sidebar.Position = UDim2.new(0, 0, 0, 52)
    sidebar.BackgroundColor3 = bgColor
    sidebar.BackgroundTransparency = 0.15
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    local sideStroke = Instance.new("UIStroke")
    sideStroke.Color = primaryColor
    sideStroke.Thickness = 0.5
    sideStroke.Transparency = 0.3
    sideStroke.Parent = sidebar

    -- Nav Container
    local navContainer = Instance.new("Frame")
    navContainer.Size = UDim2.new(1, 0, 1, -70)
    navContainer.Position = UDim2.new(0, 0, 0, 10)
    navContainer.BackgroundTransparency = 1
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    -- User Profile di bawah sidebar
    local userProfile = Instance.new("Frame")
    userProfile.Size = UDim2.new(1, -16, 0, 50)
    userProfile.Position = UDim2.new(0, 8, 1, -60)
    userProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    userProfile.BackgroundTransparency = 0.2
    userProfile.Parent = sidebar
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = userProfile

    local userIcon = Instance.new("ImageLabel")
    userIcon.Size = UDim2.new(0, 24, 0, 24)
    userIcon.Position = UDim2.new(0, 10, 0.5, -12)
    userIcon.BackgroundTransparency = 1
    userIcon.Image = "rbxassetid://6023420986"
    userIcon.Parent = userProfile

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -40, 1, 0)
    userLbl.Position = UDim2.new(0, 40, 0, 0)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = player.Name
    userLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    userLbl.TextSize = 12
    userLbl.Font = Enum.Font.GothamSemibold
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.Parent = userProfile

    -- ==========================================
    -- 6. CONTENT AREA
    -- ==========================================
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -170, 1, -52)
    contentArea.Position = UDim2.new(0, 170, 0, 52)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainWindow

    -- Tab & Navigation system
    local tabs = {}
    local navButtons = {}

    local function SwitchTab(tabName)
        for name, tab in pairs(tabs) do
            tab.Visible = (name == tabName)
        end
        for name, btn in pairs(navButtons) do
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if name == tabName then
                btn.BackgroundColor3 = primaryColor
                btn.BackgroundTransparency = 0.2
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamBold
                if stroke then stroke.Transparency = 0 end
            else
                btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                btn.BackgroundTransparency = 1
                btn.TextColor3 = Color3.fromRGB(160, 160, 160)
                btn.Font = Enum.Font.Gotham
                if stroke then stroke.Transparency = 1 end
            end
        end
    end

    local function CreateNavButton(name, icon, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -16, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = icon .. "   " .. name
        btn.TextColor3 = Color3.fromRGB(160, 160, 160)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = navContainer

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 14)
        padding.Parent = btn

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = primaryColor
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
        scroll.ScrollBarImageColor3 = primaryColor
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        tabs[name] = scroll
        return scroll
    end

    -- ==========================================
    -- 7. UI BUILDERS (Card, Toggle, Slider, Dropdown)
    -- ==========================================
    local function createSectionHeader(parent, text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 24)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.TextSize = 14
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.Parent = parent
    end

    local function createCard(parent, height, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, height)
        card.BackgroundColor3 = bgColor
        card.BackgroundTransparency = 0.15
        card.LayoutOrder = order
        card.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Color = primaryColor
        stroke.Thickness = 0.5
        stroke.Transparency = 0.2
        stroke.Parent = card

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = card

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 14)
        padding.PaddingRight = UDim.new(0, 14)
        padding.Parent = card

        return card
    end

    local function createToggleInCard(card, labelText, settingKey, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 32)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 54, 0, 26)
        toggle.Position = UDim2.new(1, -54, 0.5, -13)
        toggle.BackgroundColor3 = Config[settingKey] and primaryColor or Color3.fromRGB(45, 45, 55)
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = toggle

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 18, 0, 18)
        indicator.Position = Config[settingKey] and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Parent = toggle
        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(1, 0)
        indCorner.Parent = indicator

        toggle.MouseButton1Click:Connect(function()
            Config[settingKey] = not Config[settingKey]
            local isActive = Config[settingKey]
            toggle.BackgroundColor3 = isActive and primaryColor or Color3.fromRGB(45, 45, 55)
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = isActive and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            }):Play()
        end)
    end

    local function createSliderInCard(card, labelText, settingKey, minVal, maxVal, step, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 44)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = labelText .. " : " .. tostring(Config[settingKey])
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 0, 0, 8)
        sliderBtn.Position = UDim2.new(0, 0, 0, 26)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        sliderBtn.Text = ""
        sliderBtn.AutoButtonColor = false
        sliderBtn.Parent = frame
        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(1, 0)
        sCorner.Parent = sliderBtn

        local startPercent = math.clamp((Config[settingKey] - minVal) / (maxVal - minVal), 0, 1)
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = primaryColor
        sliderFill.Parent = sliderBtn
        local sfCorner = Instance.new("UICorner")
        sfCorner.CornerRadius = UDim.new(1, 0)
        sfCorner.Parent = sliderFill

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

                Config[settingKey] = newValue
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                local fmt = step % 1 == 0 and "%.0f" or "%.1f"
                label.Text = labelText .. " : " .. string.format(fmt, newValue)
            end
        end)
    end

    local function createDropdownInCard(card, labelText, settingKey, options, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 32)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamSemibold
        label.Parent = frame

        local dropdown = Instance.new("TextBox")
        dropdown.Size = UDim2.new(0, 100, 0, 26)
        dropdown.Position = UDim2.new(1, -100, 0.5, -13)
        dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        dropdown.Text = Config[settingKey]
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.TextSize = 12
        dropdown.Font = Enum.Font.GothamBold
        dropdown.Parent = frame
        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 6)
        dCorner.Parent = dropdown

        dropdown.FocusLost:Connect(function()
            local val = dropdown.Text
            local isValid = false
            for _, opt in ipairs(options) do
                if val:lower() == opt:lower() then
                    val = opt
                    isValid = true
                    break
                end
            end
            if isValid then
                Config[settingKey] = val
                dropdown.Text = val
            else
                dropdown.Text = Config[settingKey]
            end
        end)
    end

    -- ==========================================
    -- 8. BUILD TABS & CONTENT (Sesuai gambar)
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

    -- ===== Tab About =====
    createSectionHeader(tabAbout, "About H4xScripts", 1)
    local aboutCard = createCard(tabAbout, 80, 2)
    local aboutLbl = Instance.new("TextLabel")
    aboutLbl.Size = UDim2.new(1, 0, 1, 0)
    aboutLbl.BackgroundTransparency = 1
    aboutLbl.Text = "H4xScripts - Premium Roblox Script\nDev: @Mallo\nVersion: 2.0"
    aboutLbl.TextColor3 = Color3.fromRGB(210, 210, 210)
    aboutLbl.TextSize = 13
    aboutLbl.Font = Enum.Font.Gotham
    aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
    aboutLbl.TextYAlignment = Enum.TextYAlignment.Center
    aboutLbl.Parent = aboutCard

    -- ===== Tab Generators =====
    createSectionHeader(tabGenerators, "Generators", 1)
    local genCard = createCard(tabGenerators, 80, 2)
    createToggleInCard(genCard, "Anti-Fail Generator", "AntiFailGen", 1)
    createToggleInCard(genCard, "Auto Perfect Skill Check", "AutoPerfect", 2)

    -- ===== Tab Main Stuff =====
    createSectionHeader(tabMain, "Main Stuff", 1)
    local mainCard = createCard(tabMain, 110, 2)
    createToggleInCard(mainCard, "Auto Parry", "AutoParry", 1)
    createToggleInCard(mainCard, "Speed Boost", "SpeedBoost", 2)
    createSliderInCard(mainCard, "Range", "RangeValue", 5, 50, 1, 3)

    -- ===== Tab Visuals =====
    createSectionHeader(tabVisuals, "Visuals", 1)
    local visCard = createCard(tabVisuals, 110, 2)
    createToggleInCard(visCard, "Wallhack (Survivor)", "WallhackS", 1)
    createToggleInCard(visCard, "Wallhack (Killer)", "WallhackK", 2)
    createToggleInCard(visCard, "Hook ESP", "HookESP", 3)

    -- ===== Tab Others =====
    createSectionHeader(tabOthers, "Others", 1)
    local otherCard = createCard(tabOthers, 80, 2)
    createToggleInCard(otherCard, "Auto Vault", "AutoVault", 1)
    createToggleInCard(otherCard, "No Recoil", "NoRecoil", 2)

    -- ===== Tab Misc =====
    createSectionHeader(tabMisc, "Misc", 1)
    local miscCard = createCard(tabMisc, 80, 2)
    createToggleInCard(miscCard, "LocalPlayer", "LocalPlayer", 1)
    createToggleInCard(miscCard, "Range Check", "RangeCheck", 2)

    -- ===== Tab Emotes =====
    createSectionHeader(tabEmotes, "Emotes", 1)
    local emoteCard = createCard(tabEmotes, 80, 2)
    -- Dropdown untuk pilih emote
    local frameEmote = Instance.new("Frame")
    frameEmote.Size = UDim2.new(1, 0, 0, 32)
    frameEmote.BackgroundTransparency = 1
    frameEmote.LayoutOrder = 1
    frameEmote.Parent = emoteCard

    local labelEmote = Instance.new("TextLabel")
    labelEmote.Size = UDim2.new(0.5, 0, 1, 0)
    labelEmote.BackgroundTransparency = 1
    labelEmote.Text = "Select Emote"
    labelEmote.TextColor3 = Color3.fromRGB(240, 240, 240)
    labelEmote.TextSize = 13
    labelEmote.Font = Enum.Font.GothamSemibold
    labelEmote.TextXAlignment = Enum.TextXAlignment.Left
    labelEmote.Parent = frameEmote

    local emoteDropdown = Instance.new("TextBox")
    emoteDropdown.Size = UDim2.new(0, 120, 0, 26)
    emoteDropdown.Position = UDim2.new(1, -120, 0.5, -13)
    emoteDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    emoteDropdown.Text = "4EverLvu"
    emoteDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    emoteDropdown.TextSize = 12
    emoteDropdown.Font = Enum.Font.GothamBold
    emoteDropdown.Parent = frameEmote
    local edCorner = Instance.new("UICorner")
    edCorner.CornerRadius = UDim.new(0, 6)
    edCorner.Parent = emoteDropdown

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0, 60, 0, 26)
    playBtn.Position = UDim2.new(1, -190, 0.5, -13)
    playBtn.BackgroundColor3 = primaryColor
    playBtn.Text = "Play"
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.TextSize = 12
    playBtn.Font = Enum.Font.GothamBold
    playBtn.Parent = frameEmote
    local pbCorner = Instance.new("UICorner")
    pbCorner.CornerRadius = UDim.new(0, 6)
    pbCorner.Parent = playBtn

    playBtn.MouseButton1Click:Connect(function()
        print("Playing emote: " .. emoteDropdown.Text)
        -- Di sini logika play emote
    end)

    -- ==========================================
    -- 9. DEFAULT TAB & KEYBIND
    -- ==========================================
    SwitchTab("About")

    -- Toggle UI dengan Insert
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            mainWindow.Visible = not mainWindow.Visible
        end
    end)

    return screenGui
end

return UI
```
