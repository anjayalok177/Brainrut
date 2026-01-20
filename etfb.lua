-- Yi Da Mu Sake Script
-- Modified by user request

-- ======================
-- Intro animation
-- ======================
local function createIntroAnimation()
    local TweenService = game:GetService("TweenService")
    local SoundService = game:GetService("SoundService")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "IntroScreen"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Create sounds
    local laserSound = Instance.new("Sound")
    laserSound.SoundId = "rbxassetid://9057675920"
    laserSound.Volume = 0.5
    laserSound.Parent = SoundService
    
    local explosionSound = Instance.new("Sound")
    explosionSound.SoundId = "rbxassetid://112797079504478"
    explosionSound.Volume = 0.6
    explosionSound.Parent = SoundService
    
    -- Animated Background with gradient
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    background.BorderSizePixel = 0
    background.Parent = screenGui
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 10, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 30, 70))
    }
    gradient.Rotation = 45
    gradient.Parent = background
    
    -- Animated particles in background
    for i = 1, 20 do
        local bgParticle = Instance.new("Frame")
        bgParticle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
        bgParticle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        bgParticle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        bgParticle.BackgroundTransparency = math.random(50, 80) / 100
        bgParticle.BorderSizePixel = 0
        bgParticle.Parent = background
        
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(1, 0)
        bgCorner.Parent = bgParticle
        
        -- Float animation
        task.spawn(function()
            while bgParticle.Parent do
                local floatAnim = TweenService:Create(
                    bgParticle,
                    TweenInfo.new(math.random(20, 40) / 10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {
                        Position = UDim2.new(
                            bgParticle.Position.X.Scale + math.random(-10, 10) / 100,
                            0,
                            bgParticle.Position.Y.Scale + math.random(-10, 10) / 100,
                            0
                        )
                    }
                )
                floatAnim:Play()
                task.wait(math.random(20, 40) / 10)
            end
        end)
    end
    
    -- Main Image Frame (Square) - Centered
    local imageFrame = Instance.new("ImageLabel")
    imageFrame.Size = UDim2.new(0, 220, 0, 220)
    imageFrame.Position = UDim2.new(0.5, 0, 1.2, 0)
    imageFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    imageFrame.BackgroundTransparency = 1
    imageFrame.Image = "rbxassetid://110843044052526"
    imageFrame.ScaleType = Enum.ScaleType.Fit
    imageFrame.Parent = background
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 25)
    corner.Parent = imageFrame
    
    -- Glow effect around image
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1.3, 0, 1.3, 0)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Color3.fromRGB(138, 43, 226)
    glow.ImageTransparency = 0.5
    glow.Parent = imageFrame
    
    -- Title text - MOVED MUCH LOWER
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 500, 0, 70)
    title.Position = UDim2.new(0.5, 0, 0.78, 0)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.BackgroundTransparency = 1
    title.Text = "YI DA MU SAKE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 48
    title.Font = Enum.Font.GothamBold
    title.TextTransparency = 1
    title.TextStrokeTransparency = 0.5
    title.TextStrokeColor3 = Color3.fromRGB(138, 43, 226)
    title.Parent = background
    
    -- ANIMATION 1: Slide up from bottom with smooth BOUNCE effect (2.5 SECONDS)
    local slideUp = TweenService:Create(
        imageFrame,
        TweenInfo.new(2.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0.4, 0)}
    )
    
    -- ANIMATION 2: Fade in text
    local fadeInTitle = TweenService:Create(
        title,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    )
    
    -- Start animations + LASER SOUND
    laserSound:Play()
    slideUp:Play()
    task.wait(1.2)
    fadeInTitle:Play()
    
    -- Wait for bounce to settle completely
    task.wait(2.0)
    
    -- Calculate distance from center for OUTSIDE-IN shatter
    local function getDistanceFromCenter(row, col, gridSize)
        local centerRow = (gridSize - 1) / 2
        local centerCol = (gridSize - 1) / 2
        local distRow = row - centerRow
        local distCol = col - centerCol
        return math.sqrt(distRow * distRow + distCol * distCol)
    end
    
    -- SHATTER FROM OUTSIDE TO INSIDE
    local function createShatteredPieces()
        local pieces = {}
        local gridSize = 6
        local imageSize = 220
        local pieceSize = imageSize / gridSize
        local originalImageSize = 420
        
        local piecesWithDistance = {}
        
        for row = 0, gridSize - 1 do
            for col = 0, gridSize - 1 do
                local piece = Instance.new("ImageLabel")
                
                piece.Size = UDim2.new(0, pieceSize, 0, pieceSize)
                piece.Position = UDim2.new(
                    0.5, (col * pieceSize) - (imageSize / 2),
                    0.4, (row * pieceSize) - (imageSize / 2)
                )
                piece.AnchorPoint = Vector2.new(0, 0)
                
                piece.BackgroundTransparency = 1
                piece.Image = "rbxassetid://110843044052526"
                piece.ScaleType = Enum.ScaleType.Crop
                piece.ZIndex = 5
                
                local rectWidth = originalImageSize / gridSize
                local rectHeight = originalImageSize / gridSize
                
                piece.ImageRectSize = Vector2.new(rectWidth, rectHeight)
                piece.ImageRectOffset = Vector2.new(col * rectWidth, row * rectHeight)
                
                piece.Parent = background
                
                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(0, math.random(2, 6))
                pCorner.Parent = piece
                
                local distance = getDistanceFromCenter(row, col, gridSize)
                
                table.insert(piecesWithDistance, {
                    piece = piece,
                    distance = distance
                })
            end
        end
        
        table.sort(piecesWithDistance, function(a, b)
            return a.distance > b.distance
        end)
        
        return piecesWithDistance
    end
    
    local function createTotemParticles()
        local particles = {}
        
        for i = 1, 45 do
            local particle = Instance.new("Frame")
            local size = math.random(10, 22)
            particle.Size = UDim2.new(0, size, 0, size)
            particle.Position = UDim2.new(0.5, 0, 0.4, 0)
            particle.AnchorPoint = Vector2.new(0.5, 0.5)
            
            local colorChoice = math.random(1, 4)
            if colorChoice == 1 then
                particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            elseif colorChoice == 2 then
                particle.BackgroundColor3 = Color3.fromRGB(255, 255, 120)
            elseif colorChoice == 3 then
                particle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            else
                particle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            end
            
            particle.BorderSizePixel = 0
            particle.ZIndex = 6
            particle.Parent = background
            
            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0.35, 0)
            pCorner.Parent = particle
            
            table.insert(particles, particle)
        end
        
        return particles
    end
    
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BorderSizePixel = 0
    flash.BackgroundTransparency = 1
    flash.ZIndex = 10
    flash.Parent = background
    
    local flashIn = TweenService:Create(
        flash,
        TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.1}
    )
    
    local flashOut = TweenService:Create(
        flash,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    )
    
    imageFrame.Visible = false
    glow.Visible = false
    
    explosionSound:Play()
    
    flashIn:Play()
    flashIn.Completed:Connect(function()
        flashOut:Play()
    end)
    
    local shatteredPieces = createShatteredPieces()
    local totemParts = createTotemParticles()
    
    for i, pieceData in ipairs(shatteredPieces) do
        local piece = pieceData.piece
        
        local angle = math.random(0, 360)
        local rad = math.rad(angle)
        local distance = math.random(400, 800)
        
        local targetX = math.cos(rad) * distance
        local targetY = math.sin(rad) * distance + math.random(100, 300)
        
        local scatter = TweenService:Create(
            piece,
            TweenInfo.new(
                2.0,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Position = UDim2.new(piece.Position.X.Scale, piece.Position.X.Offset + targetX, 
                                   piece.Position.Y.Scale, piece.Position.Y.Offset + targetY),
                ImageTransparency = 1,
                Rotation = math.random(-450, 450),
                Size = UDim2.new(0, piece.Size.X.Offset * 0.3, 0, piece.Size.Y.Offset * 0.3)
            }
        )
        
        scatter:Play()
        
        if i <= #totemParts then
            local totemParticle = totemParts[i]
            
            local tAngle = math.random(0, 360)
            local tRad = math.rad(tAngle)
            local tDistance = math.random(350, 750)
            
            local tTargetX = math.cos(tRad) * tDistance
            local tTargetY = math.sin(tRad) * tDistance + math.random(120, 280)
            
            local totemScatter = TweenService:Create(
                totemParticle,
                TweenInfo.new(
                    2.0,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.Out
                ),
                {
                    Position = UDim2.new(0.5, tTargetX, 0.4, tTargetY),
                    BackgroundTransparency = 1,
                    Rotation = math.random(-280, 280),
                    Size = UDim2.new(0, totemParticle.Size.X.Offset * 0.25, 0, totemParticle.Size.Y.Offset * 0.25)
                }
            )
            
            totemScatter:Play()
        end
        
        task.wait(0.004)
    end
    
    task.wait(1.5)
    
    local fadeOutTitle = TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1})
    local fadeOutBg = TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    
    fadeOutTitle:Play()
    fadeOutBg:Play()
    
    task.wait(0.6)
    
    laserSound:Destroy()
    explosionSound:Destroy()
    
    screenGui:Destroy()
end

createIntroAnimation()

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Yi Da Mu Sake",
    Footer = "version: 1.0",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    AutoFarm = Window:AddTab("Auto Farm", "zap"),
    Teleportasi = Window:AddTab("Teleportasi😆", "map-pin"),
    Sell = Window:AddTab("Sell", "shopping-cart"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ============================================
-- AUTO FARM TAB
-- ============================================
local AutoCollectGroup = Tabs.AutoFarm:AddLeftGroupbox("Auto Collect Money", "dollar-sign")
local AutoEventGroup = Tabs.AutoFarm:AddRightGroupbox("Auto Collect Event", "sparkles")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Variables for Auto Collect Slots
local collectSlotsEnabled = false
local playerBase = nil
local collectDelay = 0.1
local lastCollectTime = 0
local hrp = nil
local char = player.Character or player.CharacterAdded:Wait()

-- Update HRP reference
local function updateCharacter()
    char = player.Character
    if char then
        hrp = char:WaitForChild("HumanoidRootPart")
    end
end

updateCharacter()

-- Function to detect player's base (FULL VERSION)
local function detectPlayerBase()
    local basesFolder = workspace:FindFirstChild("Bases_NEW")
    if not basesFolder then 
        warn("Bases_NEW folder not found!")
        return nil 
    end
    
    -- Method 1: Try ReplicatedStorage PlotAction
    local success1, plotBase = pcall(function()
        local plotAction = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction")
        local result = plotAction:InvokeServer("GetPlot")
        if result and type(result) == "string" then
            return basesFolder:FindFirstChild(result)
        end
    end)
    
    if success1 and plotBase then
        print("✅ Base found via PlotAction:", plotBase.Name)
        return plotBase
    end
    
    -- Method 2: Check for base with player's username/UserId
    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local owner = base:FindFirstChild("Owner") or base:FindFirstChild("PlotOwner")
            if owner then
                if owner:IsA("StringValue") and (owner.Value == player.Name or owner.Value == tostring(player.UserId)) then
                    print("✅ Base found via Owner StringValue:", base.Name)
                    return base
                elseif owner:IsA("ObjectValue") and owner.Value == player then
                    print("✅ Base found via Owner ObjectValue:", base.Name)
                    return base
                end
            end
            
            local ownerAttr = base:GetAttribute("Owner") or base:GetAttribute("PlotOwner")
            if ownerAttr and (ownerAttr == player.Name or ownerAttr == tostring(player.UserId) or ownerAttr == player.UserId) then
                print("✅ Base found via Attribute:", base.Name)
                return base
            end
            
            local config = base:FindFirstChild("Configuration")
            if config then
                local configOwner = config:FindFirstChild("Owner")
                if configOwner and configOwner:IsA("StringValue") and (configOwner.Value == player.Name or configOwner.Value == tostring(player.UserId)) then
                    print("✅ Base found via Configuration:", base.Name)
                    return base
                end
            end
        end
    end
    
    -- Method 3: Check if base has player inside it (ownership check)
    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local claimed = base:FindFirstChild("Claimed") or base:FindFirstChild("Owned")
            if claimed and claimed:IsA("BoolValue") and claimed.Value == true then
                local testPart = base:FindFirstChildWhichIsA("BasePart", true)
                if testPart and hrp and (hrp.Position - testPart.Position).Magnitude < 100 then
                    print("✅ Base found via Claimed status:", base.Name)
                    return base
                end
            end
        end
    end
    
    -- Method 4: Proximity as last resort (closest base)
    warn("⚠️ Using proximity detection as fallback...")
    local closestBase = nil
    local closestDistance = math.huge
    
    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local basePart = base:FindFirstChildWhichIsA("BasePart", true)
            if basePart and hrp then
                local distance = (hrp.Position - basePart.Position).Magnitude
                if distance < closestDistance and distance < 150 then
                    closestDistance = distance
                    closestBase = base
                end
            end
        end
    end
    
    if closestBase then
        print("⚠️ Base found via proximity:", closestBase.Name)
    end
    
    return closestBase
end

-- Function to find all Collect parts in player's base
local function findCollectParts()
    if not playerBase then return {} end
    
    local collectParts = {}
    local slotsFolder = playerBase:FindFirstChild("Slots")
    
    if not slotsFolder then 
        warn("Slots folder not found in base!")
        return collectParts 
    end
    
    for i = 1, 30 do
        local slotName = "Slot" .. i
        local slot = slotsFolder:FindFirstChild(slotName)
        
        if slot then
            local collectPart = slot:FindFirstChild("Collect")
            if collectPart and collectPart:IsA("BasePart") then
                if collectPart:FindFirstChildOfClass("TouchTransmitter") then
                    table.insert(collectParts, collectPart)
                end
            end
        end
    end
    
    return collectParts
end

-- Function to collect money from all slots
local function collectMoney()
    if not hrp then return end
    
    local currentTime = tick()
    if currentTime - lastCollectTime < collectDelay then
        return
    end
    lastCollectTime = currentTime
    
    local collectParts = findCollectParts()
    local count = 0
    
    for _, collectPart in pairs(collectParts) do
        if collectPart and collectPart.Parent then
            local success, err = pcall(function()
                firetouchinterest(hrp, collectPart, 0)
                firetouchinterest(hrp, collectPart, 1)
            end)
            
            if success then
                count = count + 1
            end
            
            task.wait(0.01)
        end
    end
    
    return count
end

-- Auto Collect All Slots Toggle
AutoCollectGroup:AddToggle("AutoCollectSlots", {
    Text = "Auto Collect All Slots",
    Tooltip = "Auto collect money from Slot 1-30",
    Default = false,
    Callback = function(Value)
        collectSlotsEnabled = Value
        
        if Value then
            if not playerBase then
                playerBase = detectPlayerBase()
                if playerBase then
                    local baseName = playerBase.Name
                    if #baseName > 20 then
                        baseName = baseName:sub(1, 15) .. "..."
                    end
                    Library:Notify("Base found: " .. baseName, 2)
                else
                    Library:Notify("Base not found! Make sure you're in your base.", 3)
                    Toggles.AutoCollectSlots:SetValue(false)
                    return
                end
            end
            
            task.spawn(function()
                while collectSlotsEnabled do
                    local collected = collectMoney()
                    task.wait(collectDelay)
                end
            end)
        end
    end,
})

-- Auto detect base on startup
task.spawn(function()
    task.wait(2)
    playerBase = detectPlayerBase()
    if playerBase then
        local baseName = playerBase.Name
        if #baseName > 20 then
            baseName = baseName:sub(1, 15) .. "..."
        end
        Library:Notify("Base detected: " .. baseName, 2)
        print("✅ Base detected: " .. playerBase.Name)
    else
        Library:Notify("Base: Not Found! Will detect when toggled.", 3)
        warn("❌ Could not detect player base!")
    end
end)

-- Re-detect base on character respawn
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
    
    task.wait(2)
    playerBase = detectPlayerBase()
    if playerBase then
        Library:Notify("Base re-detected after respawn", 2)
    end
end)

-- Variables for Auto Collect Coins
local collectCoinsEnabled = false
local coinCollectDelay = 0.1
local lastCoinCollectTime = 0

-- Function to find all coins
local function findCoins()
    local coins = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("coin") or name:find("radioactive") or name:find("money") then
                table.insert(coins, obj)
            end
        end
    end
    return coins
end

-- Function to collect coins
local function collectCoins()
    local char = player.Character
    if not char then return 0 end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end
    
    local currentTime = tick()
    if currentTime - lastCoinCollectTime < coinCollectDelay then
        return 0
    end
    lastCoinCollectTime = currentTime
    
    local coins = findCoins()
    local count = 0
    
    for _, coin in pairs(coins) do
        if coin and coin.Parent then
            pcall(function()
                firetouchinterest(hrp, coin, 0)
                firetouchinterest(hrp, coin, 1)
            end)
            count = count + 1
            task.wait(0.01)
        end
    end
    
    return count
end

-- Auto Collect Radioactive Coins Toggle
AutoEventGroup:AddToggle("AutoCollectCoins", {
    Text = "Auto Collect Radioactive Coins",
    Tooltip = "Auto collect event coins",
    Default = false,
    Callback = function(Value)
        collectCoinsEnabled = Value
        
        if Value then
            task.spawn(function()
                while collectCoinsEnabled do
                    collectCoins()
                    task.wait(coinCollectDelay)
                end
            end)
        end
    end,
})

AutoEventGroup:AddDivider()

-- Variables for Luckybox Obby Macro
local obbyMacroRunning = false

-- Luckybox Obby Macro Data
local obbyWaypoints = {
    {1074.6,-2.8,-62.5},{1074.6,-2.8,-62.5},{1074.6,-2.8,-62.5},{1074.6,-2.8,-62.5},{1074.6,-2.8,-62.5},{1074.6,-2.8,-63.1},{1074.5,-2.8,-65.8},{1074.4,-2.8,-68.6},{1074.2,-2.8,-71.5},{1074.1,-2.8,-74.3},{1074,-2.6,-77.2},{1073.9,-2.3,-79.9},{1073.8,-2.7,-82.8},{1073.7,-2.7,-85.8},{1073.5,-2.5,-88.8},{1073.4,-2.8,-91.8},{1073.3,-2.8,-94.5},{1073.2,-2.8,-97.5},{1073.2,-2.8,-100.2},{1073.2,-2.8,-103.2},{1073.2,-2.8,-106.3},{1073.2,-2.8,-109.2},{1073.3,-2.8,-112.2},{1073.3,-2.8,-114.9},{1073.4,-2.8,-117.6},{1073.4,-2.8,-120.6},{1073.5,-2.8,-123.6},{1073.5,-2.8,-126.6},{1073.4,-2.8,-129.4},{1073.3,-2.8,-132.3},{1073.3,-2.8,-135.1},{1073.4,-2.8,-138},{1073.5,-2.8,-140.7},{1073.7,-2.8,-143.7},{1073.8,3.1,-146.7},{1073.9,4.4,-149.6},{1074,0.9,-152.4},{1074.1,-3.3,-155.3},{1074.3,-0.4,-158.3},{1074.4,3.8,-161.3},{1074.5,2.9,-164.2},{1074.6,-2.8,-167},{1074.6,-12,-169.7},{1074.5,-11.3,-172.3},{1074.4,-11.2,-175.1},{1074.2,-11.4,-178},{1074.1,-13.6,-180.7},{1074,-14,-183.7},{1073.9,-14,-186.6},{1073.8,-14,-189.4},{1073.7,-14,-192.4},{1073.6,-14,-195.4},{1073.5,-14,-198.4},{1073.5,-14,-201.4},{1073.5,-8.3,-204.3},{1073.5,-6.7,-207.1},{1073.5,-9.7,-209.8},{1073.5,-11.3,-212.7},{1073.5,-11.2,-215.6},{1073.5,-6.8,-218.5},{1073.5,-4.1,-222.1},{1073.5,-7.7,-225},{1073.5,-13.1,-227.7},{1073.3,-13.8,-230.8},{1072.6,-13.8,-233.2},{1071.3,-13.8,-236},{1069.7,-13.3,-238.6},{1068,-7.7,-240.9},{1066.2,-5.9,-243.3},{1064.5,-9.2,-245.5},{1063.1,-18.3,-248.2},{1063.3,-22.7,-251.2},{1064.6,-22.7,-253.9},{1066.1,-20,-256.2},{1067.7,-15.3,-258.7},{1069.3,-16,-261.2},{1071,-18.7,-263.7},{1072.9,-18.7,-265.7},{1075.1,-18.7,-267.8},{1077.5,-18.2,-270.1},{1079.6,-12.5,-272.3},{1081.6,-10.9,-274.5},{1083.4,-13.8,-276.5},{1085.2,-13.7,-278.6},{1087.1,-13.7,-280.9},{1089,-13.3,-283.3},{1090.9,-8.7,-285.5},{1092.8,-5.7,-287.9},{1094.7,-8.1,-290.1},{1096.5,-8.8,-292.3},{1097.8,-7,-294.8},{1098.3,-2.1,-297.6},{1098.2,-2.1,-300.3},{1097.8,-6.8,-303.1},{1097.3,-6.8,-306.1},{1097.1,-2.9,-308.8},{1097,0.4,-311.7},{1096.9,-1.2,-314.5},{1096.7,-7.5,-317.3},{1094.3,-8.8,-318.6},{1091.9,-8.8,-320.2},{1089.7,-2.8,-322},{1087.6,-1.8,-324},{1085.6,-5.7,-326},{1083.7,-7.9,-328.1},{1082.1,-7.8,-330.2},{1081,-6.9,-332.7},{1080.2,-6,-335.3},{1079.7,-5.2,-338},{1079.7,-4.5,-340.8},{1080.1,-3.8,-343.5},{1080.4,-3.1,-346.2},{1080.4,-1.7,-348.9},{1080.1,3.9,-351.8},{1079.5,4.3,-354.6},{1079,0.1,-357.3},{1078.2,-1.8,-360.3},{1077.4,-1.8,-363.1},{1076.9,-1.8,-365.9},{1076.2,-1.8,-368.6},{1075.5,-1.8,-371.4},{1074.9,-1.8,-374.1},{1074.6,-0.3,-377},{1074.3,4.7,-379.8},{1074,5.1,-382.5},{1073.1,0.6,-385.2},{1071.2,-2.9,-387.3},{1070.2,1,-390.2},{1069.8,4.3,-392.8},{1069.4,3.3,-395.5},{1069.1,-2.2,-398.2},{1069,-7.9,-399.2},{1069,-7.8,-399.2},{1069,-7.8,-399.2},{1069.4,-7.8,-400.4},{1070.3,-6.1,-403},{1071.2,-1.1,-405.7},{1072,-1.2,-408.6},{1072.7,-2.8,-411.4},{1073.4,2.6,-414.2},{1074.1,4.4,-417.2},{1074.5,1.3,-419.9},{1075,-7.4,-422.9},{1074.7,-7.8,-425.5},{1074.1,-7.7,-428},{1073.4,-6.1,-430.7},{1072.8,-6.2,-433.3},{1072.4,-0.4,-436.2},{1072.4,1.1,-439.3},{1072.5,-2.7,-442.2},{1072.6,-5.5,-444.9},{1073.4,-5,-447.9},{1074.1,-4.5,-450.4},{1074.8,-4,-453},{1075.6,-3.6,-455.5},{1076.4,-3.1,-458.2},{1077.1,-2.6,-460.8},{1077.5,-2.1,-463.8},{1078,4,-466.7},{1078.6,5.1,-469.4},{1079,2.2,-472.1},{1079.2,1.6,-475.2},{1078.8,1.6,-478.1},{1078.4,1.6,-480.8},{1078.7,1.6,-483.7},{1079.5,1.6,-486.3},{1079.7,1.6,-486.9},{1079.7,1.6,-486.9},{1078.7,1.6,-488.1},{1076.9,6.7,-490.4},{1075.1,8.9,-492.7},{1073.5,6.4,-494.8},{1071.6,-1.1,-496.9},{1069.3,-10.9,-498.6},{1067,-10.7,-500},{1064.8,-10.4,-501.9},{1062.7,-4.3,-503.9},{1060.8,-3.2,-505.8},{1058.8,-5.1,-507.8},{1056.1,-5.7,-509},{1053.3,-5.7,-510},{1052,-5.7,-510.4},{1052,-5.7,-510.4},{1050.2,-5.4,-510.9},{1047.5,-1.8,-511.7},{1044.8,2.1,-512.6},{1041.9,0.5,-513.8},{1039.9,0.6,-513.3},{1037.7,0.6,-512.3},{1037,0.6,-512.1},{1037,0.6,-512.1},{1035.3,0.6,-512.1},{1032.6,0.6,-512.2},{1029.6,0.6,-512.8},{1026.7,0.6,-513.4},{1024,6.1,-513.9},{1021.4,7.9,-514.5},{1019.3,5.2,-516.2},{1018.2,-1,-519},{1018.2,-1.9,-519.1},{1018.2,-1.9,-519.1},{1017.5,-1.9,-520.6},{1015.8,-2.1,-523.2},{1014,2.4,-525.5},{1011.9,4.9,-527.3},{1009.8,2.9,-529.1},{1007.7,-3.7,-530.9},{1005.6,-6,-532.9},{1003.5,-6.3,-535.1},{1001.6,-2.9,-537.4},{999.7,0.7,-539.4},{997.8,-0.4,-541.3},{995.9,-6.5,-543.6},{994.2,-10.9,-545.5},{991.2,-5.8,-545.2},{988.7,-3.8,-543.7},{986.3,-7.3,-541.9},{984.3,-11.4,-540.4},{982.6,-11.2,-537.8},{981.9,-11.2,-535.6},{981.9,-11.2,-535.6},{981.9,-11.2,-534.7},{980.8,-11.2,-531.7},{979.2,-11.2,-529.3},{977.1,-11.2,-527.5},{974.6,-6.9,-526.3},{971.9,-4.3,-525.6},{969.2,-6.3,-524.9},{967.5,-11,-524.5},{967.5,-10.8,-524.5},{967.4,-10.8,-524.5},{964.6,-10.8,-525},{961.8,-9.5,-525.5},{959,-4.3,-526},{956.3,-3.9,-526.4},{953.6,-8,-526.3},{950.8,-10.8,-525.1},{947.8,-7,-524.6},{944.9,-3.6,-524.3},{942.2,-5,-524.2},{939.1,-12,-524.1},{936.2,-16.8,-523.9},{933.4,-16.8,-523.5},{930.5,-16.8,-523.5},{927.7,-16.8,-523.6},{924.7,-16.8,-523.7},{921.8,-16.8,-523.8},{918.8,-16.8,-523.9},{915.8,-16.8,-524},{913.1,-16.8,-524.1},{910.1,-16.8,-524.2},{1073.3,-2.8,-53.1},{1070.4,-2.8,-53.2},{1067.4,-2.8,-53.3},{1067.2,-2.8,-53.3},{1067.2,-2.8,-53.3},{1067.2,-2.8,-53.3},{1067.2,-2.8,-53.3},{1067.4,-2.8,-53.6},{1068.1,-2.8,-55.8},{1068.1,-2.8,-55.8},{1068.1,-2.8,-55.8},{1068.2,-2.8,-55.9},{1069.1,-2.8,-58.6},{1069.1,-2.8,-58.7},{1069.1,-2.8,-58.7},{1069.1,-2.8,-58.7}
}

-- Function to run Luckybox Obby Macro
local function runObbyMacro()
    local c = player.Character
    if not c then
        Library:Notify("Character not found!", 2)
        return
    end
    
    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    
    if not h or not r then
        Library:Notify("Humanoid or HumanoidRootPart not found!", 2)
        return
    end
    
    obbyMacroRunning = true
    Library:Notify("Starting Luckybox Obby Macro...", 2)
    
    task.spawn(function()
        while obbyMacroRunning do
            h:Move(Vector3.new(0, 0, -1), true)
            task.wait()
        end
    end)
    
    for i, v in ipairs(obbyWaypoints) do
        if not obbyMacroRunning then break end
        
        local targetPos = Vector3.new(v[1], v[2], v[3])
        
        if targetPos.Y > r.Position.Y + 1.2 then
            h.Jump = true
        end
        
        r.CFrame = CFrame.new(targetPos)
        task.wait(0.1)
    end
    
    obbyMacroRunning = false
    h:Move(Vector3.new(0, 0, 0), true)
    Library:Notify("Luckybox Obby Macro Completed!", 2)
    print("✅ Macro Finished - Xiao & Li")
end

-- Auto Complete Luckybox Obby Button
AutoEventGroup:AddButton({
    Text = "Auto Complete Luckybox Obby",
    Func = function()
        if obbyMacroRunning then
            Library:Notify("Macro is already running!", 2)
            return
        end
        runObbyMacro()
    end,
    Tooltip = "Automatically complete the Luckybox Obby using recorded macro"
})

-- Stop Macro Button
AutoEventGroup:AddButton({
    Text = "Stop Obby Macro",
    Func = function()
        if obbyMacroRunning then
            obbyMacroRunning = false
            Library:Notify("Obby Macro stopped!", 2)
        else
            Library:Notify("No macro is running!", 2)
        end
    end,
    Tooltip = "Stop the running obby macro"
})

-- ============================================
-- TELEPORTASI TAB
-- ============================================
local TeleportGroup = Tabs.Teleportasi:AddLeftGroupbox("Waypoint Teleport", "navigation")

-- Waypoint Button
TeleportGroup:AddButton({
    Text = "Open Waypoint UI",
    Func = function()
        loadstring([[
-- Waypoint Tween UI (Modified - PC & Mobile Compatible)
local waypoints = {
    {x = 125, y = 3, z = 0, name = "BASE"},
    {x = 205, y = -3, z = 0, name = "WP 1"},
    {x = 287, y = -3, z = 0, name = "WP 2"},
    {x = 393, y = -3, z = 0, name = "WP 3"},
    {x = 548, y = -3, z = 0, name = "WP 4"},
    {x = 749, y = -3, z = 0, name = "WP 5"},
    {x = 1081, y = -3, z = 0, name = "WP 6"},
    {x = 1572, y = -3, z = 0, name = "WP 7"},
    {x = 2263, y = -3, z = 0, name = "WP 8"},
    {x = 2617, y = -3, z = 0, name = "WP 9"}
}

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local currentWaypointIndex = 1
local isTweening = false
local tweenDuration = 3

-- Detect platform
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function detectNearestWaypoint()
    local character = player.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local playerPos = hrp.Position
    local nearestIndex = nil
    local nearestDistance = 35
    
    for i, wp in ipairs(waypoints) do
        local wpPos = Vector3.new(wp.x, wp.y, wp.z)
        local distance = (wpPos - playerPos).Magnitude
        if distance <= nearestDistance then
            nearestDistance = distance
            nearestIndex = i
        end
    end
    
    return nearestIndex
end

local function updateCurrentWaypointFromPosition()
    local nearestIndex = detectNearestWaypoint()
    if nearestIndex then
        currentWaypointIndex = nearestIndex
        return true
    end
    return false
end

local function tweenToPosition(position, wpName)
    local character = player.Character
    if not character or isTweening then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    isTweening = true
    local targetCFrame = CFrame.new(position.x, position.y, position.z)
    local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    if StatusLabel then
        StatusLabel.Text = "Moving to " .. wpName
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    end
    
    tween.Completed:Connect(function()
        isTweening = false
        if StatusLabel then
            StatusLabel.Text = "Ready"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        updateCurrentWaypointFromPosition()
        updateWaypointDisplay()
    end)
    
    return true
end

local function goToNextWaypoint()
    if currentWaypointIndex < #waypoints then
        local wp = waypoints[currentWaypointIndex + 1]
        return tweenToPosition({x = wp.x, y = wp.y, z = wp.z}, wp.name)
    end
    return false
end

local function goToPreviousWaypoint()
    if currentWaypointIndex > 1 then
        local wp = waypoints[currentWaypointIndex - 1]
        return tweenToPosition({x = wp.x, y = wp.y, z = wp.z}, wp.name)
    end
    return false
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WaypointTweenUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 200, 0, 170)
MainWindow.Position = UDim2.new(0, 10, 0, 10)
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainWindow.BorderSizePixel = 0
MainWindow.Parent = ScreenGui
MainWindow.Active = true
MainWindow.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainWindow

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 5, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "📍 WP " .. (isMobile and "(Mobile)" or "(PC)")
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.Font = Enum.Font.GothamMedium
TitleText.TextSize = 10
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 15, 0, 15)
CloseBtn.Position = UDim2.new(1, -20, 0.5, -7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 8
CloseBtn.Parent = TitleBar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -25)
Content.Position = UDim2.new(0, 5, 0, 20)
Content.BackgroundTransparency = 1
Content.Parent = MainWindow

StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 9
StatusLabel.Parent = Content

WaypointDisplay = Instance.new("TextLabel")
WaypointDisplay.Size = UDim2.new(1, 0, 0, 25)
WaypointDisplay.Position = UDim2.new(0, 0, 0, 25)
WaypointDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
WaypointDisplay.TextColor3 = Color3.new(1, 1, 1)
WaypointDisplay.Text = "BASE"
WaypointDisplay.Font = Enum.Font.Gotham
WaypointDisplay.TextSize = 10
WaypointDisplay.Parent = Content

local DurationLabel = Instance.new("TextLabel")
DurationLabel.Size = UDim2.new(0.4, 0, 0, 20)
DurationLabel.Position = UDim2.new(0, 0, 0, 55)
DurationLabel.BackgroundTransparency = 1
DurationLabel.Text = "Duration:"
DurationLabel.TextColor3 = Color3.new(1, 1, 1)
DurationLabel.Font = Enum.Font.Gotham
DurationLabel.TextSize = 8
DurationLabel.TextXAlignment = Enum.TextXAlignment.Left
DurationLabel.Parent = Content

local DurationBox = Instance.new("TextBox")
DurationBox.Size = UDim2.new(0.6, 0, 0, 20)
DurationBox.Position = UDim2.new(0.4, 0, 0, 55)
DurationBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
DurationBox.TextColor3 = Color3.new(1, 1, 1)
DurationBox.Text = tostring(tweenDuration)
DurationBox.Font = Enum.Font.Gotham
DurationBox.TextSize = 9
DurationBox.Parent = Content

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 45)
ButtonContainer.Position = UDim2.new(0, 0, 0, 80)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Content

local DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0.48, 0, 0, 40)
DownBtn.Position = UDim2.new(0, 0, 0, 0)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 80)
DownBtn.Text = "DOWN" .. (isMobile and "" or "\n(PgDn)")
DownBtn.TextColor3 = Color3.new(1, 1, 1)
DownBtn.Font = Enum.Font.GothamMedium
DownBtn.TextSize = isMobile and 9 or 8
DownBtn.Parent = ButtonContainer

local UpBtn = Instance.new("TextButton")
UpBtn.Size = UDim2.new(0.48, 0, 0, 40)
UpBtn.Position = UDim2.new(0.52, 0, 0, 0)
UpBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
UpBtn.Text = "UP" .. (isMobile and "" or "\n(PgUp)")
UpBtn.TextColor3 = Color3.new(1, 1, 1)
UpBtn.Font = Enum.Font.GothamMedium
UpBtn.TextSize = isMobile and 9 or 8
UpBtn.Parent = ButtonContainer

local BaseBtn = Instance.new("TextButton")
BaseBtn.Size = UDim2.new(1, 0, 0, 20)
BaseBtn.Position = UDim2.new(0, 0, 0, 130)
BaseBtn.BackgroundColor3 = Color3.fromRGB(48, 255, 106)
BaseBtn.Text = "BASE"
BaseBtn.TextColor3 = Color3.new(0, 0, 0)
BaseBtn.Font = Enum.Font.GothamMedium
BaseBtn.TextSize = 9
BaseBtn.Parent = Content

function updateWaypointDisplay()
    local wp = waypoints[currentWaypointIndex]
    if wp then WaypointDisplay.Text = wp.name end
end

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

DurationBox.FocusLost:Connect(function()
    local newDuration = tonumber(DurationBox.Text)
    if newDuration and newDuration >= 0.5 and newDuration <= 30 then
        tweenDuration = newDuration
    else
        DurationBox.Text = tostring(tweenDuration)
    end
end)

DownBtn.MouseButton1Click:Connect(function()
    if not isTweening then goToPreviousWaypoint() updateWaypointDisplay() end
end)

UpBtn.MouseButton1Click:Connect(function()
    if not isTweening then goToNextWaypoint() updateWaypointDisplay() end
end)

BaseBtn.MouseButton1Click:Connect(function()
    if not isTweening then
        currentWaypointIndex = 1
        tweenToPosition(waypoints[1], "BASE")
    end
end)

-- Keyboard Controls (PC Only)
if not isMobile then
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and not isTweening then
            if input.KeyCode == Enum.KeyCode.PageUp then
                goToNextWaypoint()
                updateWaypointDisplay()
            elseif input.KeyCode == Enum.KeyCode.PageDown then
                goToPreviousWaypoint()
                updateWaypointDisplay()
            end
        end
    end)
end

spawn(function()
    while ScreenGui.Parent do
        updateCurrentWaypointFromPosition()
        updateWaypointDisplay()
        task.wait(1)
    end
end)

updateCurrentWaypointFromPosition()
updateWaypointDisplay()

-- Show controls info
if not isMobile then
    print("✅ Waypoint UI - PC Mode")
    print("⌨️ PageUp = Next Waypoint")
    print("⌨️ PageDown = Previous Waypoint")
else
    print("✅ Waypoint UI - Mobile Mode")
    print("📱 Use buttons to navigate")
end
        ]])()
    end,
    Tooltip = "Open separate waypoint teleport UI (PC & Mobile compatible)"
})

-- ============================================
-- SELL TAB
-- ============================================
local SellGroup = Tabs.Sell:AddLeftGroupbox("Sell Tool", "dollar-sign")

-- Sell Tool Button
SellGroup:AddButton({
    Text = "Sell Equipped Tool",
    Func = function()
        local character = player.Character
        if not character then
            Library:Notify("Character not found!", 2)
            return
        end
        
        local tool = character:FindFirstChildOfClass("Tool")
        if not tool then
            Library:Notify("No tool equipped!", 2)
            return
        end
        
        local success, result = pcall(function()
            local sellRemote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SellTool")
            return sellRemote:InvokeServer(tool)
        end)
        
        if success then
            Library:Notify("Sold: " .. tool.Name, 2)
        else
            Library:Notify("Failed to sell tool!", 2)
        end
    end,
    Tooltip = "Sell the tool you're currently holding"
})

-- ============================================
-- UI SETTINGS
-- ============================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("YiDaMuSake")
SaveManager:SetFolder("YiDaMuSake/configs")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

-- Notification
Library:Notify("Yi Da Mu Sake loaded successfully!", 3)
print("✅ Yi Da Mu Sake Script Loaded!")
print("📌 Auto Farm: Toggle features to start")
print("🗺️ Teleportasi: Click button to open waypoint UI")
print("💰 Sell: Click to sell equipped tool")
