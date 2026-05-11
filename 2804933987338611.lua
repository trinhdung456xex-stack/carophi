-- [[ DUG HUB V3 - BYPASS FAST ATTACK & AUTO QUEST ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false
_G.FastAttack = false -- Bản V3 sẽ đánh cực nhanh

-- 1. HÀM BAY (TWEEN) - Giúp bay xuyên vật thể không bị kẹt
local function TweenTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local distance = (char.HumanoidRootPart.Position - targetCFrame.p).Magnitude
    local speed = 300 -- Tốc độ bay (điều chỉnh nếu muốn nhanh hơn)
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(char.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- 2. BYPASS FAST ATTACK (Spam Remote)
-- Lưu ý: Đánh quá nhanh có thể gây lag hoặc kick nếu Server check kỹ
task.spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                -- Thay đổi "Combat" thành tên tool bạn đang cầm
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Gửi tín hiệu đánh trực tiếp tới Server (Bypass Animation)
                    ReplicatedStorage.Remotes.Validator:FireServer(math.huge) -- Một số bản cần validator
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", tool) 
                end
            end)
        end
    end
end)

-- 3. GIAO DIỆN V3 (Gọn gàng hơn)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DugHubV3"
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0.5, -125, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Active = true
Main.Draggable = true -- Có thể cầm kéo đi được
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "DUG HUB V3"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.Parent = Main

-- Nút Bật/Tắt chính
local function CreateToggle(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Main
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 255, 255)
        callback(state)
    end)
end

-- 4. LOGIC AUTO FARM LEVEL (NHẬN QUEST -> BAY -> ĐÁNH)
CreateToggle("Auto Farm Level", 60, function(v)
    _G.AutoFarm = v
    _G.FastAttack = v
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFarm then
            pcall(function()
                -- Bước 1: Check xem có nhiệm vụ chưa
                if not LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") or LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    -- Bay đến NPC nhận Quest (Ví dụ cho đảo đầu, bạn cần script thêm ID Quest cho từng đảo)
                    -- CommF_:InvokeServer("StartQuest", "QuestName", 1)
                    print("Đang đi nhận nhiệm vụ...")
                else
                    -- Bước 2: Có quest rồi thì tìm quái
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            -- Bay lên đầu quái (cách 10 unit cho vừa tầm đánh)
                            local targetPos = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            TweenTo(targetPos)
                            
                            -- Gom quái xung quanh vào vị trí đó
                            for _, e in pairs(workspace.Enemies:GetChildren()) do
                                if (e.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude < 100 then
                                    e.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                                    e.HumanoidRootPart.CanCollide = false
                                end
                            end
                            break -- Tập trung đánh 1 mục tiêu/nhóm mục tiêu
                        end
                    end
                end
            end)
        end
    end
end)

-- Phím tắt ẩn hiện GUI (Nhấn L)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.L then
        Main.Visible = not Main.Visible
    end
end)

print("Dug Hub V3 Loaded! Speed Bypass Active.")
