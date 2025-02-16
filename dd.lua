local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Theme configuration
local Theme = {
	MainBackground = Color3.fromRGB(15, 15, 20),    -- Darker background
	Accent = Color3.fromRGB(114, 137, 218),         -- Blurple
	Secondary = Color3.fromRGB(25, 25, 30),         -- Darker gray
	Highlight = Color3.fromRGB(35, 35, 40),         -- Slightly lighter gray
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
	-- Check if UI already exists
	if game:GetService("CoreGui"):FindFirstChild("CheatUILoading") then
		return
	end
	
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
	-- Check if UI already exists
	if game:GetService("CoreGui"):FindFirstChild("CheatUI") then
		return
	end

	local self = setmetatable({}, Library)
	self.Title = title or "Cheat UI Library"
	
	-- Store original position for proper UI toggling
	self.OriginalPosition = UDim2.new(0.5, -350, 0.5, -200)
	
	-- Main ScreenGui
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "CheatUI"
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.IgnoreGuiInset = true
	self.ScreenGui.Parent = game:GetService("CoreGui")
	
	-- Main window frame
	self.MainFrame = Instance.new("Frame")
	self.MainFrame.Size = UDim2.new(0, 700, 0, 400)
	self.MainFrame.Position = self.OriginalPosition
	self.MainFrame.BackgroundColor3 = Theme.MainBackground
	self.MainFrame.BorderSizePixel = 0
	CreateRound(self.MainFrame, 12)
	self.MainFrame.Parent = self.ScreenGui
	
	-- Add shadow
	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.Position = UDim2.new(0, -15, 0, -15)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://5554236805"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.7
	shadow.Parent = self.MainFrame
	
	-- Title bar with gradient
	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
	self.TitleBar.BackgroundColor3 = Theme.Secondary
	self.TitleBar.BorderSizePixel = 0
	CreateRound(self.TitleBar, 12)
	self.TitleBar.Parent = self.MainFrame
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -150, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextColor3 = Theme.TextColor
	titleLabel.Parent = self.TitleBar

	-- Minimize button
	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
	minimizeBtn.Position = UDim2.new(1, -80, 0, 0)
	minimizeBtn.BackgroundTransparency = 1
	minimizeBtn.Text = "-"
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.TextSize = 20
	minimizeBtn.TextColor3 = Theme.TextColor
	minimizeBtn.Parent = self.TitleBar

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 40, 0, 40)
	closeBtn.Position = UDim2.new(1, -40, 0, 0)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "×"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 20
	closeBtn.TextColor3 = Theme.TextColor
	closeBtn.Parent = self.TitleBar

	self.Minimized = false
	self.OriginalSize = self.MainFrame.Size

	-- Content container for everything below title bar
	self.ContentContainer = Instance.new("Frame")
	self.ContentContainer.Size = UDim2.new(1, 0, 1, -40)
	self.ContentContainer.Position = UDim2.new(0, 0, 0, 40)
	self.ContentContainer.BackgroundTransparency = 1
	self.ContentContainer.ClipsDescendants = true
	self.ContentContainer.Parent = self.MainFrame

	-- Move TabButtons and TabContainer to be children of ContentContainer
	self.TabButtons = Instance.new("Frame")
	self.TabButtons.Size = UDim2.new(0, 150, 1, 0)
	self.TabButtons.Position = UDim2.new(0, 0, 0, 0)
	self.TabButtons.BackgroundColor3 = Theme.Secondary
	self.TabButtons.BorderSizePixel = 0
	self.TabButtons.Parent = self.ContentContainer

	self.TabContainer = Instance.new("Frame")
	self.TabContainer.Size = UDim2.new(1, -150, 1, 0)
	self.TabContainer.Position = UDim2.new(0, 150, 0, 0)
	self.TabContainer.BackgroundTransparency = 1
	self.TabContainer.Parent = self.ContentContainer

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
	
	-- Global hotkey: Toggle UI visibility (Left Alt)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.LeftAlt then
			if not self.MainFrame.Visible then
				-- Opening animation
				self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
				self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
				self.MainFrame.Visible = true
				Tween(self.MainFrame, {Size = self.OriginalSize}, 0.3)
				Tween(self.MainFrame, {Position = self.OriginalPosition}, 0.3)
				Tween(shadow, {ImageTransparency = 0.7}, 0.3)
			else
				-- Closing animation
				Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
				Tween(self.MainFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
				Tween(shadow, {ImageTransparency = 1}, 0.3)
				wait(0.3)
				self.MainFrame.Visible = false
			end
		end
	end)
	
	-- Always create a Settings tab that includes info about the toggle hotkey.
	local settingsTab = self:CreateTab("Settings")
	settingsTab:AddText("Toggle UI Visibility: LeftAlt")
	
	minimizeBtn.MouseButton1Click:Connect(function()
		self.Minimized = not self.Minimized
		if self.Minimized then
			-- Hide content first
			Tween(self.ContentContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
			wait(0.1)
			-- Then minimize the frame
			Tween(self.MainFrame, {Size = UDim2.new(0, 700, 0, 40)}, 0.2)
		else
			-- Restore frame size first
			Tween(self.MainFrame, {Size = self.OriginalSize}, 0.2)
			wait(0.1)
			-- Then show content
			Tween(self.ContentContainer, {Size = UDim2.new(1, 0, 1, -40)}, 0.3)
		end
	end)

	closeBtn.MouseButton1Click:Connect(function()
		-- Simple fade out and hide
		Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
		Tween(self.MainFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
		Tween(shadow, {ImageTransparency = 1}, 0.3)
		wait(0.3)
		self.MainFrame.Visible = false
		
		-- Show notification
		self:Notify("UI Hidden - Press Left Alt to show again", 3)
	end)
	
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

	-- Function: Add a button element
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
		
		-- Add hover effect
		btnContainer.MouseEnter:Connect(function()
			Tween(btnContainer, {BackgroundColor3 = Theme.Highlight}, 0.2)
		end)
		
		btnContainer.MouseLeave:Connect(function()
			Tween(btnContainer, {BackgroundColor3 = Theme.Secondary}, 0.2)
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
		dropdownFrame.BackgroundColor3 = Theme.Secondary
		dropdownFrame.BorderSizePixel = 0
		CreateRound(dropdownFrame, 8)
		dropdownFrame.Parent = tab.Container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.5, 0, 1, 0)
		label.Position = UDim2.new(0.05, 0, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = Theme.TextColor
		label.Parent = dropdownFrame

		local dropdownButton = Instance.new("TextButton")
		dropdownButton.Size = UDim2.new(0.35, 0, 0, 30)
		dropdownButton.Position = UDim2.new(0.6, 0, 0.5, -15)
		dropdownButton.BackgroundColor3 = Theme.MainBackground
		dropdownButton.Text = options[1] or ""
		dropdownButton.Font = Enum.Font.GothamMedium
		dropdownButton.TextSize = 14
		dropdownButton.TextColor3 = Theme.TextColor
		dropdownButton.BorderSizePixel = 0
		CreateRound(dropdownButton, 6)
		dropdownButton.Parent = dropdownFrame

		-- Add arrow indicator
		local arrow = Instance.new("TextLabel")
		arrow.Size = UDim2.new(0, 20, 0, 20)
		arrow.Position = UDim2.new(1, -25, 0.5, -10)
		arrow.BackgroundTransparency = 1
		arrow.Text = "▼"
		arrow.TextColor3 = Theme.TextColor
		arrow.Font = Enum.Font.GothamBold
		arrow.TextSize = 12
		arrow.Parent = dropdownButton

		local isOpen = false
		local dropdownList = Instance.new("Frame")
		dropdownList.Size = UDim2.new(1, 0, 0, #options * 30)
		dropdownList.Position = UDim2.new(0, 0, 1, 5)
		dropdownList.BackgroundColor3 = Theme.MainBackground
		dropdownList.BorderSizePixel = 0
		dropdownList.ZIndex = 10
		CreateRound(dropdownList, 6)
		dropdownList.Visible = false
		dropdownList.Parent = dropdownButton

		-- Add container for options with padding
		local optionsContainer = Instance.new("Frame")
		optionsContainer.Size = UDim2.new(1, -10, 1, -10)
		optionsContainer.Position = UDim2.new(0, 5, 0, 5)
		optionsContainer.BackgroundTransparency = 1
		optionsContainer.ZIndex = 10
		optionsContainer.Parent = dropdownList

		for i, option in ipairs(options) do
			local optionButton = Instance.new("TextButton")
			optionButton.Size = UDim2.new(1, 0, 0, 25)
			optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 27)
			optionButton.BackgroundColor3 = Theme.Secondary
			optionButton.Text = option
			optionButton.Font = Enum.Font.GothamMedium
			optionButton.TextSize = 14
			optionButton.TextColor3 = Theme.TextColor
			optionButton.BorderSizePixel = 0
			optionButton.ZIndex = 10
			CreateRound(optionButton, 6)
			optionButton.Parent = optionsContainer

			-- Add hover effect
			optionButton.MouseEnter:Connect(function()
				Tween(optionButton, {BackgroundColor3 = Theme.Highlight}, 0.2)
			end)

			optionButton.MouseLeave:Connect(function()
				Tween(optionButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
			end)

			optionButton.MouseButton1Click:Connect(function()
				dropdownButton.Text = option
				isOpen = false
				dropdownList.Visible = false
				arrow.Rotation = 0
				pcall(callback, option)
			end)
		end

		-- Add hover effect to main button
		dropdownButton.MouseEnter:Connect(function()
			Tween(dropdownButton, {BackgroundColor3 = Theme.Highlight}, 0.2)
		end)

		dropdownButton.MouseLeave:Connect(function()
			Tween(dropdownButton, {BackgroundColor3 = Theme.MainBackground}, 0.2)
		end)

		dropdownButton.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			dropdownList.Visible = isOpen
			Tween(arrow, {Rotation = isOpen and 180 or 0}, 0.2)
		end)

		table.insert(self.Elements, dropdownFrame)
	end

	-- Function: Add a simple text element.
	function tab:AddText(text)
		local textFrame = Instance.new("Frame")
		textFrame.Size = UDim2.new(1, -20, 0, 30)
		textFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
		textFrame.BackgroundColor3 = Theme.Secondary
		textFrame.BorderSizePixel = 0
		CreateRound(textFrame, 8)
		textFrame.Parent = tab.Container

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(0.95, 0, 1, 0)
		textLabel.Position = UDim2.new(0.025, 0, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text
		textLabel.Font = Enum.Font.GothamMedium
		textLabel.TextSize = 14
		textLabel.TextColor3 = Theme.TextColor
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Parent = textFrame

		table.insert(self.Elements, textFrame)
	end

	-- Function: Add a color picker element
	function tab:AddColorPicker(text, default, callback)
		local colorPickerFrame = Instance.new("Frame")
		colorPickerFrame.Size = UDim2.new(1, -20, 0, 40)
		colorPickerFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 45)
		colorPickerFrame.BackgroundColor3 = Theme.Secondary
		colorPickerFrame.BorderSizePixel = 0
		CreateRound(colorPickerFrame, 8)
		colorPickerFrame.Parent = tab.Container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.7, 0, 1, 0)
		label.Position = UDim2.new(0.05, 0, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = Theme.TextColor
		label.Parent = colorPickerFrame

		local colorDisplay = Instance.new("TextButton")
		colorDisplay.Size = UDim2.new(0, 30, 0, 30)
		colorDisplay.Position = UDim2.new(0.85, -15, 0.5, -15)
		colorDisplay.BackgroundColor3 = default or Color3.new(1, 1, 1)
		colorDisplay.BorderSizePixel = 0
		colorDisplay.Text = "" -- Removed "button" text
		CreateRound(colorDisplay, 6)
		colorDisplay.Parent = colorPickerFrame

		-- Color picker window
		local pickerGui = Instance.new("Frame")
		pickerGui.Size = UDim2.new(0, 200, 0, 220)
		pickerGui.Position = UDim2.new(1, 10, 0, 0)
		pickerGui.BackgroundColor3 = Theme.Secondary
		pickerGui.BorderSizePixel = 0
		pickerGui.Visible = false
		pickerGui.ZIndex = 100
		CreateRound(pickerGui, 8)
		pickerGui.Parent = self.ScreenGui -- Changed parent to ScreenGui to prevent overlap

		-- Add a connection to update picker position when the frame moves
		local function updatePickerPosition()
			local framePos = colorDisplay.AbsolutePosition
			pickerGui.Position = UDim2.new(0, framePos.X + colorDisplay.AbsoluteSize.X + 10, 0, framePos.Y)
		end

		-- Handle color gradient input
		colorGradient.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local dragConnection
				dragConnection = UserInputService.InputChanged:Connect(function(dragInput)
					if dragInput.UserInputType == Enum.UserInputType.MouseMovement then
						local relativeX = math.clamp((dragInput.Position.X - colorGradient.AbsolutePosition.X) / colorGradient.AbsoluteSize.X, 0, 1)
						local relativeY = math.clamp((dragInput.Position.Y - colorGradient.AbsolutePosition.Y) / colorGradient.AbsoluteSize.Y, 0, 1)
						saturation = relativeX
						value = 1 - relativeY
						updateColor()
					end
				end)

				UserInputService.InputEnded:Connect(function(endInput)
					if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
						dragConnection:Disconnect()
					end
				end)
			end
		end)

		-- Handle hue slider input
		hueSlider.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local dragConnection
				dragConnection = UserInputService.InputChanged:Connect(function(dragInput)
					if dragInput.UserInputType == Enum.UserInputType.MouseMovement then
						hue = math.clamp((dragInput.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
						updateColor()
					end
				end)

				UserInputService.InputEnded:Connect(function(endInput)
					if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
						dragConnection:Disconnect()
					end
				end)
			end
		end)

		-- Toggle color picker visibility
		colorDisplay.MouseButton1Click:Connect(function()
			pickerGui.Visible = not pickerGui.Visible
			if pickerGui.Visible then
				updatePickerPosition()
			end
		end)

		-- Update picker position when window is dragged
		self.MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
			if pickerGui.Visible then
				updatePickerPosition()
			end
		end)

		-- Close picker when clicking outside
		UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local mousePos = UserInputService:GetMouseLocation()
				local inFrame = mousePos.X >= pickerGui.AbsolutePosition.X and
							   mousePos.X <= pickerGui.AbsolutePosition.X + pickerGui.AbsoluteSize.X and
							   mousePos.Y >= pickerGui.AbsolutePosition.Y and
							   mousePos.Y <= pickerGui.AbsolutePosition.Y + pickerGui.AbsoluteSize.Y

				if not inFrame and pickerGui.Visible then
					pickerGui.Visible = false
				end
			end
		end)

		table.insert(self.Elements, colorPickerFrame)
		return colorDisplay
	end

	return tab
end

-- Function: Show a notification on the screen.
function Library:Notify(message, duration)
	duration = duration or 3
	
	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(0, 300, 0, 50)
	notification.Position = UDim2.new(1, 20, 0.8, 0)  -- Start off screen
	notification.BackgroundColor3 = Theme.Secondary
	notification.BorderSizePixel = 0
	CreateRound(notification, 8)
	notification.Parent = self.ScreenGui
	
	-- Add shadow to notification
	local notifShadow = Instance.new("ImageLabel")
	notifShadow.Size = UDim2.new(1, 30, 1, 30)
	notifShadow.Position = UDim2.new(0, -15, 0, -15)
	notifShadow.BackgroundTransparency = 1
	notifShadow.Image = "rbxassetid://5554236805"
	notifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	notifShadow.ImageTransparency = 0.7
	notifShadow.Parent = notification
	
	local msgLabel = Instance.new("TextLabel")
	msgLabel.Size = UDim2.new(1, -20, 1, 0)
	msgLabel.Position = UDim2.new(0, 10, 0, 0)
	msgLabel.BackgroundTransparency = 1
	msgLabel.Text = message
	msgLabel.Font = Enum.Font.GothamSemibold
	msgLabel.TextSize = 14
	msgLabel.TextColor3 = Theme.TextColor
	msgLabel.TextWrapped = true
	msgLabel.Parent = notification
	
	-- Slide in animation
	Tween(notification, {Position = UDim2.new(1, -320, 0.8, 0)}, 0.3)
	
	-- Wait and slide out
	delay(duration, function()
		Tween(notification, {Position = UDim2.new(1, 20, 0.8, 0)}, 0.3)
		wait(0.3)
		notification:Destroy()
	end)
end

return Library
