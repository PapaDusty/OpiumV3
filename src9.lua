-- Opium Library (VapeV4-style Module System)
-- GitHub: https://github.com/yourusername/Opium

local library = {}
library.Flags = {}
library.DefaultColor = Color3.fromRGB(56, 207, 154)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Blacklist = {
    Enum.KeyCode.Unknown, Enum.KeyCode.CapsLock, Enum.KeyCode.Escape,
    Enum.KeyCode.Tab, Enum.KeyCode.Return, Enum.KeyCode.Backspace,
    Enum.KeyCode.Space, Enum.KeyCode.W, Enum.KeyCode.A,
    Enum.KeyCode.S, Enum.KeyCode.D
}

for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "Opium" then
        v:Destroy()
    end
end

function library:GetXY(GuiObject)
	local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
	local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
	return Px/Max, Py/May
end

local LibraryToggleKey = Enum.KeyCode.RightShift
function library:Toggle()
    for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "Opium" then
            v.Enabled = not v.Enabled
        end
    end
end

function library:SetToggleKeybind(key)
    LibraryToggleKey = key
end

if not game:GetService("CoreGui"):FindFirstChild("NotificationLibrary") then
    local notificationLibrary = Instance.new("ScreenGui")
    notificationLibrary.Name = "NotificationLibrary"
    notificationLibrary.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notificationLibrary.Parent = game:GetService("CoreGui")

    local notificationHolder = Instance.new("Frame")
    notificationHolder.Name = "NotificationHolder"
    notificationHolder.AnchorPoint = Vector2.new(0, 0.5)
    notificationHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notificationHolder.BackgroundTransparency = 1
    notificationHolder.Position = UDim2.fromScale(0, 0.5)
    notificationHolder.Size = UDim2.fromScale(0.8, 1)
    notificationHolder.Parent = notificationLibrary

    local notificationUIListLayout = Instance.new("UIListLayout")
    notificationUIListLayout.Name = "NotificationUIListLayout"
    notificationUIListLayout.FillDirection = Enum.FillDirection.Vertical
    notificationUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationUIListLayout.Padding = UDim.new(0, 4)
    notificationUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notificationUIListLayout.Parent = notificationHolder

    local notificationUIPadding = Instance.new("UIPadding")
    notificationUIPadding.Name = "NotificationUIPadding"
    notificationUIPadding.PaddingBottom = UDim.new(0, 9)
    notificationUIPadding.PaddingLeft = UDim.new(0, 5)
    notificationUIPadding.Parent = notificationHolder
end

local NotificationLib = game:GetService("CoreGui"):FindFirstChild("NotificationLibrary")
local Holder = NotificationLib:FindFirstChild("NotificationHolder")

function library:Notification(NotificationInfo)
    NotificationInfo.Text = NotificationInfo.Text or "This is a notification."
    NotificationInfo.Duration = NotificationInfo.Duration or 5
    NotificationInfo.Color = NotificationInfo.Color or library.DefaultColor

    local notificationText = Instance.new("TextLabel")
    notificationText.Name = "NotificationText"
    notificationText.ClipsDescendants = true
    notificationText.Font = Enum.Font.GothamBold
    notificationText.Text = NotificationInfo.Text
    notificationText.TextColor3 = Color3.fromRGB(214, 214, 214)
    notificationText.TextSize = 14
    notificationText.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    notificationText.BorderSizePixel = 0
    notificationText.Position = UDim2.fromScale(0, 0.954)
    notificationText.Size = UDim2.fromOffset(0, 38)
    notificationText.Parent = Holder

    local outerFrame = Instance.new("Frame")
    outerFrame.Name = "OuterFrame"
    outerFrame.AnchorPoint = Vector2.new(0, 1)
    outerFrame.BackgroundColor3 = NotificationInfo.Color
    outerFrame.BorderSizePixel = 0
    outerFrame.Position = UDim2.fromScale(0, 1)
    outerFrame.Size = UDim2.new(1, 0, 0, 3)
    outerFrame.ZIndex = 2
    outerFrame.Parent = notificationText

    local notificationUICorner = Instance.new("UICorner")
    notificationUICorner.Name = "NotificationUICorner"
    notificationUICorner.CornerRadius = UDim.new(0, 4)
    notificationUICorner.Parent = notificationText

    local innerFrame = Instance.new("Frame")
    innerFrame.Name = "InnerFrame"
    innerFrame.AnchorPoint = Vector2.new(0, 1)
    innerFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    innerFrame.BorderSizePixel = 0
    innerFrame.Position = UDim2.fromScale(0, 1)
    innerFrame.Size = UDim2.new(1, 0, 0, 3)
    innerFrame.Parent = notificationText

    local NotifText = notificationText
    local TextBounds = NotifText.TextBounds

    coroutine.wrap(function()
        local InTween = TweenService:Create(NotifText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, TextBounds.X + 20, 0, 38)})
        InTween:Play()
        InTween.Completed:Wait()

        local LineTween = TweenService:Create(outerFrame, TweenInfo.new(NotificationInfo.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 3)})
        LineTween:Play()
        LineTween.Completed:Wait()

        local OutTween = TweenService:Create(NotifText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 0, 0, 38)})
        OutTween:Play()
        OutTween.Completed:Wait()
        notificationText:Destroy()
    end)()
end

local Request = syn and syn.request or http and http.request or http_request or request or httprequest
local getcustomasset = getcustomasset or getsynasset

if not isfolder("Opium") then
    makefolder("Opium")
    local Circle = Request({
        Url = "https://github.com/Rain-Design/Libraries/blob/main/Icon/Circle.png?raw=true",
        Method = "GET"
    })
    writefile("Opium/Circle.png", Circle.Body)
    library:Notification({
        Text = "Downloaded Toggle Asset.",
        Duration = 3
    })
end

function library:Window(Info)
    Info.Text = Info.Text or "Opium"
    local windowWidth = 200
    local PosX = 0.35
    local PosY = 0.08

    local count = 0
    for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "Opium" then
            count = count + 1
        end
    end
    PosX = PosX + (count * (windowWidth / 1920 + 0.02))

    local insidewindow = {}

    local opiumGui = Instance.new("ScreenGui")
    opiumGui.Name = "Opium"
    opiumGui.Parent = game:GetService("CoreGui")

    local WindowOpened = Instance.new("BoolValue", opiumGui)
    WindowOpened.Value = true

    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    topbar.Position = UDim2.new(PosX, 0, PosY, 0)
    topbar.Size = UDim2.fromOffset(windowWidth, 38)
    topbar.Parent = opiumGui

    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        topbar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = topbar.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(0, 4)
    uICorner.Parent = topbar

    local BackgroundSize = 0

    local tabArea = Instance.new("Frame")
    tabArea.Name = "TabArea"
    tabArea.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    tabArea.BorderSizePixel = 0
    tabArea.ClipsDescendants = false
    tabArea.Position = UDim2.fromScale(0, 1)
    tabArea.Size = UDim2.fromOffset(windowWidth, 0)
    tabArea.Parent = topbar

    local tabCorner = Instance.new("UICorner")
    tabCorner.Name = "UICorner"
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tabArea

    local fixLine = Instance.new("Frame")
    fixLine.Name = "FixLine"
    fixLine.AnchorPoint = Vector2.new(0.5, 0)
    fixLine.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    fixLine.BorderSizePixel = 0
    fixLine.Position = UDim2.fromScale(0.5, 0)
    fixLine.Size = UDim2.fromOffset(windowWidth, 2)
    fixLine.Parent = tabArea
    fixLine.ZIndex = 2

    local moduleArea = Instance.new("Frame")
    moduleArea.Name = "ModuleArea"
    moduleArea.AnchorPoint = Vector2.new(0.5, 0)
    moduleArea.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    moduleArea.BackgroundTransparency = 1
    moduleArea.BorderSizePixel = 0
    moduleArea.Position = UDim2.fromScale(0.5, 0)
    moduleArea.Size = UDim2.fromOffset(windowWidth, 0)
    moduleArea.Parent = tabArea

    moduleArea.ChildAdded:Connect(function(v)
        if v.ClassName ~= "UIListLayout" then
            tabArea.Size = UDim2.new(0,windowWidth,0,moduleArea.Size.Y.Offset + 38)
            moduleArea.Size = UDim2.new(0,windowWidth,0,moduleArea.Size.Y.Offset + 38)
            BackgroundSize = BackgroundSize + 38
        end
    end)

    moduleArea.ChildRemoved:Connect(function(v)
        if v.ClassName ~= "UIListLayout" then
            tabArea.Size = UDim2.new(0,windowWidth,0,moduleArea.Size.Y.Offset - 38)
            moduleArea.Size = UDim2.new(0,windowWidth,0,moduleArea.Size.Y.Offset - 38)
            BackgroundSize = BackgroundSize - 38
        end
    end)

    local moduleList = Instance.new("UIListLayout")
    moduleList.Name = "UIListLayout"
    moduleList.SortOrder = Enum.SortOrder.LayoutOrder
    moduleList.Parent = moduleArea

    local expandedModule = nil

    -- ============================================================
    -- MODULE (returns object with create methods)
    -- ============================================================
    function insidewindow:Module(Info)
        local moduleEnabled = false
        local moduleKeybind = Enum.KeyCode.LeftAlt

        local moduleContainer = Instance.new("Frame")
        moduleContainer.Name = "Module"
        moduleContainer.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        moduleContainer.ClipsDescendants = false
        moduleContainer.Size = UDim2.fromOffset(windowWidth, 38)
        moduleContainer.Parent = moduleArea

        local mainCorner = Instance.new("UICorner")
        mainCorner.CornerRadius = UDim.new(0, 4)
        mainCorner.Parent = moduleContainer

        local moduleFixLine = Instance.new("Frame")
        moduleFixLine.Name = "FixLine"
        moduleFixLine.AnchorPoint = Vector2.new(0.5, 1)
        moduleFixLine.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
        moduleFixLine.BorderSizePixel = 0
        moduleFixLine.Position = UDim2.fromScale(0.5, 1)
        moduleFixLine.Size = UDim2.fromOffset(windowWidth, 2)
        moduleFixLine.ZIndex = 2
        moduleFixLine.Parent = moduleContainer

        local moduleButton = Instance.new("Frame")
        moduleButton.Name = "ModuleButton"
        moduleButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        moduleButton.BorderSizePixel = 0
        moduleButton.Size = UDim2.new(1, 0, 0, 38)
        moduleButton.Parent = moduleContainer

        local moduleText = Instance.new("TextLabel")
        moduleText.Name = "ModuleText"
        moduleText.Font = Enum.Font.GothamBold
        moduleText.Text = Info.Name or "Module"
        moduleText.TextColor3 = Color3.fromRGB(214, 214, 214)
        moduleText.TextSize = 14
        moduleText.TextXAlignment = Enum.TextXAlignment.Left
        moduleText.BackgroundTransparency = 1
        moduleText.Position = UDim2.new(0, 10, 0, 0)
        moduleText.Size = UDim2.new(0, windowWidth - 80, 1, 0)
        moduleText.Parent = moduleButton

        local keybindDisplay = Instance.new("TextLabel")
        keybindDisplay.Name = "KeybindDisplay"
        keybindDisplay.Font = Enum.Font.GothamBold
        keybindDisplay.Text = ""
        keybindDisplay.TextColor3 = Color3.fromRGB(120, 120, 120)
        keybindDisplay.TextSize = 12
        keybindDisplay.TextXAlignment = Enum.TextXAlignment.Right
        keybindDisplay.BackgroundTransparency = 1
        keybindDisplay.Position = UDim2.new(1, -70, 0, 0)
        keybindDisplay.Size = UDim2.new(0, 60, 1, 0)
        keybindDisplay.Parent = moduleButton

        local clickButton = Instance.new("TextButton")
        clickButton.Name = "ClickButton"
        clickButton.Text = ""
        clickButton.BackgroundTransparency = 1
        clickButton.Size = UDim2.new(1, 0, 1, 0)
        clickButton.Parent = moduleButton

        local moduleOptions = Instance.new("Frame")
        moduleOptions.Name = "ModuleOptions"
        moduleOptions.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        moduleOptions.BorderSizePixel = 0
        moduleOptions.ClipsDescendants = true
        moduleOptions.Position = UDim2.new(0, 0, 0, 38)
        moduleOptions.Size = UDim2.new(1, 0, 0, 0)
        moduleOptions.Visible = false
        moduleOptions.ZIndex = 1
        moduleOptions.Parent = moduleContainer

        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, 4)
        optionsCorner.Parent = moduleOptions

        local optionsList = Instance.new("UIListLayout")
        optionsList.Name = "OptionsList"
        optionsList.SortOrder = Enum.SortOrder.LayoutOrder
        optionsList.Padding = UDim.new(0, 4)
        optionsList.Parent = moduleOptions

        local optionsPadding = Instance.new("UIPadding")
        optionsPadding.Name = "OptionsPadding"
        optionsPadding.PaddingLeft = UDim.new(0, 5)
        optionsPadding.PaddingRight = UDim.new(0, 5)
        optionsPadding.PaddingTop = UDim.new(0, 4)
        optionsPadding.PaddingBottom = UDim.new(0, 4)
        optionsPadding.Parent = moduleOptions

        local optionsHeight = 0

        local function createKeybindControl(parent, info, onBind)
            local PressKey = info.Default or Enum.KeyCode.LeftAlt

            local keybind = Instance.new("Frame")
            keybind.Name = "Keybind"
            keybind.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            keybind.Size = UDim2.new(1, 0, 0, 28)
            keybind.Parent = parent

            local keybindCorner = Instance.new("UICorner")
            keybindCorner.CornerRadius = UDim.new(0, 3)
            keybindCorner.Parent = keybind

            local keybindText = Instance.new("TextLabel")
            keybindText.Name = "KeybindText"
            keybindText.Font = Enum.Font.GothamBold
            keybindText.Text = info.Text or "Keybind"
            keybindText.TextColor3 = Color3.fromRGB(214, 214, 214)
            keybindText.TextSize = 13
            keybindText.TextXAlignment = Enum.TextXAlignment.Left
            keybindText.BackgroundTransparency = 1
            keybindText.Position = UDim2.new(0, 4, 0, 0)
            keybindText.Size = UDim2.new(0, 120, 0, 28)
            keybindText.Parent = keybind

            local keybindHolder = Instance.new("Frame")
            keybindHolder.Name = "KeybindHolder"
            keybindHolder.AnchorPoint = Vector2.new(1, 0.5)
            keybindHolder.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
            keybindHolder.BorderSizePixel = 0
            keybindHolder.Position = UDim2.new(1, -4, 0.5, 0)
            keybindHolder.Size = UDim2.fromOffset(38, 17)
            keybindHolder.Parent = keybind

            local keybindHolderCorner = Instance.new("UICorner")
            keybindHolderCorner.CornerRadius = UDim.new(0, 3)
            keybindHolderCorner.Parent = keybindHolder

            local keybindLabel = Instance.new("TextLabel")
            keybindLabel.Name = "KeybindLabel"
            keybindLabel.Font = Enum.Font.GothamBold
            keybindLabel.Text = PressKey.Name
            keybindLabel.TextColor3 = Color3.fromRGB(214, 214, 214)
            keybindLabel.TextSize = 11
            keybindLabel.BackgroundTransparency = 1
            keybindLabel.Size = UDim2.new(1, 0, 1, 0)
            keybindLabel.Parent = keybindHolder

            local function UpdateKeybindSize()
                local bounds = keybindLabel.TextBounds
                keybindHolder.Size = UDim2.new(0, bounds.X + 12, 0, 17)
            end
            UpdateKeybindSize()
            keybindLabel:GetPropertyChangedSignal("Text"):Connect(UpdateKeybindSize)

            local Changing = false
            local KeybindConnection

            local button = Instance.new("TextButton")
            button.Name = "KeybindButton"
            button.Text = ""
            button.BackgroundTransparency = 1
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Parent = keybind

            button.MouseButton1Click:Connect(function()
                if KeybindConnection then KeybindConnection:Disconnect() end
                Changing = true
                keybindLabel.Text = "..."
                KeybindConnection = UserInputService.InputBegan:Connect(function(Key, gameProcessed)
                    if not table.find(Blacklist, Key.KeyCode) and not gameProcessed and Key.KeyCode ~= Enum.KeyCode.Unknown then
                        KeybindConnection:Disconnect()
                        keybindLabel.Text = Key.KeyCode.Name
                        PressKey = Key.KeyCode
                        if onBind then onBind(PressKey) end
                        wait(0.1)
                        Changing = false
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(Key, gameProcessed)
                if not Changing and Key.KeyCode == PressKey and not gameProcessed then
                    if info.Callback then pcall(info.Callback) end
                    if info.ToggleModule then
                        moduleEnabled = not moduleEnabled
                        if Info.Function then pcall(Info.Function, moduleEnabled) end
                        moduleButton.BackgroundColor3 = moduleEnabled and library.DefaultColor or Color3.fromRGB(36, 36, 36)
                        moduleText.TextColor3 = moduleEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(214, 214, 214)
                    end
                end
            end)

            return keybind, PressKey
        end

        local moduleAPI = {}

        function moduleAPI:CreateToggle(info)
            local toggle = Instance.new("Frame")
            toggle.Name = "Toggle"
            toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            toggle.Size = UDim2.new(1, 0, 0, 28)
            toggle.Parent = moduleOptions

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 3)
            toggleCorner.Parent = toggle

            local toggleText = Instance.new("TextLabel")
            toggleText.Name = "ToggleText"
            toggleText.Font = Enum.Font.GothamBold
            toggleText.Text = info.Name or "Toggle"
            toggleText.TextColor3 = Color3.fromRGB(214, 214, 214)
            toggleText.TextSize = 13
            toggleText.TextXAlignment = Enum.TextXAlignment.Left
            toggleText.BackgroundTransparency = 1
            toggleText.Position = UDim2.new(0, 4, 0, 0)
            toggleText.Size = UDim2.new(0, 140, 0, 28)
            toggleText.Parent = toggle

            local outerFrame = Instance.new("Frame")
            outerFrame.Name = "OuterFrame"
            outerFrame.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
            outerFrame.BorderSizePixel = 0
            outerFrame.Position = UDim2.new(1, -32, 0.5, -8)
            outerFrame.Size = UDim2.fromOffset(28, 14)
            outerFrame.Parent = toggle

            local outerCorner = Instance.new("UICorner")
            outerCorner.CornerRadius = UDim.new(1, 0)
            outerCorner.Parent = outerFrame

            local innerFrame = Instance.new("ImageLabel")
            innerFrame.Name = "InnerFrame"
            innerFrame.Image = getcustomasset("Opium/Circle.png")
            innerFrame.ResampleMode = "Pixelated"
            innerFrame.ImageColor3 = Color3.fromRGB(255, 255, 255)
            innerFrame.BackgroundTransparency = 1
            innerFrame.Position = UDim2.fromOffset(2, 1)
            innerFrame.Size = UDim2.fromOffset(11, 11)
            innerFrame.Parent = outerFrame

            local toggled = info.Default or false
            if info.Callback then pcall(info.Callback, toggled) end
            innerFrame.Position = toggled and UDim2.new(0, 15, 0, 1) or UDim2.new(0, 2, 0, 1)
            outerFrame.BackgroundColor3 = toggled and library.DefaultColor or Color3.fromRGB(62, 62, 62)

            local btn = Instance.new("TextButton")
            btn.Name = "ToggleButton"
            btn.Text = ""
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Parent = toggle

            btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                if info.Callback then pcall(info.Callback, toggled) end
                TweenService:Create(innerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = toggled and UDim2.new(0, 15, 0, 1) or UDim2.new(0, 2, 0, 1)}):Play()
                TweenService:Create(outerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = toggled and library.DefaultColor or Color3.fromRGB(62, 62, 62)}):Play()
            end)

            optionsHeight = optionsHeight + 28
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
            return toggle
        end

        function moduleAPI:CreateSlider(info)
            local slider = Instance.new("Frame")
            slider.Name = "Slider"
            slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            slider.Size = UDim2.new(1, 0, 0, 38)
            slider.Parent = moduleOptions

            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 3)
            sliderCorner.Parent = slider

            local sliderText = Instance.new("TextLabel")
            sliderText.Name = "SliderText"
            sliderText.Font = Enum.Font.GothamBold
            sliderText.Text = info.Name or "Slider"
            sliderText.TextColor3 = Color3.fromRGB(214, 214, 214)
            sliderText.TextSize = 13
            sliderText.TextXAlignment = Enum.TextXAlignment.Left
            sliderText.BackgroundTransparency = 1
            sliderText.Position = UDim2.new(0, 4, 0, 0)
            sliderText.Size = UDim2.new(0, 140, 0, 18)
            sliderText.Parent = slider

            local sliderValueText = Instance.new("TextLabel")
            sliderValueText.Name = "SliderValueText"
            sliderValueText.Font = Enum.Font.GothamBold
            sliderValueText.Text = tostring(info.Default or 5) .. (info.Postfix or "")
            sliderValueText.TextColor3 = Color3.fromRGB(214, 214, 214)
            sliderValueText.TextSize = 13
            sliderValueText.TextXAlignment = Enum.TextXAlignment.Right
            sliderValueText.BackgroundTransparency = 1
            sliderValueText.Position = UDim2.new(0, 4, 0, 0)
            sliderValueText.Size = UDim2.new(1, -8, 0, 18)
            sliderValueText.Parent = slider

            local sliderFrames = Instance.new("Frame")
            sliderFrames.Name = "SliderFrames"
            sliderFrames.BackgroundTransparency = 1
            sliderFrames.Position = UDim2.new(0, 4, 0, 20)
            sliderFrames.Size = UDim2.new(1, -8, 0, 12)
            sliderFrames.Parent = slider

            local outerSlider = Instance.new("Frame")
            outerSlider.Name = "OuterSlider"
            outerSlider.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
            outerSlider.BorderSizePixel = 0
            outerSlider.Position = UDim2.new(0, 0, 0.5, -2)
            outerSlider.Size = UDim2.new(1, 0, 0, 4)
            outerSlider.Parent = sliderFrames

            local outerSliderCorner = Instance.new("UICorner")
            outerSliderCorner.CornerRadius = UDim.new(0, 100)
            outerSliderCorner.Parent = outerSlider

            local min = info.Min or 1
            local max = info.Max or 100
            local default = math.clamp(info.Default or 5, min, max)
            local defaultScale = (default - min) / (max - min)

            local innerSlider = Instance.new("Frame")
            innerSlider.Name = "InnerSlider"
            innerSlider.BackgroundColor3 = library.DefaultColor
            innerSlider.BorderSizePixel = 0
            innerSlider.Position = UDim2.new(0, 0, 0.5, -2)
            innerSlider.Size = UDim2.new(defaultScale, 0, 0, 4)
            innerSlider.ZIndex = 2
            innerSlider.Parent = sliderFrames

            local innerSliderCorner = Instance.new("UICorner")
            innerSliderCorner.CornerRadius = UDim.new(0, 100)
            innerSliderCorner.Parent = innerSlider

            local dragSlider = Instance.new("Frame")
            dragSlider.Name = "DragSlider"
            dragSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dragSlider.Position = UDim2.new(defaultScale, -5, 0.5, -5)
            dragSlider.Size = UDim2.fromOffset(10, 10)
            dragSlider.ZIndex = 2
            dragSlider.Parent = sliderFrames

            local dragSliderCorner = Instance.new("UICorner")
            dragSliderCorner.CornerRadius = UDim.new(0, 100)
            dragSliderCorner.Parent = dragSlider

            local dragButton = Instance.new("TextButton")
            dragButton.Name = "DragButton"
            dragButton.Text = ""
            dragButton.BackgroundTransparency = 1
            dragButton.Size = UDim2.new(1.5, 0, 1.5, 0)
            dragButton.Position = UDim2.new(-0.25, 0, -0.25, 0)
            dragButton.Parent = dragSlider

            if info.Callback then pcall(info.Callback, default) end

            dragButton.MouseButton1Down:Connect(function()
                local MouseMove, MouseKill
                MouseMove = Mouse.Move:Connect(function()
                    local Px = library:GetXY(outerSlider)
                    local Value = math.floor(min + ((max - min) * Px))
                    Value = math.clamp(Value, min, max)
                    Px = math.clamp(Px, 0, 1)
                    TweenService:Create(innerSlider, TweenInfo.new(0.1), {Size = UDim2.new(Px, 0, 0, 4)}):Play()
                    TweenService:Create(dragSlider, TweenInfo.new(0.1), {Position = UDim2.new(Px, -5, 0.5, -5)}):Play()
                    sliderValueText.Text = tostring(Value) .. (info.Postfix or "")
                    if info.Callback then pcall(info.Callback, Value) end
                end)
                MouseKill = UserInputService.InputEnded:Connect(function(UserInput)
                    if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseMove:Disconnect()
                        MouseKill:Disconnect()
                    end
                end)
            end)

            optionsHeight = optionsHeight + 38
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
            return slider
        end

        function moduleAPI:CreateDropdown(info)
            local dropdown = Instance.new("Frame")
            dropdown.Name = "Dropdown"
            dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            dropdown.Size = UDim2.new(1, 0, 0, 28)
            dropdown.Parent = moduleOptions

            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 4)
            dropdownCorner.Parent = dropdown

            local dropdownStroke = Instance.new("UIStroke")
            dropdownStroke.Thickness = 1
            dropdownStroke.Color = Color3.fromRGB(80, 80, 80)
            dropdownStroke.Transparency = 0.5
            dropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            dropdownStroke.Enabled = false
            dropdownStroke.Parent = dropdown

            local dropdownText = Instance.new("TextLabel")
            dropdownText.Name = "DropdownText"
            dropdownText.Font = Enum.Font.GothamBold
            dropdownText.Text = (info.Name or "Dropdown") .. " - " .. (info.Default or "Select")
            dropdownText.TextColor3 = Color3.fromRGB(214, 214, 214)
            dropdownText.TextSize = 13
            dropdownText.TextXAlignment = Enum.TextXAlignment.Left
            dropdownText.BackgroundTransparency = 1
            dropdownText.Position = UDim2.new(0, 4, 0, 0)
            dropdownText.Size = UDim2.new(0, 120, 0, 28)
            dropdownText.Parent = dropdown

            local dropdownArrow = Instance.new("ImageLabel")
            dropdownArrow.Name = "DropdownArrow"
            dropdownArrow.Image = "rbxassetid://7733717447"
            dropdownArrow.ImageColor3 = Color3.fromRGB(129, 129, 129)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Position = UDim2.new(1, -20, 0.5, -8)
            dropdownArrow.Size = UDim2.fromOffset(14, 14)
            dropdownArrow.Parent = dropdown

            local dropdownOptions = Instance.new("Frame")
            dropdownOptions.Name = "DropdownOptions"
            dropdownOptions.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            dropdownOptions.BorderSizePixel = 0
            dropdownOptions.ClipsDescendants = true
            dropdownOptions.Position = UDim2.new(0, 0, 1, 2)
            dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
            dropdownOptions.ZIndex = 5
            dropdownOptions.Parent = dropdown

            local dropdownList = Instance.new("UIListLayout")
            dropdownList.Name = "DropdownList"
            dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownList.Parent = dropdownOptions

            local Opened = false
            local DropdownSize = 0

            local function UpdateDropdownSize()
                dropdownOptions.Size = UDim2.new(1, 0, 0, DropdownSize)
            end

            for _, item in pairs(info.List or {}) do
                local option = Instance.new("Frame")
                option.Name = "DropdownOption"
                option.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
                option.Size = UDim2.new(1, 0, 0, 20)
                option.Parent = dropdownOptions

                local optionText = Instance.new("TextLabel")
                optionText.Name = "OptionText"
                optionText.Font = Enum.Font.GothamBold
                optionText.Text = item
                optionText.TextColor3 = Color3.fromRGB(214, 214, 214)
                optionText.TextSize = 12
                optionText.TextXAlignment = Enum.TextXAlignment.Center
                optionText.BackgroundTransparency = 1
                optionText.Size = UDim2.new(1, 0, 1, 0)
                optionText.Parent = option

                local optionButton = Instance.new("TextButton")
                optionButton.Name = "OptionButton"
                optionButton.Text = ""
                optionButton.BackgroundTransparency = 1
                optionButton.Size = UDim2.new(1, 0, 1, 0)
                optionButton.Parent = option

                option.MouseEnter:Connect(function()
                    option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end)
                option.MouseLeave:Connect(function()
                    option.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
                end)

                optionButton.MouseButton1Click:Connect(function()
                    if info.Callback then pcall(info.Callback, item) end
                    dropdownText.Text = (info.Name or "Dropdown") .. " - " .. item
                    Opened = false
                    dropdownArrow.Rotation = 0
                    dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                    dropdownStroke.Enabled = false
                end)

                DropdownSize = DropdownSize + 20
                UpdateDropdownSize()
            end

            local clickBtn = Instance.new("TextButton")
            clickBtn.Name = "ClickButton"
            clickBtn.Text = ""
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.Parent = dropdown

            clickBtn.MouseButton1Click:Connect(function()
                Opened = not Opened
                dropdownArrow.Rotation = Opened and 180 or 0
                dropdownOptions.Size = Opened and UDim2.new(1, 0, 0, DropdownSize) or UDim2.new(1, 0, 0, 0)
                dropdownStroke.Enabled = Opened
            end)

            optionsHeight = optionsHeight + 28
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
            return dropdown
        end

        function moduleAPI:CreateMultiDropdown(info)
            local multidd = Instance.new("Frame")
            multidd.Name = "MultiDropdown"
            multidd.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            multidd.Size = UDim2.new(1, 0, 0, 28)
            multidd.Parent = moduleOptions

            local multiddCorner = Instance.new("UICorner")
            multiddCorner.CornerRadius = UDim.new(0, 4)
            multiddCorner.Parent = multidd

            local multiddStroke = Instance.new("UIStroke")
            multiddStroke.Thickness = 1
            multiddStroke.Color = Color3.fromRGB(80, 80, 80)
            multiddStroke.Transparency = 0.5
            multiddStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            multiddStroke.Enabled = false
            multiddStroke.Parent = multidd

            local multiddText = Instance.new("TextLabel")
            multiddText.Name = "MultiDropdownText"
            multiddText.Font = Enum.Font.GothamBold
            multiddText.Text = (info.Name or "MultiDropdown") .. " - none"
            multiddText.TextColor3 = Color3.fromRGB(214, 214, 214)
            multiddText.TextSize = 13
            multiddText.TextXAlignment = Enum.TextXAlignment.Left
            multiddText.BackgroundTransparency = 1
            multiddText.Position = UDim2.new(0, 4, 0, 0)
            multiddText.Size = UDim2.new(0, 120, 0, 28)
            multiddText.Parent = multidd

            local multiddArrow = Instance.new("ImageLabel")
            multiddArrow.Name = "MultiDropdownArrow"
            multiddArrow.Image = "rbxassetid://7733717447"
            multiddArrow.ImageColor3 = Color3.fromRGB(129, 129, 129)
            multiddArrow.BackgroundTransparency = 1
            multiddArrow.Position = UDim2.new(1, -20, 0.5, -8)
            multiddArrow.Size = UDim2.fromOffset(14, 14)
            multiddArrow.Parent = multidd

            local multiddOptions = Instance.new("Frame")
            multiddOptions.Name = "MultiDropdownOptions"
            multiddOptions.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            multiddOptions.BorderSizePixel = 0
            multiddOptions.ClipsDescendants = true
            multiddOptions.Position = UDim2.new(0, 0, 1, 2)
            multiddOptions.Size = UDim2.new(1, 0, 0, 0)
            multiddOptions.ZIndex = 5
            multiddOptions.Parent = multidd

            local multiddList = Instance.new("UIListLayout")
            multiddList.Name = "MultiDropdownList"
            multiddList.SortOrder = Enum.SortOrder.LayoutOrder
            multiddList.Parent = multiddOptions

            local OpenedMulti = false
            local MultiDropdownSize = 0
            local selectedItems = {}

            local function UpdateMultiDropdownSize()
                multiddOptions.Size = UDim2.new(1, 0, 0, MultiDropdownSize)
            end

            local function fireMultiCallback()
                local selected = {}
                for k,v in pairs(selectedItems) do
                    if v then table.insert(selected, k) end
                end
                if info.Callback then pcall(info.Callback, selected) end
                local count = #selected
                multiddText.Text = (info.Name or "MultiDropdown") .. " - " .. (count > 0 and count.." selected" or "none")
            end

            for _, item in pairs(info.List or {}) do
                selectedItems[item] = false

                local option = Instance.new("Frame")
                option.Name = "MultiDropdownOption"
                option.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
                option.Size = UDim2.new(1, 0, 0, 20)
                option.Parent = multiddOptions

                local optionText = Instance.new("TextLabel")
                optionText.Name = "OptionText"
                optionText.Font = Enum.Font.GothamBold
                optionText.Text = item
                optionText.TextColor3 = Color3.fromRGB(214, 214, 214)
                optionText.TextSize = 12
                optionText.TextXAlignment = Enum.TextXAlignment.Left
                optionText.BackgroundTransparency = 1
                optionText.Position = UDim2.new(0, 20, 0, 0)
                optionText.Size = UDim2.new(1, -20, 1, 0)
                optionText.Parent = option

                local checkBox = Instance.new("Frame")
                checkBox.Name = "CheckBox"
                checkBox.Size = UDim2.fromOffset(12, 12)
                checkBox.Position = UDim2.new(0, 4, 0.5, -6)
                checkBox.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
                checkBox.BorderSizePixel = 0
                checkBox.Parent = option
                local checkCorner = Instance.new("UICorner")
                checkCorner.CornerRadius = UDim.new(0, 2)
                checkCorner.Parent = checkBox

                local checkMark = Instance.new("ImageLabel")
                checkMark.Name = "CheckMark"
                checkMark.Size = UDim2.new(1, -4, 1, -4)
                checkMark.Position = UDim2.new(0, 2, 0, 2)
                checkMark.BackgroundTransparency = 1
                checkMark.Image = "rbxassetid://6031094678"
                checkMark.ImageColor3 = library.DefaultColor
                checkMark.ImageTransparency = 1
                checkMark.Parent = checkBox

                local optionButton = Instance.new("TextButton")
                optionButton.Name = "OptionButton"
                optionButton.Text = ""
                optionButton.BackgroundTransparency = 1
                optionButton.Size = UDim2.new(1, 0, 1, 0)
                optionButton.Parent = option

                option.MouseEnter:Connect(function()
                    option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end)
                option.MouseLeave:Connect(function()
                    option.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
                end)

                optionButton.MouseButton1Click:Connect(function()
                    selectedItems[item] = not selectedItems[item]
                    checkMark.ImageTransparency = selectedItems[item] and 0 or 1
                    checkBox.BackgroundColor3 = selectedItems[item] and library.DefaultColor or Color3.fromRGB(62, 62, 62)
                    fireMultiCallback()
                end)

                MultiDropdownSize = MultiDropdownSize + 20
                UpdateMultiDropdownSize()
            end

            local clickBtn = Instance.new("TextButton")
            clickBtn.Name = "ClickButton"
            clickBtn.Text = ""
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.Parent = multidd

            clickBtn.MouseButton1Click:Connect(function()
                OpenedMulti = not OpenedMulti
                multiddArrow.Rotation = OpenedMulti and 180 or 0
                multiddOptions.Size = OpenedMulti and UDim2.new(1, 0, 0, MultiDropdownSize) or UDim2.new(1, 0, 0, 0)
                multiddStroke.Enabled = OpenedMulti
            end)

            optionsHeight = optionsHeight + 28
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
            return multidd
        end

        function moduleAPI:CreateKeybind(info)
            local onBind = function(key)
                moduleKeybind = key
                keybindDisplay.Text = key.Name
            end
            local _, key = createKeybindControl(moduleOptions, info, onBind)
            moduleKeybind = key
            keybindDisplay.Text = key.Name
            optionsHeight = optionsHeight + 28
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
            return nil
        end

        function moduleAPI:CreateButton(info)
            local btn = Instance.new("Frame")
            btn.Name = "Button"
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.Parent = moduleOptions

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 3)
            btnCorner.Parent = btn

            local btnText = Instance.new("TextLabel")
            btnText.Name = "ButtonText"
            btnText.Font = Enum.Font.GothamBold
            btnText.Text = info.Name or "Button"
            btnText.TextColor3 = Color3.fromRGB(214, 214, 214)
            btnText.TextSize = 13
            btnText.TextXAlignment = Enum.TextXAlignment.Center
            btnText.BackgroundTransparency = 1
            btnText.Size = UDim2.new(1, 0, 1, 0)
            btnText.Parent = btn

            local clickBtn = Instance.new("TextButton")
            clickBtn.Name = "ClickButton"
            clickBtn.Text = ""
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.Parent = btn

            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end)

            clickBtn.MouseButton1Click:Connect(function()
                if info.Callback then pcall(info.Callback) end
            end)

            optionsHeight = optionsHeight + 28
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
            return btn
        end

        function moduleAPI:CreateLabel(info)
            local label = Instance.new("Frame")
            label.Name = "Label"
            label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Parent = moduleOptions

            local labelCorner = Instance.new("UICorner")
            labelCorner.CornerRadius = UDim.new(0, 3)
            labelCorner.Parent = label

            local labelText = Instance.new("TextLabel")
            labelText.Name = "LabelText"
            labelText.Font = Enum.Font.GothamBold
            labelText.Text = info.Name or "Label"
            labelText.TextColor3 = info.Color or Color3.fromRGB(214, 214, 214)
            labelText.TextSize = 12
            labelText.TextXAlignment = Enum.TextXAlignment.Center
            labelText.BackgroundTransparency = 1
            labelText.Size = UDim2.new(1, 0, 1, 0)
            labelText.Parent = label

            optionsHeight = optionsHeight + 20
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
            return label
        end

        local function addDefaultKeybind()
            local onBind = function(key)
                moduleKeybind = key
                keybindDisplay.Text = key.Name
            end
            createKeybindControl(moduleOptions, {
                Text = "Keybind",
                Default = moduleKeybind,
                ToggleModule = true,
                Callback = function()
                end
            }, onBind)
            optionsHeight = optionsHeight + 28
            moduleOptions.Size = UDim2.new(1, 0, 0, optionsHeight + 4)
        end

        local expanded = false
        local function toggleExpand()
            if expandedModule and expandedModule ~= moduleContainer then
                local prev = expandedModule
                expandedModule = nil
                local prevOptions = prev:FindFirstChild("ModuleOptions")
                if prevOptions then
                    prevOptions.Visible = false
                    prev.Size = UDim2.new(0, windowWidth, 0, 38)
                end
                prev:SetAttribute("Expanded", false)
            end

            expanded = not expanded
            moduleContainer:SetAttribute("Expanded", expanded)
            moduleOptions.Visible = expanded
            if expanded then
                expandedModule = moduleContainer
                moduleContainer.Size = UDim2.new(0, windowWidth, 0, 38 + optionsHeight + 4)
            else
                expandedModule = nil
                moduleContainer.Size = UDim2.new(0, windowWidth, 0, 38)
            end
            local totalHeight = 0
            for _, child in ipairs(moduleArea:GetChildren()) do
                if child:IsA("Frame") and child.Visible then
                    totalHeight = totalHeight + child.Size.Y.Offset
                end
            end
            moduleArea.Size = UDim2.new(0, windowWidth, 0, totalHeight)
            tabArea.Size = UDim2.new(0, windowWidth, 0, totalHeight)
            BackgroundSize = totalHeight
        end

        addDefaultKeybind()

        clickButton.MouseButton2Click:Connect(toggleExpand)

        clickButton.MouseButton1Click:Connect(function()
            moduleEnabled = not moduleEnabled
            if Info.Function then pcall(Info.Function, moduleEnabled) end
            moduleButton.BackgroundColor3 = moduleEnabled and library.DefaultColor or Color3.fromRGB(36, 36, 36)
            moduleText.TextColor3 = moduleEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(214, 214, 214)
        end)

        moduleContainer.MouseEnter:Connect(function()
            if not moduleEnabled then
                moduleButton.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
            end
        end)
        moduleContainer.MouseLeave:Connect(function()
            if not moduleEnabled then
                moduleButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            end
        end)

        moduleOptions.Visible = false
        moduleContainer.Size = UDim2.new(0, windowWidth, 0, 38)

        return moduleAPI
    end

    -- ============================================================
    -- STANDARD BUTTON
    -- ============================================================
    function insidewindow:Button(Info)
        local button = Instance.new("Frame")
        button.Name = "Button"
        button.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        button.Size = UDim2.fromOffset(windowWidth, 38)
        button.Parent = moduleArea

        local uICorner2 = Instance.new("UICorner")
        uICorner2.Name = "UICorner"
        uICorner2.CornerRadius = UDim.new(0, 4)
        uICorner2.Parent = button

        local fixLine1 = Instance.new("Frame")
        fixLine1.Name = "FixLine"
        fixLine1.AnchorPoint = Vector2.new(0.5, 1)
        fixLine1.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
        fixLine1.BorderSizePixel = 0
        fixLine1.Position = UDim2.fromScale(0.5, 0.0526)
        fixLine1.Size = UDim2.fromOffset(windowWidth, 4)
        fixLine1.Parent = button

        local buttonTextButton = Instance.new("TextButton")
        buttonTextButton.Name = "ButtonTextButton"
        buttonTextButton.Font = Enum.Font.GothamBold
        buttonTextButton.Text = ""
        buttonTextButton.TextColor3 = Color3.fromRGB(214, 214, 214)
        buttonTextButton.TextSize = 13
        buttonTextButton.AutoButtonColor = false
        buttonTextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        buttonTextButton.BackgroundTransparency = 1
        buttonTextButton.Size = UDim2.fromOffset(windowWidth, 38)
        buttonTextButton.Parent = button

        local buttonTextLabel = Instance.new("TextLabel")
        buttonTextLabel.Name = "ButtonTextLabel"
        buttonTextLabel.Font = Enum.Font.GothamBold
        buttonTextLabel.Text = Info.Text or "Button"
        buttonTextLabel.TextColor3 = Color3.fromRGB(214, 214, 214)
        buttonTextLabel.TextSize = 13
        buttonTextLabel.TextXAlignment = Enum.TextXAlignment.Left
        buttonTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        buttonTextLabel.BackgroundTransparency = 1
        buttonTextLabel.Position = UDim2.fromScale(0.0489, 0)
        buttonTextLabel.Size = UDim2.fromOffset(windowWidth - 10, 38)
        buttonTextLabel.Parent = button

        button.MouseEnter:Connect(function()
            fixLine1.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
            button.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
        end)

        button.MouseLeave:Connect(function()
            fixLine1.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
            button.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        end)

        buttonTextButton.MouseButton1Click:Connect(function()
            if Info.Callback then pcall(Info.Callback) end
        end)
    end

    -- ============================================================
    -- Topbar elements
    -- ============================================================
    local tabName = Instance.new("TextLabel")
    tabName.Name = "TabName"
    tabName.Font = Enum.Font.GothamBold
    tabName.Text = Info.Text
    tabName.TextColor3 = Color3.fromRGB(214, 214, 214)
    tabName.TextSize = 16
    tabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabName.BackgroundTransparency = 1
    tabName.Size = UDim2.fromOffset(windowWidth, 38)
    tabName.Parent = topbar

    local chevron = Instance.new("ImageButton")
    chevron.Name = "Chevron"
    chevron.Image = "rbxassetid://7733717447"
    chevron.Active = true
    chevron.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    chevron.BackgroundTransparency = 1
    chevron.Position = UDim2.new(1, -25, 0.5, -8)
    chevron.Size = UDim2.fromOffset(16, 16)
    chevron.Parent = topbar

    local function toggleTab()
        WindowOpened.Value = not WindowOpened.Value
        tabArea.ClipsDescendants = WindowOpened.Value and false or true
        TweenService:Create(tabArea, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = WindowOpened.Value and UDim2.new(0, windowWidth, 0, BackgroundSize) or UDim2.new(0, windowWidth, 0, 0)}):Play()
        TweenService:Create(chevron, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Rotation = WindowOpened.Value and 0 or 180}):Play()
    end

    chevron.MouseButton1Click:Connect(toggleTab)

    -- Right-click on topbar toggles tab (using InputBegan)
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            toggleTab()
        end
    end)

    return insidewindow
end

-- ============================================================
-- Global keybind for library toggle (RightShift)
-- ============================================================
UserInputService.InputBegan:Connect(function(Key, gameProcessed)
    if Key.KeyCode == LibraryToggleKey and not gameProcessed then
        library:Toggle()
    end
end)

return library
