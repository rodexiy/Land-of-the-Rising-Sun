local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProfileService = require(game.ServerScriptService.Server.services.ProfileService)

local Players = game:GetService("Players")
local Trigger = game.ReplicatedStorage.Public:WaitForChild("Trigger") :: RemoteEvent
local DataConfiguration = require(game.ReplicatedStorage.Common:WaitForChild("DataConfiguration"))

local ProfileStore = ProfileService.GetProfileStore(
	"Land of the Rising Sun #1", --//DataKey
	DataConfiguration
)

local Profiles = {}

function PlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		--profile:Reconcile()
		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			local ProfileData = ReplicatedStorage.Profiles:FindFirstChild(player.UserId)
			if ProfileData then
				ProfileData:SetAttribute("ProfileReady", true)
			end

			Profiles[player] = profile
			local __Profile = require(ReplicatedStorage.Profiles)
			__Profile[player.UserId] = profile.Data

			Trigger:FireClient(player,"Load_Client_Info",profile.Data)
		else
			profile:Release()
			local ProfileData = ReplicatedStorage.Profiles:FindFirstChild(player.UserId)
			if ProfileData then
				ProfileData:SetAttribute("ProfileReady", "abort")
			end
		end
	else
		player:Kick("Data Error")
	end
end

--for _, player in ipairs(Players:GetPlayers()) do
--	coroutine.wrap(PlayerAdded)(player)
--end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:Release()
	end
end)
