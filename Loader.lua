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

local _getgenv = rawget(_G, "getgenv")
local secureMode = false

if _getgenv then
	local ok, result = pcall(function() return _getgenv().LIBRARY_SECURE end)
	if ok and result then secureMode = true end
end

if secureMode then
	warn = function(...) end
	print = function(...) end
end

local function callSafely(func, ...)
	if func then
		local success, result = pcall(func, ...)
		return if success then result else false
	end
end

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
	
	if isfolder and not callSafely(isfolder, folder) then
		callSafely(makefolder, folder)
	end
	
	local data = {}
	for flag, element in pairs(Library.Elements) do
		if element.Type == "Toggle" then
			data[flag] = element.Value
		elseif element.Type == "Slider" then
			data[flag] = element.Value
		end
	end
	
	callSafely(writefile, folder .. "/" .. file .. ".json", HttpService:JSONEncode(data))
end

function Library:LoadConfiguration()
	if not Library.ConfigSettings.Enabled or not readfile then return end
	local folder = Library.ConfigSettings.Folder
	local file = Library.ConfigSettings.File
	local path = folder .. "/" .. file .. ".json"
	
	if isfile and callSafely(isfile, path) then
		local raw = callSafely(readfile, path)
		if raw then
			local success, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
			if success and type(decoded) == "table" then
				for flag, savedValue in pairs(decoded) do
					local element = Library.Elements[flag]
					if element then
						element:Set(savedValue)
					end
				end
			end
		end
	end
end

function Library:CreateWindow(config)
	config = config or {}
	local windowName = config.Name or "Library Suite"
	local loadingTitle = config.LoadingTitle or "JojoHub Loader"
	local loadingSubtitle = config.LoadingSubtitle or "by JojoHub Team"
	local toggleKey = config.ToggleUIKeybind or "K"
	
	if config.ConfigurationSaving then
		Library.ConfigSettings.Enabled = config.ConfigurationSaving.Enabled or false
		Library.ConfigSettings.Folder = config.ConfigurationSaving.FolderName or "CustomUILibrary"
		Library.ConfigSettings.File = config.ConfigurationSaving.FileName or "Config"
	end
	
	if typeof(toggleKey) == "string" then
		toggleKey = Enum.KeyCode[toggleKey:upper()]
	end

	local WindowData = {
		Visible = true
	}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CustomLibraryUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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
	HubTitle.Name = "HubTitle"
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
	HubSubtitle.Name = "HubSubtitle"
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
	CloseButton.Name = "CloseButton"
	CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.Position = UDim2.new(1, -40, 0, 8)
	CloseButton.BackgroundTransparency = 1
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Library.Theme.TextMuted
	CloseButton.TextSize = 24
	CloseButton.Font = Enum.Font.GothamMedium
	CloseButton.ZIndex = 5
	CloseButton.Parent = MainFrame

	CloseButton.MouseEnter:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(240, 70, 70)}):Play()
	end)

	CloseButton.MouseLeave:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.15), {TextColor3 = Library.Theme.TextMuted}):Play()
	end)

	CloseButton.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 170, 1, 0)
	Sidebar.Position = UDim2.new(1, -170, 0, 0)
	Sidebar.BackgroundColor3 = Library.Theme.Sidebar
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame

	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 10)
	SidebarCorner.Parent = Sidebar

	local SidebarFix = Instance.new("Frame")
	SidebarFix.Size = UDim2.new(0, 10, 1, 0)
	SidebarFix.Position = UDim2.new(0, 0, 0, 0)
	SidebarFix.BackgroundColor3 = Library.Theme.Sidebar
	SidebarFix.BorderSizePixel = 0
	SidebarFix.Parent = Sidebar

	local SidebarDivider = Instance.new("Frame")
	SidebarDivider.Size = UDim2.new(0, 1, 1, -20)
	SidebarDivider.Position = UDim2.new(0, 0, 0, 10)
	SidebarDivider.BackgroundColor3 = Color3.fromRGB(45, 46, 60)
	SidebarDivider.BorderSizePixel = 0
	SidebarDivider.Parent = Sidebar

	local TabButtonContainer = Instance.new("ScrollingFrame")
	TabButtonContainer.Name = "TabButtonContainer"
	TabButtonContainer.Size = UDim2.new(1, -16, 1, -120)
	TabButtonContainer.Position = UDim2.new(0, 12, 0, 55)
	TabButtonContainer.BackgroundTransparency = 1
	TabButtonContainer.BorderSizePixel = 0
	TabButtonContainer.ScrollBarThickness = 0
	TabButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabButtonContainer.Parent = Sidebar

	local TabButtonsLayout = Instance.new("UIListLayout")
	TabButtonsLayout.Padding = UDim.new(0, 6)
	TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabButtonsLayout.Parent = TabButtonContainer

	TabButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabButtonContainer.CanvasSize = UDim2.new(0, 0, 0, TabButtonsLayout.AbsoluteContentSize.Y)
	end)

	local ProfileFrame = Instance.new("Frame")
	ProfileFrame.Name = "ProfileFrame"
	ProfileFrame.Size = UDim2.new(1, -20, 0, 45)
	ProfileFrame.Position = UDim2.new(0, 12, 1, -55)
	ProfileFrame.BackgroundTransparency = 1
	ProfileFrame.Parent = Sidebar

	local ProfilePic = Instance.new("ImageLabel")
	ProfilePic.Name = "ProfilePic"
	ProfilePic.Size = UDim2.new(0, 34, 0, 34)
	ProfilePic.Position = UDim2.new(0, 0, 0.5, -17)
	ProfilePic.BackgroundColor3 = Library.Theme.ElementBg
	ProfilePic.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
	ProfilePic.Parent = ProfileFrame

	local ProfilePicCorner = Instance.new("UICorner")
	ProfilePicCorner.CornerRadius = UDim.new(1, 0)
	ProfilePicCorner.Parent = ProfilePic

	local ProfileName = Instance.new("TextLabel")
	ProfileName.Name = "ProfileName"
	ProfileName.Size = UDim2.new(1, -42, 0, 16)
	ProfileName.Position = UDim2.new(0, 42, 0, 4)
	ProfileName.BackgroundTransparency = 1
	ProfileName.Text = LocalPlayer.DisplayName
	ProfileName.TextColor3 = Library.Theme.Text
	ProfileName.TextSize = 13
	ProfileName.Font = Enum.Font.GothamBold
	ProfileName.TextXAlignment = Enum.TextXAlignment.Left
	ProfileName.Parent = ProfileFrame

	local ProfileUser = Instance.new("TextLabel")
	ProfileUser.Name = "ProfileUser"
	ProfileUser.Size = UDim2.new(1, -42, 0, 14)
	ProfileUser.Position = UDim2.new(0, 42, 0, 20)
	ProfileUser.BackgroundTransparency = 1
	ProfileUser.Text = "@" .. LocalPlayer.Name
	ProfileUser.TextColor3 = Library.Theme.TextMuted
	ProfileUser.TextSize = 11
	ProfileUser.Font = Enum.Font.GothamMedium
	ProfileUser.TextXAlignment = Enum.TextXAlignment.Left
	ProfileUser.Parent = ProfileFrame

	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -190, 1, -65)
	ContentArea.Position = UDim2.new(0, 15, 0, 55)
	ContentArea.BackgroundTransparency = 1
	ContentArea.Parent = MainFrame

	local dragging, dragInput, dragStart, startPosition

	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPosition = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	Topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(
				startPosition.X.Scale, 
				startPosition.X.Offset + delta.X, 
				startPosition.Y.Scale, 
				startPosition.Y.Offset + delta.Y
			)
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
		TabPage.Name = tabName .. "_Page"
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 4
		TabPage.ScrollBarImageColor3 = Library.Theme.Accent
		TabPage.Visible = false
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabPage.Parent = ContentArea

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = TabPage

		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
		end)

		local TabButton = Instance.new("Frame")
		TabButton.Name = tabName .. "_TabButton"
		TabButton.Size = UDim2.new(1, -6, 0, 34)
		TabButton.BackgroundColor3 = Library.Theme.Sidebar
		TabButton.BackgroundTransparency = 1
		TabButton.BorderSizePixel = 0
		TabButton.Parent = TabButtonContainer

		local ButtonCorner = Instance.new("UICorner")
		ButtonCorner.CornerRadius = UDim.new(0, 6)
		ButtonCorner.Parent = TabButton

		local TabLabel = Instance.new("TextLabel")
		TabLabel.Size = UDim2.new(1, -12, 1, 0)
		TabLabel.Position = UDim2.new(0, 8)
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
				TweenService:Create(activeTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Sidebar, BackgroundTransparency = 1}):Play()
				TweenService:Create(activeTab.Label, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextMuted}):Play()
			end

			activeTab = TabData
			TabPage.Visible = true
			TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.ElementBg, BackgroundTransparency = 0}):Play()
			TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
		end

		ClickArea.MouseButton1Click:Connect(activate)

		ClickArea.MouseEnter:Connect(function()
			if activeTab ~= TabData then
				TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Library.Theme.Text}):Play()
			end
		end)

		ClickArea.MouseLeave:Connect(function()
			if activeTab ~= TabData then
				TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Library.Theme.TextMuted}):Play()
			end
		end)

		TabData = {
			Page = TabPage,
			Button = TabButton,
			Label = TabLabel
		}

		tabs[tabName] = TabData
		if not activeTab then activate() end

		function TabData:CreateButton(options)
			options = options or {}
			local text = options.Name or "Button"
			local callback = options.Callback or function() end

			local ButtonBg = Instance.new("Frame")
			ButtonBg.Size = UDim2.new(1, -10, 0, 38)
			ButtonBg.BackgroundColor3 = Library.Theme.ElementBg
			ButtonBg.BorderSizePixel = 0
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
			TextLabel.TextSize = 13
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = ButtonBg

			local ClickButton = Instance.new("TextButton")
			ClickButton.Size = UDim2.new(1, 0, 1, 0)
			ClickButton.BackgroundTransparency = 1
			ClickButton.Text = ""
			ClickButton.Parent = ButtonBg

			ClickButton.MouseEnter:Connect(function()
				TweenService:Create(ButtonBg, TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme.ElementHover}):Play()
			end)
			ClickButton.MouseLeave:Connect(function()
				TweenService:Create(ButtonBg, TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme.ElementBg}):Play()
			end)
			ClickButton.MouseButton1Down:Connect(function()
				TweenService:Create(ButtonBg, TweenInfo.new(0.05), {Size = UDim2.new(1, -14, 0, 36)}):Play()
			end)
			ClickButton.MouseButton1Up:Connect(function()
				TweenService:Create(ButtonBg, TweenInfo.new(0.05), {Size = UDim2.new(1, -10, 0, 38)}):Play()
				task.spawn(callback)
			end)
		end

		function TabData:CreateToggle(options)
			options = options or {}
			local text = options.Name or "Toggle"
			local toggled = options.CurrentValue or false -- UPDATED: Now supports CurrentValue from documentation
			local callback = options.Callback or function() end
			local flag = options.Flag

			local ToggleBg = Instance.new("Frame")
			ToggleBg.Size = UDim2.new(1, -10, 0, 38)
			ToggleBg.BackgroundColor3 = Library.Theme.ElementBg
			ToggleBg.BorderSizePixel = 0
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
			TextLabel.TextSize = 13
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = ToggleBg

			local StatusBox = Instance.new("Frame")
			StatusBox.Size = UDim2.new(0, 32, 0, 16)
			StatusBox.Position = UDim2.new(1, -44, 0.5, -8)
			StatusBox.BackgroundColor3 = toggled and Library.Theme.ToggleOn or Library.Theme.ToggleOff
			StatusBox.BorderSizePixel = 0
			StatusBox.Parent = ToggleBg

			local StatusCorner = Instance.new("UICorner")
			StatusCorner.CornerRadius = UDim.new(1, 0)
			StatusCorner.Parent = StatusBox

			local Circle = Instance.new("Frame")
			Circle.Size = UDim2.new(0, 10, 0, 10)
			Circle.Position = toggled and UDim2.new(1, -14, 0.5, -5) or UDim2.new(0, 4, 0.5, -5)
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.BorderSizePixel = 0
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

			local function updateToggle(isLoad)
				local targetColor = ToggleObject.Value and Library.Theme.ToggleOn or Library.Theme.ToggleOff
				local targetPos = ToggleObject.Value and UDim2.new(1, -14, 0.5, -5) or UDim2.new(0, 4, 0.5, -5)

				TweenService:Create(StatusBox, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()

				if flag then
					Library.Flags[flag] = ToggleObject.Value
				end
				
				if not isLoad then
					Library:SaveConfiguration()
				end
				task.spawn(callback, ToggleObject.Value)
			end

			function ToggleObject:Set(bool)
				ToggleObject.Value = bool
				updateToggle(true)
			end

			if flag then
				Library.Flags[flag] = toggled
				Library.Elements[flag] = ToggleObject
			end

			ClickButton.MouseEnter:Connect(function()
				TweenService:Create(ToggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme.ElementHover}):Play()
			end)
			ClickButton.MouseLeave:Connect(function()
				TweenService:Create(ToggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme.ElementBg}):Play()
			end)

			ClickButton.MouseButton1Click:Connect(function()
				ToggleObject.Value = not ToggleObject.Value
				updateToggle(false)
			end)
		end

		function TabData:CreateSlider(options)
			options = options or {}
			local text = options.Name or "Slider"
			
			-- UPDATED: Pulls Min and Max from your documented Range array style {0, 100}
			local rangeTable = options.Range or {0, 100}
			local min = rangeTable[1] or 0
			local max = rangeTable[2] or 100
			local default = options.CurrentValue or min -- UPDATED: Uses CurrentValue from documentation
			
			local callback = options.Callback or function() end
			local flag = options.Flag

			local SliderBg = Instance.new("Frame")
			SliderBg.Size = UDim2.new(1, -10, 0, 45)
			SliderBg.BackgroundColor3 = Library.Theme.ElementBg
			SliderBg.BorderSizePixel = 0
			SliderBg.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = SliderBg

			local TextLabel = Instance.new("TextLabel")
			TextLabel.Size = UDim2.new(1, -100, 0, 20)
			TextLabel.Position = UDim2.new(0, 12, 0, 4)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = text
			TextLabel.TextColor3 = Library.Theme.Text
			TextLabel.TextSize = 13
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = SliderBg

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(0, 60, 0, 20)
			ValueLabel.Position = UDim2.new(1, -72, 0, 4)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(default)
			ValueLabel.TextColor3 = Library.Theme.Accent
			ValueLabel.TextSize = 13
			ValueLabel.Font = Enum.Font.GothamBold
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderBg

			local SliderTrack = Instance.new("TextButton")
			SliderTrack.Name = "SliderTrack"
			SliderTrack.Size = UDim2.new(1, -24, 0, 6)
			SliderTrack.Position = UDim2.new(0, 12, 0, 28)
			SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 52, 65)
			SliderTrack.BorderSizePixel = 0
			SliderTrack.Text = ""
			SliderTrack.AutoButtonColor = false
			SliderTrack.Parent = SliderBg

			local TrackCorner = Instance.new("UICorner")
			TrackCorner.CornerRadius = UDim.new(1, 0)
			TrackCorner.Parent = SliderTrack

			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			SliderFill.BackgroundColor3 = Library.Theme.Accent
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderTrack

			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = SliderFill

			local SliderObject = {Type = "Slider", Value = default}
			local Sliding = false

			local function move(input, isLoad)
				local scale
				if input then
					local absPos = SliderTrack.AbsolutePosition.X
					local absSize = SliderTrack.AbsoluteSize.X
					scale = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
					SliderObject.Value = math.floor(min + (max - min) * scale)
				else
					scale = math.clamp((SliderObject.Value - min) / (max - min), 0, 1)
				end

				SliderFill.Size = UDim2.new(scale, 0, 1, 0)
				ValueLabel.Text = tostring(SliderObject.Value)
				
				if flag then
					Library.Flags[flag] = SliderObject.Value
				end
				
				if not isLoad then
					Library:SaveConfiguration()
				end
				task.spawn(callback, SliderObject.Value)
			end

			function SliderObject:Set(val)
				SliderObject.Value = math.clamp(val, min, max)
				move(nil, true)
			end

			if flag then
				Library.Flags[flag] = default
				Library.Elements[flag] = SliderObject
			end

			SliderTrack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					move(input, false)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if Sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
					move(input, false)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
				end
			end)
		end

		function TabData:CreateKeybind(options)
			options = options or {}
			local text = options.Name or "Keybind"
			local currentKey = options.CurrentKeybind or "None" -- UPDATED: Uses CurrentKeybind from documentation
			local callback = options.Callback or function() end

			if typeof(currentKey) == "EnumItem" then
				currentKey = currentKey.Name
			end

			local KeybindBg = Instance.new("Frame")
			KeybindBg.Size = UDim2.new(1, -10, 0, 38)
			KeybindBg.BackgroundColor3 = Library.Theme.ElementBg
			KeybindBg.BorderSizePixel = 0
			KeybindBg.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 6)
			Corner.Parent = KeybindBg

			local TextLabel = Instance.new("TextLabel")
			TextLabel.Size = UDim2.new(1, -100, 1, 0)
			TextLabel.Position = UDim2.new(0, 12, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = text
			TextLabel.TextColor3 = Library.Theme.Text
			TextLabel.TextSize = 13
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = KeybindBg

			local BindBox = Instance.new("Frame")
			BindBox.Size = UDim2.new(0, 70, 0, 24)
			BindBox.Position = UDim2.new(1, -82, 0.5, -12)
			BindBox.BackgroundColor3 = Color3.fromRGB(48, 49, 64)
			BindBox.BorderSizePixel = 0
			BindBox.Parent = KeybindBg

			local BindCorner = Instance.new("UICorner")
			BindCorner.CornerRadius = UDim.new(0, 4)
			BindCorner.Parent = BindBox

			local BindLabel = Instance.new("TextLabel")
			BindLabel.Size = UDim2.new(1, 0, 1, 0)
			BindLabel.BackgroundTransparency = 1
			BindLabel.Text = currentKey
			BindLabel.TextColor3 = Library.Theme.Accent
			BindLabel.TextSize = 12
			BindLabel.Font = Enum.Font.GothamBold
			BindLabel.Parent = BindBox

			local ClickButton = Instance.new("TextButton")
			ClickButton.Size = UDim2.new(1, 0, 1, 0)
			ClickButton.BackgroundTransparency = 1
			ClickButton.Text = ""
			ClickButton.Parent = KeybindBg

			local Listening = false

			ClickButton.MouseButton1Click:Connect(function()
				Listening = true
				BindLabel.Text = "..."
				BindLabel.TextColor3 = Library.Theme.TextMuted
			end)

			UserInputService.InputBegan:Connect(function(input, processed)
				if Listening and not processed then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						Listening = false
						currentKey = input.KeyCode.Name
						BindLabel.Text = currentKey
						BindLabel.TextColor3 = Library.Theme.Accent
					end
				elseif not Listening and not processed then
					if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
						task.spawn(callback)
					end
				end
			end)
		end

		return TabData
	end

	return WindowData
end

return Library
