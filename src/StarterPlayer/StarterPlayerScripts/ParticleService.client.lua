local ParticleService = {ModuleMain = true}
local Services = {}
local MaxParticleDistance = 350 -- studs
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

function ParticleService:EmitParticle(ParentTable: {ParentPart: BasePart})--array
    if (RootPart.CFrame.Position - ParentTable[1].CFrame.Position).Magnitude > MaxParticleDistance then return end
    for _,v in ipairs(ParentTable[1]:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v:Emit(v:GetAttribute("EmitCount") or 1) 
        end
    end
end


function ParticleService:Main(_srvs)
    Services = _srvs
end

return ParticleService