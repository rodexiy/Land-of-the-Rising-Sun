local Katana = {ModuleMain = true}
local DataManager
local CombatService
local Validate = require(game.ReplicatedStorage.Common.Validate)
local RaycastHitbox = require(game.ReplicatedStorage.Shared.RaycastHitbox)

function Katana:WeldSword(player)
    local playerData = DataManager:Get(player)
    if not game.ServerStorage.Swords[playerData.SwordName] then return print("Sword does not exist") end

    local character = player.Character
    local characterAssets = character.CharacterAssets

    local swordAndSheath = game.ServerStorage.Swords[playerData.SwordName]:Clone()
    local sword = swordAndSheath.Sword
    sword.Name = "Sword"
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
    local CharacterAssets = character:WaitForChild("CharacterAssets")
    local sword = CharacterAssets.Sword:FindFirstChild("Sword")

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

    local hitbox = RaycastHitbox.new(character)
    hitbox.OnHit:Connect(function(hit, enemyHumanoid: Humanoid)
        if enemyHumanoid == humanoid then return end

        if CombatService:HaveCounterStance(humanoid, enemyHumanoid) then
            print("Blocked")
        else
            enemyHumanoid:TakeDamage(35)
        end
    end)
    hitbox:HitStart(0.5)
    hitbox.Visualizer = true

end

function Katana:Main(services)
    CombatService = services.CombatService
    DataManager = services.DataManager
end

return Katana