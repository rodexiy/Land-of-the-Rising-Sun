local requester = game.ReplicatedStorage.Public.Requester :: RemoteFunction



local requests = {

}

requester.OnServerInvoke = function(player, request, data)
    if requests[request] then
        return requests[request](player, data)
    end
end