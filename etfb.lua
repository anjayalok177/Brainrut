-- ========================================
-- INTRO ANIMATION WITH YOUR IMAGE
-- ========================================

local function createIntroAnimation()
    local TweenService = game:GetService("TweenService")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "IntroScreen"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Background
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    background.BorderSizePixel = 0
    background.Parent = screenGui
    
    -- Main Image Frame
    local imageFrame = Instance.new("ImageLabel")
    imageFrame.Size = UDim2.new(0, 300, 0, 300)
    imageFrame.Position = UDim2.new(0.5, -150, 1.2, 0)
    imageFrame.BackgroundTransparency = 1
    imageFrame.Image = "rbxassetid://110843044052526"
    imageFrame.ScaleType = Enum.ScaleType.Fit
    imageFrame.Parent = background
    
    -- Circle border
    local border = Instance.new("UICorner")
    border.CornerRadius = UDim.new(1, 0)
    border.Parent = imageFrame
    
    -- Title text
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 400, 0, 60)
    title.Position = UDim2.new(0.5, -200, 0.7, 0)
    title.BackgroundTransparency = 1
    title.Text = "BRAINROT HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 42
    title.Font = Enum.Font.GothamBold
    title.TextTransparency = 1
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(138, 43, 226)
    title.Parent = background
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 400, 0, 30)
    subtitle.Position = UDim2.new(0.5, -200, 0.75, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "v2.1 by sir lewis"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subtitle.TextSize = 18
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextTransparency = 1
    subtitle.Parent = background
    
    -- ANIMATION 1: Slide up from bottom
    local slideUp = TweenService:Create(
        imageFrame,
        TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -150, 0.35, -150)}
    )
    
    -- ANIMATION 2: Fade in text
    local fadeInTitle = TweenService:Create(
        title,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    )
    
    local fadeInSubtitle = TweenService:Create(
        subtitle,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0.3}
    )
    
    -- Start animations
    slideUp:Play()
    task.wait(0.4)
    fadeInTitle:Play()
    fadeInSubtitle:Play()
    
    -- Wait before shatter
    task.wait(1.5)
    
    -- SHATTER EFFECT
    local function createShatterParticles()
        local particles = {}
        local rows, cols = 5, 5
        local pieceWidth = 300 / cols
        local pieceHeight = 300 / rows
        
        for row = 0, rows - 1 do
            for col = 0, cols - 1 do
                local piece = Instance.new("ImageLabel")
                piece.Size = UDim2.new(0, pieceWidth, 0, pieceHeight)
                piece.Position = UDim2.new(
                    0.5, -150 + (col * pieceWidth),
                    0.35, -150 + (row * pieceHeight)
                )
                piece.BackgroundTransparency = 1
                piece.Image = "rbxassetid://110843044052526"
                piece.ImageRectSize = Vector2.new(300, 300)
                piece.ImageRectOffset = Vector2.new(col * pieceWidth, row * pieceHeight)
                piece.ScaleType = Enum.ScaleType.Crop
                piece.Parent = background
                
                local pieceCorner = Instance.new("UICorner")
                pieceCorner.CornerRadius = UDim.new(0.2, 0)
                pieceCorner.Parent = piece
                
                table.insert(particles, piece)
            end
        end
        
        return particles
    end
    
    imageFrame.Visible = false
    
    local pieces = createShatterParticles()
    
    for i, piece in ipairs(pieces) do
        local randomX = math.random(-600, 600)
        local randomY = math.random(-600, 600)
        local randomRotation = math.random(-360, 360)
        
        local scatter = TweenService:Create(
            piece,
            TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {
                Position = UDim2.new(piece.Position.X.Scale, piece.Position.X.Offset + randomX, 
                                   piece.Position.Y.Scale, piece.Position.Y.Offset + randomY),
                Rotation = randomRotation,
                ImageTransparency = 1
            }
        )
        
        scatter:Play()
        task.wait(0.025)
    end
    
    task.wait(0.4)
    
    local fadeOutTitle = TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1})
    local fadeOutSubtitle = TweenService:Create(subtitle, TweenInfo.new(0.5), {TextTransparency = 1})
    local fadeOutBg = TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    
    fadeOutTitle:Play()
    fadeOutSubtitle:Play()
    fadeOutBg:Play()
    
    task.wait(0.6)
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

local function holdE(duration)
	duration = duration or 2.0
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(duration)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function getBrainrots()
	local brainrots = {
		Legendary = {},
		Mythical = {},
		Secret = {}
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
		if teleportTo(secretZonePosition) then
			Library:Notify("Teleported to Celestial Zone!", 2)
		end
	end,
	Tooltip = "Teleports you to the Celestial Zone (2666, 3, -7)",
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
	Values = {"Legendary", "Mythical", "Secret"},
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
							holdE(2)
							task.wait(delay)
							teleportTo(basePosition)
							task.wait(0.5)
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
				continue
			end
			
			local totalCollected = 0
			
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
								local success = collectFromSlot(collectPart)
								if success then
									totalCollected = totalCollected + 1
									collectStatusLabel:SetText("Status: " .. base.Name .. " - " .. slot.Name)
								end
								task.wait(0.1)
							end
						end
					end
				end
			end
			
			if totalCollected > 0 then
				collectStatusLabel:SetText("Status: Collected " .. totalCollected .. " slots ✓")
			else
				collectStatusLabel:SetText("Status: No slots to collect")
			end
			
			task.wait(2)
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
