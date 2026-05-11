-- [[ DUG HUB - PHIÊN BẢN TỔNG HỢP TEST LẦN 1 ]] --

-- 1. SERVICES & BIẾN KHỞI TẠO
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Trạng thái chức năng
_G.AutoFarm = false
_G.FastAttack = false
_G.BringMobs = false
_G.AutoLevel = false

-- 2. HÀM HỖ TRỢ (UTILITIES)
-- Chống AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Tự động cầm vũ khí (Melee hoặc Sword)
local function EquipWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword") then
            tool.Parent = char
        end
    end
end

-- 3. GIAO DIỆN (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DugHub_Final"
ScreenGui.Parent = CoreGui

-- Nút Toggle (Mở/Đóng)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 150)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
ToggleBtn.Text = "MENU"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ScreenGui

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Bo góc UI
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "DUG HUB | BLOX FRUIT"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Font = Enum.Font.Code
Title.TextSize = 20
Title.Parent = MainFrame

-- Layout cho các nút
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 10)

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 60)
Padding.Parent = MainFrame

-- Hàm tạo nút
local function AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 255, 255)
        callback(state)
    end)
end

-- 4. LOGIC CHỨC NĂNG
-- Nút 1: Gom quái
AddButton("Gom Quái (Bring)", function(v)
    _G.BringMobs = v
end)

-- Nút 2: Đánh siêu nhanh
AddButton("Đánh Siêu Nhanh", function(v)
    _G.FastAttack = v
end)

-- Nút 3: Bay & Farm
AddButton("Bay Tới Đảo & Farm", function(v)
    _G.AutoFarm = v
end)

-- Nút 4: Auto Level
AddButton("Auto Cày Level", function(v)
    _G.AutoLevel = v
end)

-- 5. VÒNG LẶP HÀNH ĐỘNG (LOOPS)
-- Loop xử lý Gom quái
task.spawn(function()
    while task.wait() do
        if _G.BringMobs then
            pcall(function()
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                        v.HumanoidRootPart.CanCollide = false -- Tránh bị kẹt
                    end
                end
            end)
        end
    end
end)

-- Loop xử lý Auto Đánh & Cầm vũ khí
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.FastAttack or _G.AutoLevel then
            pcall(function()
                EquipWeapon()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(850, 500), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

-- Sự kiện ẩn/hiện Menu
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("Dug Hub Loaded Successfully!")
