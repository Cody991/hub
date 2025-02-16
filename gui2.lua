local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create base GUI elements with extended controls (buttons, sliders, text inputs, toggles, etc.)
function Library.new(title)
    -- Add Loading Screen
    local LoadingGui = Instance.new("ScreenGui")
    local LoadingFrame = Instance.new("Frame")
    local LoadingBar = Instance.new("Frame")
    local LoadingText = Instance.new("TextLabel")
    local Logo = Instance.new("ImageLabel")
    
    LoadingGui.Name = "LoadingGui"
    LoadingGui.Parent = game:GetService("CoreGui")
    
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = LoadingGui
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -85)
    LoadingFrame.Size = UDim2.new(0, 300, 0, 170)
    LoadingFrame.BorderSizePixel = 0
    
    Logo.Name = "Logo"
    Logo.Parent = LoadingFrame
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0.5, -40, 0.2, 0)
    Logo.Size = UDim2.new(0, 80, 0, 80)
    Logo.Image = "rbxassetid://14357329745" -- Replace with your logo
    
    LoadingText.Name = "LoadingText"
    LoadingText.Parent = LoadingFrame
    LoadingText.BackgroundTransparency = 1
    LoadingText.Position = UDim2.new(0, 0, 0.7, 0)
    LoadingText.Size = UDim2.new(1, 0, 0, 20)
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = "Loading..."
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 14
    
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Parent = LoadingFrame
    LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Position = UDim2.new(0.1, 0, 0.85, 0)
    LoadingBar.Size = UDim2.new(0, 0, 0, 4)
    
    -- Animate loading bar
    local tween = TweenService:Create(LoadingBar, 
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.8, 0, 0, 4)}
    )
    tween:Play()
    
    -- Main GUI (shown after loading)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("ImageButton")
    local MinimizeButton = Instance.new("ImageButton")
    local TabHolder = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame")
    local ContentContainer = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Shadow = Instance.new("ImageLabel")
    
    -- Configure modern styling
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    MainFrame.ClipsDescendants = true
    
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    
    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 8)
    
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    
    local TopBarCorner = UICorner:Clone()
    TopBarCorner.Parent = TopBar
    
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    -- Add close and minimize buttons
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -25, 0, 8)
    CloseButton.Image = "rbxassetid://7743878857"
    CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundTransparency = 1
    
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Position = UDim2.new(1, -50, 0, 8)
    MinimizeButton.Image = "rbxassetid://7743878552"
    MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.BackgroundTransparency = 1
    
    -- Modern tab styling
    TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    local TabHolderCorner = UICorner:Clone()
    TabHolderCorner.Parent = TabHolder
    
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 45)
    TabContainer.ScrollBarThickness = 4
    
    -- Add animations and effects
    local function CreateRipple(parent)
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.8
        ripple.BorderSizePixel = 0
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        
        return ripple
    end
    
    -- Show main GUI after loading
    wait(1.5)
    LoadingGui:Destroy()
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Add minimize/close functionality
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(1, 0, 0, 35) or UDim2.new(1, 0, 1, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Enhance button creation
    local function EnhanceButton(button)
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = Color3.fromRGB(60, 60, 65)
        buttonStroke.Thickness = 1
        buttonStroke.Parent = button
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), 
                {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), 
                {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
        end)
        
        button.MouseButton1Down:Connect(function()
            local ripple = CreateRipple(button)
            local size = UDim2.new(1, 30, 1, 30)
            local transparency = 1
            
            TweenService:Create(ripple, TweenInfo.new(0.5), 
                {Size = size, BackgroundTransparency = transparency}):Play()
            wait(0.5)
            ripple:Destroy()
        end)
    end
    
    local Window = {}
    
    function Window:CreateTab(name)
        local Tab = Instance.new("TextButton")
        local TabContent = Instance.new("ScrollingFrame")
        
        -- Configure Tab Button
        Tab.Name = name
        Tab.Parent = TabContainer
        Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(1, -10, 0, 30)
        Tab.Font = Enum.Font.SourceSans
        Tab.Text = name
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 14
        Tab.AutoButtonColor = false
        
        -- Configure Tab Content
        TabContent.Name = name .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        
        local TabMethods = {}
        
        -- Utility: update the vertical canvas size based on children count.
        function TabMethods:UpdateCanvas()
            local count = #TabContent:GetChildren()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, count * 35 + 5)
        end
        
        function TabMethods:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Parent = TabContent
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, -20, 0, 30)
            Button.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 35)
            Button.Font = Enum.Font.SourceSans
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.MouseButton1Click:Connect(callback)
            TabMethods:UpdateCanvas()
            return Button
        end
        
        function TabMethods:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text .. "Slider"
            SliderFrame.Parent = TabContent
            SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, -20, 0, 30)
            SliderFrame.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 35)
            
            local Label = Instance.new("TextLabel")
            Label.Name = "SliderLabel"
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 5, 0, 0)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "ValueLabel"
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0.4, 5, 0, 0)
            ValueLabel.Size = UDim2.new(0.2, 0, 1, 0)
            ValueLabel.Font = Enum.Font.SourceSans
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 14
            ValueLabel.Text = tostring(default)
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "SliderBar"
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0.65, 0, 0.3, 0)
            SliderBar.Size = UDim2.new(0.3, 0, 0.4, 0)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            local draggingSlider = false
            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                local value = math.floor(min + (max - min) * relativeX + 0.5)
                ValueLabel.Text = tostring(value)
                if callback then
                    callback(value)
                end
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    updateSlider(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            TabMethods:UpdateCanvas()
            return SliderFrame
        end
        
        function TabMethods:AddTextInput(text, default, callback)
            local TextInputFrame = Instance.new("Frame")
            TextInputFrame.Name = text .. "TextInput"
            TextInputFrame.Parent = TabContent
            TextInputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TextInputFrame.BorderSizePixel = 0
            TextInputFrame.Size = UDim2.new(1, -20, 0, 30)
            TextInputFrame.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 35)
            
            local Label = Instance.new("TextLabel")
            Label.Name = "InputLabel"
            Label.Parent = TextInputFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 5, 0, 0)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local TextBox = Instance.new("TextBox")
            TextBox.Name = "TextBox"
            TextBox.Parent = TextInputFrame
            TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TextBox.BorderSizePixel = 0
            TextBox.Position = UDim2.new(0.45, 5, 0.1, 0)
            TextBox.Size = UDim2.new(0.5, 0, 0.8, 0)
            TextBox.Font = Enum.Font.SourceSans
            TextBox.Text = default or ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 14
            
            TextBox.FocusLost:Connect(function(enterPressed)
                if callback then
                    callback(TextBox.Text)
                end
            end)
            
            TabMethods:UpdateCanvas()
            return TextInputFrame
        end
        
        function TabMethods:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text .. "Toggle"
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
            ToggleFrame.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 35)
            
            local Label = Instance.new("TextLabel")
            Label.Name = "ToggleLabel"
            Label.Parent = ToggleFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 5, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 100, 100)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(0.75, 5, 0.1, 0)
            ToggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
            ToggleButton.Font = Enum.Font.SourceSans
            ToggleButton.Text = default and "On" or "Off"
            ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            ToggleButton.TextSize = 14
            
            local toggled = default
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleButton.Text = toggled and "On" or "Off"
                ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 100, 100)
                if callback then
                    callback(toggled)
                end
            end)
            
            TabMethods:UpdateCanvas()
            return ToggleFrame
        end
        
        -- Tab Selection Logic
        Tab.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(TabContainer:GetChildren()) do
                if otherTab:IsA("TextButton") then
                    otherTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end
            Tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            
            for _, content in pairs(ContentContainer:GetChildren()) do
                content.Visible = false
            end
            TabContent.Visible = true
        end)
        
        if #TabContainer:GetChildren() == 1 then
            Tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TabContent.Visible = true
        end
        
        return TabMethods
    end
    
    return Window
end

return Library
