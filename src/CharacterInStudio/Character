local Character = {}

local RunServ = game:GetService("RunService")
local PlayerServ = game:GetService("Players")

local Settings = require(script.Parent.Settings)

Character.Container = nil
Character.CharacterObject = nil
Character._connection = nil

function Character:CreateContainer()
	self.Container = Instance.new("BloomEffect")
	self.Container.Name = PlayerServ.LocalPlayer.Name .. "'s Character"
	self.Container.Parent = workspace
end

function Character:GetContainer()
	if self.Container == nil then
		self:CreateContainer()
	elseif self.Container.Parent ~= workspace then
		self.Container.Parent = workspace
	end
	return(self.Container)
end

function Character:CreateCharacter()
	self.CharacterObject = script.Parent.DefaultRig:Clone()
	self.CharacterObject.Parent = self.Container
	
	local HumanoidDescription = PlayerServ:GetHumanoidDescriptionFromUserId(PlayerServ.LocalPlayer.UserId)
	
	--print("Enabled?: " .. tostring(Settings:GetUserAppearanceEnabled()))
	if Settings:GetUserAppearanceEnabled() == true then
		--print(Settings:GetUserAppearance())
		if tonumber(Settings:GetUserAppearance()) == true then
			--print("UserId")
			local success = pcall(function()
				PlayerServ:GetPlayerByUserId(Settings:GetUserAppearance())
			end)
			if success then
				HumanoidDescription = PlayerServ:GetHumanoidDescriptionFromUserId(Settings:GetUserAppearance())
			end
		else
			local success, userId = pcall(function()
				return(PlayerServ:GetUserIdFromNameAsync(Settings:GetUserAppearance()))
			end)
			if success then
				HumanoidDescription = PlayerServ:GetHumanoidDescriptionFromUserId(userId)
			end
		end
	end
	
	--Scaling inputs
	HumanoidDescription.WidthScale = Settings:GetWidth()
	HumanoidDescription.HeightScale = Settings:GetHeight()
	HumanoidDescription.DepthScale = Settings:GetDepth()
	HumanoidDescription.HeadScale = Settings:GetHeadScale()
	
	self.CharacterObject:WaitForChild("Humanoid"):ApplyDescription(HumanoidDescription)
end

function Character:GetCharacter()
	if self.CharacterObject == nil then
		self:CreateCharacter()
	elseif self.CharacterObject.Parent ~= self.Container then
		self.CharacterObject.Parent = self.Container
	end
	return(Character.CharacterObject)
end

function Character:Reconnect()
	--print("Redrawing Character")
	Character.Disconnect()
	Character.Connect()
end

function CharacterMove()
	Character:GetContainer()
	Character:GetCharacter():SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame)
end

function Character.Connect()
	Character._connection = RunServ.RenderStepped:Connect(CharacterMove)
end
function Character.Disconnect()
	Character._connection:Disconnect()
	Character.CharacterObject:Destroy()
	Character.CharacterObject = nil
	Character.Container:Destroy()
	Character.Container = nil
end

return Character
