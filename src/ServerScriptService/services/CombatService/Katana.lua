local Katana = {ModuleMain = true}
local DataManager
local Validate = require(game.ReplicatedStorage.Common.Validate)

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

local KatanaAnimations = {
    ["Right1"] = game.ReplicatedStorage.Animations.Katana.Right1;
    ["Left2"] = game.ReplicatedStorage.Animations.Katana.Right2;
    ["Left1"] = game.ReplicatedStorage.Animations.Katana.Left1;
    ["Right2"] = game.ReplicatedStorage.Animations.Katana.Left2;
    ["Up"] = game.ReplicatedStorage.Animations.Katana.Up;
}

local AttackDebounces = {
    ["Up"] = 0.8;
    ["Left"] = 0.65;
    ["Right"] = 0.65
}

function Katana:Attack(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local currentStance = humanoid:GetAttribute("CurrentStance")

    if not Validate:CanAttack(humanoid) then return end
    humanoid:SetAttribute("AttackDebounce", true)
    task.delay(AttackDebounces[currentStance], function()
        humanoid:SetAttribute("AttackDebounce", false)
    end)


    local VariationNumber = {
        [1] = function()
            humanoid:SetAttribute("AttackVariationNumber", 2)
        end,
        
        [2] = function()
            humanoid:SetAttribute("AttackVariationNumber", 1)
        end
    }

    if VariationNumber[humanoid:GetAttribute("AttackVariationNumber")] then
        VariationNumber[humanoid:GetAttribute("AttackVariationNumber")]()
    end

    if currentStance ~= "Up"then
        humanoid.Animator:LoadAnimation(KatanaAnimations[currentStance.. tostring(humanoid:GetAttribute("AttackVariationNumber"))]):Play()
    else
        humanoid.Animator:LoadAnimation(KatanaAnimations["Up"]):Play()
    end


end

function Katana:Main(services)
    DataManager = services.DataManager
end

return Katana