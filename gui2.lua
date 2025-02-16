local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create base GUI elements with extended controls (buttons, sliders, text inputs, toggles, etc.)
function Library.new(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame")
    local ContentContainer = Instance.new("Frame")
    
    -- Configure ScreenGui
    ScreenGui.Name = "ScriptHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Configure MainFrame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    
    -- Configure TopBar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    
    -- Configure TitleLabel
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Configure TabHolder
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = MainFrame
    TabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 0, 0, 30)
    TabHolder.Size = UDim2.new(0, 150, 1, -30)
    
    -- Configure TabContainer
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = TabHolder
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 2
    
    -- Configure ContentContainer
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 30)
    ContentContainer.Size = UDim2.new(1, -150, 1, -30)
    
    -- Make window draggable
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
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
