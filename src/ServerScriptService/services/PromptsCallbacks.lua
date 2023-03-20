local PromptsCallbacks = {ModuleMain = true}
local ChestService

local Trigger = game.ReplicatedStorage.Public.Trigger:: RemoteEvent
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")

local callbacks = {
    ["openChest"] = function(player: Player, prompt: ProximityPrompt)
        ChestService:OpenChest(player, prompt)
    end
}

function PromptsCallbacks:ButtonTriggered(player, prompt: ProximityPrompt)
    local Character = player.Character
    local RootPart = Character.PrimaryPart
    if (RootPart.CFrame.Position - prompt.Parent.PrimaryPart.CFrame.Position).Magnitude > prompt.MaxActivationDistance then return end
    if callbacks[prompt:GetAttribute("promptCallback")] then
        callbacks[prompt:GetAttribute("promptCallback")](player, prompt)
    end
end

function PromptsCallbacks:Main(_srvs)
    ChestService = _srvs.ChestService

    ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
        if callbacks[prompt:GetAttribute("promptCallback")] then
            callbacks[prompt:GetAttribute("promptCallback")](player, prompt)
        end
    end)
end

return PromptsCallbacks