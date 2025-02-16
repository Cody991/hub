local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

function Library.new(title)
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
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Size = UDim2.new(0, 500, 0, 300)

    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.Size = UDim2.new(1, 0, 0, 30)

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
    TabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabHolder.Position = UDim2.new(0, 0, 0, 30)
    TabHolder.Size = UDim2.new(0, 120, 1, -30)

    TabList.Parent = TabHolder
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 2)

    ContainerHolder.Name = "ContainerHolder"
    ContainerHolder.Parent = Main
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Position = UDim2.new(0, 125, 0, 35)
    ContainerHolder.Size = UDim2.new(1, -130, 1, -40)

    local Window = {}
    
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        local Container = Instance.new("ScrollingFrame")
        local ItemList = Instance.new("UIListLayout")
        
        TabButton.Name = name
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 12
        
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
            Button.Name = text
            Button.Parent = Container
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Font = Enum.Font.Gotham
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 12
            
            Button.MouseButton1Click:Connect(function()
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
            Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
            ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, 30, 0, 20)
            
            Indicator.Name = "Indicator"
            Indicator.Parent = ToggleButton
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Position = UDim2.new(0, 2, 0.5, -8)
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            
            local toggled = default or false
            
            local function updateToggle()
                local pos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local color = toggled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
                
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = pos, BackgroundColor3 = color}):Play()
                callback(toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            updateToggle()
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
