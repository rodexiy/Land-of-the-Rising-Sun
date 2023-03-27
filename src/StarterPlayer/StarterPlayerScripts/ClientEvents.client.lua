local Trigger = game.ReplicatedStorage.Public.Trigger :: RemoteEvent
local Player = game.Players.LocalPlayer
local ParticleService = require(script.Parent.ParticleService)


local PlayerGui = Player:WaitForChild("PlayerGui")
--[[
local Controller = PlayerGui:WaitForChild("Controller")
local UIManager = require(Controller:WaitForChild("UIManager"))
]]



local clientEvents = {
    ["SetPromptVisibility"] = function(data: {["prompt"]: ProximityPrompt, ["visibility"]: boolean })
        if not data.prompt then return print("Prompt is nil") end
        data.prompt.Enabled = data.visibility or true
    end;

    ["EmitParticle"] = function(data: {["BaseParts"]: BasePart}) 
        ParticleService:EmitParticle(data)
    end

}


Trigger.OnClientEvent:Connect(function(event, data)
    if clientEvents[event] then
        clientEvents[event](data)
    end
end)