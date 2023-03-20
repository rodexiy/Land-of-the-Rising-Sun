local Trigger = game.ReplicatedStorage.Public.Trigger :: RemoteEvent




local events = {

}

Trigger.OnServerEvent:Connect(function(player, action, data)
    if events[action] then
        events[action](player, data)
    end
end)