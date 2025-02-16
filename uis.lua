local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Updated color scheme with more refined colors
local colors = {
    background = Color3.fromRGB(15, 15, 20),    -- Darker, richer background
    foreground = Color3.fromRGB(25, 25, 30),    -- Subtle contrast for elements
    accent = Color3.fromRGB(66, 135, 245),      -- Modern blue accent
    accent_dark = Color3.fromRGB(48, 110, 215), -- Darker accent for gradients
    hover = Color3.fromRGB(35, 35, 40),         -- Subtle hover state
    text = Color3.fromRGB(255, 255, 255),       -- Crisp white text
    subtext = Color3.fromRGB(180, 180, 190),    -- Softer secondary text
    border = Color3.fromRGB(40, 40, 45)         -- Subtle borders
}

function Library.new(title)
    local LoadingGui = Instance.new("ScreenGui")
    local LoadingFrame = Instance.new("Frame")
    local LoadingBar = Instance.new("Frame")
    local LoadingText = Instance.new("TextLabel")
    
    LoadingGui.Name = "LoadingScreen"
    LoadingGui.Parent = CoreGui
    
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = LoadingGui
    LoadingFrame.BackgroundColor3 = colors.background
    LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -25)
    LoadingFrame.Size = UDim2.new(0, 300, 0, 50)
    LoadingFrame.BackgroundTransparency = 0
    
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Parent = LoadingFrame
    LoadingBar.BackgroundColor3 = colors.accent
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    
    LoadingText.Name = "LoadingText"
    LoadingText.Parent = LoadingFrame
    LoadingText.BackgroundTransparency = 1
    LoadingText.Size = UDim2.new(1, 0, 1, 0)
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = "Loading..."
    LoadingText.TextColor3 = colors.text
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
    Main.BackgroundColor3 = colors.background
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.BackgroundTransparency = 1 -- Start invisible

    UICorner.CornerRadius = UDim.new(0, 8) -- Rounder corners
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = colors.accent
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -15, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = colors.text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = colors.foreground
    TabHolder.Position = UDim2.new(0, 10, 0, 50)
    TabHolder.Size = UDim2.new(0, 150, 1, -60)

    local TabHolderCorner = Instance.new("UICorner")
    TabHolderCorner.CornerRadius = UDim.new(0, 6)
    TabHolderCorner.Parent = TabHolder

    TabList.Parent = TabHolder
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    ContainerHolder.Name = "ContainerHolder"
    ContainerHolder.Parent = Main
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Position = UDim2.new(0, 170, 0, 50)
    ContainerHolder.Size = UDim2.new(1, -180, 1, -60)

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
    MainShadow.ImageTransparency = 0.8
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(24, 24, 276, 276)

    -- Add gradient to top bar
    local TopBarGradient = Instance.new("UIGradient")
    TopBarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors.accent),
        ColorSequenceKeypoint.new(1, colors.accent_dark)
    })
    TopBarGradient.Parent = TopBar

    -- Add a subtle glow effect to the TopBar
    local TopBarGlow = Instance.new("ImageLabel")
    TopBarGlow.Name = "Glow"
    TopBarGlow.BackgroundTransparency = 1
    TopBarGlow.Position = UDim2.new(0, -15, 0, -15)
    TopBarGlow.Size = UDim2.new(1, 30, 1, 30)
    TopBarGlow.ZIndex = 0
    TopBarGlow.Image = "rbxassetid://4996891970"
    TopBarGlow.ImageColor3 = colors.accent
    TopBarGlow.ImageTransparency = 0.9
    TopBarGlow.Parent = TopBar

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
        
        -- Fade in main GUI with bounce effect
        Main.BackgroundTransparency = 0
        MainShadow.ImageTransparency = 0.8
        Main:TweenPosition(UDim2.new(0.5, -300, 0.5, -175), "Out", "Bounce", 0.8, true)
    end
    
    startLoadingSequence()
    
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        local Container = Instance.new("ScrollingFrame")
        local ItemList = Instance.new("UIListLayout")
        
        TabButton.Name = name
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = colors.foreground
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = name
        TabButton.TextColor3 = colors.subtext
        TabButton.TextSize = 12
        
        -- Enhanced hover effect
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.hover,
                TextColor3 = colors.text
            }):Play()
        end)
        
        TabButton.MouseLeave:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.foreground,
                TextColor3 = colors.subtext
            }):Play()
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
            local Button = Instance.new("Frame")
            local ButtonContent = Instance.new("Frame")
            local ButtonLabel = Instance.new("TextLabel")
            local ButtonClick = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local UIStroke = Instance.new("UIStroke")
            local ButtonGradient = Instance.new("UIGradient")
            
            Button.Name = text
            Button.Parent = Container
            Button.BackgroundColor3 = colors.foreground
            Button.Size = UDim2.new(1, -20, 0, 40)
            Button.ClipsDescendants = true
            
            ButtonContent.Name = "ButtonContent"
            ButtonContent.Parent = Button
            ButtonContent.BackgroundColor3 = colors.foreground
            ButtonContent.Size = UDim2.new(1, 0, 1, 0)
            ButtonContent.ZIndex = 2
            
            ButtonLabel.Name = "ButtonLabel"
            ButtonLabel.Parent = ButtonContent
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
            ButtonLabel.Font = Enum.Font.GothamBold
            ButtonLabel.Text = text
            ButtonLabel.TextColor3 = colors.text
            ButtonLabel.TextSize = 14
            ButtonLabel.ZIndex = 3
            
            ButtonClick.Name = "ButtonClick"
            ButtonClick.Parent = Button
            ButtonClick.BackgroundTransparency = 1
            ButtonClick.Size = UDim2.new(1, 0, 1, 0)
            ButtonClick.ZIndex = 4
            ButtonClick.Text = ""
            
            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = Button
            
            local ContentCorner = UICorner:Clone()
            ContentCorner.Parent = ButtonContent
            
            UIStroke.Color = colors.border
            UIStroke.Thickness = 1.5
            UIStroke.Parent = Button
            
            ButtonGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
            })
            ButtonGradient.Rotation = 45
            ButtonGradient.Parent = ButtonContent
            
            -- Enhanced hover and click effects
            local isHovering = false
            
            ButtonClick.MouseEnter:Connect(function()
                isHovering = true
                TweenService:Create(ButtonContent, TweenInfo.new(0.2), {
                    BackgroundColor3 = colors.hover
                }):Play()
                TweenService:Create(UIStroke, TweenInfo.new(0.2), {
                    Color = colors.accent
                }):Play()
            end)
            
            ButtonClick.MouseLeave:Connect(function()
                isHovering = false
                TweenService:Create(ButtonContent, TweenInfo.new(0.2), {
                    BackgroundColor3 = colors.foreground
                }):Play()
                TweenService:Create(UIStroke, TweenInfo.new(0.2), {
                    Color = colors.border
                }):Play()
            end)
            
            -- Modern click effect with ripple
            ButtonClick.MouseButton1Down:Connect(function()
                -- Ripple effect
                local ripple = Instance.new("Frame")
                ripple.Name = "Ripple"
                ripple.Parent = ButtonContent
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.6
                ripple.BorderSizePixel = 0
                ripple.ZIndex = 2
                
                -- Position ripple at mouse position
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local relativeX = mouse.X - Button.AbsolutePosition.X
                local relativeY = mouse.Y - Button.AbsolutePosition.Y
                ripple.Position = UDim2.new(0, relativeX - 5, 0, relativeY - 5)
                ripple.Size = UDim2.new(0, 10, 0, 10)
                
                local rippleCorner = Instance.new("UICorner")
                rippleCorner.CornerRadius = UDim.new(1, 0)
                rippleCorner.Parent = ripple
                
                -- Animate ripple
                TweenService:Create(ripple, TweenInfo.new(0.5), {
                    Size = UDim2.new(2, 0, 2, 0),
                    Position = UDim2.new(0, relativeX - Button.AbsoluteSize.X, 0, relativeY - Button.AbsoluteSize.Y),
                    BackgroundTransparency = 1
                }):Play()
                
                -- Scale down effect
                TweenService:Create(ButtonContent, TweenInfo.new(0.1), {
                    Size = UDim2.new(0.97, 0, 0.97, 0),
                    Position = UDim2.new(0.015, 0, 0.015, 0)
                }):Play()
                
                game.Debris:AddItem(ripple, 0.5)
                callback()
            end)
            
            ButtonClick.MouseButton1Up:Connect(function()
                TweenService:Create(ButtonContent, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
            end)
        end
        
        function Tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local ToggleButton = Instance.new("TextButton")
            local Indicator = Instance.new("Frame")
            
            Toggle.Name = text
            Toggle.Parent = Container
            Toggle.BackgroundColor3 = colors.foreground
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            
            Title.Name = "Title"
            Title.Parent = Toggle
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -50, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = colors.text
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = Toggle
            ToggleButton.BackgroundColor3 = colors.background
            ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, 30, 0, 20)
            
            Indicator.Name = "Indicator"
            Indicator.Parent = Toggle
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Position = UDim2.new(0, 2, 0.5, -8)
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            
            local toggled = default or false
            
            -- Update toggle colors
            local function updateToggle()
                local pos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local color = toggled and colors.accent or colors.text
                local buttonColor = toggled and colors.hover or colors.background
                
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
            HotkeyFrame.BackgroundColor3 = colors.foreground
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
            Title.TextColor3 = colors.text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            HotkeyButton.Name = "HotkeyButton"
            HotkeyButton.Parent = HotkeyFrame
            HotkeyButton.BackgroundColor3 = colors.background
            HotkeyButton.Position = UDim2.new(1, -80, 0.5, -12)
            HotkeyButton.Size = UDim2.new(0, 70, 0, 24)
            HotkeyButton.Font = Enum.Font.GothamBold
            HotkeyButton.Text = default and default.Name or "None"
            HotkeyButton.TextColor3 = colors.text
            HotkeyButton.TextSize = 12
            
            local UICorner_2 = Instance.new("UICorner")
            UICorner_2.CornerRadius = UDim.new(0, 4)
            UICorner_2.Parent = HotkeyButton
            
            local currentKey = default
            local listening = false
            
            -- Enhanced hover effect
            HotkeyButton.MouseEnter:Connect(function()
                TweenService:Create(HotkeyButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = colors.hover
                }):Play()
            end)
            
            HotkeyButton.MouseLeave:Connect(function()
                TweenService:Create(HotkeyButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = colors.background
                }):Play()
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
