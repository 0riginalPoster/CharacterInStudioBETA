local Prereq = {}

local RunServ = game:GetService("RunService")
local Players = game:GetService("Players")

function Prereq.Ready()
	return RunServ:IsStudio() and Players.LocalPlayer ~= nil
end

return Prereq