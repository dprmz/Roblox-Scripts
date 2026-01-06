-- [[ ADI PROJECT - V42 INTERNAL ENGINE HOOK ]] --

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 1. DETEKSI UI SECARA PAKSA (RECURSIVE)
local function getSkillcheckObjects()
    local pGui = lp:FindFirstChild("PlayerGui")
    if not pGui then return nil, nil end
    
    -- Mencari Needle dan White Bar di seluruh folder game
    local needle = nil
    local white = nil
    
    for _, v in pairs(pGui:GetDescendants()) do
        if v:IsA("GuiObject") and v.Visible and v.AbsoluteSize.X > 0 then
            -- Logika Iceware: Mencari Jarum berdasarkan rotasi yang aktif
            if (v.Name:lower():find("needle") or v.Name:lower():find("pointer")) then
                needle = v
            elseif (v.Name:lower():find("perfect") or v.Name:lower():find("success") or v.BackgroundColor3 == Color3.new(1,1,1)) then
                white = v
            end
        end
    end
    return needle, white
end

-- 2. AUTO PERFECT LOGIC (ZERO DELAY)
-- Menggunakan RenderStepped dengan prioritas tertinggi (2000)
RunService:BindToRenderStep("AdiInternalHook", 2000, function()
    local needle, white = getSkillcheckObjects()
    
    if needle and white then
        local nRot = needle.Rotation % 360
        local wRot = white.Rotation % 360
        
        -- Kalkulasi jarak rotasi
        local diff = math.abs(nRot - wRot)
        
        -- Iceware biasanya menekan spasi 2-5 derajat SEBELUM menyentuh zona
        -- agar saat sinyal sampai ke server, posisinya tepat di tengah (Perfect)
        if diff <= 7 or diff >= 353 then
            -- MENGIRIM INPUT VIRTUAL LANGSUNG KE ENGINE
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.01)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            
            -- Anti-Spam (Menunggu sampai UI Skillcheck hilang)
            repeat task.wait() until not needle or not needle.Parent
        end
    end
end)

print("V42 INTERNAL HOOK LOADED")
