local function createSlider(labelText, settingKey, minVal, maxVal, step, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    frame.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText .. " (" .. tostring(Config[settingKey]) .. ")"
    label.TextColor3 = Color3.fromRGB(240, 240, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    -- Menggunakan TextButton sebagai background/track slider
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, -10, 0, 16)
    sliderBtn.Position = UDim2.new(0, 5, 0, 22)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Text = ""
    sliderBtn.AutoButtonColor = false
    sliderBtn.Parent = frame

    -- Kalkulasi ukuran awal berdasarkan Config
    local startPercent = math.clamp((Config[settingKey] - minVal) / (maxVal - minVal), 0, 1)

    -- Frame sebagai pengisi (fill)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBtn

    local dragging = false
    local UserInputService = game:GetService("UserInputService")

    -- Logika drag slider
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = sliderBtn.AbsolutePosition.X
            local sliderSize = sliderBtn.AbsoluteSize.X
            
            -- Menghitung persentase posisi mouse di dalam slider
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)

            -- Konversi persentase ke nilai Config dan terapkan step
            local newValue = minVal + (maxVal - minVal) * percent
            newValue = math.floor(newValue / step + 0.5) * step

            -- Update Config & UI
            Config[settingKey] = newValue
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            
            -- Hapus angka nol berlebih di desimal jika formatnya bulat
            local formatString = step % 1 == 0 and "%.0f" or "%.1f"
            label.Text = labelText .. " (" .. string.format(formatString, newValue) .. ")"
        end
    end)

    return sliderBtn
end
