local Validate = {}

function Validate:CanAttack(humanoid: Humanoid)
    if humanoid:GetAttribute("AttackDebounce") then 
        return false
    end

    return true
end

return Validate