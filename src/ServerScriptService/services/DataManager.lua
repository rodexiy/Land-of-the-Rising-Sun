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

function DataService:GetTemporaryData(player: Player)
	
end

function DataService:GetDataFromCharacter(character: Model)
	if not game:GetService("Players"):GetPlayerFromCharacter(character) then
		return require(character.Data)
	else
		return DataService:Get(game:GetService("Players"):GetPlayerFromCharacter(character))
	end
end

function DataService:GetTemporaryDataFromCharacter(character: Model)
	
end

return DataService
