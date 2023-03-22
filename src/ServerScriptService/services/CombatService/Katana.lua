local Katana = {ModuleMain = true}
local DataManager
local Validate = require(game.ReplicatedStorage.Shared.Validate)

function Katana:WeldSword(player)
    local playerData = DataManager:Get(player)
    if not game.ServerStorage.Swords[playerData.SwordName] then return print("Sword does not exist") end

    local character = player.Character
    local characterAssets = character.CharacterAssets

    local swordAndSheath = game.ServerStorage.Swords[playerData.SwordName]:Clone()
    local sword = swordAndSheath.Sword
    local sheath = swordAndSheath.Sheath

    local swordWeld = Instance.new("WeldConstraint")
    local rightHand = character.RightHand

    sword:PivotTo(rightHand.CFrame)
    swordWeld.Part0 = rightHand
    swordWeld.Part1 = sword.PrimaryPart
    swordWeld.Parent = sword.PrimaryPart
    sword.Parent = characterAssets.Sword
end

function Katana:Attack(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    if not Validate:CanAttack(humanoid) then return end

end

function Katana:Main(services)
    DataManager = services.DataManager
end

return Katana