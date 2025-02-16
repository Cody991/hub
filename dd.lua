local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Theme configuration
local Theme = {
	MainBackground = Color3.fromRGB(20, 20, 25),    -- Darker background
	Accent = Color3.fromRGB(114, 137, 218),         -- Blurple
	Secondary = Color3.fromRGB(30, 30, 35),         -- Darker gray
	Highlight = Color3.fromRGB(40, 40, 45),         -- Slightly lighter gray
	TextColor = Color3.fromRGB(235, 235, 235)       -- Slightly off-white
}

-- Utility: Add rounded corners to a UI element
local function CreateRound(uiObject, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = uiObject
end

-- Utility: Tween helper
local function Tween(uiObject, properties, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(uiObject, tweenInfo, properties)
	tween:Play()
	return tween
end

-- Create a loading screen with a progress bar animation
local function CreateLoadingScreen()
	local loadingScreen = Instance.new("ScreenGui")
	loadingScreen.Name = "CheatUILoading"
	loadingScreen.ResetOnSpawn = false
	loadingScreen.IgnoreGuiInset = true
	loadingScreen.Parent = game:GetService("CoreGui")
	
	local loadingFrame = Instance.new("Frame")
	loadingFrame.Size = UDim2.new(1, 0, 1, 0)
	loadingFrame.BackgroundColor3 = Theme.MainBackground
	loadingFrame.BorderSizePixel = 0
	loadingFrame.Parent = loadingScreen
	
	-- Enhanced blur effect
	local blur = Instance.new("BlurEffect")
	blur.Size = 24
	blur.Parent = game:GetService("Lighting")
	
	local centerContainer = Instance.new("Frame")
	centerContainer.Size = UDim2.new(0.25, 0, 0.15, 0)
	centerContainer.Position = UDim2.new(0.375, 0, 0.425, 0)
	centerContainer.BackgroundColor3 = Theme.Secondary
	centerContainer.BorderSizePixel = 0
	CreateRound(centerContainer, 12)
	centerContainer.Parent = loadingFrame
	
	-- Add subtle shadow
	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1.2, 0, 1.2, 0)
	shadow.Position = UDim2.new(-0.1, 0, -0.1, 0)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://5554236805"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.6
	shadow.Parent = centerContainer
	
	local loadingLabel = Instance.new("TextLabel")
	loadingLabel.Size = UDim2.new(1, 0, 0.3, 0)
	loadingLabel.Position = UDim2.new(0, 0, 0.15, 0)
	loadingLabel.BackgroundTransparency = 1
	loadingLabel.Text = "Loading Cheats..."
	loadingLabel.Font = Enum.Font.GothamBold
	loadingLabel.TextSize = 22
	loadingLabel.TextColor3 = Theme.TextColor
	loadingLabel.Parent = centerContainer
	
	local progressBarBg = Instance.new("Frame")
	progressBarBg.Size = UDim2.new(0.85, 0, 0.1, 0)
	progressBarBg.Position = UDim2.new(0.075, 0, 0.6, 0)
	progressBarBg.BackgroundColor3 = Theme.MainBackground
	progressBarBg.BorderSizePixel = 0
	CreateRound(progressBarBg, 6)
	progressBarBg.Parent = centerContainer
	
	local progressBar = Instance.new("Frame")
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.BackgroundColor3 = Theme.Accent
	progressBar.BorderSizePixel = 0
	CreateRound(progressBar, 6)
	progressBar.Parent = progressBarBg
	
	-- Improved glow effect
	local glow = Instance.new("UIGradient")
	glow.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(Theme.Accent.R * 1.3, Theme.Accent.G * 1.3, Theme.Accent.B * 1.3)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
	})
	glow.Parent = progressBar
	
	-- Smoother animation
	for i = 0, 1, 0.008 do
		progressBar:TweenSize(UDim2.new(i, 0, 1, 0), "Out", "Sine", 0.01, true)
		glow.Offset = Vector2.new(-i, 0)
		wait(0.01)
	end
	
	wait(0.3)
	blur:Destroy()
	Tween(loadingFrame, {BackgroundTransparency = 1}, 0.4)
	Tween(shadow, {ImageTransparency = 1}, 0.4)
	Tween(centerContainer, {BackgroundTransparency = 1}, 0.4)
	Tween(loadingLabel, {TextTransparency = 1}, 0.4)
	wait(0.4)
	loadingScreen:Destroy()
end

-- Show the loading screen before the UI library loads
CreateLoadingScreen()

-- Library table definition
local Library = {}
Library.__index = Library

-- Create the main UI window. This function returns a library object.
function Library.new(title)
	local self = setmetatable({}, Library)
	self.Title = title or "Cheat UI Library"
	
	-- Main ScreenGui
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "CheatUI"
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.IgnoreGuiInset = true
	self.ScreenGui.Parent = game:GetService("CoreGui")
	
	-- Main window frame (adjusted for side tabs)
	self.MainFrame = Instance.new("Frame")
	self.MainFrame.Size = UDim2.new(0, 700, 0, 400)
	self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -200)
	self.MainFrame.BackgroundColor3 = Theme.Secondary
	self.MainFrame.BorderSizePixel = 0
	CreateRound(self.MainFrame, 12)
	self.MainFrame.Parent = self.ScreenGui
	
	-- Title bar with gradient
	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
	self.TitleBar.BackgroundColor3 = Theme.Accent
	self.TitleBar.BorderSizePixel = 0
	CreateRound(self.TitleBar, 12)
	self.TitleBar.Parent = self.MainFrame
	
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.Accent),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(Theme.Accent.R * 0.7, Theme.Accent.G * 0.7, Theme.Accent.B * 0.7))
	})
	gradient.Parent = self.TitleBar
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -50, 1, 0)
	titleLabel.Position = UDim2.new(0, 25, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 24
	titleLabel.TextColor3 = Theme.TextColor
	titleLabel.Parent = self.TitleBar
	
	-- Close button (clicking it hides the UI; can be toggled with RightShift)
	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 40, 0, 40)
	closeButton.Position = UDim2.new(1, -40, 0, 0)
	closeButton.BackgroundTransparency = 1
	closeButton.Text = "X"
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 24
	closeButton.TextColor3 = Theme.TextColor
	closeButton.Parent = self.TitleBar
	closeButton.MouseButton1Click:Connect(function()
		self.MainFrame.Visible = false
	end)
	
	-- Tab buttons container (moved to side)
	self.TabButtons = Instance.new("Frame")
	self.TabButtons.Size = UDim2.new(0, 150, 1, -40)
	self.TabButtons.Position = UDim2.new(0, 0, 0, 40)
	self.TabButtons.BackgroundColor3 = Theme.Secondary
	self.TabButtons.BorderSizePixel = 0
	self.TabButtons.Parent = self.MainFrame
	
	-- Container for tab pages (adjusted for side tabs)
	self.TabContainer = Instance.new("Frame")
	self.TabContainer.Size = UDim2.new(1, -150, 1, -40)
	self.TabContainer.Position = UDim2.new(0, 150, 0, 40)
	self.TabContainer.BackgroundTransparency = 1
	self.TabContainer.Parent = self.MainFrame
	
	self.Tabs = {} -- Holds all created tabs
	
	-- Enable dragging of the main window via the title bar
	local dragging, dragInput, dragStart, startPos

	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.MainFrame.Position
		end
	end)

	self.TitleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			dragInput = nil
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	-- Global hotkey: Toggle UI visibility (RightShift)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			self.MainFrame.Visible = not self.MainFrame.Visible
		end
	end)
	
	-- Always create a Settings tab that includes info about the toggle hotkey.
	local settingsTab = self:CreateTab("Settings")
	settingsTab:AddText("Toggle UI Visibility: RightShift")
	
	return self
end

-- Method to create a new tab. Each tab gets its own scrolling content frame and tab button.
function Library:CreateTab(name)
	local tab = {}
	tab.Name = name or "Tab"
	tab.Elements = {}

	-- Create the content container for this tab
	tab.Container = Instance.new("ScrollingFrame")
	tab.Container.Size = UDim2.new(1, -10, 1, -10)
	tab.Container.Position = UDim2.new(0, 5, 0, 5)
	tab.Container.BackgroundTransparency = 1
	tab.Container.ScrollBarThickness = 4
	tab.Container.Parent = self.TabContainer
	tab.Container.Visible = false

	-- Modified tab button styling
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 35)
	button.Position = UDim2.new(0, 10, 0, (#self.Tabs * 40))
	button.BackgroundColor3 = Theme.Secondary
	button.BorderSizePixel = 0
	button.Text = name
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 14
	button.TextColor3 = Theme.TextColor
	button.Parent = self.TabButtons
	CreateRound(button, 8)

	-- Add hover effect
	button.MouseEnter:Connect(function()
		if button.BackgroundColor3 ~= Theme.Accent then
			Tween(button, {BackgroundColor3 = Color3.fromRGB(
				Theme.Secondary.R * 1.2,
				Theme.Secondary.G * 1.2,
				Theme.Secondary.B * 1.2
			)}, 0.2)
		end
	end)

	button.MouseLeave:Connect(function()
		if button.BackgroundColor3 ~= Theme.Accent then
			Tween(button, {BackgroundColor3 = Theme.Secondary}, 0.2)
		end
	end)

	button.MouseButton1Click:Connect(function()
		-- Hide all tab containers and reset button colors
		for _, t in pairs(self.Tabs) do
			t.Container.Visible = false
			t.Button.BackgroundColor3 = Theme.Secondary
		end
		tab.Container.Visible = true
		button.BackgroundColor3 = Theme.Accent
	end)

	tab.Button = button

	table.insert(self.Tabs, tab)
	-- If this is the first tab created, then show it by default.
	if #self.Tabs == 1 then
		tab.Container.Visible = true
		button.BackgroundColor3 = Theme.Accent
	end

	-- Function: Add a button element to this tab.
	function tab:AddButton(text, callback)
		local btnContainer = Instance.new("Frame")
		btnContainer.Size = UDim2.new(1, -20, 0, 40)
		btnContainer.Position = UDim2.new(0, 10, 0, #self.Elements * 45)
		btnContainer.BackgroundColor3 = Theme.Secondary
		btnContainer.BorderSizePixel = 0
		CreateRound(btnContainer, 8)
		btnContainer.Parent = tab.Container
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundTransparency = 1
		btn.Text = text
		btn.Font = Enum.Font.GothamSemibold
		btn.TextSize = 14
		btn.TextColor3 = Theme.TextColor
		btn.Parent = btnContainer
		
		-- Add modern gradient
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
		})
		gradient.Rotation = 45
		gradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.95),
			NumberSequenceKeypoint.new(1, 0.97)
		})
		gradient.Parent = btnContainer
		
		-- Add subtle glow effect
		local glow = Instance.new("ImageLabel")
		glow.Size = UDim2.new(1, 20, 1, 20)
		glow.Position = UDim2.new(0, -10, 0, -10)
		glow.BackgroundTransparency = 1
		glow.Image = "rbxassetid://5554236805"
		glow.ImageColor3 = Theme.Accent
		glow.ImageTransparency = 0.9
		glow.Parent = btnContainer
		
		-- Enhanced hover and click effects
		btnContainer.MouseEnter:Connect(function()
			Tween(btnContainer, {BackgroundColor3 = Theme.Highlight}, 0.2)
			Tween(glow, {ImageTransparency = 0.8}, 0.2)
		end)
		
		btnContainer.MouseLeave:Connect(function()
			Tween(btnContainer, {BackgroundColor3 = Theme.Secondary}, 0.2)
			Tween(glow, {ImageTransparency = 0.9}, 0.2)
		end)
		
		btn.MouseButton1Down:Connect(function()
			Tween(btnContainer, {Size = UDim2.new(1, -24, 0, 38)}, 0.08)
			Tween(btnContainer, {Position = UDim2.new(0, 12, 0, #self.Elements * 45 + 1)}, 0.08)
			Tween(glow, {ImageTransparency = 0.7}, 0.08)
		end)
		
		btn.MouseButton1Up:Connect(function()
			Tween(btnContainer, {Size = UDim2.new(1, -20, 0, 40)}, 0.08)
			Tween(btnContainer, {Position = UDim2.new(0, 10, 0, #self.Elements * 45)}, 0.08)
			Tween(glow, {ImageTransparency = 0.8}, 0.08)
		end)
		
		btn.MouseButton1Click:Connect(function()
			pcall(callback)
		end)
		
		table.insert(self.Elements, btnContainer)
	end

	-- Function: Add a toggle element.
	function tab:AddToggle(text, default, callback)
		local toggleFrame = Instance.new("Frame")
		toggleFrame.Size = UDim2.new(1, -20, 0, 40)
		toggleFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 45)
		toggleFrame.BackgroundColor3 = Theme.Secondary
		toggleFrame.BorderSizePixel = 0
		CreateRound(toggleFrame, 8)
		toggleFrame.Parent = tab.Container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.7, 0, 1, 0)
		label.Position = UDim2.new(0.05, 0, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 16
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = Theme.TextColor
		label.Parent = toggleFrame

		local toggleContainer = Instance.new("Frame")
		toggleContainer.Size = UDim2.new(0, 44, 0, 24)
		toggleContainer.Position = UDim2.new(0.85, -22, 0.5, -12)
		toggleContainer.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(80, 80, 80)
		toggleContainer.BorderSizePixel = 0
		CreateRound(toggleContainer, 12)
		toggleContainer.Parent = toggleFrame

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 18, 0, 18)
		knob.Position = UDim2.new(default and 0.6 or 0.1, 0, 0.5, -9)
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		CreateRound(knob, 9)
		knob.Parent = toggleContainer

		local toggled = default

		toggleFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				toggled = not toggled
				Tween(toggleContainer, {BackgroundColor3 = toggled and Theme.Accent or Color3.fromRGB(80, 80, 80)}, 0.2)
				Tween(knob, {Position = toggled and UDim2.new(0.6, 0, 0.5, -9) or UDim2.new(0.1, 0, 0.5, -9)}, 0.2)
				pcall(callback, toggled)
			end
		end)

		-- Add hover effect
		toggleFrame.MouseEnter:Connect(function()
			Tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(
				Theme.Secondary.R * 1.2,
				Theme.Secondary.G * 1.2,
				Theme.Secondary.B * 1.2
			)}, 0.2)
		end)

		toggleFrame.MouseLeave:Connect(function()
			Tween(toggleFrame, {BackgroundColor3 = Theme.Secondary}, 0.2)
		end)

		table.insert(self.Elements, toggleFrame)
	end

	-- Function: Add a slider element.
	function tab:AddSlider(text, min, max, default, callback)
		local sliderFrame = Instance.new("Frame")
		sliderFrame.Size = UDim2.new(1, -20, 0, 50)
		sliderFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 55)
		sliderFrame.BackgroundTransparency = 1
		sliderFrame.Parent = tab.Container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -20, 0, 20)
		label.Position = UDim2.new(0, 0, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text .. " : " .. default
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 18
		label.TextColor3 = Theme.TextColor
		label.Parent = sliderFrame

		local sliderBar = Instance.new("Frame")
		sliderBar.Size = UDim2.new(1, 0, 0, 6)
		sliderBar.Position = UDim2.new(0, 0, 0, 30)
		sliderBar.BackgroundColor3 = Theme.Secondary
		sliderBar.BorderSizePixel = 0
		CreateRound(sliderBar, 3)
		sliderBar.Parent = sliderFrame

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		fill.BackgroundColor3 = Theme.Accent
		fill.BorderSizePixel = 0
		CreateRound(fill, 3)
		fill.Parent = sliderBar

		local dragging = false

		sliderBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
			end
		end)

		sliderBar.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		sliderBar.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local pos = input.Position.X - sliderBar.AbsolutePosition.X
				local size = math.clamp(pos / sliderBar.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(size, 0, 1, 0)
				local value = math.floor(min + (max - min) * size)
				label.Text = text .. " : " .. value
				pcall(callback, value)
			end
		end)
		table.insert(self.Elements, sliderFrame)
	end

	-- Function: Add a dropdown element.
	function tab:AddDropdown(text, options, callback)
		local dropdownFrame = Instance.new("Frame")
		dropdownFrame.Size = UDim2.new(1, -20, 0, 40)
		dropdownFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 45)
		dropdownFrame.BackgroundTransparency = 1
		dropdownFrame.Parent = tab.Container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.7, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 18
		label.TextColor3 = Theme.TextColor
		label.Parent = dropdownFrame

		local dropdownButton = Instance.new("TextButton")
		dropdownButton.Size = UDim2.new(0, 100, 0, 30)
		dropdownButton.Position = UDim2.new(0.75, 0, 0.2, 0)
		dropdownButton.BackgroundColor3 = Theme.Secondary
		dropdownButton.Text = options[1] or ""
		dropdownButton.Font = Enum.Font.GothamMedium
		dropdownButton.TextSize = 18
		dropdownButton.TextColor3 = Theme.TextColor
		dropdownButton.BorderSizePixel = 0
		CreateRound(dropdownButton, 8)
		dropdownButton.Parent = dropdownFrame

		local isOpen = false
		local dropdownList = Instance.new("Frame")
		dropdownList.Size = UDim2.new(0, 100, 0, #options * 30)
		dropdownList.Position = UDim2.new(0.75, 0, 0.2, 30)
		dropdownList.BackgroundColor3 = Theme.Secondary
		dropdownList.BorderSizePixel = 0
		CreateRound(dropdownList, 8)
		dropdownList.Visible = false
		dropdownList.Parent = dropdownFrame

		for i, option in ipairs(options) do
			local optionButton = Instance.new("TextButton")
			optionButton.Size = UDim2.new(1, 0, 0, 30)
			optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
			optionButton.BackgroundColor3 = Theme.Secondary
			optionButton.Text = option
			optionButton.Font = Enum.Font.GothamMedium
			optionButton.TextSize = 18
			optionButton.TextColor3 = Theme.TextColor
			optionButton.BorderSizePixel = 0
			CreateRound(optionButton, 8)
			optionButton.Parent = dropdownList

			optionButton.MouseButton1Click:Connect(function()
				dropdownButton.Text = option
				dropdownList.Visible = false
				isOpen = false
				pcall(callback, option)
			end)
		end

		dropdownButton.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			dropdownList.Visible = isOpen
		end)
		table.insert(self.Elements, dropdownFrame)
	end

	-- Function: Add a simple text element.
	function tab:AddText(text)
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, -20, 0, 30)
		textLabel.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextSize = 18
		textLabel.TextColor3 = Theme.TextColor
		textLabel.Parent = tab.Container
		table.insert(self.Elements, textLabel)
	end

	return tab
end

-- Function: Show a notification on the screen.
function Library:Notify(message, duration)
	duration = duration or 3
	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(0, 300, 0, 50)
	notification.Position = UDim2.new(1, -310, 0.8, 0)
	notification.BackgroundColor3 = Theme.Secondary
	notification.BorderSizePixel = 0
	CreateRound(notification, 8)
	notification.Parent = self.ScreenGui
	
	local msgLabel = Instance.new("TextLabel")
	msgLabel.Size = UDim2.new(1, -10, 1, 0)
	msgLabel.Position = UDim2.new(0, 5, 0, 0)
	msgLabel.BackgroundTransparency = 1
	msgLabel.Text = message
	msgLabel.Font = Enum.Font.Gotham
	msgLabel.TextSize = 18
	msgLabel.TextColor3 = Theme.TextColor
	msgLabel.Parent = notification
	
	-- Slide in animation from the right
	notification.Position = UDim2.new(1, 310, 0.8, 0)
	Tween(notification, {Position = UDim2.new(1, -310, 0.8, 0)}, 0.5)
	delay(duration, function()
		Tween(notification, {Position = UDim2.new(1, 310, 0.8, 0)}, 0.5)
		wait(0.5)
		notification:Destroy()
	end)
end

return Library
