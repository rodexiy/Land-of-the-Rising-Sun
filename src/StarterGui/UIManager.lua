local TweenService = game:GetService("TweenService")
local UIManager = {}
local player = game.Players.LocalPlayer
local playerGui = script.Parent.Parent
local hud = playerGui:WaitForChild("Hud")


function UIManager:UpdateChestUI(chestData)
    --Enabled = true
    if #chestData["Items"] ~= 0 then
        
    else
        --close UI
    end
end

local defaultBlockProperties ={
    BackgroundColor3 = Color3.fromRGB(81, 81, 81);
    BackgroundTransparency = 0.5
}

local selectedBlockProperties = {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    BackgroundTransparency = 0.2
}

local changeBlockTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

function UIManager:UpdateStanceViewer()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local stanceViewer = hud:WaitForChild("StanceViewer")
    local currentStance = humanoid:GetAttribute("CurrentStance")

    for _, stanceBlock: Frame in pairs(stanceViewer:GetChildren()) do
        if stanceBlock.Name ~= currentStance then
            TweenService:Create(stanceBlock, changeBlockTweenInfo, defaultBlockProperties):Play()
        else
            TweenService:Create(stanceBlock, changeBlockTweenInfo, selectedBlockProperties):Play()
        end
    end
end

function UIManager:ShowOrHideStanceViewer(bool)
    local stanceViewer = hud:WaitForChild("StanceViewer")

    if bool then
        stanceViewer.Enabled = true
    else
        stanceViewer.Enabled = false
    end
end


return UIManager