local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

function Library.new(title)
    -- Create loading screen first
    local LoadingGui = Instance.new("ScreenGui")
    local LoadingFrame = Instance.new("Frame")
    local LoadingBar = Instance.new("Frame")
    local LoadingText = Instance.new("TextLabel")
    
    LoadingGui.Name = "LoadingScreen"
    LoadingGui.Parent = CoreGui
    
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = LoadingGui
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -25)
    LoadingFrame.Size = UDim2.new(0, 300, 0, 50)
    LoadingFrame.BackgroundTransparency = 0
    
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Parent = LoadingFrame
    LoadingBar.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    
    LoadingText.Name = "LoadingText"
    LoadingText.Parent = LoadingFrame
    LoadingText.BackgroundTransparency = 1
    LoadingText.Size = UDim2.new(1, 0, 1, 0)
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = "Loading..."
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 16

    -- Main GUI (initially invisible)
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local TabList = Instance.new("UIListLayout")
    local ContainerHolder = Instance.new("Frame")

    ScreenGui.Name = "UILibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.BackgroundTransparency = 1 -- Start invisible

    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TopBar.Size = UDim2.new(1, 0, 0, 35)

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabHolder.Position = UDim2.new(0, 0, 0, 35)
    TabHolder.Size = UDim2.new(0, 150, 1, -35)

    TabList.Parent = TabHolder
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 2)

    ContainerHolder.Name = "ContainerHolder"
    ContainerHolder.Parent = Main
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Position = UDim2.new(0, 125, 0, 35)
    ContainerHolder.Size = UDim2.new(1, -130, 1, -40)

    local Window = {}
    
    -- Add shadows and gradients
    local MainShadow = Instance.new("ImageLabel")
    MainShadow.Name = "Shadow"
    MainShadow.Parent = Main
    MainShadow.BackgroundTransparency = 1
    MainShadow.Position = UDim2.new(0, -15, 0, -15)
    MainShadow.Size = UDim2.new(1, 30, 1, 30)
    MainShadow.Image = "rbxassetid://5028857084"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 1
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(24, 24, 276, 276)

    -- Loading animation sequence
    local function startLoadingSequence()
        TweenService:Create(LoadingBar, TweenInfo.new(1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        wait(1.2)
        
        -- Fade out loading screen
        TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(LoadingBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        
        wait(0.5)
        LoadingGui:Destroy()
        
        -- Fade in main GUI
        Main.BackgroundTransparency = 0
        MainShadow.ImageTransparency = 0.5
        Main:TweenPosition(UDim2.new(0.5, -300, 0.5, -175), "Out", "Back", 0.5, true)
    end
    
    startLoadingSequence()
    
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        local Container = Instance.new("ScrollingFrame")
        local ItemList = Instance.new("UIListLayout")
        
        TabButton.Name = name
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 12
        
        -- Add hover effect
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
        end)
        
        TabButton.MouseLeave:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        end)
        
        Container.Name = name.."Container"
        Container.Parent = ContainerHolder
        Container.BackgroundTransparency = 1
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.ScrollBarThickness = 2
        Container.Visible = false
        
        ItemList.Parent = Container
        ItemList.SortOrder = Enum.SortOrder.LayoutOrder
        ItemList.Padding = UDim.new(0, 5)
        
        local Tab = {}
        
        function Tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local ButtonEffect = Instance.new("Frame")
            local UICorner_2 = Instance.new("UICorner")
            
            Button.Name = text
            Button.Parent = Container
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.Font = Enum.Font.GothamBold
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 13
            Button.ClipsDescendants = true
            
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = Button
            
            ButtonEffect.Name = "ButtonEffect"
            ButtonEffect.Parent = Button
            ButtonEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonEffect.BackgroundTransparency = 0.9
            ButtonEffect.Size = UDim2.new(0, 0, 0, 0)
            ButtonEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            UICorner_2.CornerRadius = UDim.new(1, 0)
            UICorner_2.Parent = ButtonEffect
            
            -- Add hover and click effects
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
            end)
            
            Button.MouseButton1Down:Connect(function()
                local effect = ButtonEffect:Clone()
                effect.Parent = Button
                
                local mx, my = UserInputService:GetMouseLocation()
                local px, py = Button.AbsolutePosition.X, Button.AbsolutePosition.Y
                effect.Position = UDim2.new(0, mx - px, 0, my - py)
                
                local goal = {}
                goal.Size = UDim2.new(1.5, 0, 1.5, 0)
                goal.BackgroundTransparency = 1
                
                TweenService:Create(effect, TweenInfo.new(0.5), goal):Play()
                game.Debris:AddItem(effect, 0.5)
                
                callback()
            end)
        end
        
        function Tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local ToggleButton = Instance.new("TextButton")
            local Indicator = Instance.new("Frame")
            
            Toggle.Name = text
            Toggle.Parent = Container
            Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            
            Title.Name = "Title"
            Title.Parent = Toggle
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -50, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = Toggle
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, 30, 0, 20)
            
            Indicator.Name = "Indicator"
            Indicator.Parent = Toggle
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Position = UDim2.new(0, 2, 0.5, -8)
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            
            local toggled = default or false
            
            -- Update toggle visuals
            Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = Toggle
            
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            local UICorner_2 = Instance.new("UICorner")
            UICorner_2.CornerRadius = UDim.new(1, 0)
            UICorner_2.Parent = ToggleButton
            
            local UICorner_3 = Instance.new("UICorner")
            UICorner_3.CornerRadius = UDim.new(1, 0)
            UICorner_3.Parent = Indicator
            
            -- Add smooth animation
            local function updateToggle()
                local pos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local color = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 255, 255)
                local buttonColor = toggled and Color3.fromRGB(55, 55, 60) or Color3.fromRGB(45, 45, 50)
                
                TweenService:Create(Indicator, TweenInfo.new(0.2), {
                    Position = pos,
                    BackgroundColor3 = color
                }):Play()
                
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = buttonColor
                }):Play()
                
                callback(toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            updateToggle()
        end
        
        function Tab:AddHotkey(text, default, callback)
            local HotkeyFrame = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local HotkeyButton = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            
            HotkeyFrame.Name = text
            HotkeyFrame.Parent = Container
            HotkeyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            HotkeyFrame.Size = UDim2.new(1, -10, 0, 35)
            
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = HotkeyFrame
            
            Title.Name = "Title"
            Title.Parent = HotkeyFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -90, 1, 0)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            HotkeyButton.Name = "HotkeyButton"
            HotkeyButton.Parent = HotkeyFrame
            HotkeyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            HotkeyButton.Position = UDim2.new(1, -80, 0.5, -12)
            HotkeyButton.Size = UDim2.new(0, 70, 0, 24)
            HotkeyButton.Font = Enum.Font.GothamBold
            HotkeyButton.Text = default and default.Name or "None"
            HotkeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            HotkeyButton.TextSize = 12
            
            local UICorner_2 = Instance.new("UICorner")
            UICorner_2.CornerRadius = UDim.new(0, 4)
            UICorner_2.Parent = HotkeyButton
            
            local currentKey = default
            local listening = false
            
            -- Add hover effect
            HotkeyButton.MouseEnter:Connect(function()
                TweenService:Create(HotkeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
            end)
            
            HotkeyButton.MouseLeave:Connect(function()
                TweenService:Create(HotkeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
            end)
            
            HotkeyButton.MouseButton1Click:Connect(function()
                if listening then return end
                
                listening = true
                HotkeyButton.Text = "..."
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        HotkeyButton.Text = currentKey.Name
                        listening = false
                        connection:Disconnect()
                    end
                end)
            end)
            
            -- Listen for hotkey press
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard 
                    and input.KeyCode == currentKey 
                    and not listening then
                    callback(currentKey)
                end
            end)
            
            return {
                SetKey = function(key)
                    currentKey = key
                    HotkeyButton.Text = key.Name
                end,
                GetKey = function()
                    return currentKey
                end
            }
        end
        
        TabButton.MouseButton1Click:Connect(function()
            for _, container in pairs(ContainerHolder:GetChildren()) do
                container.Visible = container.Name == name.."Container"
            end
        end)
        
        if #TabHolder:GetChildren() == 1 then
            Container.Visible = true
        end
        
        return Tab
    end
    
    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
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
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local delta = dragInput.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    return Window
end

return Library
