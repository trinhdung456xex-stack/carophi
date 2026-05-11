-- ==========================================
-- DUG HUB - BẢN TEST ĐẦU TIÊN
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Biến lưu trạng thái chức năng
_G.AutoFarm = false
_G.FastAttack = false
_G.BringMobs = false
_G.AutoLevel = false

-- ================== TẠO GUI ==================
local DugHub = Instance.new("ScreenGui")
DugHub.Name = "DugHub"
DugHub.Parent = CoreGui

-- Nút Bật/Tắt (Toggle Button)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 128) -- Neon Green
ToggleBtn.Text = "MỞ"
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextScaled = true
ToggleBtn.Parent = DugHub

-- Khung chính (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 128)
MainFrame.Visible = false
MainFrame.Parent = DugHub

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Text = "DUG HUB | AUTO BLOX FRUIT"
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Hàm tạo nút chức năng
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. " [TẮT]"
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = MainFrame

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            btn.Text = name .. " [BẬT]"
            btn.TextColor3 = Color3.fromRGB(0, 255, 128)
        else
            btn.Text = name .. " [TẮT]"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        callback(toggled)
    end)
end

-- ================== XỬ LÝ CHỨC NĂNG ==================

-- 1. Tự động gom quái (Bring Mobs)
createButton("Tự Động Gom Quái", 60, function(state)
    _G.BringMobs = state
    task.spawn(function()
        while _G.BringMobs do
            task.wait(0.1)
            -- Logic gom quái: Lấy CFrame của LocalPlayer và set CFrame của quái (workspace.Enemies) về đó
            -- Cần check NetworkOwnership để không bị lỗi
        end
    end)
end)

-- 2. Đánh siêu nhanh (Fast Attack)
createButton("Đánh Siêu Nhanh", 110, function(state)
    _G.FastAttack = state
    task.spawn(function()
        while _G.FastAttack do
            task.wait()
            -- Logic Fast Attack: Thay đổi tốc độ animation (getupvalues/setupvalues) 
            -- hoặc spam RemoteEvent "RegisterAttack" của game
        end
    end)
end)

-- 3. Bay đến đảo gom quái & Đánh (Teleport & Farm)
createButton("Bay Đến Đảo & Gom Quái", 160, function(state)
    _G.AutoFarm = state
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.5)
            -- Logic: TweenService để mượt mà di chuyển (Tween CFrame) đến vị trí đảo.
            -- Kết hợp vòng lặp tìm quái gần nhất và auto click.
        end
    end)
end)

-- 4. Auto Cày Level (Auto Farm Level)
createButton("Auto Cày Level", 210, function(state)
    _G.AutoLevel = state
    task.spawn(function()
        while _G.AutoLevel do
            task.wait(1)
            -- Logic: 
            -- 1. Lấy cấp độ hiện tại
            -- 2. Bay đến NPC nhận Quest phù hợp
            -- 3. FireServer để nhận Quest
            -- 4. Bay ra bãi quái tương ứng và bật AutoFarm
        end
    end)
end)

-- ================== SỰ KIỆN NÚT ==================
-- Mở / Đóng Menu
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleBtn.Text = "ĐÓNG"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    else
        ToggleBtn.Text = "MỞ"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
    end
end)
