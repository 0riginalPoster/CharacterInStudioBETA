local toolbar = plugin:CreateToolbar("StudioCharacterPlugin")
local Prereq = require(script.Prereq)

if Prereq.Ready() then
	print("CharacterInStudio Loaded")
	_G.CharacterInStudio = plugin
	
	local Settings = require(script.Settings)
	Settings:Init() --Creates settings variables
	
	require(script.Menu)
	
	local Character = require(script.Character)
	Character.Connect()

	_G.StudioCharacterPlugin.Unloading:Connect(function()
		Character:Disconnect()
	end)
end
