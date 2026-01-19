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

-- ========================================
-- SCRIPT MULAI DI BAWAH INI
-- ========================================

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "yi da mu sake",
    Footer = "version: 3.0",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Waypoint = Window:AddTab("Waypoint Tween", "navigation"),
    AutoCollect = Window:AddTab("Auto Collect", "dollar-sign"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ========================================
-- VARIABLES
-- ========================================

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ========================================
-- WAYPOINT TWEEN FEATURE
-- ========================================

local WaypointBox = Tabs.Waypoint:AddLeftGroupbox("Waypoint Navigation")

WaypointBox:AddButton({
    Text = "Open Waypoint UI",
    Func = function()
        -- Load the waypoint UI script
        loadstring([[
-- Waypoint Tween UI dengan Dragable Window

-- ============================================
-- WAYPOINT DATA
-- ============================================
local waypoints = {
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

local baseCoords = {x = 125, y = 3, z = 0}

-- ============================================
-- VARIABLES
-- ============================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local currentWaypointIndex = 1
local isTweening = false
local tweenDuration = 3

-- ============================================
-- DRAGABLE WINDOW SYSTEM
-- ============================================
local dragging = false
local dragStart
local startPos

-- ============================================
-- FUNGSI UTAMA
-- ============================================
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
    local tweenInfo = TweenInfo.new(
        tweenDuration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
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
    
    spawn(function()
        while isTweening do
            if UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
                tween:Cancel()
                isTweening = false
                if StatusLabel then
                    StatusLabel.Text = "Cancelled"
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                break
            end
            task.wait(0.1)
        end
    end)
    
    return true
end

local function goToNextWaypoint()
    if currentWaypointIndex < #waypoints then
        local wp = waypoints[currentWaypointIndex + 1]
        return tweenToPosition({x = wp.x, y = wp.y, z = wp.z}, wp.name)
    else
        if StatusLabel then
            StatusLabel.Text = "Last WP"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            task.wait(1)
            StatusLabel.Text = "Ready"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        return false
    end
end

local function goToPreviousWaypoint()
    if currentWaypointIndex > 1 then
        local wp = waypoints[currentWaypointIndex - 1]
        return tweenToPosition({x = wp.x, y = wp.y, z = wp.z}, wp.name)
    else
        if StatusLabel then
            StatusLabel.Text = "First WP"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            task.wait(1)
            StatusLabel.Text = "Ready"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        return false
    end
end

local function goToBase()
    return tweenToPosition(baseCoords, "BASE")
end

-- ============================================
-- BUAT UI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WaypointTweenUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- ==================== MAIN WINDOW ====================
MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 200, 0, 160)
MainWindow.Position = UDim2.new(0, 10, 0, 10)
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainWindow.BorderSizePixel = 0
MainWindow.Parent = ScreenGui

MainWindow.Active = true
MainWindow.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(48, 255, 106)
MainStroke.Thickness = 1
MainStroke.Parent = MainWindow

-- ==================== TITLE BAR ====================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6, 0, 0)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 5, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "📍 Waypoint Tween"
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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 3)
CloseCorner.Parent = CloseBtn

-- ==================== CONTENT ====================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -25)
Content.Position = UDim2.new(0, 5, 0, 20)
Content.BackgroundTransparency = 1
Content.Parent = MainWindow

StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready (Drag me!)"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 9
StatusLabel.Parent = Content

local PositionInfo = Instance.new("TextLabel")
PositionInfo.Size = UDim2.new(1, 0, 0, 15)
PositionInfo.Position = UDim2.new(0, 0, 0, 20)
PositionInfo.BackgroundTransparency = 1
PositionInfo.Text = "Near: None"
PositionInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
PositionInfo.Font = Enum.Font.Gotham
PositionInfo.TextSize = 8
PositionInfo.Name = "PositionInfo"
PositionInfo.Parent = Content

WaypointDisplay = Instance.new("TextLabel")
WaypointDisplay.Size = UDim2.new(1, 0, 0, 25)
WaypointDisplay.Position = UDim2.new(0, 0, 0, 35)
WaypointDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
WaypointDisplay.TextColor3 = Color3.new(1, 1, 1)
WaypointDisplay.Text = "WP 1"
WaypointDisplay.Font = Enum.Font.Gotham
WaypointDisplay.TextSize = 10
WaypointDisplay.Name = "WaypointDisplay"
WaypointDisplay.Parent = Content

local WaypointCorner = Instance.new("UICorner")
WaypointCorner.CornerRadius = UDim.new(0, 4)
WaypointCorner.Parent = WaypointDisplay

local DurationContainer = Instance.new("Frame")
DurationContainer.Size = UDim2.new(1, 0, 0, 20)
DurationContainer.Position = UDim2.new(0, 0, 0, 65)
DurationContainer.BackgroundTransparency = 1
DurationContainer.Parent = Content

local DurationLabel = Instance.new("TextLabel")
DurationLabel.Size = UDim2.new(0.4, 0, 1, 0)
DurationLabel.BackgroundTransparency = 1
DurationLabel.Text = "Duration:"
DurationLabel.TextColor3 = Color3.new(1, 1, 1)
DurationLabel.Font = Enum.Font.Gotham
DurationLabel.TextSize = 8
DurationLabel.TextXAlignment = Enum.TextXAlignment.Left
DurationLabel.Parent = DurationContainer

local DurationBox = Instance.new("TextBox")
DurationBox.Size = UDim2.new(0.6, 0, 1, 0)
DurationBox.Position = UDim2.new(0.4, 0, 0, 0)
DurationBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
DurationBox.TextColor3 = Color3.new(1, 1, 1)
DurationBox.Text = tostring(tweenDuration)
DurationBox.Font = Enum.Font.Gotham
DurationBox.TextSize = 9
DurationBox.Parent = DurationContainer

local DurationCorner = Instance.new("UICorner")
DurationCorner.CornerRadius = UDim.new(0, 4)
DurationCorner.Parent = DurationBox

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 45)
ButtonContainer.Position = UDim2.new(0, 0, 0, 90)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Content

DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0.48, 0, 0, 40)
DownBtn.Position = UDim2.new(0, 0, 0, 0)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 80)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.new(1, 1, 1)
DownBtn.Font = Enum.Font.GothamMedium
DownBtn.TextSize = 9
DownBtn.Parent = ButtonContainer

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 4)
DownCorner.Parent = DownBtn

UpBtn = Instance.new("TextButton")
UpBtn.Size = UDim2.new(0.48, 0, 0, 40)
UpBtn.Position = UDim2.new(0.52, 0, 0, 0)
UpBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
UpBtn.Text = "UP"
UpBtn.TextColor3 = Color3.new(1, 1, 1)
UpBtn.Font = Enum.Font.GothamMedium
UpBtn.TextSize = 9
UpBtn.Parent = ButtonContainer

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 4)
UpCorner.Parent = UpBtn

local BaseBtn = Instance.new("TextButton")
BaseBtn.Size = UDim2.new(1, 0, 0, 20)
BaseBtn.Position = UDim2.new(0, 0, 0, 140)
BaseBtn.BackgroundColor3 = Color3.fromRGB(48, 255, 106)
BaseBtn.Text = "BASE"
BaseBtn.TextColor3 = Color3.new(0, 0, 0)
BaseBtn.Font = Enum.Font.GothamMedium
BaseBtn.TextSize = 9
BaseBtn.Parent = Content

local BaseCorner = Instance.new("UICorner")
BaseCorner.CornerRadius = UDim.new(0, 4)
BaseCorner.Parent = BaseBtn

-- ==================== FUNGSI UPDATE UI ====================
function updateWaypointDisplay()
    local wp = waypoints[currentWaypointIndex]
    if wp then
        WaypointDisplay.Text = wp.name
    end
    
    local nearestIndex = detectNearestWaypoint()
    if nearestIndex then
        PositionInfo.Text = "Near: WP " .. nearestIndex
        PositionInfo.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        PositionInfo.Text = "Near: None (>35 studs)"
        PositionInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- ==================== EVENT HANDLERS ====================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

DurationBox.FocusLost:Connect(function()
    local newDuration = tonumber(DurationBox.Text)
    if newDuration and newDuration >= 0.5 and newDuration <= 30 then
        tweenDuration = newDuration
    else
        DurationBox.Text = tostring(tweenDuration)
    end
end)

DownBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    goToPreviousWaypoint()
    updateWaypointDisplay()
end)

UpBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    goToNextWaypoint()
    updateWaypointDisplay()
end)

BaseBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    goToBase()
end)

-- ==================== SETUP DRAGGING ====================
MainWindow.Active = true
MainWindow.Draggable = true

MainWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
    end
end)

MainWindow.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ==================== HOTKEY SUPPORT ====================
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and not isTweening then
        if input.KeyCode == Enum.KeyCode.PageUp then
            goToNextWaypoint()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.PageDown then
            goToPreviousWaypoint()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.Up then
            goToNextWaypoint()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.Down then
            goToPreviousWaypoint()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.B then
            goToBase()
        elseif input.KeyCode == Enum.KeyCode.R then
            updateCurrentWaypointFromPosition()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.Escape then
            if isTweening then
                StatusLabel.Text = "Cancelling..."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end
end)

-- ==================== AUTO UPDATE ====================
spawn(function()
    while ScreenGui.Parent do
        updateCurrentWaypointFromPosition()
        updateWaypointDisplay()
        task.wait(1)
    end
end)

-- ==================== INITIALIZE ====================
updateCurrentWaypointFromPosition()
updateWaypointDisplay()

print("✅ Waypoint Tween UI Loaded!")
print("🖱️ DRAG: Click and drag anywhere on the window")
print("⬆️⬇️ Arrow Keys: Navigate waypoints")
print("📄 PageUp/PageDown: Navigate waypoints")
print("🏠 B Key: Go to base")
print("🔄 R Key: Refresh position")
print("⏱️ Duration: Adjustable (0.5-30 seconds)")

return ScreenGui
        ]])()
        
        Library:Notify("Waypoint UI opened!", 2)
    end,
    Tooltip = "Opens a separate draggable UI for waypoint navigation",
})

WaypointBox:AddLabel("Click the button above to open", true)
WaypointBox:AddLabel("the waypoint tween UI", true)

local WaypointInfo = Tabs.Waypoint:AddRightGroupbox("Features")

WaypointInfo:AddLabel("• Draggable window", true)
WaypointInfo:AddLabel("• UP/DOWN buttons", true)
WaypointInfo:AddLabel("• BASE teleport", true)
WaypointInfo:AddLabel("• Auto-detect nearest WP (35 studs)", true)
WaypointInfo:AddLabel("• Adjustable tween speed", true)
WaypointInfo:AddLabel("", true)
WaypointInfo:AddLabel("Keybinds:", true)
WaypointInfo:AddLabel("• PageUp / Arrow Up = Next WP", true)
WaypointInfo:AddLabel("• PageDown / Arrow Down = Prev WP", true)
WaypointInfo:AddLabel("• B = Go to Base", true)
WaypointInfo:AddLabel("• R = Refresh Position", true)
WaypointInfo:AddLabel("• ESC = Cancel Tween", true).Font = Enum.Font.GothamMedium
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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 3)
CloseCorner.Parent = CloseBtn

-- ==================== CONTENT ====================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -25)
Content.Position = UDim2.new(0, 5, 0, 20)
Content.BackgroundTransparency = 1
Content.Parent = MainWindow

StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready (Drag me!)"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 9
StatusLabel.Parent = Content

local PositionInfo = Instance.new("TextLabel")
PositionInfo.Size = UDim2.new(1, 0, 0, 15)
PositionInfo.Position = UDim2.new(0, 0, 0, 20)
PositionInfo.BackgroundTransparency = 1
PositionInfo.Text = "Near: -- ========================================
-- AUTO COLLECT FEATURES
-- ========================================

local AutoMoneyBox = Tabs.AutoCollect:AddLeftGroupbox("Auto Collect Money")

local isAutoCollectingMoney = false
local playerBase = nil

-- Function to detect player's base using multiple methods
local function detectPlayerBase()
    local basesFolder = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("Bases_NEW")
    if not basesFolder then 
        return nil 
    end
    
    -- Method 1: Try ReplicatedStorage PlotAction
    local success1, plotBase = pcall(function()
        local plotAction = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 2):WaitForChild("Net", 2):WaitForChild("RF/Plot.PlotAction", 2)
        local result = plotAction:InvokeServer("GetPlot")
        if result and type(result) == "string" then
            return basesFolder:FindFirstChild(result)
        end
    end)
    
    if success1 and plotBase then
        return plotBase
    end
    
    -- Method 2: Check for base with player's username/"
PositionInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
PositionInfo.Font = Enum.Font.Gotham
PositionInfo.TextSize = 8
PositionInfo.Name = "PositionInfo"
PositionInfo.Parent = Content

WaypointDisplay = Instance.new("TextLabel")
WaypointDisplay.Size = UDim2.new(1, 0, 0, 25)
WaypointDisplay.Position = UDim2.new(0, 0, 0, 35)
WaypointDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
WaypointDisplay.TextColor3 = Color3.new(1, 1, 1)
WaypointDisplay.Text = "WP 1"
WaypointDisplay.Font = Enum.Font.Gotham
WaypointDisplay.TextSize = 10
WaypointDisplay.Name = "WaypointDisplay"
WaypointDisplay.Parent = Content

local WaypointCorner = Instance.new("UICorner")
WaypointCorner.CornerRadius = UDim.new(0, 4)
WaypointCorner.Parent = WaypointDisplay

local DurationContainer = Instance.new("Frame")
DurationContainer.Size = UDim2.new(1, 0, 0, 20)
DurationContainer.Position = UDim2.new(0, 0, 0, 65)
DurationContainer.BackgroundTransparency = 1
DurationContainer.Parent = Content

local DurationLabel = Instance.new("TextLabel")
DurationLabel.Size = UDim2.new(0.4, 0, 1, 0)
DurationLabel.BackgroundTransparency = 1
DurationLabel.Text = "Duration:"
DurationLabel.TextColor3 = Color3.new(1, 1, 1)
DurationLabel.Font = Enum.Font.Gotham
DurationLabel.TextSize = 8
DurationLabel.TextXAlignment = Enum.TextXAlignment.Left
DurationLabel.Parent = DurationContainer

local DurationBox = Instance.new("TextBox")
DurationBox.Size = UDim2.new(0.6, 0, 1, 0)
DurationBox.Position = UDim2.new(0.4, 0, 0, 0)
DurationBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
DurationBox.TextColor3 = Color3.new(1, 1, 1)
DurationBox.Text = tostring(tweenDuration)
DurationBox.Font = Enum.Font.Gotham
DurationBox.TextSize = 9
DurationBox.Parent = DurationContainer

local DurationCorner = Instance.new("UICorner")
DurationCorner.CornerRadius = UDim.new(0, 4)
DurationCorner.Parent = DurationBox

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 45)
ButtonContainer.Position = UDim2.new(0, 0, 0, 90)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Content

DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0.48, 0, 0, 40)
DownBtn.Position = UDim2.new(0, 0, 0, 0)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 80)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.new(1, 1, 1)
DownBtn.Font = Enum.Font.GothamMedium
DownBtn.TextSize = 9
DownBtn.Parent = ButtonContainer

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 4)
DownCorner.Parent = DownBtn

UpBtn = Instance.new("TextButton")
UpBtn.Size = UDim2.new(0.48, 0, 0, 40)
UpBtn.Position = UDim2.new(0.52, 0, 0, 0)
UpBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
UpBtn.Text = "UP"
UpBtn.TextColor3 = Color3.new(1, 1, 1)
UpBtn.Font = Enum.Font.GothamMedium
UpBtn.TextSize = 9
UpBtn.Parent = ButtonContainer

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 4)
UpCorner.Parent = UpBtn

local BaseBtn = Instance.new("TextButton")
BaseBtn.Size = UDim2.new(1, 0, 0, 20)
BaseBtn.Position = UDim2.new(0, 0, 0, 140)
BaseBtn.BackgroundColor3 = Color3.fromRGB(48, 255, 106)
BaseBtn.Text = "BASE"
BaseBtn.TextColor3 = Color3.new(0, 0, 0)
BaseBtn.Font = Enum.Font.GothamMedium
BaseBtn.TextSize = 9
BaseBtn.Parent = Content

local BaseCorner = Instance.new("UICorner")
BaseCorner.CornerRadius = UDim.new(0, 4)
BaseCorner.Parent = BaseBtn

-- ==================== FUNGSI UPDATE UI ====================
function updateWaypointDisplay()
    local wp = waypoints[currentWaypointIndex]
    if wp then
        WaypointDisplay.Text = wp.name
    end
    
    local nearestIndex = detectNearestWaypoint()
    if nearestIndex then
        PositionInfo.Text = "Near: WP " .. nearestIndex
        PositionInfo.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        PositionInfo.Text = "Near: None (>35 studs)"
        PositionInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- ==================== EVENT HANDLERS ====================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

DurationBox.FocusLost:Connect(function()
    local newDuration = tonumber(DurationBox.Text)
    if newDuration and newDuration >= 0.5 and newDuration <= 30 then
        tweenDuration = newDuration
    else
        DurationBox.Text = tostring(tweenDuration)
    end
end)

DownBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    goToPreviousWaypoint()
    updateWaypointDisplay()
end)

UpBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    goToNextWaypoint()
    updateWaypointDisplay()
end)

BaseBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    goToBase()
end)

-- ==================== SETUP DRAGGING ====================
MainWindow.Active = true
MainWindow.Draggable = true

MainWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
    end
end)

MainWindow.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ==================== HOTKEY SUPPORT ====================
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and not isTweening then
        if input.KeyCode == Enum.KeyCode.Up then
            goToNextWaypoint()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.Down then
            goToPreviousWaypoint()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.B then
            goToBase()
        elseif input.KeyCode == Enum.KeyCode.R then
            updateCurrentWaypointFromPosition()
            updateWaypointDisplay()
        elseif input.KeyCode == Enum.KeyCode.Escape then
            if isTweening then
                StatusLabel.Text = "Cancelling..."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end
end)

-- ==================== AUTO UPDATE ====================
spawn(function()
    while ScreenGui.Parent do
        updateCurrentWaypointFromPosition()
        updateWaypointDisplay()
        task.wait(1)
    end
end)

-- ==================== INITIALIZE ====================
updateCurrentWaypointFromPosition()
updateWaypointDisplay()

print("✅ Waypoint Tween UI Loaded!")
print("🖱️ DRAG: Click and drag anywhere on the window")
print("⬆️⬇️ UP/DOWN: Navigate waypoints")
print("🏠 BASE: Go to base coordinates")
print("⏱️ Duration: Adjustable (0.5-30 seconds)")

return ScreenGui
        ]])()
        
        Library:Notify("Waypoint UI opened!", 2)
    end,
    Tooltip = "Opens a separate draggable UI for waypoint navigation",
})

WaypointBox:AddLabel("Click the button above to open", true)
WaypointBox:AddLabel("the waypoint tween UI", true)

local WaypointInfo = Tabs.Waypoint:AddRightGroupbox("Features")

WaypointInfo:AddLabel("• Draggable window", true)
WaypointInfo:AddLabel("• UP/DOWN buttons", true)
WaypointInfo:AddLabel("• BASE teleport", true)
WaypointInfo:AddLabel("• Auto-detect nearest WP (35 studs)", true)
WaypointInfo:AddLabel("• Adjustable tween speed", true)
WaypointInfo:AddLabel("• Arrow key support", true)

-- ========================================
-- AUTO COLLECT FEATURES
-- ========================================

local AutoMoneyBox = Tabs.AutoCollect:AddLeftGroupbox("Auto Collect Money")

local isAutoCollectingMoney = false
local playerBase = nil

-- Function to detect player's base using multiple methods
local function detectPlayerBase()
    local basesFolder = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("Bases_NEW")
    if not basesFolder then 
        return nil 
    end
    
    -- Method 1: Try ReplicatedStorage PlotAction
    local success1, plotBase = pcall(function()
        local plotAction = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 2):WaitForChild("Net", 2):WaitForChild("RF/Plot.PlotAction", 2)
        local result = plotAction:InvokeServer("GetPlot")
        if result and type(result) == "string" then
            return basesFolder:FindFirstChild(result)
        end
    end)
    
    if success1 and plotBase then
        return plotBase
    end
    
    -- Method 2: Check for base with player's username/UserId
    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local owner = base:FindFirstChild("Owner") or base:FindFirstChild("PlotOwner")
            if owner then
                if owner:IsA("StringValue") and (owner.Value == player.Name or owner.Value == tostring(player.UserId)) then
                    return base
                elseif owner:IsA("ObjectValue") and owner.Value == player then
                    return base
                end
            end
            
            local ownerAttr = base:GetAttribute("Owner") or base:GetAttribute("PlotOwner")
            if ownerAttr and (ownerAttr == player.Name or ownerAttr == tostring(player.UserId) or ownerAttr == player.UserId) then
                return base
            end
            
            local config = base:FindFirstChild("Configuration")
            if config then
                local configOwner = config:FindFirstChild("Owner")
                if configOwner and configOwner:IsA("StringValue") and (configOwner.Value == player.Name or configOwner.Value == tostring(player.UserId)) then
                    return base
                end
            end
        end
    end
    
    -- Method 3: Proximity as fallback
    local char = player.Character
    if not char then return nil end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closestBase = nil
    local closestDistance = math.huge
    
    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local basePart = base:FindFirstChildWhichIsA("BasePart", true)
            if basePart then
                local distance = (hrp.Position - basePart.Position).Magnitude
                if distance < closestDistance and distance < 150 then
                    closestDistance = distance
                    closestBase = base
                end
            end
        end
    end
    
    return closestBase
end

local function collectFromSlot(collectPart)
    if not collectPart or not collectPart:FindFirstChild("TouchInterest") then
        return false
    end
    
    local char = player.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    firetouchinterest(hrp, collectPart, 0)
    task.wait(0.01)
    firetouchinterest(hrp, collectPart, 1)
    
    return true
end

AutoMoneyBox:AddToggle("AutoCollectMoney", {
    Text = "Enable Auto Collect Money",
    Default = false,
    Tooltip = "Automatically collects money from your base slots",
    
    Callback = function(Value)
        isAutoCollectingMoney = Value
        
        if Value then
            Library:Notify("Auto Collect Money started!", 2)
        else
            Library:Notify("Auto Collect Money stopped!", 2)
        end
    end,
})

local moneyStatusLabel = AutoMoneyBox:AddLabel("Status: Idle")

task.spawn(function()
    while task.wait(0.5) do
        if isAutoCollectingMoney then
            -- Re-detect base if not found
            if not playerBase then
                playerBase = detectPlayerBase()
                if playerBase then
                    Library:Notify("Base detected!", 2)
                else
                    moneyStatusLabel:SetText("Status: Base not found")
                    task.wait(3)
                end
            end
            
            if playerBase then
                moneyStatusLabel:SetText("Status: Collecting...")
                
                local totalCollected = 0
                local slotsFolder = playerBase:FindFirstChild("Slots")
                
                if slotsFolder then
                    for i = 1, 30 do
                        if not isAutoCollectingMoney then break end
                        
                        local slot = slotsFolder:FindFirstChild("Slot" .. i)
                        if slot then
                            local collectPart = slot:FindFirstChild("Collect")
                            if collectPart then
                                local success = collectFromSlot(collectPart)
                                if success then
                                    totalCollected = totalCollected + 1
                                end
                            end
                        end
                    end
                end
                
                if totalCollected > 0 then
                    moneyStatusLabel:SetText("Collected " .. totalCollected .. " slots ✓")
                else
                    moneyStatusLabel:SetText("No slots to collect")
                end
                
                task.wait(1)
            end
        else
            moneyStatusLabel:SetText("Status: Idle")
            playerBase = nil
        end
    end
end)

-- ========================================
-- AUTO COLLECT RADIOACTIVE COINS
-- ========================================

local AutoCoinBox = Tabs.AutoCollect:AddRightGroupbox("Auto Collect Radioactive Coins")

local isAutoCollectingCoins = false

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

local function collectCoins()
    local char = player.Character
    if not char then return 0 end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end
    
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

AutoCoinBox:AddToggle("AutoCollectCoins", {
    Text = "Enable Auto Collect Coins",
    Default = false,
    Tooltip = "Automatically collects radioactive coins",
    
    Callback = function(Value)
        isAutoCollectingCoins = Value
        
        if Value then
            Library:Notify("Auto Collect Coins started!", 2)
        else
            Library:Notify("Auto Collect Coins stopped!", 2)
        end
    end,
})

local coinStatusLabel = AutoCoinBox:AddLabel("Status: Idle")

task.spawn(function()
    while task.wait(0.1) do
        if isAutoCollectingCoins then
            local collected = collectCoins()
            if collected > 0 then
                coinStatusLabel:SetText("Collected " .. collected .. " coins ✓")
            else
                coinStatusLabel:SetText("No coins found")
            end
            task.wait(0.1)
        else
            coinStatusLabel:SetText("Status: Idle")
        end
    end
end)

-- ========================================
-- UI SETTINGS
-- ========================================

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("YiDaMuSake")
SaveManager:SetFolder("YiDaMuSake/config")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

Library:Notify("Yi Da Mu Sake v3.0 loaded!", 3)
