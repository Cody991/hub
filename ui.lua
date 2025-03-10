local Library = {}

function Library.new(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabsHolder = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local ContentFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UICorner2 = Instance.new("UICorner")

    -- Configure ScreenGui
    ScreenGui.Name = "SleekUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Configure main frame with rounded corners
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 8)

    -- Add title with gradient
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Text = title or "Sleek UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Parent = Title
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 40))
    })

    -- Configure tabs holder with smooth corners
    TabsHolder.Name = "TabsHolder"
    TabsHolder.Parent = MainFrame
    TabsHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabsHolder.Position = UDim2.new(0, 10, 0, 45)
    TabsHolder.Size = UDim2.new(0, 100, 1, -55)
    UICorner2.Parent = TabsHolder
    UICorner2.CornerRadius = UDim.new(0, 6)

    UIListLayout.Parent = TabsHolder
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Configure content frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    ContentFrame.Position = UDim2.new(0, 120, 0, 45)
    ContentFrame.Size = UDim2.new(1, -130, 1, -55)
    Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 6)

    local Window = {}
    
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        local TabContent = Instance.new("ScrollingFrame")
        local UIListLayout2 = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
        
        TabButton.Name = name.."Tab"
        TabButton.Parent = TabsHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        TabButton.Size = UDim2.new(0.9, 0, 0, 30)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 14
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)
        
        TabContent.Name = name.."Content"
        TabContent.Parent = ContentFrame
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 2
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        UIListLayout2.Parent = TabContent
        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout2.Padding = UDim.new(0, 5)
        
        UIPadding.Parent = TabContent
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 10)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(ContentFrame:GetChildren()) do
                if content:IsA("ScrollingFrame") then
                    content.Visible = false
                end
            end
            TabContent.Visible = true
            
            for _, button in pairs(TabsHolder:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                end
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        end)
        
        local Tab = {}
        
        function Tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text.."Button"
            Button.Parent = TabContent
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 14
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
            
            Button.MouseButton1Click:Connect(callback or function() end)
            return Button
        end

        function Tab:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            local SliderLabel = Instance.new("TextLabel")
            local SliderButton = Instance.new("TextButton")
            local SliderFill = Instance.new("Frame")
            local ValueLabel = Instance.new("TextLabel")
            
            SliderFrame.Name = text.."Slider"
            SliderFrame.Parent = TabContent
            SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)
            
            SliderLabel.Name = "Label"
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderFrame
            SliderButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            SliderButton.Position = UDim2.new(0, 10, 0, 30)
            SliderButton.Size = UDim2.new(1, -70, 0, 6)
            Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(0, 3)
            
            SliderFill.Name = "Fill"
            SliderFill.Parent = SliderButton
            SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)
            
            ValueLabel.Name = "Value"
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -50, 0, 25)
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 14
            ValueLabel.Font = Enum.Font.GothamSemibold
            
            local value = default
            local dragging = false
            
            local function updateValue(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderButton.AbsolutePosition.X) / SliderButton.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                
                local val = math.floor(min + (max - min) * pos.X.Scale)
                value = val
                ValueLabel.Text = tostring(val)
                
                if callback then
                    callback(val)
                end
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateValue(input)
                end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(input)
                end
            end)
            
            return SliderFrame
        end
        
        return Tab
    end

    -- Make the frame draggable
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return Window
end

return Library
