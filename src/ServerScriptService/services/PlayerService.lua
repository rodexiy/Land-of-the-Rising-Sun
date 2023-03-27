local PlayerService = {ModuleMain = true}
local DataManager
local CombatService


function PlayerService:AssemblyPlayer(player: Player)
    local playerData = DataManager:Get(player)
    PlayerService:AssemblyCharacter(player)
end

function PlayerService:ChangeWalkSpeed(humanoid, newWalkspeed)
    if humanoid:GetAttribute("Hit") then
        humanoid.Walkspeed = 0
      elseif humanoid:SetAttribute("AttackDebounce") then
         humanoid.Walkspeed = 5
      else
         humanoid.Walkspeed = newWalkspeed or humanoid.Walkspeed
      end
end

function PlayerService:AssemblyCharacter(player: Player)
    local playerData = DataManager:Get(player)
    
    player:LoadCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    repeat character.Parent = game.Workspace.Enemies task.wait() until character.Parent == game.Workspace.Enemies
    local humanoid = character:WaitForChild("Humanoid"):: Humanoid

    humanoid:SetAttribute("RollDebounce", false)
    humanoid:SetAttribute("Running", false)
    humanoid:SetAttribute("WeaponClass", playerData.WeaponClass)
    humanoid:SetAttribute("CurrentStance", "Right")
    humanoid:SetAttribute("AttackVariationNumber", 1)
    humanoid:SetAttribute("PostureDamage", 0)
    humanoid:SetAttribute("MaxPostureDamage", 100) 

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

function PlayerService:Roll()
    
end


function PlayerService:Main(services)
    DataManager = services.DataManager
    CombatService = services.CombatService
    game.Players.PlayerAdded:Connect(function(player)
        PlayerService:AssemblyPlayer(player)
    end)
end

return PlayerService