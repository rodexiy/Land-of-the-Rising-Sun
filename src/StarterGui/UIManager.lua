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


function UIManager:ShowOrHideStanceViewer(bool)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local stanceViewer = rootPart:WaitForChild("StanceViewer")


    if bool then
        stanceViewer.Enabled = true
    else
        stanceViewer.Enabled = false
    end
end


return UIManager