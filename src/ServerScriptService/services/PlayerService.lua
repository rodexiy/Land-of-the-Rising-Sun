local PlayerService = {ModuleMain = true}
local DataManager
local CombatService


function PlayerService:AssemblyPlayer(player: Player)
    local playerData = DataManager:Get(player)
    PlayerService:AssemblyCharacter(player)
end


function PlayerService:AssemblyCharacter(player: Player)
    local playerData = DataManager:Get(player)

    player:LoadCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid"):: Humanoid

    humanoid:SetAttribute("RollDebounce", false)
    humanoid:SetAttribute("Running", false)
    humanoid:SetAttribute("WeaponClass", playerData.WeaponClass)
    humanoid:SetAttribute("CurrentStance", "Right")

    humanoid.WalkSpeed = 12

    CombatService:WeldSword(player)

    humanoid.Died:Once(function()
        PlayerService:CharacterDied(player, character)
    end)        
end

function PlayerService:CharacterDied(player: Player, character)
    task.wait(5)
    PlayerService:AssemblyCharacter(player)
end


function PlayerService:Main(services)
    DataManager = services.DataManager
    CombatService = services.CombatService
    game.Players.PlayerAdded:Connect(function(player)
        PlayerService:AssemblyPlayer(player)
    end)
end

return PlayerService