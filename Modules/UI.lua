-- =====================================================================
-- ADI HUB - MODERN UI REWORK
-- Didesain untuk: Roblox Game Hacking (Violence District Style)
-- Konsep: Modern, Minimalis, Animasi Halus, Ringan.
-- =====================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local UI = {}

-- Konstanta Animasi
local TWEEN_INFO_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_INFO_SLIDE = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_INFO_BOUNCE = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Fungsi Helper untuk Animasi Hover
local function addHoverEffect(element, hoverColor, defaultColor, hoverTransparency, defaultTransparency, cornerInstance)
    element.MouseEnter:Connect(function()
        TweenService:Create(element, TWEEN_INFO_FAST, {
            BackgroundColor3 = hoverColor,
            BackgroundTransparency = hoverTransparency or defaultTransparency
        }):Play()
    end)

    element.MouseLeave:Connect(function()
        TweenService:Create(element, TWEEN_INFO_FAST, {
            BackgroundColor3 = defaultColor,
            BackgroundTransparency = defaultTransparency
        }):Play()
    end)
end

-- Fungsi Helper untuk Animasi Klik (efek kedip/skala)
local function addClickAnimation(element)
    local originalSize = element.Size
    element.MouseButton1Down:Connect(function()
        TweenService:Create(element, TweenInfo.new(0.05), {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset * 0.95, originalSize.Y.Scale, originalSize.Y.Offset * 0.95)}):Play()
    end)
    element.MouseButton1Up:Connect(function()
        TweenService:Create(element, TweenInfo.new(0.1), {Size = originalSize}):Play()
    end)
end

function UI:CreateSidebar(Config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ADIHub_Modern"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- ==========================================
    -- 1. FLOATING TOGGLE BUTTON (Modern & Minimalis)
    -- ==========================================
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 20, 0, 20)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24) -- Warna dasar gelap
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Image = "rbxassetid://6031090793" -- Icon pedang/senjata
    toggleBtn.ImageColor3 = Color3.fromRGB(230, 50, 50) -- Warna icon merah
    toggleBtn.Parent = screenGui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleBtn

    -- Efek bayangan (DropShadow) menggunakan ImageLabel agar ringan tapi estetik
    local toggleShadow = Instance.new("ImageLabel")
    toggleShadow.Name = "Shadow"
    toggleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleShadow.Size = UDim2.new(1, 20, 1, 20)
    toggleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    toggleShadow.BackgroundTransparency = 1
    toggleShadow.Image = "rbxassetid://6014261993" -- Shadow asset ID
    toggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    toggleShadow.ImageTransparency = 0.6
    toggleShadow.ScaleType = Enum.ScaleType.Slice
    toggleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    toggleShadow.Parent = toggleBtn
    toggleBtn.Archivable = true -- Diperlukan untuk cloning jika perlu

    addHoverEffect(toggleBtn, Color3.fromRGB(25, 25, 33), Color3.fromRGB(18, 18, 24), 0, 0)
    addClickAnimation(toggleBtn)

    -- ==========================================
    -- 2. MAIN WINDOW (Scale Animation Intro)
    -- ==========================================
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 600, 0, 380)
    mainWindow.Position = UDim2.new(0.5, -300, 0.5, -190)
    mainWindow.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    mainWindow.BorderSizePixel = 0
    mainWindow.Visible = false -- Default tertutup
    mainWindow.Parent = screenGui

    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 15)
    windowCorner.Parent = mainWindow

    -- Window Glow / Stroke
    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = Color3.fromRGB(230, 50, 50)
    windowStroke.Thickness = 1.5
    windowStroke.Transparency = 0.7
    windowStroke.Parent = mainWindow

    -- Logika Toggle Buka/Tutup dengan Animasi Scale
    local function toggleWindow()
        if not mainWindow.Visible then
            mainWindow.Visible = true
            mainWindow.ScaleType = Enum.ScaleType.Slice
            -- Animasi masuk: Skala dari 0 ke 1, dan Fade in
            mainWindow.Size = UDim2.new(0, 0, 0, 0)
            mainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(mainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 380),
                Position = UDim2.new(0.5, -300, 0.5, -190)
            }):Play()
        else
            -- Animasi keluar: Skala ke 0, Fade out
            local closeTween = TweenService:Create(mainWindow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            closeTween:Play()
            closeTween.Completed:Wait()
            mainWindow.Visible = false
        end
    end

    toggleBtn.MouseButton1Click:Connect(toggleWindow)

    -- Logika Dragging Jendela (Dioptimalkan)
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
    -- 3. TOP BAR (Header Ramping)
    -- ==========================================
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainWindow

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.RichText = true
    titleLabel.Text = "<font color='#E63232'>ADI</font> Hub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Badge (Desain lebih halus)
    local badgeContainer = Instance.new("Frame")
    badgeContainer.Size = UDim2.new(0, 200, 1, 0)
    badgeContainer.Position = UDim2.new(0, 120, 0, 0)
    badgeContainer.BackgroundTransparency = 1
    badgeContainer.Parent = topBar

    local badgeLayout = Instance.new("UIListLayout")
    badgeLayout.FillDirection = Enum.FillDirection.Horizontal
    badgeLayout.Padding = UDim.new(0, 8)
    badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    badgeLayout.Parent = badgeContainer

    local function createBadge(text, color)
        local b = Instance.new("TextLabel")
        b.Size = UDim2.new(0, TextService:GetTextSize(text, 12, Enum.Font.GothamBold, Vector2.new(200, 50)).X + 16, 0, 20)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.Parent = badgeContainer
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        return b
    end

    createBadge("Violence district", Color3.fromRGB(230, 50, 50))
    createBadge("Remake v2.1", Color3.fromRGB(45, 45, 55))

    -- Tombol Close (X) - Dibuat lebih elegan
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -37, 0.5, -15)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar

    addHoverEffect(closeBtn, Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 150), 1, 1)
    closeBtn.MouseButton1Click:Connect(toggleWindow)

    -- ==========================================
    -- 4. SIDEBAR (Modern Deep Black)
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 160, 1, -45)
    sidebar.Position = UDim2.new(0, 0, 0, 45)
    sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainWindow

    -- Gradient halus di pinggir sidebar agar tidak terlalu polos
    local sideGradient = Instance.new("UIGradient")
    sideGradient.Rotation = 90
    sideGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(20, 20, 26)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(16, 16, 21))
    }
    sideGradient.Parent = sidebar

    local navContainer = Instance.new("Frame")
    navContainer.Name = "NavContainer"
    navContainer.Size = UDim2.new(1, 0, 1, -60)
    navContainer.Position = UDim2.new(0, 0, 0, 15)
    navContainer.BackgroundTransparency = 1
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 8)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    -- User Profile di bawah sidebar
    local userProfile = Instance.new("Frame")
    userProfile.Size = UDim2.new(1, -20, 0, 50)
    userProfile.Position = UDim2.new(0, 10, 1, -60)
    userProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    userProfile.Parent = sidebar
    Instance.new("UICorner", userProfile).CornerRadius = UDim.new(0, 10)

    -- Avatar Player
    local userImg = Instance.new("ImageLabel")
    userImg.Size = UDim2.new(0, 34, 0, 34)
    userImg.Position = UDim2.new(0, 8, 0.5, -17)
    userImg.BackgroundTransparency = 1
    userImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.
