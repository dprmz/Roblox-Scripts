-- [[ ADI PROJECT - V33 VIOLENCE DISTRICT - PREMIUM SIDEBAR V2 ]] --
-- DELTA EXECUTOR FIXED & OPTIMIZED VERSION

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Detect Delta
local isDelta = (getexecutorname and getexecutorname() == "Delta")
if isDelta and setfpscap then
    pcall(function() setfpscap(60) end)
end

-- Safely get GUI Container
local function getUIContainer()
    local success, target = pcall(function()
        return (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if success and target then return target end
    return lp:WaitForChild("PlayerGui")
end

-- Remove Existing GUI Instance
local container = getUIContainer()
if container:FindFirstChild("AdiV33_VD_SidebarUI") then
    container:FindFirstChild("AdiV33_VD_SidebarUI"):Destroy()
end

-- ============================================
-- ========== CORE VARIABLES ==================
-- ============================================
local aimEnabled = false
local aimSmoothness = 0.3
local aimFOV = 200
local rightMousePressed = false
local autoPerfectEnabled = false
local lastSkillCheckTime = 0
local skillCheckCooldown = 0.3
local wallhackActive = true
local genEspActive = false

local origFogStart = Lighting.FogStart
local origFogEnd = Lighting.FogEnd
local origAmbient = Lighting.Ambient
local origOutdoorAmbient = Lighting.OutdoorAmbient

-- ============================================
-- ========== ESP FUNCTIONS ===================
-- ============================================

local function createESPLabel(player)
    if not player or not player.Character then return nil end
    local char = player.Character
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    
    local oldLabel = char:FindFirstChild("ESP_Label")
    if oldLabel then oldLabel:Destroy() end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Label"
    billboard.Size = UDim2.new(0, 250, 0, 70)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 1000
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Enabled = true
    
    local bgFrame = Instance.new("Frame")
    bgFrame.Name = "Background"
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgFrame.BackgroundTransparency = 0.5
    bgFrame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = bgFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = ""
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.TextStrokeTransparency = 0.2
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = bgFrame
    
    local isKiller = player.Team and (player.Team.Name:lower():find("killer") or player.Team.Name:lower():find("beast") or player.Team.Name:lower():find("murderer"))
    textLabel.TextColor3 = isKiller and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 200, 255)
    
    billboard.Parent = char
    return billboard
end

local function updateESPLabel(player)
    if not player or not player.Character then return end
    local billboard = player.Character:FindFirstChild("ESP_Label")
    if not billboard then return end
    local bgFrame = billboard:FindFirstChild("Background")
    if not bgFrame then return end
    local textLabel = bgFrame:FindFirstChild("TextLabel")
    if not textLabel then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local isAlive = humanoid and humanoid.Health > 0
    if not isAlive then
        textLabel.Text = player.Name .. "\n[💀 ELIMINATED]"
        textLabel.TextColor3 = Color3.fromRGB(128, 128, 128)
        return
    end
    
    local distance = -1
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") then
        distance = (lp.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    end
    
    local distText = distance >= 0 and string.format("%.1f", distance) or "???"
    local statusIcon = ""
    if distance >= 0 then
        if distance < 20 then statusIcon = "🔴 "
        elseif distance < 50 then statusIcon = "🟡 "
        elseif distance < 100 then statusIcon = "🟢 "
        else statusIcon = "🔵 " end
    end
    
    local isKiller = player.Team and (player.Team.Name:lower():find("killer") or player.Team.Name:lower():find("beast") or player.Team.Name:lower():find("murderer"))
    local textColor = isKiller and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 200, 255)
    if distance >= 0 and distance < 20 then textColor = Color3.fromRGB(255, 200, 0) end
    
    textLabel.TextColor3 = textColor
    textLabel.Text = player.Name .. "\n" .. statusIcon .. distText .. "m"
end

local function setupESPForAllPlayers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local highlight = p.Character:FindFirstChild("AdiESP")
            if highlight then highlight:Destroy() end
            local label = p.Character:FindFirstChild("ESP_Label")
            if label then label:Destroy() end
        end
    end
    
    if not wallhackActive then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = Instance.new("Highlight")
            h.Name = "AdiESP"
            h.Enabled = true
            h.OutlineTransparency = 0
            h.FillTransparency = 1
            local isKiller = p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("beast"))
            h.OutlineColor = isKiller and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(15, 45, 125)
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = p.Character
            
            local label = createESPLabel(p)
            if label then
                label.Enabled = true
                updateESPLabel(p)
            end
        end
    end
end

-- ============================================
-- ========== MAIN INTERFACE DESIGN ===========
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdiV33_VD_SidebarUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
Main.Position = UDim2.new(0.5, -260, 0.5, -200)
Main.Size = UDim2.new(0, 520, 0, 400)
Main.BackgroundTransparency = 0.05
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(35, 35, 45)

local TopGlow = Instance.new("Frame", Main)
TopGlow.Size = UDim2.new(1, 0, 0, 2)
TopGlow.BackgroundColor3 = Color3.fromRGB(115, 75, 255)
TopGlow.BorderSizePixel = 0

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

-- Dragging Engine
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel", Header)
Title.Text = "ADI PROJECT  //  V3.3"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Text = ""
CloseBtn.Size = UDim2.new(0, 12, 0, 12)
CloseBtn.Position = UDim2.new(1, -25, 0, 19)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Sidebar Layout
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Sidebar.BorderSizePixel = 0

local ButtonHolder = Instance.new("Frame", Sidebar)
ButtonHolder.Size = UDim2.new(1, 0, 1, -10)
ButtonHolder.Position = UDim2.new(0, 0, 0, 10)
ButtonHolder.BackgroundTransparency = 1

local TabContainer = Instance.new("UIListLayout", ButtonHolder)
TabContainer.SortOrder = Enum.SortOrder.LayoutOrder
TabContainer.Padding = UDim.new(0, 4)

local SidebarRightLine = Instance.new("Frame", Sidebar)
SidebarRightLine.Size = UDim2.new(0, 1, 1, 0)
SidebarRightLine.Position = UDim2.new(1, -1, 0, 0)
SidebarRightLine.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SidebarRightLine.BorderSizePixel = 0

local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -165, 1, -70)
ContentArea.Position = UDim2.new(0, 153, 0, 60)
ContentArea.BackgroundTransparency = 1

local tabs = {}
local currentActiveView = nil

local function createTab(name, order)
    local tabBtn = Instance.new("TextButton", ButtonHolder)
    tabBtn.Text = "   " .. name:upper()
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundTransparency = 1
    tabBtn.TextColor3 = Color3.fromRGB(120, 120, 140)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 11
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.LayoutOrder = order
    
    local view = Instance.new("ScrollingFrame", ContentArea)
    view.Size = UDim2.new(1, 0, 1, 0)
    view.BackgroundTransparency = 1
    view.BorderSizePixel = 0
    view.Visible = false
    view.ScrollBarThickness = 2
    view.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 50)
    
    local viewLayout = Instance.new("UIListLayout", view)
    viewLayout.SortOrder = Enum.SortOrder.LayoutOrder
    viewLayout.Padding = UDim.new(0, 10)
    
    tabBtn.MouseButton1Click:Connect(function()
        if currentActiveView == view then return end
        for _, t in pairs(tabs) do
            TweenService:Create(t.Btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                TextColor3 = Color3.fromRGB(120, 120, 140),
                BackgroundTransparency = 1
            }):Play()
            t.View.Visible = false
            t.View.CanvasPosition = Vector2.new(0,0)
        end
        TweenService:Create(tabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            TextColor3 = Color3.fromRGB(115, 75, 255),
            BackgroundTransparency = 0.95
        }):Play()
        tabBtn.BackgroundColor3 = Color3.fromRGB(115, 75, 255)
        view.Size = UDim2.new(1, 0, 0.95, 0)
        view.Visible = true
        TweenService:Create(view, TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()
        currentActiveView = view
    end)
    
    tabs[name] = {Btn = tabBtn, View = view}
    return view
end

-- Pages
local survView = createTab("Survivor", 1)
local killerView = createTab("Killer", 2)
local visualView = createTab("Visuals", 3)
local controlView = createTab("Controls", 4)

tabs["Survivor"].Btn.TextColor3 = Color3.fromRGB(115, 75, 255)
tabs["Survivor"].Btn.BackgroundTransparency = 0.95
tabs["Survivor"].Btn.BackgroundColor3 = Color3.fromRGB(115, 75, 255)
survView.Visible = true
currentActiveView = survView

-- UI Builders
local function createToggle(parent, text)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.96, 0, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
    
    local fCrn = Instance.new("UICorner", frame); fCrn.CornerRadius = UDim.new(0, 8)
    local fStr = Instance.new("UIStroke", frame); fStr.Thickness = 1; fStr.Color = Color3.fromRGB(32, 32, 42)
    
    local txt = Instance.new("TextLabel", frame)
    txt.Text = text
    txt.Size = UDim2.new(0.7, 0, 1, 0)
    txt.Position = UDim2.new(0, 14, 0, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(200, 200, 220)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local switch = Instance.new("TextButton", frame)
    switch.Text = ""
    switch.Size = UDim2.new(0, 42, 0, 22)
    switch.Position = UDim2.new(1, -56, 0.5, -11)
    switch.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    
    local sCrn = Instance.new("UICorner", switch); sCrn.CornerRadius = UDim.new(1, 0)
    local sStr = Instance.new("UIStroke", switch); sStr.Thickness = 1; sStr.Color = Color3.fromRGB(50, 50, 65)
    
    local dot = Instance.new("Frame", switch)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 4, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local active = false
    local function click()
        active = not active
        switch:SetAttribute("Active", active)
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {BackgroundColor3 = Color3.fromRGB(40, 180, 115)}):Play()
            TweenService:Create(sStr, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Color = Color3.fromRGB(60, 220, 140)}):Play()
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Position = UDim2.new(1, -18, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
            TweenService:Create(sStr, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Position = UDim2.new(0, 4, 0.5, -7), BackgroundColor3 = Color3.fromRGB(150, 150, 170)}):Play()
        end
        return active
    end
    
    return switch, click
end

local function createSlider(parent, title, min, max, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.96, 0, 0, 55)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Text = title
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 4)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(170, 170, 190)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Text = tostring(default)
    valueLabel.Size = UDim2.new(0.35, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.65, -5, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(115, 75, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1, -10, 0, 6)
    track.Position = UDim2.new(0, 5, 0, 34)
    track.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", track).Color = Color3.fromRGB(40, 40, 55)
    
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(115, 75, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local thumb = Instance.new("TextButton", track)
    thumb.Size = UDim2.new(0, 14, 0, 14)
    thumb.Position = UDim2.new((default-min)/(max-min), -7, 0, -4)
    thumb.Text = ""
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", thumb).Color = Color3.fromRGB(115, 75, 255)
    
    return thumb, track, fill, valueLabel
end

-- Generate Elements
local aimToggleBtn, clickAim = createToggle(survView, "Lock Auto Aim (RMB/Touch)")
local perfectToggleBtn, clickPerfect = createToggle(survView, "Auto Perfect Generator")
local smoothThumb, smoothTrack, smoothFill, smoothValLabel = createSlider(survView, "Aimbot Smoothness", 1, 100, 30)

local hitboxThumb, hitboxTrack, hitboxFill, hitboxValLabel = createSlider(killerView, "Adjust Hitbox Expansion", 2, 50, 2)

local espToggleBtn, clickEsp = createToggle(visualView, "Wallhack Framework")
local genToggleBtn, clickGen = createToggle(visualView, "Outline Generator ESP")
local crosshairToggleBtn, clickCrosshair = createToggle(visualView, "Hardware Crosshair Overlay")
local brightToggleBtn, clickBright = createToggle(visualView, "Ambient Fullbright")
local fogToggleBtn, clickFog = createToggle(visualView, "Clear World Rendering (No Fog)")
local speedThumb, speedTrack, speedFill, speedValLabel = createSlider(visualView, "Locomotion WalkSpeed", 16, 150, 16)

local resetToggleBtn, clickReset = createToggle(controlView, "Revert System Configuration")
local closeToggleBtn, clickClose = createToggle(controlView, "Complete Termination")

-- Attach ScreenGui to Core/Protected UI safely
ScreenGui.Parent = container

-- Close Handler
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
closeToggleBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ============================================
-- ========== INTERACT ENGINE LOOPS ===========
-- ============================================

local dragSmooth, dragHit, dragSpeed = false, false, false
local smoothValue, hitValue, speedValue = 0.3, 2, 16

smoothThumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragSmooth = true end end)
hitboxThumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragHit = true end end)
speedThumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragSpeed = true end end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragSmooth, dragHit, dragSpeed = false, false, false
    end
end)

UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 or i.UserInputType == Enum.UserInputType.Touch then
        rightMousePressed = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 or i.UserInputType == Enum.UserInputType.Touch then
        rightMousePressed = false
    end
end)

RunService.RenderStepped:Connect(function()
    local mouseX = UIS:GetMouseLocation().X
    
    if dragSmooth and smoothTrack then
        local relX = math.clamp((mouseX - smoothTrack.AbsolutePosition.X) / smoothTrack.AbsoluteSize.X, 0, 1)
        smoothValue = 0.1 + (relX * 0.9)
        smoothThumb.Position = UDim2.new(relX, -7, 0, -4)
        smoothFill.Size = UDim2.new(relX, 0, 1, 0)
        smoothValLabel.Text = string.format("%.1f", smoothValue)
        aimSmoothness = smoothValue
    end
    
    if dragHit and hitboxTrack then
        local relX = math.clamp((mouseX - hitboxTrack.AbsolutePosition.X) / hitboxTrack.AbsoluteSize.X, 0, 1)
        hitValue = math.floor(2 + (relX * 48))
        hitboxThumb.Position = UDim2.new(relX, -7, 0, -4)
        hitboxFill.Size = UDim2.new(relX, 0, 1, 0)
        hitboxValLabel.Text = tostring(hitValue) .. " studs"
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(hitValue, hitValue, hitValue)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
    
    if dragSpeed and speedTrack then
        local relX = math.clamp((mouseX - speedTrack.AbsolutePosition.X) / speedTrack.AbsoluteSize.X, 0, 1)
        speedValue = math.floor(16 + (relX * 134))
        speedThumb.Position = UDim2.new(relX, -7, 0, -4)
        speedFill.Size = UDim2.new(relX, 0, 1, 0)
        speedValLabel.Text = tostring(speedValue) .. " m/s"
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = speedValue
        end
    end
end)

-- Aimbot Target Calculation
local function getClosestTarget()
    local mouseLoc = UIS:GetMouseLocation()
    local closestDist = aimFOV; local closest = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouseLoc.X, mouseLoc.Y)).Magnitude
                if dist < closestDist then
                    local isKiller = p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("beast") or p.Team.Name:lower():find("murderer"))
                    if isKiller then dist = dist - 50 end
                    closestDist = dist; closest = p
                end
            end
        end
    end
    return closest
end

RunService:BindToRenderStep("AutoAimVD", Enum.RenderPriority.Camera.Value, function()
    if aimEnabled and rightMousePressed and lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)), aimSmoothness)
        end
    end
end)

-- Auto Skill Check
local function findSkillCheckUI()
    for _, child in pairs(pGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Enabled and (child.Name:lower():find("skill") or child.Name:lower():find("check") or child.Name:lower():find("gen")) then
            return child
        end
    end
end

RunService:BindToRenderStep("VDPerfectSkillCheck", Enum.RenderPriority.Input.Value, function()
    if not autoPerfectEnabled or tick() - lastSkillCheckTime < skillCheckCooldown then return end
    local ui = findSkillCheckUI() if not ui then return end
    local needle, zone
    for _, d in pairs(ui:GetDescendants()) do
        if d:IsA("ImageLabel") and d.Visible then
            if d.Name:lower():find("needle") or d.Name:lower():find("pointer") then needle = d
            elseif d.Name:lower():find("perfect") or d.Name:lower():find("zone") then zone = d end
        end
    end
    if needle and zone then
        local diff = math.abs((needle.Rotation - zone.Rotation) % 360)
        if math.min(diff, 360 - diff) <= 12 then
            pcall(function()
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.02)
                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
            lastSkillCheckTime = tick()
        end
    end
end)

-- Buttons Interaction
aimToggleBtn.MouseButton1Click:Connect(function() aimEnabled = clickAim() end)
perfectToggleBtn.MouseButton1Click:Connect(function() autoPerfectEnabled = clickPerfect() end)

espToggleBtn.MouseButton1Click:Connect(function()
    wallhackActive = clickEsp()
    if wallhackActive then
        setupESPForAllPlayers()
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local h = p.Character:FindFirstChild("AdiESP")
                if h then h:Destroy() end
                local label = p.Character:FindFirstChild("ESP_Label")
                if label then label:Destroy() end
            end
        end
    end
end)

genToggleBtn.MouseButton1Click:Connect(function()
    genEspActive = clickGen()
    for _, o in pairs(workspace:GetDescendants()) do
        if (o.Name:lower():find("generator") or o.Name:lower():find("gen")) and (o:IsA("Model") or o:IsA("BasePart")) then
            local h = o:FindFirstChild("GenESP") or Instance.new("Highlight", o)
            h.Name = "GenESP"; h.Enabled = genEspActive; h.OutlineTransparency = 0
            h.OutlineColor = Color3.fromRGB(0, 230, 140); h.FillTransparency = 1
        end
    end
end)

local crosshairDot = Instance.new("Frame", ScreenGui)
crosshairDot.Size = UDim2.new(0, 4, 0, 4)
crosshairDot.Position = UDim2.new(0.5, -2, 0.5, -2)
crosshairDot.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
crosshairDot.Visible = false
Instance.new("UICorner", crosshairDot).CornerRadius = UDim.new(1, 0)
crosshairToggleBtn.MouseButton1Click:Connect(function() crosshairDot.Visible = clickCrosshair() end)

brightToggleBtn.MouseButton1Click:Connect(function()
    if clickBright() then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Ambient = origAmbient
        Lighting.OutdoorAmbient = origOutdoorAmbient
    end
end)

fogToggleBtn.MouseButton1Click:Connect(function()
    if clickFog() then
        Lighting.FogStart = 999999
        Lighting.FogEnd = 999999
    else
        Lighting.FogStart = origFogStart
        Lighting.FogEnd = origFogEnd
    end
end)

-- ESP Refresh Loop
RunService.RenderStepped:Connect(function()
    if wallhackActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then
                updateESPLabel(p)
            end
        end
    end
end)

-- Initial ESP Trigger
setupESPForAllPlayers()

-- System Reset
resetToggleBtn.MouseButton1Click:Connect(function()
    if clickReset() then
        Lighting.FogStart = origFogStart
        Lighting.FogEnd = origFogEnd
        Lighting.Ambient = origAmbient
        Lighting.OutdoorAmbient = origOutdoorAmbient
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = 16
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
            end
        end
        aimEnabled = false
        autoPerfectEnabled = false
        wallhackActive = false
        genEspActive = false
        crosshairDot.Visible = false
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local h = p.Character:FindFirstChild("AdiESP")
                if h then h:Destroy() end
                local label = p.Character:FindFirstChild("ESP_Label")
                if label then label:Destroy() end
            end
        end
        smoothThumb.Position = UDim2.new(0.3, -7, 0, -4)
        smoothFill.Size = UDim2.new(0.3, 0, 1, 0)
        smoothValLabel.Text = "0.3"
        hitboxThumb.Position = UDim2.new(0, -7, 0, -4)
        hitboxFill.Size = UDim2.new(0, 0, 1, 0)
        hitboxValLabel.Text = "2 studs"
        speedThumb.Position = UDim2.new(0, -7, 0, -4)
        speedFill.Size = UDim2.new(0, 0, 1, 0)
        speedValLabel.Text = "16 m/s"
    end
end)

print("🔥 ADI V33 | DELTA FULLY FIXED & EXECUTABLE")
