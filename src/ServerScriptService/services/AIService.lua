local AIService = {}
AIService.__index = AIService

local AIs = {}

function AIService.new(humanoid: Humanoid)
    local AI = setmetatable({}, AIService)
    AI.Character = humanoid

    AI.connections = {}
    AI.settings = {}
    
    return AI
end

function AIService:StartAI()

end


return AIService