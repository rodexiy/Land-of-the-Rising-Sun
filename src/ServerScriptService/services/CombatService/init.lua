local CombatService = {ModuleMain = true}
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
        WeaponClasses[weaponClass]:WeldSword(player)
    end
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