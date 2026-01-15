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
        local gridSize = 6  -- 6x6 grid = 36 pieces
        local imageSize = 220
        local pieceSize = imageSize / gridSize
        local originalImageSize = 420
        
        -- Store pieces with their distance from center
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
                
                -- Crop to specific part
                local rectWidth = originalImageSize / gridSize
                local rectHeight = originalImageSize / gridSize
                
                piece.ImageRectSize = Vector2.new(rectWidth, rectHeight)
                piece.ImageRectOffset = Vector2.new(col * rectWidth, row * rectHeight)
                
                piece.Parent = background
                
                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(0, math.random(2, 6))
                pCorner.Parent = piece
                
                -- Calculate distance from center
                local distance = getDistanceFromCenter(row, col, gridSize)
                
                table.insert(piecesWithDistance, {
                    piece = piece,
                    distance = distance
                })
            end
        end
        
        -- Sort by distance (furthest first = outside first)
        table.sort(piecesWithDistance, function(a, b)
            return a.distance > b.distance
        end)
        
        return piecesWithDistance
    end
    
    -- TOTEM PARTICLES (spawn with image pieces!)
    local function createTotemParticles()
        local particles = {}
        
        for i = 1, 45 do
            local particle = Instance.new("Frame")
            local size = math.random(10, 22)
            particle.Size = UDim2.new(0, size, 0, size)
            particle.Position = UDim2.new(0.5, 0, 0.4, 0)
            particle.AnchorPoint = Vector2.new(0.5, 0.5)
            
            -- Totem colors: white, yellow, gold
            local colorChoice = math.random(1, 4)
            if colorChoice == 1 then
                particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White
            elseif colorChoice == 2 then
                particle.BackgroundColor3 = Color3.fromRGB(255, 255, 120) -- Yellow
            elseif colorChoice == 3 then
                particle.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
            else
                particle.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Purple accent
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
    
    -- White flash
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BorderSizePixel = 0
    flash.BackgroundTransparency = 1
    flash.ZIndex = 10
    flash.Parent = background
    
    -- INSTANT FLASH (like totem pop)
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
    
    -- Hide original
    imageFrame.Visible = false
    glow.Visible = false
    
    -- EXPLOSION SOUND!
    explosionSound:Play()
    
    -- FLASH!
    flashIn:Play()
    flashIn.Completed:Connect(function()
        flashOut:Play()
    end)
    
    -- Create particles
    local shatteredPieces = createShatteredPieces()
    local totemParts = createTotemParticles()
    
    -- SCATTER FROM OUTSIDE TO INSIDE (shockwave effect!)
    -- Image pieces and totem particles fly out TOGETHER
    
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
                2.0, -- PARTICLE DURATION: 2 SECONDS
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
        
        -- Spawn totem particle alongside some image pieces
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
                    2.0, -- PARTICLE DURATION: 2 SECONDS
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
        
        -- DELAY based on distance (outside pieces go first!)
        -- Smaller delay = faster shockwave effect
        task.wait(0.004)
    end
    
    -- Fade out (wait longer for particles to finish)
    task.wait(1.5)
    
    local fadeOutTitle = TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1})
    local fadeOutBg = TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    
    fadeOutTitle:Play()
    fadeOutBg:Play()
    
    task.wait(0.6)
    
    -- Clean up sounds
    laserSound:Destroy()
    explosionSound:Destroy()
    
    screenGui:Destroy()
end

createIntroAnimation()

-- ========================================
-- SCRIPT KAMU MULAI DI BAWAH INI
-- ========================================

-- Obsidian UI Integration - Yok Main Yok
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
	Footer = "version: 2.1",
	Icon = 95816097006870,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

local Tabs = {
	Teleport = Window:AddTab("Teleport", "map-pin"),
	AutoFarm = Window:AddTab("Auto Farm", "zap"),
	Combat = Window:AddTab("Combat", "shield"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ========================================
-- HELPER FUNCTIONS
-- ========================================

local player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local basePosition = Vector3.new(117, 3, -1)
local secretZonePosition = Vector3.new(2451, 3, -7)
local celestialZonePosition = Vector3.new(3100, 3, -7)

local function teleportTo(position)
	local char = player.Character
	if not char then 
		Library:Notify("Error: Character not found!", 3)
		return false
	end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then 
		Library:Notify("Error: HumanoidRootPart not found!", 3)
		return false
	end
	
	hrp.CFrame = CFrame.new(position)
	task.wait(0.1)
	return true
end

local function grabBrainrot(brainrot)
	if not brainrot then return false end
	
	local prompt = nil
	
	if brainrot:IsA("Model") then
		prompt = brainrot:FindFirstChildWhichIsA("ProximityPrompt", true)
	elseif brainrot:IsA("BasePart") then
		prompt = brainrot:FindFirstChildWhichIsA("ProximityPrompt")
	end
	
	if prompt then
		fireproximityprompt(prompt)
		return true
	end
	
	return false
end

local function getBrainrots()
	local brainrots = {
		Legendary = {},
		Mythical = {},
		Secret = {},
        Celestial = {} 
	}
	
	local activeBrainrots = workspace:FindFirstChild("ActiveBrainrots")
	if not activeBrainrots then 
		return brainrots 
	end
	
	local legendary = activeBrainrots:FindFirstChild("Legendary")
	if legendary then
		for _, brainrot in pairs(legendary:GetChildren()) do
			if brainrot:IsA("Model") or brainrot:IsA("BasePart") then
				table.insert(brainrots.Legendary, brainrot)
			end
		end
	end
	
	local mythical = activeBrainrots:FindFirstChild("Mythical")
	if mythical then
		for _, brainrot in pairs(mythical:GetChildren()) do
			if brainrot:IsA("Model") or brainrot:IsA("BasePart") then
				table.insert(brainrots.Mythical, brainrot)
			end
		end
	end
	
	local secret = activeBrainrots:FindFirstChild("Secret")
	if secret then
		for _, brainrot in pairs(secret:GetChildren()) do
			if brainrot:IsA("Model") or brainrot:IsA("BasePart") then
				table.insert(brainrots.Secret, brainrot)
			end
		end
	end
	
    local secret = activeBrainrots:FindFirstChild("Celestial")
	if secret then
		for _, brainrot in pairs(celestial:GetChildren()) do
			if brainrot:IsA("Model") or brainrot:IsA("BasePart") then
				table.insert(brainrots.Celestial, brainrot)
			end
		end
	end
	
	return brainrots
end

local function getBrainrotPosition(brainrot)
	if not brainrot then return nil end
	
	local pos = nil
	
	if brainrot:IsA("Model") then
		local primary = brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart")
		if primary then
			pos = primary.Position
		end
	elseif brainrot:IsA("BasePart") then
		pos = brainrot.Position
	end
	
	return pos
end

-- ========================================
-- TELEPORT TAB
-- ========================================

local TeleportGroupBox = Tabs.Teleport:AddLeftGroupbox("Basic Teleport")

TeleportGroupBox:AddButton({
	Text = "Teleport to Base",
	Func = function()
		if teleportTo(basePosition) then
			Library:Notify("Teleported to base!", 2)
		end
	end,
	Tooltip = "Teleports you to the base (117, 3, -1)",
})

TeleportGroupBox:AddButton({
	Text = "Teleport to Secret Zone",
	Func = function()
		if teleportTo(secretZonePosition) then
			Library:Notify("Teleported to Secret Zone!", 2)
		end
	end,
	Tooltip = "Teleports you to the Secret Zone (2451, 3, -7)",
})

TeleportGroupBox:AddButton({
	Text = "Teleport to Celestial Zone",
	Func = function()
		if teleportTo(celestialZonePosition) then
			Library:Notify("Teleported to Celestial Zone!", 2)
		end
	end,
	Tooltip = "Teleports you to the Celestial Zone (3100, 3, -7)",
})

-- ========================================
-- BRAINROT TELEPORT
-- ========================================

local BrainrotGroupBox = Tabs.Teleport:AddRightGroupbox("Brainrot Teleport")

local brainrotList = {}
local currentRarity = "Legendary"

local function refreshBrainrotList()
	brainrotList = getBrainrots()
	
	local dropdownValues = {}
	local brainrotsInRarity = brainrotList[currentRarity] or {}
	
	if #brainrotsInRarity == 0 then
		dropdownValues = {"No " .. currentRarity .. " brainrots found"}
	else
		for i, brainrot in pairs(brainrotsInRarity) do
			table.insert(dropdownValues, brainrot.Name)
		end
	end
	
	Options.BrainrotDropdown:SetValues(dropdownValues)
	if #dropdownValues > 0 then
		Options.BrainrotDropdown:SetValue(dropdownValues[1])
	end
	
	Library:Notify("Found " .. #brainrotsInRarity .. " " .. currentRarity .. " brainrots", 2)
end

BrainrotGroupBox:AddDropdown("RarityDropdown", {
	Values = {"Legendary", "Mythical", "Secret"},
	Default = 1,
	Multi = false,
	Text = "Select Rarity",
	Tooltip = "Choose which rarity to display",
	
	Callback = function(Value)
		currentRarity = Value
		refreshBrainrotList()
	end,
})

BrainrotGroupBox:AddDropdown("BrainrotDropdown", {
	Values = {"Click 'Refresh List' to load brainrots"},
	Default = 1,
	Multi = false,
	Text = "Select Brainrot",
	Tooltip = "Choose a brainrot to teleport to",
	Searchable = true,
})

BrainrotGroupBox:AddButton({
	Text = "Refresh List",
	Func = function()
		refreshBrainrotList()
	end,
	Tooltip = "Refreshes the brainrot list",
})

BrainrotGroupBox:AddButton({
	Text = "Teleport to Brainrot",
	Func = function()
		local selectedValue = Options.BrainrotDropdown.Value
		
		if selectedValue == "Click 'Refresh List' to load brainrots" or selectedValue:find("No .+ brainrots found") then
			Library:Notify("Please refresh the list first!", 3)
			return
		end
		
		local brainrotsInRarity = brainrotList[currentRarity] or {}
		
		for _, brainrot in pairs(brainrotsInRarity) do
			if brainrot.Name == selectedValue then
				local pos = getBrainrotPosition(brainrot)
				if pos then
					if teleportTo(pos + Vector3.new(0, 5, 0)) then
						Library:Notify("Teleported to " .. selectedValue .. "!", 2)
					end
				else
					Library:Notify("Could not get position!", 3)
				end
				return
			end
		end
		
		Library:Notify("Brainrot not found!", 3)
	end,
	Tooltip = "Teleports you to the selected brainrot",
})

-- ========================================
-- AUTO FARM TAB
-- ========================================

local AutoFarmSettings = Tabs.AutoFarm:AddLeftGroupbox("Auto Farm Settings")

AutoFarmSettings:AddSlider("FarmDelay", {
	Text = "Return Delay (seconds)",
	Default = 1.5,
	Min = 1,
	Max = 3,
	Rounding = 1,
	Compact = false,
	Suffix = "s",
	
	Tooltip = "Time to wait before returning to base after grabbing brainrot",
})

AutoFarmSettings:AddDivider()

AutoFarmSettings:AddDropdown("AutoFarmRarity", {
	Values = {"Legendary", "Mythical", "Secret", "Celestial"},
	Default = 1,
	Multi = false,
	Text = "Target Rarity",
	Tooltip = "Which rarity to auto farm",
})

local AutoFarmControl = Tabs.AutoFarm:AddRightGroupbox("Auto Farm Control")

local isAutoFarming = false

AutoFarmControl:AddToggle("AutoFarm", {
	Text = "Enable Auto Farm",
	Default = false,
	Tooltip = "Automatically teleports to brainrots, grabs them, and returns to base",
	
	Callback = function(Value)
		isAutoFarming = Value
		
		if Value then
			Library:Notify("Auto Farm started!", 2)
		else
			Library:Notify("Auto Farm stopped!", 2)
		end
	end,
})

local farmStatusLabel = AutoFarmControl:AddLabel("Status: Idle")

task.spawn(function()
	while task.wait(1) do
		if isAutoFarming then
			local targetRarity = Options.AutoFarmRarity.Value
			local delay = Options.FarmDelay.Value
			
			local brainrots = getBrainrots()
			local targetBrainrots = brainrots[targetRarity] or {}
			
			if #targetBrainrots == 0 then
				farmStatusLabel:SetText("Status: No " .. targetRarity .. " brainrots found")
				task.wait(5)
			else
				for i, brainrot in pairs(targetBrainrots) do
					if not isAutoFarming then break end
					
					farmStatusLabel:SetText("Status: Farming " .. brainrot.Name .. " (" .. i .. "/" .. #targetBrainrots .. ")")
					
					local pos = getBrainrotPosition(brainrot)
					
					if pos then
						if teleportTo(pos + Vector3.new(0, 3, 0)) then
						task.wait(0.3)
						
						if grabBrainrot(brainrot) then
							task.wait(delay)
							teleportTo(basePosition)
							task.wait(0.5)
						else
							Library:Notify("Failed to grab " .. brainrot.Name, 2)
						end
					end
					end
					
					task.wait(0.5)
				end
				
				farmStatusLabel:SetText("Status: Cycle complete, waiting...")
				task.wait(3)
			end
		else
			farmStatusLabel:SetText("Status: Idle")
		end
	end
end)

local AutoFarmInfo = Tabs.AutoFarm:AddLeftGroupbox("Information")

AutoFarmInfo:AddLabel("How Auto Farm Works:", true)
AutoFarmInfo:AddLabel("1. Select target rarity", true)
AutoFarmInfo:AddLabel("2. Adjust return delay (1-3s)", true)
AutoFarmInfo:AddLabel("3. Enable 'Auto Farm'", true)
AutoFarmInfo:AddLabel("4. Script will teleport → grab → return", true)

-- ========================================
-- AUTO COLLECT
-- ========================================

local AutoCollectBox = Tabs.AutoFarm:AddRightGroupbox("Auto Collect")

local isAutoCollecting = false

-- Function to trigger touch for collect
local function collectFromSlot(collectPart)
	if not collectPart or not collectPart:FindFirstChild("TouchInterest") then
		return false
	end
	
	local char = player.Character
	if not char then return false end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	
	firetouchinterest(hrp, collectPart, 0)
	task.wait(0.1)
	firetouchinterest(hrp, collectPart, 1)
	
	return true
end

AutoCollectBox:AddToggle("AutoCollect", {
	Text = "Enable Auto Collect",
	Default = false,
	Tooltip = "Automatically collects from all your base slots",
	
	Callback = function(Value)
		isAutoCollecting = Value
		
		if Value then
			Library:Notify("Auto Collect started!", 2)
		else
			Library:Notify("Auto Collect stopped!", 2)
		end
	end,
})

local collectStatusLabel = AutoCollectBox:AddLabel("Status: Idle")

AutoCollectBox:AddDivider()

AutoCollectBox:AddLabel("This will collect from:", true)
AutoCollectBox:AddLabel("• Only YOUR bases", true)
AutoCollectBox:AddLabel("• All slots automatically", true)

task.spawn(function()
	while task.wait(0.5) do
		if isAutoCollecting then
			local bases = workspace:FindFirstChild("Bases")
			if not bases then
				collectStatusLabel:SetText("Status: Bases not found")
				task.wait(3)
			else
				collectStatusLabel:SetText("Status: Collecting all slots...")
				
				local totalCollected = 0
				local collectTasks = {}
				
				for _, base in pairs(bases:GetChildren()) do
					if not isAutoCollecting then break end
					
					-- Check ownership via Title GUI
					local isOwner = false
					local title = base:FindFirstChild("Title")
					if title then
						local titleGui = title:FindFirstChild("TitleGui")
						if titleGui then
							local frame = titleGui:FindFirstChild("Frame")
							if frame then
								local playerNameLabel = frame:FindFirstChild("PlayerName")
								if playerNameLabel and playerNameLabel.Text == player.Name then
									isOwner = true
								end
							end
						end
					end
					
					if isOwner then
						local slots = base:FindFirstChild("Slots")
						if slots then
							for _, slot in pairs(slots:GetChildren()) do
								if not isAutoCollecting then break end
								
								local collectPart = slot:FindFirstChild("Collect")
								if collectPart then
									-- Spawn parallel task untuk setiap slot
									table.insert(collectTasks, task.spawn(function()
										local success = collectFromSlot(collectPart)
										if success then
											totalCollected = totalCollected + 1
										end
									end))
								end
							end
						end
					end
				end
				
				-- Wait untuk semua tasks selesai
				task.wait(0.3)
				
				if totalCollected > 0 then
					collectStatusLabel:SetText("Status: Collected " .. totalCollected .. " slots instantly ✓")
				else
					collectStatusLabel:SetText("Status: No slots to collect")
				end
				
				task.wait(2)
			end
		else
			collectStatusLabel:SetText("Status: Idle")
		end
	end
end)

-- ========================================
-- COMBAT TAB (ANTI-WAVE WITHOUT NOCLIP)
-- ========================================

local AntiWaveBox = Tabs.Combat:AddLeftGroupbox("Anti-Wave Protection")

AntiWaveBox:AddToggle("AntiWave", {
	Text = "Enable Anti-Wave",
	Default = false,
	Tooltip = "Protects you from tsunami waves",
	
	Callback = function(Value)
		if Value then
			Library:Notify("Anti-Wave enabled!", 2)
		else
			Library:Notify("Anti-Wave disabled!", 2)
		end
	end,
})

local antiWaveActive = false

task.spawn(function()
	while task.wait(0.5) do
		if Toggles.AntiWave and Toggles.AntiWave.Value then
			if not antiWaveActive then
				antiWaveActive = true
				
				local char = player.Character
				if char then
					local humanoid = char:FindFirstChild("Humanoid")
					if humanoid then
						humanoid.MaxHealth = 9999999999
						humanoid.Health = 9999999999
						
						humanoid.HealthChanged:Connect(function(health)
							if Toggles.AntiWave and Toggles.AntiWave.Value then
								if health < 9999999999 then
									humanoid.Health = 9999999999
								end
							end
						end)
					end
				end
			end
			
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj.Name == "Hitbox" and obj:IsA("BasePart") then
					pcall(function() obj:Destroy() end)
				end
			end
		else
			antiWaveActive = false
		end
	end
end)

AntiWaveBox:AddLabel("Features when enabled:", true)
AntiWaveBox:AddLabel("• God Mode (999,999 HP)", true)
AntiWaveBox:AddLabel("• Hitbox Destroyer", true)

-- ========================================
-- UI SETTINGS
-- ========================================

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("BrainrotHub")
SaveManager:SetFolder("BrainrotHub/config")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

Library:Notify("Yi Da Mu Sake v2.1 loaded!", 3)
