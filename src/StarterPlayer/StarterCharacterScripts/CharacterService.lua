local CharacterService = {}
local Character = script.Parent.Parent
local Humanoid = Character:WaitForChild("Humanoid")


function CharacterService:ChangeWalkSpeed(newWalkspeed)
    if Humanoid:GetAttribute("Hit") then
        Humanoid.Walkspeed = 0
      elseif Humanoid:SetAttribute("AttackDebounce") then
          Humanoid.Walkspeed = 5
      else
          Humanoid.Walkspeed = newWalkspeed or Humanoid.Walkspeed
      end
end

return CharacterService