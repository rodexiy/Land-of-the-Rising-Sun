local Validate = {}

function Validate:CanAttack(humanoid: Humanoid)
    if humanoid:GetAttribute("AttackDebounce") or humanoid:GetAttribute("Hit") or humanoid:GetAttribute("CurrentStance") == "none" then 
        return false
    end

    return true
end

function Validate:CanRoll(humanoid: Humanoid)
    if humanoid:GetAttribute("AttackDebounce") or humanoid:GetAttribute("Hit") then 
        return false
    end

    return true
end

function Validate:CanChangeStance(humanoid: Humanoid)
    if  humanoid:GetAttribute("AttackDebounce") then
        return false
    end

    return true
end

return Validate