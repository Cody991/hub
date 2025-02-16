local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create base GUI elements
function Library.new(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
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
    
    -- Configure Title
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
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
    local dragging
    local dragInput
    local dragStart
    local startPos
    
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
        TabContent.Name = name.."Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        
        local TabMethods = {}
        
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
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, #TabContent:GetChildren() * 35 + 5)
            
            return Button
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
        
        -- Show first tab by default
        if #TabContainer:GetChildren() == 1 then
            Tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TabContent.Visible = true
        end
        
        return TabMethods
    end
    
    return Window
end

return Library

