local Players = game:GetService("Players")
local CombatService = {ModuleMain = true}
local Validate = require(game.ReplicatedStorage.Common.Validate)
local DataManager
local PlayerService
local Trigger = game.ReplicatedStorage.Public.Trigger :: RemoteEvent

local WeaponClasses = {}

function GetPlayerWeaponClass(player)
    local playerData = DataManager:Get(player)
    
    return playerData["WeaponClass"]
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

function CombatService:ChangeStance(player, newStance)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    if not Validate:CanChangeStance(humanoid) then return end
    humanoid:SetAttribute("StanceChangeTime", tick())
    humanoid:SetAttribute("CurrentStance", newStance)
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
}

function CombatService:HaveCounterStance(humanoid: Humanoid, enemyHumanoid: Humanoid)
    return counterStances[humanoid:GetAttribute("CurrentStance")] == enemyHumanoid:GetAttribute("CurrentStance")
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

function CombatService:EmitParticle(particles: {})
    Trigger:FireAllClients("EmitParticle", particles)
end

return CombatService