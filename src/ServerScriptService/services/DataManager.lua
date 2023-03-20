local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = {ModuleStart = false}

function DataService:Get(player: Player)
	local data = require(ReplicatedStorage.Profiles)[player.UserId]

	if not data then
		repeat
			data = require(ReplicatedStorage.Profiles)[player.UserId]
			task.wait(0.1)
		until data ~= nil
	end
	
	return data
end


return DataService
