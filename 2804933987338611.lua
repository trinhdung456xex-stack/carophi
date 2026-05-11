-- [[ DUG HUB V4 - REDZ HUB STYLE ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Khởi tạo biến trạng thái
_G.Config = {
    AutoFarm = false,
    FastAttack = false,
    BringMob = false,
    Distance = 10
}

-- 1. HỆ THỐNG FAST ATTACK (BYPASS ANIMATION)
local CombatFramework = require(RS:WaitForChild("CombatFramework"))
local CombatFrameworkLib = debug.getupvalues(CombatFramework)[2]

local function GetCurrentBlade()
    return CombatFrameworkLib.activeController.blades[1]
end

local function Attack()
    local ac = CombatFrameworkLib.activeController
    if ac and ac.equipped then
        for i = 1, 3 do -- Spam 3 lần mỗi nhịp để tăng tốc
            ac.hitboxStats.hitboxResonance = 64
            ac:attack()
        end
    end
end

-- 2. HÀM DI CHUYỂN TWEEN
local function TweenTo(target)
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local dist = (LP.Character.HumanoidRootPart.Position - target.p).Magnitude
    local info = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
    local tween = TS:Create(LP.Character.HumanoidRootPart, info, {CFrame = target})
    tween:Play()
    return tween
end

-- 3. GIAO DIỆN STYLE REDZ HUB
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "DugHubV4"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 500, 0, 300)
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

-- Sidebar (Thanh bên trái)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0

local SideCorner = Instance.new("UICorner", Sidebar)

-- Title
local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "DUG SHOP"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- Khu vực chứa nút (Tabs)
local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 130, 0, 10)
Container.Size = UDim2.new(1, -140, 1, -20)
Container.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

-- Hàm tạo Switch (Bật/Tắt) chuyên nghiệp
local function CreateSwitch(text, config_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamSemibold
    
    local c = Instance.new("UICorner", btn)
    
    local Status = Instance.new("Frame", btn)
    Status.Size = UDim2.new(0, 10, 0, 10)
    Status.Position = UDim2.new(1, -25, 0.5, -5)
    Status.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        _G.Config[config_key] = not _G.Config[config_key]
        TS:Create(Status, TweenInfo.new(0.3), {
            BackgroundColor3 = _G.Config[config_key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
        }):Play()
    end)
end

-- Tạo các chức năng
CreateSwitch("Auto Farm Level", "AutoFarm")
CreateSwitch("Fast Attack (Bypass)", "FastAttack")
CreateSwitch("Gom Quái (Bring Mob)", "BringMob")

-- 4. VÒNG LẶP XỬ LÝ (CORE LOGIC)
task.spawn(function()
    while task.wait() do
        -- Fast Attack Logic
        if _G.Config.FastAttack then
            pcall(Attack)
        end
        
        -- Auto Farm & Bring Mob
        if _G.Config.AutoFarm then
            pcall(function()
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- Bay lên đầu quái
                        local targetPos = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Config.Distance, 0)
                        TweenTo(targetPos)
                        
                        -- Gom quái
                        if _G.Config.BringMob then
                            for _, m in pairs(workspace.Enemies:GetChildren()) do
                                if (m.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < 150 then
                                    m.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                                    m.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                        break
                    end
                end
            end)
        end
    end
end)

print("Dug Hub V4 Loaded - Redz Style UI!")
