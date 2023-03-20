local clientRequester = game.ReplicatedStorage.Public.ClientRequester :: BindableFunction


local clientRequests = {

}

clientRequester.OnInvoke = function(request, data)
    if clientRequests[request] then
       return clientRequests[request](data)
    end
end