local Trigger = game.ReplicatedStorage.Public.Trigger :: RemoteEvent
local CombatService = require(script.Parent.CombatService)



local events = {
    ["ChangeStance"] = function(player, newStance)
        CombatService:ChangeStance(player, newStance)
    end
}

Trigger.OnServerEvent:Connect(function(player, action, data)
    if events[action] then
        events[action](player, data)
    end
end)