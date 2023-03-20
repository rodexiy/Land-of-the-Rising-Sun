local ProximityPromptService = game:GetService("ProximityPromptService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Humanoid = character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")
local RootPart = character:WaitForChild("HumanoidRootPart")
local Torso = character:WaitForChild("Torso")

local PlayerGui = player:WaitForChild("PlayerGui") 
local Hud = PlayerGui:WaitForChild("Hud")
local PromptUI = Hud:WaitForChild("PromptUI")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Trigger = game.ReplicatedStorage.Public.Trigger:: RemoteEvent
local BasicInfo = TweenInfo.new(0.25)
local IsShowing = false
local Connection
local CurrentPrompt

local Action = PromptUI:WaitForChild("content"):WaitForChild("Action"):: TextButton

local ClientCallbacks = {
    
}

Action.Activated:Connect(function()
    if CurrentPrompt == nil then return end

    local callback = CurrentPrompt:GetAttribute("promptCallback")
    if ClientCallbacks[callback] then
        ClientCallbacks[callback]()
    end

    Trigger:FireServer("InteractionButtonTriggered", CurrentPrompt)
end)
ProximityPromptService.PromptTriggered:Connect(function(prompt, playerWhoTriggered)
    local callback = prompt:GetAttribute("promptCallback")
    if ClientCallbacks[callback] then
        ClientCallbacks[callback]()
    end
end)

function Shown(prompt: ProximityPrompt)
    local Highlight = prompt.Parent:FindFirstChild("Highlight"):: Highlight
    IsShowing = true
    CurrentPrompt = prompt
    Action.Text = prompt.KeyboardKeyCode.Name.. " - ".. prompt.ActionText
    PromptUI.Enabled = true
    TweenService:Create(Action, BasicInfo, {TextTransparency = 0}):Play()

    if Highlight then   
        Highlight.Enabled = true
        TweenService:Create(Highlight,BasicInfo, {OutlineTransparency = 0.1, FillTransparency = 0.8}):Play()
    end
end

function Hidden(prompt: ProximityPrompt)
    local Highlight = prompt.Parent:FindFirstChild("Highlight"):: Highlight
    local Action = PromptUI:WaitForChild("content"):WaitForChild("Action")
    IsShowing = false
    if Connection then
        Connection:Disconnect()
    end
    
    TweenService:Create(Action, BasicInfo, {TextTransparency = 1}):Play()
    task.delay(0.25, function()
        if IsShowing then return end
        PromptUI.Enabled = false
    end)

    if Highlight then
        TweenService:Create(Highlight,BasicInfo, {OutlineTransparency = 1, FillTransparency = 1}):Play()
        task.delay(0.25, function()
            if IsShowing then return end
            Highlight.Enabled = false
        end)
    end
end

ProximityPromptService.PromptHidden:Connect(Hidden)
ProximityPromptService.PromptShown:Connect(Shown)
