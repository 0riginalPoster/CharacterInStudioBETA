local Menu = {}

local Settings = require(script.Parent.Settings)
local Character = require(script.Parent.Character)
 
Menu.Toolbar = _G.CharacterInStudio:CreateToolbar("Studio Character")
Menu.ButtonCharacterSettings = Menu.Toolbar:CreateButton("Character Settings", "Configure your character", "rbxassetid://5882460669")
Menu.WidgetCharacterSettings = _G.CharacterInStudio:CreateDockWidgetPluginGui(
	"CharacterSettings", 
	DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Left,
		true,
		false,
		200,
		300,
		150,
		150
	)
)

Menu.ButtonCharacterSettings:SetActive(Menu.WidgetCharacterSettings.Enabled)

--Open/Close Button
Menu.ButtonCharacterSettings.Click:Connect(function()
	Menu.WidgetCharacterSettings.Enabled = not Menu.WidgetCharacterSettings.Enabled
	Menu.ButtonCharacterSettings:SetActive(Menu.WidgetCharacterSettings.Enabled)
end)

--Widget Content
local studioWidgets = require(1638103268)

local VerticallyScalingListFrameClass = studioWidgets.VerticallyScalingListFrame
local LabeledCheckboxClass = studioWidgets.LabeledCheckbox
local LabeledTextInputClass = studioWidgets.LabeledTextInput
local CollapsibleTitledSectionClass = studioWidgets.CollapsibleTitledSection
local GuiUtil = studioWidgets.GuiUtilities

local ScrollerBodyList = VerticallyScalingListFrameClass.new("BodyList")
local ScrollerBodyNew = Instance.new("ScrollingFrame")
ScrollerBodyNew.Size = UDim2.new(1,0,1,0)
ScrollerBodyNew.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
ScrollerBodyNew.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollerBodyNew.ScrollBarImageColor3 = Color3.fromRGB(62,62,62)
ScrollerBodyNew.ScrollBarThickness = 8
local ScrollerBodyListLayout = Instance.new("UIListLayout")
ScrollerBodyListLayout.Parent = ScrollerBodyNew

ScrollerBodyListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollerBodyNew.CanvasSize = UDim2.new(1, 0, 1, ScrollerBodyListLayout.AbsoluteContentSize.Y/3)
end)

--CharacterSettings Section
local SectionCharacterSettings = CollapsibleTitledSectionClass.new("CharacterSettings", "Character Settings", true, true)
Menu.TextboxCharacterWidth = LabeledTextInputClass.new("CharacterWidth", "Character Width", tostring(Settings:GetWidth()))
Menu.TextboxCharacterHeight = LabeledTextInputClass.new("CharacterHeight", "Character Height", tostring(Settings:GetHeight()))
Menu.TextboxCharacterDepth = LabeledTextInputClass.new("CharacterDepth", "Character Depth", tostring(Settings:GetDepth()))
Menu.TextboxCharacterHeadScale = LabeledTextInputClass.new("CharacterHeadScale", "Head Scale", tostring(Settings:GetHeadScale()))

--User Appearance Section
local SectionUserAppearance = CollapsibleTitledSectionClass.new("UserAppearance", "User Appearance", true, true)
Menu.DescriptionUserAppearance = Instance.new("TextLabel")
Menu.DescriptionUserAppearance.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Menu.DescriptionUserAppearance.Text = "Enter the Name or UserId of a player below to use their avatar."
Menu.DescriptionUserAppearance.TextSize = 12.5
Menu.DescriptionUserAppearance.TextWrapped = true
Menu.DescriptionUserAppearance.TextColor3 = Color3.fromRGB(255,255,255)
Menu.DescriptionUserAppearance.Size = UDim2.new(1,0,0,60)

Menu.CheckboxUserAppearanceEnabled = LabeledCheckboxClass.new("UserAppearanceEnabled", "Enabled", tostring(Settings:GetUserAppearanceEnabled()))

Menu.TextboxUserAppearance = LabeledTextInputClass.new("UserAppearance", "User Appearance", tostring(Settings:GetUserAppearance()))

--Place in sections
local function SetGuisInSection(objs, section)
	local background = Instance.new("Frame")
	background.BackgroundColor3 = objs[1].BackgroundColor3
	background.Size = UDim2.new(1, 0, 1, 0)
	background.ZIndex = -10
	background.Parent = Menu.WidgetCharacterSettings
	GuiUtil.syncGuiElementBackgroundColor(background)

	local totalLength = 0
		
	for i, obj in pairs(objs)do
		local Frame = obj
		Frame.Position = UDim2.new(0, 0, 0, totalLength)
		Frame.Parent = section:GetContentsFrame()
		totalLength = totalLength + Frame.Size.Y.Offset
	end
	section:GetContentsFrame().Size = UDim2.new(1,0,0,totalLength) --Makes Content Frame (Contains things under title bar) match content's size
end

--Character Settings Section
SetGuisInSection({Menu.TextboxCharacterWidth:GetFrame(), Menu.TextboxCharacterHeight:GetFrame(), Menu.TextboxCharacterDepth:GetFrame(), Menu.TextboxCharacterHeadScale:GetFrame()}, SectionCharacterSettings)
SectionCharacterSettings:GetSectionFrame().Parent = ScrollerBodyNew

SetGuisInSection({Menu.DescriptionUserAppearance, Menu.CheckboxUserAppearanceEnabled:GetFrame(), Menu.TextboxUserAppearance:GetFrame()}, SectionUserAppearance)
SectionUserAppearance:GetSectionFrame().Parent = ScrollerBodyNew

ScrollerBodyNew.Parent = Menu.WidgetCharacterSettings

--Filters
function FilterToNumber(textbox, value)
	local NumericString = value:match("%d[%d.]*") or ""
	if value:sub(1,1) == "-" then
		NumericString = "-" .. NumericString
	end
	textbox:SetValue(NumericString)
end
function UserFilter(textbox, value)
	local FilteredString = value:gsub("[^%w_]+", "") or "" -- "Term" or "Term_Term2" for username format
	
	textbox:SetValue(FilteredString)
end

--Filter Input
Menu.TextboxCharacterWidth:SetValueChangedFunction(function(value)
	FilterToNumber(Menu.TextboxCharacterWidth, value)
end)
Menu.TextboxCharacterHeight:SetValueChangedFunction(function(value)
	FilterToNumber(Menu.TextboxCharacterHeight, value)
end)
Menu.TextboxCharacterDepth:SetValueChangedFunction(function(value)
	FilterToNumber(Menu.TextboxCharacterDepth, value)
end)
Menu.TextboxUserAppearance:SetValueChangedFunction(function(value)
	UserFilter(Menu.TextboxUserAppearance, value)
end)

--Update Settings to reflect GUI input
--Character Settings
Menu.TextboxCharacterWidth:GetFrame().Wrapper.TextBox.FocusLost:Connect(function()
	Settings:SetWidth(Menu.TextboxCharacterWidth:GetValue())
	Character:Reconnect()
end)
Menu.TextboxCharacterHeight:GetFrame().Wrapper.TextBox.FocusLost:Connect(function()
	Settings:SetHeight(Menu.TextboxCharacterHeight:GetValue())
	Character:Reconnect()
end)
Menu.TextboxCharacterDepth:GetFrame().Wrapper.TextBox.FocusLost:Connect(function()
	Settings:SetDepth(Menu.TextboxCharacterDepth:GetValue())
	Character:Reconnect()
end)
Menu.TextboxCharacterHeadScale:GetFrame().Wrapper.TextBox.FocusLost:Connect(function()
	Settings:SetHeadScale(Menu.TextboxCharacterHeadScale:GetValue())
	Character:Reconnect()
end)

--User Appearance
Menu.CheckboxUserAppearanceEnabled._button.MouseButton1Down:Connect(function()
	Settings:SetLoadingState(true)
	Settings:SetUserAppearanceEnabled(not Menu.CheckboxUserAppearanceEnabled:GetValue())
	Character:Reconnect()
end)
Menu.TextboxUserAppearance._textBox.FocusLost:Connect(function()
	Settings:SetLoadingState(true) 
	Settings:SetUserAppearance(Menu.TextboxUserAppearance:GetValue())
	Character:Reconnect()
end)

return Menu