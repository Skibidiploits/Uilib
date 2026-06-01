-- =============================================================================
-- [ JOJOHUB UI LIBRARY ENGINE - LOADER.LUA ]
-- =============================================================================
local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local HttpService = getService("HttpService")
local RunService = getService("RunService")
local LocalPlayer = Players.LocalPlayer

local Library = {
	Flags = {},
	Elements = {},
	ConfigSettings = {
		Enabled = false,
		Folder = "CustomUILibrary",
		File = "Config"
	},
	Theme = {
		Background = Color3.fromRGB(24, 25, 32),
		Sidebar = Color3.fromRGB(30, 31, 41),
		Accent = Color3.fromRGB(115, 100, 230),
		ElementBg = Color3.fromRGB(34, 35, 46),
		ElementHover = Color3.fromRGB(42, 43, 57),
		Text = Color3.fromRGB(240, 240, 245),
		TextMuted = Color3.fromRGB(140, 142, 155),
		ToggleOn = Color3.fromRGB(46, 204, 113),
		ToggleOff = Color3.fromRGB(50, 52, 65)
	}
}

function Library:SaveConfiguration()
	if not Library.ConfigSettings.Enabled or not writefile then return end
	local folder = Library.ConfigSettings.Folder
	local file = Library.ConfigSettings.File
	if isfolder and not pcall(isfolder, folder) then pcall(makefolder, folder) end
	local data = {}
	for flag, element in pairs(Library.Elements) do
		if element.Type == "Toggle" or element.Type == "Slider" then data[flag] = element.Value end
	end
	pcall(writefile, folder .. "/" .. file .. ".json", HttpService:JSONEncode(data))
end

function Library:CreateWindow(config)
	config = config or {}
	local windowName = config.Name or "Library Suite"
	local loadingSubtitle = config.LoadingSubtitle or "by JojoHub Team"
	local toggleKey = config.ToggleUIKeybind or "K"
	
	if config.ConfigurationSaving then
		Library.ConfigSettings.Enabled = config.ConfigurationSaving.Enabled or false
		Library.ConfigSettings.Folder = config.ConfigurationSaving.FolderName or "CustomUILibrary"
		Library.ConfigSettings.File = config.ConfigurationSaving.FileName or "Config"
	end
	if typeof(toggleKey) == "string" then toggleKey = Enum.KeyCode[toggleKey:upper()] end

	local WindowData = { Visible = true }

	-- [[ FIXED: NATIVE HIGH-PRIORITY LAYER IMPLEMENTATION ]]
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CustomLibraryUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	ScreenGui.DisplayOrder = 99999 -- Keeps UI on top of game textures
	ScreenGui.Parent = game:GetService("CoreGui") -- Safe execution environment injection

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 600, 0, 420)
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
	MainFrame.BackgroundColor3 = Library.Theme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainFrame

	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 45)
	Topbar.BackgroundTransparency = 1
	Topbar.BorderSizePixel = 0
	Topbar.Parent = MainFrame

	local HubTitle = Instance.new("TextLabel")
	HubTitle.Size = UDim2.new(0, 200, 0, 22)
	HubTitle.Position = UDim2.new(0, 16, 0, 8)
	HubTitle.BackgroundTransparency = 1
	HubTitle.Text = windowName
	HubTitle.TextColor3 = Library.Theme.Text
	HubTitle.TextSize = 16
	HubTitle.Font = Enum.Font.GothamBold
	HubTitle.TextXAlignment = Enum.TextXAlignment.Left
	HubTitle.Parent = Topbar

	local HubSubtitle = Instance.new("TextLabel")
	HubSubtitle.Size = UDim2.new(0, 200, 0, 14)
	HubSubtitle.Position = UDim2.new(0, 16, 0, 26)
	HubSubtitle.BackgroundTransparency = 1
	HubSubtitle.Text = loadingSubtitle
	HubSubtitle.TextColor3 = Library.Theme.TextMuted
	HubSubtitle.TextSize = 11
	HubSubtitle.Font = Enum.Font.GothamMedium
	HubSubtitle.TextXAlignment = Enum.TextXAlignment.Left
	HubSubtitle.Parent = Topbar

	local CloseButton = Instance.new("TextButton")
	CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.Position = UDim2.new(1, -40, 0, 8)
	CloseButton.BackgroundTransparency = 1
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Library.Theme.TextMuted
	CloseButton.TextSize = 24
	CloseButton.Font = Enum.Font.GothamMedium
	CloseButton.Parent = MainFrame

	CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, 170, 1, 0)
	Sidebar.Position = UDim2.new(1, -170, 0, 0)
	Sidebar.BackgroundColor3 = Library.Theme.Sidebar
	Sidebar.Parent = MainFrame

	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 10)
	SidebarCorner.Parent = Sidebar

	local TabButtonContainer = Instance.new("ScrollingFrame")
	TabButtonContainer.Size = UDim2.new(1, -16, 1, -120)
	TabButtonContainer.Position = UDim2.new(0, 12, 0, 55)
	TabButtonContainer.BackgroundTransparency = 1
	TabButtonContainer.ScrollBarThickness = 0
	TabButtonContainer.Parent = Sidebar

	local TabButtonsLayout = Instance.new("UIListLayout")
	TabButtonsLayout.Padding = UDim.new(0, 6)
	TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabButtonsLayout.Parent = TabButtonContainer

	TabButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabButtonContainer.CanvasSize = UDim2.new(0, 0, 0, TabButtonsLayout.AbsoluteContentSize.Y)
	end)

	local ContentArea = Instance.new("Frame")
	ContentArea.Size = UDim2.new(1, -190, 1, -65)
	ContentArea.Position = UDim2.new(0, 15, 0, 55)
	ContentArea.BackgroundTransparency = 1
	ContentArea.Parent = MainFrame

	-- Dragging Systems
	local dragging, dragInput, dragStart, startPosition
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPosition = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	Topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == toggleKey then
			WindowData.Visible = not WindowData.Visible
			MainFrame.Visible = WindowData.Visible
		end
	end)

	local tabs = {}
	local activeTab = nil

	function WindowData:CreateTab(tabName)
		local TabData = {}
		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.ScrollBarThickness = 4
		TabPage.ScrollBarImageColor3 = Library.Theme.Accent
		TabPage.Visible = false
		TabPage.Parent = ContentArea

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.Parent = TabPage

		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
		end)

		local TabButton = Instance.new("Frame")
		TabButton.Size = UDim2.new(1, -6, 0, 34)
		TabButton.BackgroundTransparency = 1
		TabButton.Parent = TabButtonContainer

		local TabLabel = Instance.new("TextLabel")
		TabLabel.Size = UDim2.new(1, -12, 1, 0)
		TabLabel.Position = UDim2.new(0, 8, 0, 0)
		TabLabel.BackgroundTransparency = 1
		TabLabel.Text = tabName
		TabLabel.TextColor3 = Library.Theme.TextMuted
		TabLabel.TextSize = 13
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.Parent = TabButton

		local ClickArea = Instance.new("TextButton")
		ClickArea.Size = UDim2.new(1, 0, 1, 0)
		ClickArea.BackgroundTransparency = 1
		ClickArea.Text = ""
		ClickArea.Parent = TabButton

		local function activate()
			if activeTab == TabData then return end
			if activeTab then
				activeTab.Page.Visible = false
				activeTab.Button.BackgroundTransparency = 1
				activeTab.Label.TextColor3 = Library.Theme.TextMuted
			end
			activeTab = TabData
			TabPage.Visible = true
			TabButton.BackgroundColor3 = Library.Theme.ElementBg
			TabButton.BackgroundTransparency = 0
			TabLabel.TextColor3 = Library.Theme.Text
		end
		ClickArea.MouseButton1Click:Connect(activate)

		TabData = { Page = TabPage, Button = TabButton, Label = TabLabel }
		tabs[tabName] = TabData
		if not activeTab then activate() end

		function TabData:CreateButton(options)
			local text = options.Name or "Button"
			local callback = options.Callback or function() end

			local ButtonBg = Instance.new("Frame")
			ButtonBg.Size = UDim2.new(1, -10, 0, 38)
			ButtonBg.BackgroundColor3 = Library.Theme.ElementBg
			ButtonBg.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = ButtonBg

			local TextLabel = Instance.new("TextLabel")
			TextLabel.Size = UDim2.new(1, -20, 1, 0)
			TextLabel.Position = UDim2.new(0, 12, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = text
			TextLabel.TextColor3 = Library.Theme.Text
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = ButtonBg

			local ClickButton = Instance.new("TextButton")
			ClickButton.Size = UDim2.new(1, 0, 1, 0)
			ClickButton.BackgroundTransparency = 1
			ClickButton.Text = ""
			ClickButton.Parent = ButtonBg

			ClickButton.MouseButton1Click:Connect(function() task.spawn(callback) end)
		end

		function TabData:CreateToggle(options)
			local text = options.Name or "Toggle"
			local toggled = options.CurrentValue or false
			local callback = options.Callback or function() end
			local flag = options.Flag

			local ToggleBg = Instance.new("Frame")
			ToggleBg.Size = UDim2.new(1, -10, 0, 38)
			ToggleBg.BackgroundColor3 = Library.Theme.ElementBg
			ToggleBg.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = ToggleBg

			local TextLabel = Instance.new("TextLabel")
			TextLabel.Size = UDim2.new(1, -60, 1, 0)
			TextLabel.Position = UDim2.new(0, 12, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = text
			TextLabel.TextColor3 = Library.Theme.Text
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = ToggleBg

			local StatusBox = Instance.new("Frame")
			StatusBox.Size = UDim2.new(0, 32, 0, 16)
			StatusBox.Position = UDim2.new(1, -44, 0.5, -8)
			StatusBox.BackgroundColor3 = toggled and Library.Theme.ToggleOn or Library.Theme.ToggleOff
			StatusBox.Parent = ToggleBg

			local StatusCorner = Instance.new("UICorner")
			StatusCorner.CornerRadius = UDim.new(1, 0)
			StatusCorner.Parent = StatusBox

			local Circle = Instance.new("Frame")
			Circle.Size = UDim2.new(0, 10, 0, 10)
			Circle.Position = toggled and UDim2.new(1, -14, 0.5, -5) or UDim2.new(0, 4, 0.5, -5)
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Parent = StatusBox

			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = Circle

			local ClickButton = Instance.new("TextButton")
			ClickButton.Size = UDim2.new(1, 0, 1, 0)
			ClickButton.BackgroundTransparency = 1
			ClickButton.Text = ""
			ClickButton.Parent = ToggleBg

			local ToggleObject = {Type = "Toggle", Value = toggled}

			local function updateToggle()
				local targetColor = ToggleObject.Value and Library.Theme.ToggleOn or Library.Theme.ToggleOff
				local targetPos = ToggleObject.Value and UDim2.new(1, -14, 0.5, -5) or UDim2.new(0, 4, 0.5, -5)
				StatusBox.BackgroundColor3 = targetColor
				Circle.Position = targetPos
				if flag then Library.Flags[flag] = ToggleObject.Value end
				task.spawn(callback, ToggleObject.Value)
			end

			ClickButton.MouseButton1Click:Connect(function()
				ToggleObject.Value = not ToggleObject.Value
				updateToggle()
			end)
		end

		return TabData
	end
	return WindowData
end

return Library
