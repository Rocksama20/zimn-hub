-- Zimn Hub for Jailbreak v1.0
-- Created by ZimnLas
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
local currentTab = "AutoRob"

-- Stores/Locations
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
    titleLabel.Text = "🚔 ZIMN HUB"
    titleLabel.TextColor3 = Color3.white()
    titleLabel.TextSize = 24
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
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Header
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
    title.Text = "🚔 ZIMN HUB"
    title.TextColor3 = Color3.white()
    title.TextSize = 22
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
    
    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -20, 0, 45)
    tabBar.Position = UDim2.new(0, 10, 0, 60)
    tabBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame
    
    local tabBarCorner = Instance.new("UICorner")
    tabBarCorner.CornerRadius = UDim.new(0, 8)
    tabBarCorner.Parent = tabBar
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -20, 1, -125)
    contentContainer.Position = UDim2.new(0, 10, 0, 115)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame
    
    -- Tab Content Frames
    local tabContents = {}
    
    for _, tabName in ipairs({"AutoRob", "Move", "Teleport", "Misc"}) do
        local content = Instance.new("ScrollingFrame")
        content.Name = tabName
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 6
        content.CanvasSize = UDim2.new(0, 0, 0, 400)
        content.Visible = false
        content.Parent = contentContainer
        tabContents[tabName] = content
    end
    
    -- Show first tab by default
    tabContents["AutoRob"].Visible = true
    
    -- Create Tab Buttons
    local tabButtons = {}
    local tabNames = {"AutoRob", "Move", "Teleport", "Misc"}
    local tabIcons = {"💰", "🏃", "🗺️", "⚙️"}
    
    local function switchTab(tabName)
        for name, content in pairs(tabContents) do
            content.Visible = (name == tabName)
        end
        
        for name, btn in pairs(tabButtons) do
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
                btn.TextColor3 = Color3.white()
            else
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
    
    for i, tabName in ipairs(tabNames) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.25, -5, 1, -10)
        tabBtn.Position = UDim2.new((i-1) * 0.25, 2.5, 0, 5)
        tabBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(60, 60, 70)
        tabBtn.Text = tabIcons[i] .. " " .. tabName
        tabBtn.TextColor3 = (i == 1) and Color3.white() or Color3.fromRGB(200, 200, 200)
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Parent = tabBar
        
        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 6)
        tabBtnCorner.Parent = tabBtn
        
        tabButtons[tabName] = tabBtn
        
        tabBtn.MouseButton1Click:Connect(function()
            switchTab(tabName)
        end)
    end
    
    -- Helper function to create buttons
    local function createButton(parent, name, position, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.Position = UDim2.new(0, 5, 0, position)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        btn.Text = name
        btn.TextColor3 = Color3.white()
        btn.TextSize = 15
        btn.Font = Enum.Font.Gotham
        btn.Parent = parent
        
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
                
                teleportTo(storeData.entrance)
                task.wait(2)
                teleportTo(storeData.inside)
                task.wait(5)
                teleportTo(storeData.entrance)
                task.wait(3)
            end
            
            task.wait(10)
        end
    end
    
    -- TAB 1: Auto Rob
    createButton(tabContents["AutoRob"], "💰 Auto Rob All [ON/OFF]", 5, function()
        autoRobbing = not autoRobbing
        if autoRobbing then
            spawn(startAutoRob)
        else
            notify("Auto Rob", "Đã tắt!")
        end
    end)
    
    createButton(tabContents["AutoRob"], "💎 Auto Rob Jewelry", 60, function()
        notify("Auto Rob", "Đang rob Jewelry...")
        teleportTo(stores["Jewelry"].entrance)
        task.wait(2)
        teleportTo(stores["Jewelry"].inside)
    end)
    
    createButton(tabContents["AutoRob"], "🏦 Auto Rob Bank", 115, function()
        notify("Auto Rob", "Đang rob Bank...")
        teleportTo(stores["Bank"].entrance)
        task.wait(2)
        teleportTo(stores["Bank"].inside)
    end)
    
    createButton(tabContents["AutoRob"], "🏛️ Auto Rob Museum", 170, function()
        notify("Auto Rob", "Đang rob Museum...")
        teleportTo(stores["Museum"].entrance)
        task.wait(2)
        teleportTo(stores["Museum"].inside)
    end)
    
    -- TAB 2: Move
    createButton(tabContents["Move"], "🏃 Speed Boost [ON/OFF]", 5, function()
        speedEnabled = not speedEnabled
        if speedEnabled then
            humanoid.WalkSpeed = 100
            notify("Speed", "Đã bật!")
        else
            humanoid.WalkSpeed = 16
            notify("Speed", "Đã tắt!")
        end
    end)
    
    createButton(tabContents["Move"], "🦘 Jump Power [ON/OFF]", 60, function()
        jumpEnabled = not jumpEnabled
        if jumpEnabled then
            humanoid.JumpPower = 150
            notify("Jump", "Đã bật!")
        else
            humanoid.JumpPower = 50
            notify("Jump", "Đã tắt!")
        end
    end)
    
    createButton(tabContents["Move"], "🔄 Reset Speed & Jump", 115, function()
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        speedEnabled = false
        jumpEnabled = false
        notify("Reset", "Đã reset về mặc định!")
    end)
    
    -- TAB 3: Teleport
    createButton(tabContents["Teleport"], "🏪 TP Jewelry Store", 5, function()
        teleportTo(stores["Jewelry"].entrance)
        notify("Teleport", "Đã TP đến Jewelry!")
    end)
    
    createButton(tabContents["Teleport"], "🏦 TP Bank", 60, function()
        teleportTo(stores["Bank"].entrance)
        notify("Teleport", "Đã TP đến Bank!")
    end)
    
    createButton(tabContents["Teleport"], "🏛️ TP Museum", 115, function()
        teleportTo(stores["Museum"].entrance)
        notify("Teleport", "Đã TP đến Museum!")
    end)
    
    createButton(tabContents["Teleport"], "🚗 TP Prison", 170, function()
        teleportTo(CFrame.new(-943, 18, -1500))
        notify("Teleport", "Đã TP đến Prison!")
    end)
    
    createButton(tabContents["Teleport"], "🏠 TP Police Station", 225, function()
        teleportTo(CFrame.new(-267, 18, 1574))
        notify("Teleport", "Đã TP đến Police Station!")
    end)
    
    -- TAB 4: Misc
    createButton(tabContents["Misc"], "🔄 Reset Character", 5, function()
        character:BreakJoints()
        notify("Reset", "Đã reset character!")
    end)
    
    createButton(tabContents["Misc"], "ℹ️ Script Info", 60, function()
        notify("Zimn Hub", "Version 1.0 | By ZimnLas")
    end)
    
    createButton(tabContents["Misc"], "📋 Copy Discord", 115, function()
        setclipboard("discord.gg/zimnhub")
        notify("Discord", "Đã copy link Discord!")
    end)
    
    -- Footer
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 20)
    footer.Position = UDim2.new(0, 0, 1, -20)
    footer.BackgroundTransparency = 1
    footer.Text = "Created by ZimnLas | v1.0"
    footer.TextColor3 = Color3.fromRGB(150, 150, 150)
    footer.TextSize = 12
    footer.Font = Enum.Font.Gotham
    footer.Parent = mainFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Z then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
    
    notify("Zimn Hub", "Loaded! Press Z to toggle | By ZimnLas")
end

-- Start
createKeySystem()
