local CombatService = {ModuleMain = true}
local Validate = require(game.ReplicatedStorage.Common.Validate)
local DataManager

local WeaponClasses = {}

function GetPlayerWeaponClass(player)
    local playerData = DataManager:Get(player)
    
    return playerData["WeaponClass"]
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

    humanoid:SetAttribute("CurrentStance", newStance)
end

function CombatService:Main(services)
    DataManager = services.DataManager

    for i,v in ipairs(script:GetChildren()) do
        if v:IsA("ModuleScript") then
            WeaponClasses[v.Name] = require(v)
        end
    end
end

return CombatService