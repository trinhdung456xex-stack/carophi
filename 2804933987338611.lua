-- [[ DUG HUB V4.1 - FIX BUG & AUTO LOAD ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Xóa bản cũ nếu lỡ chạy đè
if CoreGui:FindFirstChild("DugHubV4") then
    CoreGui:FindFirstChild("DugHubV4"):Destroy()
end

-- 1. TẠO UI TRƯỚC (Để đảm bảo script có lên)
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "DugHubV4"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 450, 0, 280)
Main.Position = UDim2.new(0.5, -225, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "DUG SHOP"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Position = UDim2.new(0, 130, 0, 10)
Container.Size = UDim2.new(1, -140, 1, -20)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

-- 2. HỆ THỐNG ĐÁNH (LOAD SAU)
local CombatFramework, CombatFrameworkLib
pcall(function()
    CombatFramework = require(RS:WaitForChild("CombatFramework"))
    CombatFrameworkLib = debug.getupvalues(CombatFramework)[2]
end)

_G.Config = { AutoFarm = false, FastAttack = false, BringMob = false }

local function Attack()
    pcall(function()
        if CombatFrameworkLib and CombatFrameworkLib.activeController then
            local ac = CombatFrameworkLib.activeController
            if ac.equipped then
                ac.hitboxStats.hitboxResonance = 64
                ac:attack()
            end
        end
    end)
end

-- 3. HÀM TẠO NÚT
local function CreateSwitch(text, config_key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = " " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    
    local Status = Instance.new("Frame", btn)
    Status.Size = UDim2.new(0, 10, 0, 10)
    Status.Position = UDim2.new(1, -20, 0.5, -5)
    Status.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        _G.Config[config_key] = not _G.Config[config_key]
        Status.BackgroundColor3 = _G.Config[config_key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
    end)
end

CreateSwitch("Auto Farm", "AutoFarm")
CreateSwitch("Fast Attack", "FastAttack")
CreateSwitch("Bring Mob", "BringMob")

-- 4. VÒNG LẶP CORE
task.spawn(function()
    while task.wait() do
        if _G.Config.FastAttack then Attack() end
        
        if _G.Config.AutoFarm then
            pcall(function()
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        LP.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        if _G.Config.BringMob then
                            v.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, -10, 0)
                            v.HumanoidRootPart.CanCollide = false
                        end
                        break
                    end
                end
            end)
        end
    end
end)

print("Dug Hub V4.1 Loaded!")
