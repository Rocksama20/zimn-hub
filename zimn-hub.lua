-- Zimn Hub for Jailbreak
-- Key: ZimnHub12

local keyCorrect = "ZimnHub12"

-- Kiểm tra game
repeat task.wait() until game:IsLoaded()
task.wait(2)

if game.PlaceId ~= 606849621 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚠️ Zimn Hub";
        Text = "Script chỉ hoạt động trong Jailbreak!";
        Duration = 5;
    })
    return
end

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local autoRobbing = false
local speedEnabled = false
local jumpEnabled = false

-- Stores/Locations cho Jailbreak
local stores = {
    ["Jewelry"] = {
        entrance = CFrame.new(142, 18, 1365),
        inside = CFrame.new(133, 18, 1320),
        name = "Jewelry Store"
    },
    ["Bank"] = {
        entrance = CFrame.new(-441, 18, 1574),
        inside = CFrame.new(-503, 18, 1577),
        name = "Bank"
    },
    ["Museum"] = {
        entrance = CFrame.new(1166, 102, 1245),
        inside = CFrame.new(1150, 102, 1234),
        name = "Museum"
    }
}

-- Functions
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 3;
    })
end

local function teleportTo(cframe)
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = cframe
    end
end

-- Key System GUI
local function createKeySystem()
    local playerGui = player:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("ZimnKeySystem") then
        playerGui.ZimnKeySystem:Destroy()
    end
    
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "ZimnKeySystem"
    keyGui.Parent = playerGui
    keyGui.ResetOnSpawn = false
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.5
    blur.BorderSizePixel = 0
    blur.Parent = keyGui
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 350, 0, 250)
    keyFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = keyGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 15)
    frameCorner.Parent = keyFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 60)
    titleLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "🚔 ZIMN HUB - JAILBREAK"
    titleLabel.TextColor3 = Color3.white()
    titleLabel.TextSize = 22
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = keyFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleLabel
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 40)
    infoLabel.Position = UDim2.new(0, 20, 0, 70)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Nhập key để truy cập"
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextSize = 16
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = keyFrame
    
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, -40, 0, 45)
    keyBox.Position = UDim2.new(0, 20, 0, 120)
    keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    keyBox.BorderSizePixel = 0
    keyBox.PlaceholderText = "Nhập key..."
    keyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.white()
    keyBox.TextSize = 16
    keyBox.Font = Enum.Font.Gotham
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = keyFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = keyBox
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, -40, 0, 45)
    submitBtn.Position = UDim2.new(0, 20, 0, 180)
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    submitBtn.BorderSizePixel = 0
    submitBtn.Text = "✓ XÁC NHẬN"
    submitBtn.TextColor3 = Color3.white()
    submitBtn.TextSize = 18
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.Parent = keyFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = submitBtn
    
    submitBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == keyCorrect then
            infoLabel.Text = "✓ Key đúng! Đang tải..."
            infoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.wait(1)
            keyGui:Destroy()
            loadMainMenu()
        else
            infoLabel.Text = "✗ Key sai!"
            infoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            keyBox.Text = ""
            task.wait(2)
            infoLabel.Text = "Nhập key để truy cập"
            infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitBtn.MouseButton1Click:Fire()
        end
    end)
end

-- Main Menu
function loadMainMenu()
    local playerGui = player:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("ZimnMenu") then
        playerGui.ZimnMenu:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZimnMenu"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🚔 ZIMN HUB - JAILBREAK"
    title.TextColor3 = Color3.white()
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.white()
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -20, 1, -70)
    container.Position = UDim2.new(0, 10, 0, 60)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 6
    container.CanvasSize = UDim2.new(0, 0, 0, 600)
    container.Parent = mainFrame
    
    local function createButton(name, position, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.Position = UDim2.new(0, 5, 0, position)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        btn.Text = name
        btn.TextColor3 = Color3.white()
        btn.TextSize = 15
        btn.Font = Enum.Font.Gotham
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        end)
        
        btn.MouseButton1Click:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
            task.wait(0.1)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            if callback then
                pcall(callback)
            end
        end)
        
        return btn
    end
    
    -- Auto Rob Function
    local function startAutoRob()
        autoRobbing = true
        notify("Auto Rob", "Bắt đầu auto rob!")
        
        while autoRobbing do
            for storeName, storeData in pairs(stores) do
                if not autoRobbing then break end
                
                notify("Auto Rob", "Đang rob " .. storeData.name)
                
                -- TP vào store
                teleportTo(storeData.entrance)
                task.wait(2)
                teleportTo(storeData.inside)
                task.wait(5)
                
                -- TP ra ngoài
                teleportTo(storeData.entrance)
                task.wait(3)
            end
            
            task.wait(10)
        end
    end
    
    -- Buttons
    createButton("💰 Auto Rob [ON/OFF]", 5, function()
        autoRobbing = not autoRobbing
        if autoRobbing then
            spawn(startAutoRob)
        else
            notify("Auto Rob", "Đã tắt!")
        end
    end)
    
    createButton("🏃 Speed Boost [ON/OFF]", 60, function()
        speedEnabled = not speedEnabled
        if speedEnabled then
            humanoid.WalkSpeed = 100
            notify("Speed", "Đã bật!")
        else
            humanoid.WalkSpeed = 16
            notify("Speed", "Đã tắt!")
        end
    end)
    
    createButton("🦘 Jump Power [ON/OFF]", 115, function()
        jumpEnabled = not jumpEnabled
        if jumpEnabled then
            humanoid.JumpPower = 150
            notify("Jump", "Đã bật!")
        else
            humanoid.JumpPower = 50
            notify("Jump", "Đã tắt!")
        end
    end)
    
    createButton("🏪 TP Jewelry Store", 170, function()
        teleportTo(stores["Jewelry"].entrance)
        notify("Teleport", "Đã TP đến Jewelry!")
    end)
    
    createButton("🏦 TP Bank", 225, function()
        teleportTo(stores["Bank"].entrance)
        notify("Teleport", "Đã TP đến Bank!")
    end)
    
    createButton("🏛️ TP Museum", 280, function()
        teleportTo(stores["Museum"].entrance)
        notify("Teleport", "Đã TP đến Museum!")
    end)
    
    createButton("🚗 TP Prison", 335, function()
        teleportTo(CFrame.new(-943, 18, -1500))
        notify("Teleport", "Đã TP đến Prison!")
    end)
    
    createButton("🏠 TP Police Station", 390, function()
        teleportTo(CFrame.new(-267, 18, 1574))
        notify("Teleport", "Đã TP đến Police Station!")
    end)
    
    createButton("🔄 Reset Character", 445, function()
        character:BreakJoints()
        notify("Reset", "Đã reset!")
    end)
    
    createButton("ℹ️ Info", 500, function()
        notify("Zimn Hub", "Version 1.0 - Key: ZimnHub12")
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Z then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
    
    notify("Zimn Hub", "Loaded! Nhấn Z để toggle")
end

-- Start
createKeySystem()
