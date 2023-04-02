local Players = game:GetService("Players")
local CombatService = {ModuleMain = true}
local Validate = require(game.ReplicatedStorage.Common.Validate)
local DataManager
local PlayerService
local Trigger = game.ReplicatedStorage.Public.Trigger :: RemoteEvent
local TweenService = game:GetService("TweenService")

local WeaponClasses = {}

function GetPlayerWeaponClass(player)
    local playerData = DataManager:Get(player)
    
    return playerData["WeaponClass"]
end

local defaultBlockProperties ={
    BackgroundColor3 = Color3.fromRGB(81, 81, 81);
    BackgroundTransparency = 0.5
}

local selectedBlockProperties = {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    BackgroundTransparency = 0.2
}

local AttackBlockProperties = {
    BackgroundColor3 = Color3.fromRGB(189, 8, 8);
    BackgroundTransparency = 0.2
}

local changeBlockTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

function CombatService:UpdateStanceViewer(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local stanceViewer = rootPart:WaitForChild("StanceViewer")
    local currentStance = humanoid:GetAttribute("CurrentStance")


    for _, stanceBlock: Frame in pairs(stanceViewer:GetChildren()) do
        if stanceBlock.Name ~= currentStance then
            TweenService:Create(stanceBlock, changeBlockTweenInfo, defaultBlockProperties):Play()
        else
            TweenService:Create(stanceBlock, changeBlockTweenInfo, selectedBlockProperties):Play()
        end
    end
end

--Block types can be: block or deflect <- recover a bit of posture damage
function CombatService:AddPostureDamage(humanoid: Humanoid, blockType: string, damage: number)
    local blockTypes = {
        ["Block"] = function()
            if humanoid:GetAttribute("PostureDamage") + damage
             >= humanoid:GetAttribute("MaxPostureDamage") then
                --BlockBreak
             else
                humanoid:SetAttribute("PostureDamage", humanoid:GetAttribute("PostureDamage") + (damage / 2))
             end
        end;

        ["Deflect"] = function()
            if (humanoid:GetAttribute("PostureDamage") - (damage / 2)) > 0 then
                humanoid:SetAttribute("PostureDamage", humanoid:GetAttribute("PostureDamage") - (damage / 3))
            else
                humanoid:SetAttribute("PostureDamage", 0)
            end
        end,
    }

    blockTypes[blockType]()
end

function CombatService:WeldSword(player)
    local weaponClass = GetPlayerWeaponClass(player)
    if WeaponClasses[weaponClass] then
        WeaponClasses[weaponClass]:WeldSword(player)
    end
end

function CombatService:Attack(player)
    local weaponClass = GetPlayerWeaponClass(player)
    if WeaponClasses[weaponClass] then
        WeaponClasses[weaponClass]:Attack(player)
    end
end

function CombatService:ChangeStance(player, newStance: string)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    if not Validate:CanChangeStance(humanoid) then return end
    humanoid:SetAttribute("StanceChangeTime", tick())
    humanoid:SetAttribute("CurrentStance", newStance)
    CombatService:UpdateStanceViewer(player)
end

function CombatService:ApplyDeflectStatus(humanoid: Humanoid)
    humanoid.WalkSpeed = 0;
    humanoid:SetAttribute("Deflected", true)

    task.wait(1)

    humanoid:SetAttribute("Deflected", false)
end

local counterStances = {
    ["Right"] = "Left";
    ["Left"] = "Right";
    ["Up"] = "Up";
    ["none"] = "none";
}

function CombatService:HaveCounterStance(humanoid: Humanoid, enemyHumanoid: Humanoid)
    return counterStances[humanoid:GetAttribute("CurrentStance")] == enemyHumanoid:GetAttribute("CurrentStance")
end

function CombatService:EmitParticle(particles: {})
    Trigger:FireAllClients("EmitParticle", particles)
end

function CombatService:Main(services)
    DataManager = services.DataManager
    PlayerService = services.PlayerService

    for i,v in ipairs(script:GetChildren()) do
        if v:IsA("ModuleScript") then
            WeaponClasses[v.Name] = require(v)
        end
    end
end

return CombatService